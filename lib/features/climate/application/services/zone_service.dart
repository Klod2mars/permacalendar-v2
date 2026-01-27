
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/zone.dart';
import 'dart:developer' as developer;

class ZoneService {
  static const String _zonesAssetPath = 'assets/data/zones.json';
  
  List<Zone> _zones = [];
  bool _isInitialized = false;

  /// Initialise le service en chargeant le JSON
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final jsonString = await rootBundle.loadString(_zonesAssetPath);
      final data = json.decode(jsonString);
      
      if (data != null && data['zones'] != null) {
        _zones = (data['zones'] as List)
            .map((z) => Zone.fromJson(z as Map<String, dynamic>))
            .toList();
      }
      
      _isInitialized = true;
      developer.log('ZoneService: Loaded ${_zones.length} zones', name: 'ZoneService');
    } catch (e) {
      developer.log('ZoneService: Error loading zones: $e', name: 'ZoneService', level: 1000);
      // Fallback minimal
      _zones = [
        const Zone(id: 'NH_temperate_europe', name: 'Tempéré (Fallback)', monthShift: 0)
      ];
    }
  }
  
  List<Zone> getAllZones() {
    return _zones;
  }
  
  Zone? getZoneById(String id) {
    return _zones.where((z) => z.id == id).firstOrNull;
  }

  /// Détecte la zone approximative basée sur la latitude et le pays
  /// C'est une heuristique simple qui pourra être affinée
  Zone detectZone({required double latitude, String? countryCode}) {
    if (!_isInitialized) {
      developer.log('ZoneService warning: detectZone called before initialization', name: 'ZoneService');
    }

    // 1. Hémisphère Sud
    if (latitude < 0) {
       // Simplification: Tout l'HS tempéré -> SH_temperate
       // Si trop proche équateur (>-23) -> Tropical ?
       if (latitude > -23.5) {
         return getZoneById('tropical') ?? _zones.first;
       }
       return getZoneById('SH_temperate') ?? _zones.first;
    }

    // 2. Hémisphère Nord
    // Tropiques
    if (latitude < 23.5) {
      return getZoneById('tropical') ?? _zones.first;
    }
    
    // Amérique du nord (detection grossière via countryCode si dispo)
    if (countryCode != null && ['US', 'CA', 'MX'].contains(countryCode.toUpperCase())) {
      return getZoneById('NH_temperate_na') ?? _zones.first;
    }
    
    // 3. Asie Tropicale / Subtropicale (Inde, SE Asia)
    const tropicalCountries = ['IN', 'TH', 'VN', 'PH', 'ID', 'MY', 'SG', 'LK', 'BD', 'KH', 'LA', 'MM'];
    if (countryCode != null && tropicalCountries.contains(countryCode.toUpperCase())) {
       return getZoneById('tropical') ?? _zones.first;
    }

    // Méditerranée (approx lat 30-45 + Europe/Afrique Nord? Difficile sans longitude)
    // Pour l'instant on reste sur NH_temperate_europe par défaut pour le reste (Europe/Asie)
    // Sauf si on implémente un check longitude + lat pour Mediterranean.
    
    return getZoneById('NH_temperate_europe') ?? _zones.first;
  }
}
