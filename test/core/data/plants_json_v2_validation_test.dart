import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// 🌱 Test de validation du format plants.json v2.1.0
/// 
/// Ce test valide que :
/// 1. Le fichier plants.json existe et est chargeable
/// 2. Le format v2.1.0 est détecté (schema_version)
/// 3. Les métadonnées sont présentes et cohérentes
/// 4. Au moins une plante est chargée
/// 5. La cohérence metadata.total_plants == plants.length
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('plants.json v2.1.0 Validation', () {
    late String jsonString;
    late dynamic jsonData;

    setUpAll(() async {
      // Charger le fichier plants.json depuis les assets de test
      try {
        jsonString = await rootBundle.loadString('assets/data/plants.json');
        jsonData = json.decode(jsonString);
      } catch (e) {
        fail('Impossible de charger assets/data/plants.json: $e');
      }
    });

    test('Le fichier plants.json doit être chargeable', () {
      expect(jsonString, isNotEmpty);
      expect(jsonData, isNotNull);
    });

    test('Le format doit être un Map (format v2.1.0)', () {
      expect(jsonData, isA<Map<String, dynamic>>(),
          reason: 'Le format doit être un objet structuré, pas un array');
    });

    test('schema_version doit être présent et égal à "2.1.0"', () {
      final map = jsonData as Map<String, dynamic>;
      
      expect(map, contains('schema_version'),
          reason: 'Le champ schema_version doit être présent');
      
      final schemaVersion = map['schema_version'];
      expect(schemaVersion, equals('2.1.0'),
          reason: 'La version du schéma doit être 2.1.0');
    });

    test('metadata doit être présent et valide', () {
      final map = jsonData as Map<String, dynamic>;
      
      expect(map, contains('metadata'),
          reason: 'Le champ metadata doit être présent');
      
      final metadata = map['metadata'];
      expect(metadata, isA<Map<String, dynamic>>(),
          reason: 'metadata doit être un objet');
      
      final metadataMap = metadata as Map<String, dynamic>;
      
      // Vérifier les champs obligatoires
      expect(metadataMap, contains('version'),
          reason: 'metadata.version doit être présent');
      expect(metadataMap, contains('total_plants'),
          reason: 'metadata.total_plants doit être présent');
      expect(metadataMap, contains('source'),
          reason: 'metadata.source doit être présent');
      expect(metadataMap, contains('updated_at'),
          reason: 'metadata.updated_at doit être présent');
      
      // Vérifier les types
      expect(metadataMap['version'], isA<String>());
      expect(metadataMap['total_plants'], isA<int>());
      expect(metadataMap['source'], isA<String>());
      expect(metadataMap['updated_at'], isA<String>());
    });

    test('plants doit être présent et non vide', () {
      final map = jsonData as Map<String, dynamic>;
      
      expect(map, contains('plants'),
          reason: 'Le champ plants doit être présent');
      
      final plants = map['plants'];
      expect(plants, isA<List>(),
          reason: 'plants doit être une liste');
      
      final plantsList = plants as List;
      expect(plantsList, isNotEmpty,
          reason: 'Au moins une plante doit être présente');
    });

    test('metadata.total_plants doit correspondre à la longueur de plants', () {
      final map = jsonData as Map<String, dynamic>;
      final metadata = map['metadata'] as Map<String, dynamic>;
      final plants = map['plants'] as List;
      
      final expectedTotal = metadata['total_plants'] as int;
      final actualTotal = plants.length;
      
      expect(actualTotal, equals(expectedTotal),
          reason: 'Le nombre de plantes réelles doit correspondre à metadata.total_plants. '
              'Attendu: $expectedTotal, Trouvé: $actualTotal');
    });

    test('Les plantes ne doivent pas contenir de champs obsolètes', () {
      final map = jsonData as Map<String, dynamic>;
      final plants = map['plants'] as List;
      
      if (plants.isNotEmpty) {
        final firstPlant = plants.first as Map<String, dynamic>;
        
        expect(firstPlant.containsKey('plantingSeason'), isFalse,
            reason: 'plantingSeason est un champ obsolète et ne doit pas être présent');
        expect(firstPlant.containsKey('harvestSeason'), isFalse,
            reason: 'harvestSeason est un champ obsolète et ne doit pas être présent');
        expect(firstPlant.containsKey('notificationSettings'), isFalse,
            reason: 'notificationSettings est un champ obsolète et ne doit pas être présent');
      }
    });

    test('Les plantes doivent contenir les champs essentiels', () {
      final map = jsonData as Map<String, dynamic>;
      final plants = map['plants'] as List;
      
      if (plants.isNotEmpty) {
        final firstPlant = plants.first as Map<String, dynamic>;
        
        // Champs obligatoires
        expect(firstPlant, contains('id'));
        expect(firstPlant, contains('commonName'));
        expect(firstPlant, contains('scientificName'));
        expect(firstPlant, contains('family'));
        expect(firstPlant, contains('sowingMonths'));
        expect(firstPlant, contains('harvestMonths'));
        expect(firstPlant, contains('sunExposure'));
        expect(firstPlant, contains('waterNeeds'));
        
        // Vérifier les types
        expect(firstPlant['id'], isA<String>());
        expect(firstPlant['commonName'], isA<String>());
        expect(firstPlant['scientificName'], isA<String>());
        expect(firstPlant['family'], isA<String>());
        expect(firstPlant['sowingMonths'], isA<List>());
        expect(firstPlant['harvestMonths'], isA<List>());
      }
    });

    test('Afficher un résumé des données chargées', () {
      final map = jsonData as Map<String, dynamic>;
      final metadata = map['metadata'] as Map<String, dynamic>;
      final plants = map['plants'] as List;
      
      print('');
      print('📊 Résumé de la validation plants.json v2.1.0');
      print('═══════════════════════════════════════════════');
      print('✅ Format détecté       : v${map['schema_version']}');
      print('📋 Version              : ${metadata['version']}');
      print('🌱 Total plantes        : ${metadata['total_plants']}');
      print('📦 Plantes chargées     : ${plants.length}');
      print('🏢 Source               : ${metadata['source']}');
      print('📅 Dernière mise à jour : ${metadata['updated_at']}');
      
      if (metadata.containsKey('migration_date')) {
        print('🔄 Date de migration    : ${metadata['migration_date']}');
        print('📜 Migré depuis         : ${metadata['migrated_from']}');
      }
      
      if (plants.isNotEmpty) {
        final firstPlant = plants.first as Map<String, dynamic>;
        print('');
        print('🌱 Exemple (première plante):');
        print('   - ID                 : ${firstPlant['id']}');
        print('   - Nom commun         : ${firstPlant['commonName']}');
        print('   - Nom scientifique   : ${firstPlant['scientificName']}');
        print('   - Famille            : ${firstPlant['family']}');
      }
      
      print('═══════════════════════════════════════════════');
      print('');
      
      // Ce test réussit toujours, il sert juste à afficher les infos
      expect(true, isTrue);
    });
  });
}



