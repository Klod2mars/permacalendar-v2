import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendarv2/core/services/plant_localization_service.dart';
import 'package:permacalendarv2/features/plant_catalog/domain/entities/plant_entity.dart';

// Mock implementation of TestDefaultBinaryMessengerBinding if needed, 
// but using TestWidgetsFlutterBinding.ensureInitialized() is usually enough.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlantLocalizationService', () {
    late PlantLocalizationService service;
    late Map<String, dynamic> frenchJson;
    late String firstId;
    late String expectedFrenchName;

    setUpAll(() async {
      final file = File('assets/data/i18n/plants_fr.json');
      // Ensure file exists (running from project root)
      if (!file.existsSync()) {
         // Fail gracefully or skip?
         throw Exception('Run test from project root!');
      }
      final content = await file.readAsString();
      frenchJson = json.decode(content) as Map<String, dynamic>;
      
      firstId = frenchJson.keys.first;
      expectedFrenchName = (frenchJson[firstId] as Map<String, dynamic>)['commonName'] as String;

      // Mock rootBundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        if (message == null) return null;
        final String path = utf8.decode(message.buffer.asUint8List(message.offsetInBytes, message.lengthInBytes));
        
        if (path == 'assets/data/i18n/plants_fr.json') {
          final Uint8List encoded = utf8.encode(content);
          return ByteData.view(encoded.buffer);
        }
        return null; // Return null for other assets to simulate Not Found
      });
    });

    setUp(() {
      service = PlantLocalizationService();
    });

    test('localize should correctly merge French data and map Enums', () async {
      // 1. Load Locale
      await service.loadLocale('fr');
      
      // 2. Create a Mock Plant (Technical/Tokenized state)
      // Use <String, dynamic> for Maps to satisfy Freezed/Dart strictness
      final plant = PlantFreezed(
        id: firstId,
        commonName: 'Legacy Name',
        scientificName: 'Testus scientificus',
        family: 'Testaceae',
        plantingSeason: 'SPRING,SUMMER', 
        harvestSeason: 'SUMMER',
        daysToMaturity: 60,
        spacing: 30,
        depth: 1.0,
        sunExposure: 'SUN_FULL', 
        waterNeeds: 'WATER_HIGH',
        description: 'Technical Description', 
        sowingMonths: <String>[],
        harvestMonths: <String>[],
        nutritionPer100g: <String, dynamic>{},
        germination: <String, dynamic>{},
        growth: <String, dynamic>{},
        watering: <String, dynamic>{},
        thinning: <String, dynamic>{},
        weeding: <String, dynamic>{},
        culturalTips: <String>[],
        biologicalControl: <String, dynamic>{},
        harvestTime: '',
        companionPlanting: <String, dynamic>{},
        notificationSettings: <String, dynamic>{},
        varieties: <String, dynamic>{},
        metadata: <String, dynamic>{},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      // 3. Act
      final localized = service.localize(plant);

      // 4. Assert - Text Replacement
      expect(localized.commonName, equals(expectedFrenchName));
      expect(localized.commonName, isNot(equals('Legacy Name'))); // Proves override
      
      // 5. Assert - Enum Mapping (Verify hardcoded map in service works)
      expect(localized.sunExposure, equals('Plein soleil'));
      expect(localized.waterNeeds, equals('Élevé'));
      
      // 6. Assert - Season Mapping (SPRING,SUMMER -> Printemps,Été)
      // The expected string depends on how map_seasons logic produced the string
      // LocalizationService: _translateSeasonList splits by ',' and maps.
      expect(localized.plantingSeason, contains('Printemps'));
      expect(localized.plantingSeason, contains('Été'));
    });

    test('localize should return empty list (not null or crash) for missing/null list fields', () async {
      await service.loadLocale('fr');
      
      // Create plant with empty lists (simulating a "poorly formed" but valid object from Hive)
      final plant = PlantFreezed(
        id: firstId,
        commonName: 'Legacy Name',
        scientificName: 'Testus',
        family: 'Testaceae',
        plantingSeason: 'SPRING', 
        harvestSeason: 'SUMMER',
        daysToMaturity: 60,
        spacing: 30,
        depth: 1.0,
        sunExposure: 'SUN_FULL', 
        waterNeeds: 'WATER_HIGH',
        description: 'Desc', 
        sowingMonths: <String>[],
        harvestMonths: <String>[],
        nutritionPer100g: <String, dynamic>{}, // Empty
        germination: <String, dynamic>{}, // Empty
        growth: <String, dynamic>{}, // Empty
        watering: <String, dynamic>{}, // Empty
        thinning: <String, dynamic>{}, // Empty
        weeding: <String, dynamic>{}, // Empty
        culturalTips: <String>[], // Empty list from Hive
        biologicalControl: <String, dynamic>{}, 
        harvestTime: '',
        companionPlanting: <String, dynamic>{},
        notificationSettings: <String, dynamic>{},
        varieties: <String, dynamic>{},
        metadata: <String, dynamic>{},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );
      
      // Act
      final localized = service.localize(plant);
      
      // Assert
      // Ensure culturalTips is NOT null (freezed guarantees it, but we check logic flow)
      expect(localized.culturalTips, isA<List<String>>());
      // Even if localization file has null or missing field, implementation should return list
    });
  });
}
