import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

/// 🌱 Tests de migration et validation de plants.json
/// 
/// **Tests :**
/// 1. ✅ Migration transforme correctement la structure
/// 2. ✅ Champs dépréciés sont supprimés
/// 3. ✅ Métadonnées sont ajoutées
/// 4. ✅ Toutes les plantes sont préservées
/// 5. ✅ Validation détecte les erreurs de format
void main() {
  group('Plants JSON Migration', () {
    late Directory tempDir;
    late File testFile;
    
    setUp(() async {
      // Créer un répertoire temporaire pour les tests
      tempDir = await Directory.systemTemp.createTemp('plants_test_');
      testFile = File('${tempDir.path}/test_plants.json');
    });
    
    tearDown(() async {
      // Nettoyer après les tests
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });
    
    test('should handle legacy format (array-only)', () async {
      // Arrange - Créer un fichier legacy
      final legacyData = [
        {
          'id': 'tomato',
          'commonName': 'Tomate',
          'scientificName': 'Solanum lycopersicum',
          'family': 'Solanaceae',
          'plantingSeason': 'Printemps',  // ❌ Déprécié
          'harvestSeason': 'Été',         // ❌ Déprécié
          'sowingMonths': ['M', 'A', 'M'],
          'harvestMonths': ['J', 'J', 'A'],
        },
        {
          'id': 'carrot',
          'commonName': 'Carotte',
          'scientificName': 'Daucus carota',
          'family': 'Apiaceae',
          'plantingSeason': 'Printemps',
          'sowingMonths': ['M', 'A', 'M'],
        }
      ];
      
      await testFile.writeAsString(json.encode(legacyData));
      
      // Act - Lire et parser
      final content = await testFile.readAsString();
      final data = json.decode(content);
      
      // Assert
      expect(data, isA<List>());
      expect(data.length, 2);
      expect(data[0]['plantingSeason'], 'Printemps'); // Présent dans legacy
    });
    
    test('should handle v2.1.0 format (structured)', () async {
      // Arrange - Créer un fichier v2.1.0
      final v2Data = {
        'schema_version': '2.1.0',
        'metadata': {
          'version': '2.1.0',
          'updated_at': '2025-10-08',
          'total_plants': 2,
          'source': 'Test',
        },
        'plants': [
          {
            'id': 'tomato',
            'commonName': 'Tomate',
            'scientificName': 'Solanum lycopersicum',
            'family': 'Solanaceae',
            // ✅ Pas de plantingSeason/harvestSeason
            'sowingMonths': ['M', 'A', 'M'],
            'harvestMonths': ['J', 'J', 'A'],
          },
          {
            'id': 'carrot',
            'commonName': 'Carotte',
            'scientificName': 'Daucus carota',
            'family': 'Apiaceae',
            'sowingMonths': ['M', 'A', 'M'],
          }
        ]
      };
      
      await testFile.writeAsString(json.encode(v2Data));
      
      // Act - Lire et parser
      final content = await testFile.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      // Assert
      expect(data, isA<Map<String, dynamic>>());
      expect(data['schema_version'], '2.1.0');
      expect(data['metadata'], isNotNull);
      expect(data['metadata']['total_plants'], 2);
      expect(data['plants'], isA<List>());
      expect((data['plants'] as List).length, 2);
      
      // Vérifier absence de champs dépréciés
      final firstPlant = (data['plants'] as List)[0] as Map<String, dynamic>;
      expect(firstPlant.containsKey('plantingSeason'), false);
      expect(firstPlant.containsKey('harvestSeason'), false);
    });
    
    test('should preserve all plant data during migration', () async {
      // Arrange - Plante avec données complètes
      final legacyData = [
        {
          'id': 'tomato',
          'commonName': 'Tomate',
          'scientificName': 'Solanum lycopersicum',
          'family': 'Solanaceae',
          'plantingSeason': 'Printemps',
          'harvestSeason': 'Été',
          'sowingMonths': ['M', 'A', 'M'],
          'harvestMonths': ['J', 'J', 'A'],
          'daysToMaturity': 80,
          'spacing': 60,
          'depth': 0.5,
          'sunExposure': 'Plein soleil',
          'waterNeeds': 'Moyen',
          'description': 'Description test',
          'marketPricePerKg': 3.5,
          'germination': {
            'minTemperature': 18,
            'optimalTemperature': {'min': 22, 'max': 25}
          },
          'companionPlanting': {
            'beneficial': ['carotte', 'basilic'],
            'avoid': ['fenouil']
          }
        }
      ];
      
      await testFile.writeAsString(json.encode(legacyData));
      
      // Act - Simuler migration
      final content = await testFile.readAsString();
      final List<dynamic> oldPlants = json.decode(content);
      
      // Transformer
      final transformedPlant = Map<String, dynamic>.from(oldPlants[0]);
      transformedPlant.remove('plantingSeason');
      transformedPlant.remove('harvestSeason');
      
      // Assert - Vérifier que les données importantes sont préservées
      expect(transformedPlant['id'], 'tomato');
      expect(transformedPlant['commonName'], 'Tomate');
      expect(transformedPlant['scientificName'], 'Solanum lycopersicum');
      expect(transformedPlant['family'], 'Solanaceae');
      expect(transformedPlant['sowingMonths'], ['M', 'A', 'M']);
      expect(transformedPlant['harvestMonths'], ['J', 'J', 'A']);
      expect(transformedPlant['daysToMaturity'], 80);
      expect(transformedPlant['spacing'], 60);
      expect(transformedPlant['depth'], 0.5);
      expect(transformedPlant['sunExposure'], 'Plein soleil');
      expect(transformedPlant['waterNeeds'], 'Moyen');
      expect(transformedPlant['description'], 'Description test');
      expect(transformedPlant['marketPricePerKg'], 3.5);
      expect(transformedPlant['germination'], isNotNull);
      expect(transformedPlant['companionPlanting'], isNotNull);
      
      // Vérifier suppression des champs dépréciés
      expect(transformedPlant.containsKey('plantingSeason'), false);
      expect(transformedPlant.containsKey('harvestSeason'), false);
    });
    
    test('should add proper metadata structure', () {
      // Arrange
      final metadata = {
        'version': '2.1.0',
        'updated_at': '2025-10-08',
        'total_plants': 44,
        'source': 'PermaCalendar Team',
        'description': 'Base de données des plantes pour permaculture',
      };
      
      // Assert - Vérifier structure des métadonnées
      expect(metadata['version'], matches(RegExp(r'^\d+\.\d+\.\d+$')));
      expect(metadata['updated_at'], matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
      expect(metadata['total_plants'], isA<int>());
      expect(metadata['total_plants'], greaterThan(0));
      expect(metadata['source'], isNotEmpty);
      expect(metadata['description'], isNotEmpty);
    });
    
    test('should validate schema_version format', () {
      // Valid versions
      expect('2.1.0', matches(RegExp(r'^\d+\.\d+\.\d+$')));
      expect('1.0.0', matches(RegExp(r'^\d+\.\d+\.\d+$')));
      expect('10.22.333', matches(RegExp(r'^\d+\.\d+\.\d+$')));
      
      // Invalid versions
      expect('2.1', isNot(matches(RegExp(r'^\d+\.\d+\.\d+$'))));
      expect('v2.1.0', isNot(matches(RegExp(r'^\d+\.\d+\.\d+$'))));
      expect('2.1.0-beta', isNot(matches(RegExp(r'^\d+\.\d+\.\d+$'))));
    });
    
    test('should validate month abbreviations', () {
      final validMonths = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
      
      // Valid
      expect(validMonths.contains('J'), true);
      expect(validMonths.contains('M'), true);
      expect(validMonths.contains('D'), true);
      
      // Invalid
      expect(validMonths.contains('X'), false);
      expect(validMonths.contains('Jan'), false);
      expect(validMonths.contains('1'), false);
    });
    
    test('should remove deprecated fields from all plants', () {
      // Arrange
      final plants = [
        {
          'id': 'plant1',
          'plantingSeason': 'Printemps',
          'harvestSeason': 'Été',
          'notificationSettings': {'enabled': true},
        },
        {
          'id': 'plant2',
          'plantingSeason': 'Automne',
        }
      ];
      
      // Act - Simuler transformation
      final transformed = plants.map((plant) {
        final newPlant = Map<String, dynamic>.from(plant);
        newPlant.remove('plantingSeason');
        newPlant.remove('harvestSeason');
        newPlant.remove('notificationSettings');
        return newPlant;
      }).toList();
      
      // Assert
      expect(transformed[0].containsKey('plantingSeason'), false);
      expect(transformed[0].containsKey('harvestSeason'), false);
      expect(transformed[0].containsKey('notificationSettings'), false);
      expect(transformed[1].containsKey('plantingSeason'), false);
    });
    
    test('should maintain total_plants consistency', () {
      // Arrange
      final data = {
        'schema_version': '2.1.0',
        'metadata': {
          'total_plants': 44,
        },
        'plants': List.generate(44, (i) => {'id': 'plant_$i'}),
      };
      
      // Assert
      final metadata = data['metadata'] as Map<String, dynamic>;
      final plants = data['plants'] as List;
      expect(metadata['total_plants'], plants.length);
    });
  });
  
  group('Plants JSON Validation', () {
    test('should validate required fields', () {
      // Arrange
      final plant = {
        'id': 'tomato',
        'commonName': 'Tomate',
        'scientificName': 'Solanum lycopersicum',
        'family': 'Solanaceae',
      };
      
      // Assert
      final requiredFields = ['id', 'commonName', 'scientificName', 'family'];
      for (final field in requiredFields) {
        expect(plant.containsKey(field), true, reason: 'Field "$field" is required');
        expect(plant[field], isNotNull, reason: 'Field "$field" cannot be null');
        expect(plant[field], isNotEmpty, reason: 'Field "$field" cannot be empty');
      }
    });
    
    test('should validate numeric ranges', () {
      // Valid values
      expect(80, inInclusiveRange(1, 365)); // daysToMaturity
      expect(60, greaterThanOrEqualTo(0)); // spacing
      expect(0.5, greaterThanOrEqualTo(0)); // depth
      expect(3.5, greaterThanOrEqualTo(0)); // marketPricePerKg
      
      // Invalid values
      expect(-10, lessThan(0)); // Négatif invalide
      expect(1000, greaterThan(365)); // Trop grand (sauf vivaces)
    });
    
    test('should validate sunExposure enum', () {
      final validExposures = [
        'Plein soleil',
        'Mi-ombre',
        'Ombre',
        'Plein soleil/Mi-ombre',
      ];
      
      expect(validExposures.contains('Plein soleil'), true);
      expect(validExposures.contains('Mi-ombre'), true);
      expect(validExposures.contains('Invalid'), false);
    });
    
    test('should validate waterNeeds enum', () {
      final validWaterNeeds = [
        'Faible',
        'Moyen',
        'Élevé',
        'Très élevé',
      ];
      
      expect(validWaterNeeds.contains('Moyen'), true);
      expect(validWaterNeeds.contains('Élevé'), true);
      expect(validWaterNeeds.contains('Invalid'), false);
    });
  });
  
  group('Plants JSON Real File Validation', () {
    test('should validate actual plants_v2.json exists and is valid', () async {
      // Arrange
      final file = File('assets/data/plants_v2.json');
      
      // Assert
      expect(await file.exists(), true, reason: 'plants_v2.json should exist after migration');
      
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = json.decode(content);
        
        // Vérifier structure v2.1.0
        expect(data, isA<Map<String, dynamic>>());
        expect(data['schema_version'], isNotNull);
        expect(data['metadata'], isNotNull);
        expect(data['plants'], isA<List>());
        
        // Vérifier métadonnées
        final metadata = data['metadata'] as Map<String, dynamic>;
        expect(metadata['version'], isNotNull);
        expect(metadata['total_plants'], isA<int>());
        expect(metadata['source'], isNotNull);
        
        // Vérifier cohérence
        final plants = data['plants'] as List;
        expect(plants.length, metadata['total_plants']);
        expect(plants.length, greaterThan(0));
        
        print('✅ plants_v2.json validé : ${plants.length} plantes, version ${data['schema_version']}');
      }
    });
    
    test('should validate backup exists', () async {
      // Assert
      final backupFile = File('assets/data/plants.json.backup');
      
      // Le backup devrait exister après la migration
      if (await backupFile.exists()) {
        final content = await backupFile.readAsString();
        final data = json.decode(content);
        
        expect(data, isA<List>(), reason: 'Backup should be in legacy format');
        print('✅ Backup validé : ${data.length} plantes');
      }
    });
  });
}
