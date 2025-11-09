
import '../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:permacalendar/features/climate/data/commune_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory testDir;

  setUpAll(() async {
    // CrÃ©er un rÃ©pertoire temporaire pour les tests
    testDir = await Directory.systemTemp.createTemp('hive_test_commune_');
    Hive.init(testDir.path);
  });

  tearDownAll(() async {
    // Fermer toutes les boxes et nettoyer
    await Hive.close();
    if (await testDir.exists()) {
      await testDir.delete(recursive: true);
    }
  });

  test('commune persistence works across sessions', () async {
    // Test avec coordonnÃ©es
    await CommuneStorage.saveCommune('Paris', 48.8566, 2.3522);
    final (commune, lat, lon) = await CommuneStorage.loadCommune();
    expect(commune, 'Paris');
    expect(lat, 48.8566);
    expect(lon, 2.3522);

    // Test de clear
    await CommuneStorage.clear();
    final (clearedCommune, clearedLat, clearedLon) =
        await CommuneStorage.loadCommune();
    expect(clearedCommune, isNull);
    expect(clearedLat, isNull);
    expect(clearedLon, isNull);
  });
}

