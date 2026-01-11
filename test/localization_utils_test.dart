import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/models/plant_localized.dart';
import 'package:permacalendar/utils/localization_utils.dart';

void main() {
  group('LocalizationUtils', () {
    final plant = PlantLocalized(
      id: 'test_plant',
      scientificName: 'Solanum lycopersicum',
      lastUpdated: DateTime.now(),
      localized: {
        'fr': LocalizedPlantFields(commonName: 'Tomate'),
        'en': LocalizedPlantFields(commonName: 'Tomato'),
        'pt_BR': LocalizedPlantFields(commonName: 'Tomate (BR)'),
      },
    );

    test('getLocalizedPlantName returns exact match pt_BR', () {
      final name = LocalizationUtils.getLocalizedPlantName(plant, const Locale('pt', 'BR'));
      expect(name, 'Tomate (BR)');
    });

    test('getLocalizedPlantName returns language match fr', () {
      final name = LocalizationUtils.getLocalizedPlantName(plant, const Locale('fr', 'FR'));
      expect(name, 'Tomate');
    });

    test('getLocalizedPlantName fallback to en', () {
      final name = LocalizationUtils.getLocalizedPlantName(plant, const Locale('de', 'DE'));
      expect(name, 'Tomato');
    });

    test('getLocalizedPlantName fallback to scientific', () {
      final emptyPlant = PlantLocalized(
        id: 'empty',
        scientificName: 'Unknown species',
        lastUpdated: DateTime.now(),
        localized: {},
      );
      final name = LocalizationUtils.getLocalizedPlantName(emptyPlant, const Locale('fr'));
      expect(name, 'Unknown species');
    });
  });
}
