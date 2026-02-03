import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:permacalendar/core/models/entitlement.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';
import 'package:permacalendar/core/repositories/repository_providers.dart';
import 'package:permacalendar/core/repositories/garden_hive_repository.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import 'package:permacalendar/core/models/garden.dart' as legacy; // Aliased import

// Manual Mock
class MockGardenRepository extends GardenHiveRepository {
  List<GardenFreezed> gardens = [];

  @override
  Future<List<GardenFreezed>> getAllGardens() async {
    return gardens;
  }

  @override
  Future<bool> createGarden(GardenFreezed garden) async {
    gardens.add(garden);
    return true;
  }
}

void main() {
  late Directory tempDir;
  ProviderContainer? container;
  late MockGardenRepository mockRepo;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('garden_mock_test');
    Hive.init(tempDir.path);
    try { Hive.registerAdapter(EntitlementAdapter()); } catch(_) {}
    
    // Register Legacy Adapter using alias
    // If compilation fails here, then 'legacy.GardenAdapter' is missing from generated file?
    try { Hive.registerAdapter(legacy.GardenAdapter()); } catch(_) {} 

    await GardenBoxes.initialize();
    await GardenBoxes.clearAllGardens();
    
    await EntitlementRepository().init();
    Hive.box<Entitlement>('entitlements').put('current_entitlement', Entitlement.free());
    
    mockRepo = MockGardenRepository();
  });

  tearDown(() async {
    container?.dispose();
    await GardenBoxes.close();
    await Hive.deleteFromDisk();
  });

  test('createGarden preserves existing gardens when paywall limit is reached', () async {
    // 1. Arrange: Create initial garden
    final garden1 = GardenFreezed.create(name: 'G1', location: 'Loc', totalAreaInSquareMeters: 10);
    
    // Populate MOCK REPO
    mockRepo.gardens.add(garden1);
    
    container = ProviderContainer(
      overrides: [
        gardenRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    
    final notifier = container!.read(gardenProvider.notifier);
    await notifier.loadGardens();
    
    // Verify loaded
    expect(container!.read(gardenProvider).gardens.length, 1, reason: "Loaded from mock");

    // 2. Act
    final garden2 = GardenFreezed.create(name: 'G2', location: 'Loc', totalAreaInSquareMeters: 10);
    final success = await notifier.createGarden(garden2);
    
    // 3. Assert
    expect(success, false);
    final state = container!.read(gardenProvider);
    expect(state.error, 'paywall_limit_reached');
    expect(state.gardens.length, 1, reason: "Gardens should be preserved");
  });
}
