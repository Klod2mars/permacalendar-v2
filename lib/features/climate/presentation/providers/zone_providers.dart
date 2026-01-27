import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/services/zone_service.dart';
import '../../domain/models/zone.dart';
import '../providers/weather_providers.dart';
import 'dart:developer' as developer;

import 'package:permacalendar/core/providers/app_settings_provider.dart';

/// Provider global pour ZoneService
final zoneServiceProvider = Provider<ZoneService>((ref) {
  final service = ZoneService();
  service.initialize(); // Fire and forget init
  return service;
});

/// Provider de la Zone calculée selon la commune active
final currentZoneProvider = FutureProvider<Zone>((ref) async {
  final service = ref.watch(zoneServiceProvider);
  final settings = ref.watch(appSettingsProvider);

  await service.initialize();
  
  // 1. Check override
  if (settings.customZoneId != null) {
    final forced = service.getZoneById(settings.customZoneId!);
    if (forced != null) {
      developer.log('Using forced zone: ${forced.id}', name: 'currentZoneProvider');
      return forced;
    }
  }

  // 2. Normal detection
  final coords = await ref.watch(selectedCommuneCoordinatesProvider.future);
  final zone = service.detectZone(latitude: coords.latitude, countryCode: coords.countryCode);
  
  developer.log('Detected zone: ${zone.id} (${zone.name}) for lat ${coords.latitude}', name: 'currentZoneProvider');
  
  return zone;
});

/// Provider pour la date de dernier gel (Last Frost)
final lastFrostDateProvider = FutureProvider<DateTime>((ref) async {
  final settings = ref.watch(appSettingsProvider);
  
  // 1. Check override
  if (settings.customLastFrostDate != null) {
    // Adapter l'année à l'année courante si nécessaire ?
    // Pour l'instant on retourne la date stockée (qui contient une année).
    // Idéalement on stocke juste jour/mois et on projette sur l'année.
    // L'implémentation actuelle stocke une DateTime complète.
    // On va retourner la date telle quelle, ou projetée ?
    // Pour simplifier, on prend ce qui est stocké. L'utilisateur devra changer l'année ou on ignore l'année dans le resolver ?
    // PhaseResolver utilise `lastFrostDate` pour calculer des deltas. Il compare avec `date.month`.
    // Si la date stockée est 2024 et on est en 2025, c'est pas grave tant que le jour/mois est bon pour l'affichage ?
    // Sauf si on calcule des jours précis.
    // Projetons sur l'année en cours pour être safe.
    final now = DateTime.now();
    final stored = settings.customLastFrostDate!;
    // Si la date est passée de beaucoup, on prend l'année suivante ?
    // Restons simple : on garde l'année en cours.
    return DateTime(now.year, stored.month, stored.day);
  }

  final zone = await ref.watch(currentZoneProvider.future);
  final now = DateTime.now();
  
  // Logique simplifiée par défaut
  if (zone.id == 'SH_temperate') {
    return DateTime(now.year, 9, 15);
  } else if (zone.id == 'NH_temperate_europe' || zone.id == 'NH_temperate_na') {
    return DateTime(now.year, 5, 15);
  } else if (zone.id == 'tropical') {
    return DateTime(now.year, 1, 1);
  }
  
  return DateTime(now.year, 5, 1); // Default
});
