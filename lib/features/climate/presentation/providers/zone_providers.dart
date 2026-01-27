import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/services/zone_service.dart';
import '../../domain/models/zone.dart';
import '../providers/weather_providers.dart';
import 'dart:developer' as developer;

/// Provider global pour ZoneService
final zoneServiceProvider = Provider<ZoneService>((ref) {
  final service = ZoneService();
  service.initialize(); // Fire and forget init
  return service;
});

/// Provider de la Zone calculée selon la commune active
final currentZoneProvider = FutureProvider<Zone>((ref) async {
  final service = ref.watch(zoneServiceProvider);
  
  // Attendre l'init si nécessaire ? 
  // initialize() est async mais on peut ne pas attendre bloquant si le service gère son état interne.
  // Pour être sür, on attend un peu ou on check IsInitialized si on avait exposé cette méthode.
  // Ici on fait confiance au fait que initialize() est rapide (lecture JSON asset).
  await service.initialize();
  
  final coords = await ref.watch(selectedCommuneCoordinatesProvider.future);
  
  // Detecter la zone
  // On pourrait passer le country code si on l'avait dans coords.resolvedName via un Geocoding plus fin
  // Pour l'instant on se base sur latitude.
  final zone = service.detectZone(latitude: coords.latitude);
  
  developer.log('Detected zone: ${zone.id} (${zone.name}) for lat ${coords.latitude}', name: 'currentZoneProvider');
  
  return zone;
});

/// Provider pour la date de dernier gel (Last Frost)
/// TODO: Devrait être persisté dans les settings du Jardin
/// Pour l'instant : calculé dynamiquement selon la zone et l'hémisphère.
final lastFrostDateProvider = FutureProvider<DateTime>((ref) async {
  final zone = await ref.watch(currentZoneProvider.future);
  
  final now = DateTime.now();
  
  // Logique simplifiée par défaut
  if (zone.id == 'SH_temperate') {
    // Hémisphère Sud : Gel fin octobre/début novembre ?
    // Printemps = Sept-Nov. Dernier gel souvent vers Septembre/Octobre.
    // Mettons 15 Septembre pour l'instant
    // Année : si on est en Janvier 2024, le dernier gel était en Sept 2023. La saison de culture est en cours.
    // Si on est en Juin 2024, le dernier gel sera en Sept 2024.
    // C'est complexe. Il faut la date de référence pour le "cycle actuel".
    // Disons qu'on retourne la date de l'année en cours pour simplifier la logique relative.
    return DateTime(now.year, 9, 15);
  } else if (zone.id == 'NH_temperate_europe' || zone.id == 'NH_temperate_na') {
    // Hémisphère Nord : Saints de Glace (Mi-Mai)
    return DateTime(now.year, 5, 15);
  } else if (zone.id == 'tropical') {
    // Pas de gel. On retourne une date lointaine ou null ?
    // PhaseResolver gère null ? Oui.
    // Mais FutureProvider doit retourner une valeur non null nullable?
    // On met Jan 1st pour pas casser.
    return DateTime(now.year, 1, 1);
  }
  
  return DateTime(now.year, 5, 1); // Default
});
