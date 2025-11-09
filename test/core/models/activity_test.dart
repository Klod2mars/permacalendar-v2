
import '../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:permacalendar/core/models/activity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('Activity Model Tests - SÃ©rialisation et validation complÃ¨te', () {
    late Directory tempDir;
    late Box<Activity> activityBox;
    const uuid = Uuid();

    setUpAll(() async {
      // CrÃ©er un rÃ©pertoire temporaire pour les tests Hive
      tempDir = await Directory.systemTemp.createTemp('activity_test_');
      
      // Initialiser Hive avec le rÃ©pertoire temporaire
      Hive.init(tempDir.path);
      
      // Enregistrer les adaptateurs Activity si pas dÃ©jÃ  fait
      if (!Hive.isAdapterRegistered(16)) {
        Hive.registerAdapter(ActivityAdapter());
      }
      if (!Hive.isAdapterRegistered(17)) {
        Hive.registerAdapter(ActivityTypeAdapter());
      }
      if (!Hive.isAdapterRegistered(18)) {
        Hive.registerAdapter(EntityTypeAdapter());
      }
    });

    setUp(() async {
      // Ouvrir une nouvelle box pour chaque test
      activityBox = await Hive.openBox<Activity>('test_activities');
      await activityBox.clear();
    });

    tearDown(() async {
      // Fermer la box aprÃ¨s chaque test
      if (activityBox.isOpen) {
        await activityBox.close();
      }
    });

    tearDownAll(() async {
      // Nettoyer complÃ¨tement aprÃ¨s tous les tests
      await Hive.deleteFromDisk();
      await Hive.close();
      
      // Supprimer le rÃ©pertoire temporaire
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('Tests de crÃ©ation et validation', () {
      test('Doit crÃ©er une activitÃ© avec tous les champs requis', () {
        final now = DateTime.now();
        final activity = Activity(
          id: uuid.v4(),
          type: ActivityType.gardenCreated,
          title: 'Nouveau jardin crÃ©Ã©',
          description: 'Un nouveau jardin a Ã©tÃ© crÃ©Ã© avec succÃ¨s',
          entityId: 'garden-123',
          entityType: EntityType.garden,
          timestamp: now,
          metadata: {'location': 'Balcon', 'size': 'Petit'},
          createdAt: now,
          updatedAt: now,
          isActive: true,
        );

        expect(activity.id, isNotEmpty);
        expect(activity.type, equals(ActivityType.gardenCreated));
        expect(activity.title, equals('Nouveau jardin crÃ©Ã©'));
        expect(activity.description, equals('Un nouveau jardin a Ã©tÃ© crÃ©Ã© avec succÃ¨s'));
        expect(activity.entityId, equals('garden-123'));
        expect(activity.entityType, equals(EntityType.garden));
        expect(activity.timestamp, equals(now));
        expect(activity.metadata, containsPair('location', 'Balcon'));
        expect(activity.metadata, containsPair('size', 'Petit'));
        expect(activity.createdAt, equals(now));
        expect(activity.updatedAt, equals(now));
        expect(activity.isActive, isTrue);
      });

      test('Doit crÃ©er une activitÃ© avec des champs optionnels null', () {
        final now = DateTime.now();
        final activity = Activity(
          id: uuid.v4(),
          type: ActivityType.weatherDataFetched,
          title: 'DonnÃ©es mÃ©tÃ©o rÃ©cupÃ©rÃ©es',
          description: 'Mise Ã  jour des donnÃ©es mÃ©tÃ©orologiques',
          entityId: null,
          entityType: null,
          timestamp: now,
          metadata: {},
          createdAt: now,
          updatedAt: now,
          isActive: true,
        );

        expect(activity.entityId, isNull);
        expect(activity.entityType, isNull);
        expect(activity.metadata, isEmpty);
      });

      test('Doit valider les types d\'activitÃ© disponibles', () {
        final validTypes = [
          ActivityType.gardenCreated,
          ActivityType.gardenUpdated,
          ActivityType.gardenDeleted,
          ActivityType.bedCreated,
          ActivityType.bedUpdated,
          ActivityType.bedDeleted,
          ActivityType.plantingCreated,
          ActivityType.plantingUpdated,
          ActivityType.plantingHarvested,
          ActivityType.careActionAdded,
          ActivityType.germinationConfirmed,
          ActivityType.plantCreated,
          ActivityType.plantUpdated,
          ActivityType.plantDeleted,
          ActivityType.plantingDeleted,
          ActivityType.weatherDataFetched,
          ActivityType.weatherAlertTriggered,
        ];

        for (final type in validTypes) {
          final activity = Activity(
            id: uuid.v4(),
            type: type,
            title: 'Test $type',
            description: 'Description test',
            timestamp: DateTime.now(),
            metadata: {},
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isActive: true,
          );
          
          expect(activity.type, equals(type));
        }
      });

      test('Doit valider les types d\'entitÃ© disponibles', () {
        final validEntityTypes = [
          EntityType.garden,
          EntityType.gardenBed,
          EntityType.planting,
          EntityType.plant,
          EntityType.germinationEvent,
        ];

        for (final entityType in validEntityTypes) {
          final activity = Activity(
            id: uuid.v4(),
            type: ActivityType.gardenCreated,
            title: 'Test entity type',
            description: 'Description test',
            entityType: entityType,
            timestamp: DateTime.now(),
            metadata: {},
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isActive: true,
          );
          
          expect(activity.entityType, equals(entityType));
        }
      });
    });

    group('Tests de sÃ©rialisation/dÃ©sÃ©rialisation Hive', () {
      test('Doit sauvegarder et rÃ©cupÃ©rer une activitÃ© complÃ¨te dans Hive', () async {
        final now = DateTime.now();
        final originalActivity = Activity(
          id: 'test-activity-1',
          type: ActivityType.plantingCreated,
          title: 'Nouvelle plantation',
          description: 'Plantation de tomates cerises',
          entityId: 'planting-456',
          entityType: EntityType.planting,
          timestamp: now,
          metadata: {
            'plantName': 'Tomate cerise',
            'quantity': 5,
            'location': 'CarrÃ© A1',
            'expectedHarvest': '2024-07-15',
          },
          createdAt: now,
          updatedAt: now,
          isActive: true,
        );

        // Sauvegarder dans Hive
        await activityBox.put(originalActivity.id, originalActivity);

        // RÃ©cupÃ©rer depuis Hive
        final retrievedActivity = activityBox.get('test-activity-1');

        // VÃ©rifications
        expect(retrievedActivity, isNotNull);
        expect(retrievedActivity!.id, equals(originalActivity.id));
        expect(retrievedActivity.type, equals(originalActivity.type));
        expect(retrievedActivity.title, equals(originalActivity.title));
        expect(retrievedActivity.description, equals(originalActivity.description));
        expect(retrievedActivity.entityId, equals(originalActivity.entityId));
        expect(retrievedActivity.entityType, equals(originalActivity.entityType));
        expect(retrievedActivity.timestamp, equals(originalActivity.timestamp));
        expect(retrievedActivity.metadata, equals(originalActivity.metadata));
        expect(retrievedActivity.createdAt, equals(originalActivity.createdAt));
        expect(retrievedActivity.updatedAt, equals(originalActivity.updatedAt));
        expect(retrievedActivity.isActive, equals(originalActivity.isActive));
      });

      test('Doit gÃ©rer la sÃ©rialisation avec des mÃ©tadonnÃ©es complexes', () async {
        final complexMetadata = {
          'stringValue': 'test string',
          'intValue': 42,
          'doubleValue': 3.14,
          'boolValue': true,
          'listValue': ['item1', 'item2', 'item3'],
          'mapValue': {
            'nestedString': 'nested value',
            'nestedInt': 100,
          },
          'nullValue': null,
        };

        final activity = Activity(
          id: 'complex-metadata-test',
          type: ActivityType.careActionAdded,
          title: 'Action de soin complexe',
          description: 'Test avec mÃ©tadonnÃ©es complexes',
          timestamp: DateTime.now(),
          metadata: complexMetadata,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        // Sauvegarder et rÃ©cupÃ©rer
        await activityBox.put(activity.id, activity);
        final retrieved = activityBox.get(activity.id);

        // VÃ©rifications des mÃ©tadonnÃ©es complexes
        expect(retrieved!.metadata['stringValue'], equals('test string'));
        expect(retrieved.metadata['intValue'], equals(42));
        expect(retrieved.metadata['doubleValue'], equals(3.14));
        expect(retrieved.metadata['boolValue'], equals(true));
        expect(retrieved.metadata['listValue'], equals(['item1', 'item2', 'item3']));
        expect(retrieved.metadata['mapValue']['nestedString'], equals('nested value'));
        expect(retrieved.metadata['mapValue']['nestedInt'], equals(100));
        expect(retrieved.metadata['nullValue'], isNull);
      });

      test('Doit persister plusieurs activitÃ©s et les rÃ©cupÃ©rer correctement', () async {
        final activities = <Activity>[];
        
        // CrÃ©er plusieurs activitÃ©s de types diffÃ©rents
        for (int i = 0; i < 5; i++) {
          final activity = Activity(
            id: 'activity-$i',
            type: ActivityType.values[i % ActivityType.values.length],
            title: 'ActivitÃ© $i',
            description: 'Description de l\'activitÃ© $i',
            entityId: 'entity-$i',
            entityType: EntityType.values[i % EntityType.values.length],
            timestamp: DateTime.now().subtract(Duration(hours: i)),
            metadata: {'index': i, 'batch': 'persistence_test'},
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isActive: i % 2 == 0, // Alterner entre actif et inactif
          );
          
          activities.add(activity);
          await activityBox.put(activity.id, activity);
        }

        // VÃ©rifier que toutes les activitÃ©s sont persistÃ©es
        expect(activityBox.length, equals(5));

        // VÃ©rifier chaque activitÃ© individuellement
        for (int i = 0; i < 5; i++) {
          final retrieved = activityBox.get('activity-$i');
          expect(retrieved, isNotNull);
          expect(retrieved!.title, equals('ActivitÃ© $i'));
          expect(retrieved.metadata['index'], equals(i));
          expect(retrieved.isActive, equals(i % 2 == 0));
        }
      });
    });

    group('Factory Constructors', () {
      test('gardenCreated factory should create correct activity', () {
        final activity = Activity.gardenCreated(
          gardenId: 'garden-123',
          gardenName: 'Mon Jardin',
          metadata: {'size': '100m2'},
        );

        expect(activity.type, equals(ActivityType.gardenCreated));
        expect(activity.title, equals('Jardin crÃ©Ã©'));
        expect(activity.description, contains('Mon Jardin'));
        expect(activity.entityId, equals('garden-123'));
        expect(activity.entityType, equals(EntityType.garden));
        expect(activity.metadata['gardenName'], equals('Mon Jardin'));
        expect(activity.metadata['size'], equals('100m2'));
      });

      test('plantingCreated factory should create correct activity', () {
        final activity = Activity.plantingCreated(
          plantingId: 'planting-123',
          plantName: 'Tomate',
          bedName: 'Parcelle A',
          quantity: 5,
          metadata: {'variety': 'Cherry'},
        );

        expect(activity.type, equals(ActivityType.plantingCreated));
        expect(activity.title, equals('Plantation crÃ©Ã©e'));
        expect(activity.description, contains('5 Tomate'));
        expect(activity.description, contains('Parcelle A'));
        expect(activity.entityId, equals('planting-123'));
        expect(activity.entityType, equals(EntityType.planting));
        expect(activity.metadata['plantName'], equals('Tomate'));
        expect(activity.metadata['bedName'], equals('Parcelle A'));
        expect(activity.metadata['quantity'], equals(5));
        expect(activity.metadata['variety'], equals('Cherry'));
      });

      test('plantingHarvested factory should create correct activity', () {
        final activity = Activity.plantingHarvested(
          plantingId: 'planting-123',
          plantName: 'Tomate',
          quantity: 10,
          metadata: {'weight': '2kg'},
        );

        expect(activity.type, equals(ActivityType.plantingHarvested));
        expect(activity.title, equals('RÃ©colte effectuÃ©e'));
        expect(activity.description, contains('10 Tomate'));
        expect(activity.entityId, equals('planting-123'));
        expect(activity.entityType, equals(EntityType.planting));
        expect(activity.metadata['plantName'], equals('Tomate'));
        expect(activity.metadata['quantity'], equals(10));
        expect(activity.metadata['weight'], equals('2kg'));
      });

      test('germinationConfirmed factory should create correct activity', () {
        final germinationDate = DateTime(2024, 3, 15);
        final activity = Activity.germinationConfirmed(
          plantingId: 'planting-123',
          plantName: 'Radis',
          germinationDate: germinationDate,
          metadata: {'success_rate': '90%'},
        );

        expect(activity.type, equals(ActivityType.germinationConfirmed));
        expect(activity.title, equals('Germination confirmÃ©e'));
        expect(activity.description, contains('Radis'));
        expect(activity.description, contains('15/3/2024'));
        expect(activity.entityId, equals('planting-123'));
        expect(activity.entityType, equals(EntityType.planting));
        expect(activity.metadata['plantName'], equals('Radis'));
        expect(activity.metadata['germinationDate'], equals(germinationDate.toIso8601String()));
        expect(activity.metadata['success_rate'], equals('90%'));
      });

      test('weatherDataFetched factory should create correct activity', () {
        final weatherData = {
          'temperature': 22.5,
          'humidity': 65,
          'precipitation': 0,
        };
        
        final activity = Activity.weatherDataFetched(
          location: 'Paris',
          weatherData: weatherData,
          metadata: {'source': 'OpenWeather'},
        );

        expect(activity.type, equals(ActivityType.weatherDataFetched));
        expect(activity.title, equals('DonnÃ©es mÃ©tÃ©o rÃ©cupÃ©rÃ©es'));
        expect(activity.description, contains('Paris'));
        expect(activity.entityId, isNull);
        expect(activity.entityType, isNull);
        expect(activity.metadata['location'], equals('Paris'));
        expect(activity.metadata['weatherData'], equals(weatherData));
        expect(activity.metadata['source'], equals('OpenWeather'));
      });
    });

    group('Tests des mÃ©thodes utilitaires', () {
      test('Doit implÃ©menter copyWith correctement', () {
        final originalActivity = Activity(
          id: 'original-id',
          type: ActivityType.gardenCreated,
          title: 'Titre original',
          description: 'Description originale',
          entityId: 'entity-original',
          entityType: EntityType.garden,
          timestamp: DateTime(2024, 1, 1),
          metadata: {'key': 'value'},
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          isActive: true,
        );

        final updatedActivity = originalActivity.copyWith(
          title: 'Titre modifiÃ©',
          description: 'Description modifiÃ©e',
          isActive: false,
          updatedAt: DateTime(2024, 1, 2),
        );

        // VÃ©rifier que les champs modifiÃ©s ont changÃ©
        expect(updatedActivity.title, equals('Titre modifiÃ©'));
        expect(updatedActivity.description, equals('Description modifiÃ©e'));
        expect(updatedActivity.isActive, isFalse);
        expect(updatedActivity.updatedAt, equals(DateTime(2024, 1, 2)));

        // VÃ©rifier que les autres champs sont inchangÃ©s
        expect(updatedActivity.id, equals(originalActivity.id));
        expect(updatedActivity.type, equals(originalActivity.type));
        expect(updatedActivity.entityId, equals(originalActivity.entityId));
        expect(updatedActivity.entityType, equals(originalActivity.entityType));
        expect(updatedActivity.timestamp, equals(originalActivity.timestamp));
        expect(updatedActivity.metadata, equals(originalActivity.metadata));
        expect(updatedActivity.createdAt, equals(originalActivity.createdAt));
      });

      test('Doit sÃ©rialiser correctement avec toJson', () {
        final activity = Activity(
          id: 'test-id',
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
          entityId: 'garden-123',
          entityType: EntityType.garden,
          timestamp: DateTime(2024, 3, 15, 14, 30, 0),
          metadata: {'key': 'value'},
          createdAt: DateTime(2024, 3, 15, 14, 30, 0),
          updatedAt: DateTime(2024, 3, 15, 14, 30, 0),
          isActive: true,
        );

        final json = activity.toJson();
        
        expect(json['id'], equals('test-id'));
        expect(json['type'], equals('gardenCreated'));
        expect(json['title'], equals('Test Activity'));
        expect(json['description'], equals('Test Description'));
        expect(json['entityId'], equals('garden-123'));
        expect(json['entityType'], equals('garden'));
        expect(json['metadata'], equals({'key': 'value'}));
        expect(json['isActive'], isTrue);
      });

      test('Doit dÃ©sÃ©rialiser correctement avec fromJson', () {
        final json = {
          'id': 'test-id',
          'type': 'gardenCreated',
          'title': 'Test Activity',
          'description': 'Test Description',
          'entityId': 'garden-123',
          'entityType': 'garden',
          'timestamp': '2024-03-15T14:30:00.000Z',
          'metadata': {'key': 'value'},
          'createdAt': '2024-03-15T14:30:00.000Z',
          'updatedAt': '2024-03-15T14:30:00.000Z',
          'isActive': true,
        };

        final activity = Activity.fromJson(json);
        
        expect(activity.id, equals('test-id'));
        expect(activity.type, equals(ActivityType.gardenCreated));
        expect(activity.title, equals('Test Activity'));
        expect(activity.description, equals('Test Description'));
        expect(activity.entityId, equals('garden-123'));
        expect(activity.entityType, equals(EntityType.garden));
        expect(activity.metadata, equals({'key': 'value'}));
        expect(activity.isActive, isTrue);
      });

      test('Doit implÃ©menter toString correctement', () {
        final activity = Activity(
          id: 'test-id',
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
          timestamp: DateTime.now(),
          metadata: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        final string = activity.toString();
        expect(string, contains('Activity('));
        expect(string, contains('id: test-id'));
        expect(string, contains('type: gardenCreated'));
        expect(string, contains('title: Test Activity'));
      });

      test('Doit implÃ©menter l\'Ã©galitÃ© correctement', () {
        final activity1 = Activity(
          id: 'same-id',
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
          timestamp: DateTime.now(),
          metadata: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        final activity2 = Activity(
          id: 'same-id',
          type: ActivityType.plantingCreated,
          title: 'Different Activity',
          description: 'Different Description',
          timestamp: DateTime.now(),
          metadata: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: false,
        );

        final activity3 = Activity(
          id: 'different-id',
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
          timestamp: DateTime.now(),
          metadata: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: true,
        );

        expect(activity1, equals(activity2)); // MÃªme ID
        expect(activity1, isNot(equals(activity3))); // ID diffÃ©rent
        expect(activity1.hashCode, equals(activity2.hashCode));
        expect(activity1.hashCode, isNot(equals(activity3.hashCode)));
      });
    });

    group('Data Validation', () {
      test('should accept empty metadata', () {
        final activity = Activity(
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
          metadata: {},
        );

        expect(activity.metadata, isEmpty);
      });

      test('should validate date consistency', () {
        final createdAt = DateTime(2024, 1, 15, 10, 0);
        final updatedAt = DateTime(2024, 1, 15, 11, 0);

        final activity = Activity(
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

        expect(activity.createdAt.isBefore(activity.updatedAt) || 
               activity.createdAt.isAtSameMomentAs(activity.updatedAt), isTrue);
      });

      test('should handle null optional fields correctly', () {
        final activity = Activity(
          type: ActivityType.weatherDataFetched,
          title: 'Weather Update',
          description: 'Weather data fetched',
          entityId: null,
          entityType: null,
        );

        expect(activity.entityId, isNull);
        expect(activity.entityType, isNull);
        expect(activity.isActive, isTrue); // Default value
      });

      test('should generate unique IDs when not provided', () {
        final activity1 = Activity(
          type: ActivityType.gardenCreated,
          title: 'Test 1',
          description: 'Description 1',
        );

        final activity2 = Activity(
          type: ActivityType.gardenCreated,
          title: 'Test 2',
          description: 'Description 2',
        );

        expect(activity1.id, isNotEmpty);
        expect(activity2.id, isNotEmpty);
        expect(activity1.id, isNot(equals(activity2.id)));
      });

      test('should use provided ID when specified', () {
        const customId = 'custom-id-123';
        final activity = Activity(
          id: customId,
          type: ActivityType.gardenCreated,
          title: 'Test Activity',
          description: 'Test Description',
        );

        expect(activity.id, equals(customId));
      });
    });
  });
}

