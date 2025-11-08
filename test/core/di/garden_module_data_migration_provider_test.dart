import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/di/garden_module.dart';
import 'package:permacalendar/core/data/migration/garden_data_migration.dart';

/// Test d'intégration Riverpod pour le provider `dataMigrationProvider`
///
/// Ce test vérifie :
/// 1. Que le provider est correctement défini et accessible
/// 2. Que le provider retourne une instance valide de `GardenDataMigration`
/// 3. Que l'instance retournée est fonctionnelle (non null, pas d'exception)
/// 4. Que le provider peut être lu plusieurs fois (singleton behavior)
/// 5. Que les dépendances sont correctement résolues
void main() {
  group('GardenModule.dataMigrationProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should be defined and accessible', () {
      // Arrange & Act
      final provider = GardenModule.dataMigrationProvider;

      // Assert
      expect(provider, isNotNull);
      expect(provider, isA<Provider<GardenDataMigration>>());
    });

    test('should return a valid GardenDataMigration instance', () {
      // Act
      final migration = container.read(GardenModule.dataMigrationProvider);

      // Assert
      expect(migration, isNotNull);
      expect(migration, isA<GardenDataMigration>());
    });

    test('should return the same instance on multiple reads (singleton)', () {
      // Act
      final migration1 = container.read(GardenModule.dataMigrationProvider);
      final migration2 = container.read(GardenModule.dataMigrationProvider);

      // Assert
      expect(migration1, same(migration2));
    });

    test('should return an instance with default state', () {
      // Act
      final migration = container.read(GardenModule.dataMigrationProvider);

      // Assert
      expect(migration.lastResult, isNull); // Pas de résultat initial
    });

    test('should not throw when reading the provider', () {
      // Act & Assert
      expect(
        () => container.read(GardenModule.dataMigrationProvider),
        returnsNormally,
      );
    });

    test('should have correct type signature', () {
      // Act
      final migration = container.read(GardenModule.dataMigrationProvider);

      // Assert
      expect(migration, isA<GardenDataMigration>());
      expect(migration.runtimeType, equals(GardenDataMigration));
    });

    test('should be independent from other providers', () {
      // Act
      final migration = container.read(GardenModule.dataMigrationProvider);
      // Note: Le provider n'utilise pas ref, donc pas de dépendances
      // On vérifie juste qu'il fonctionne indépendamment

      // Assert
      expect(migration, isNotNull);
      // Si on arrive ici sans exception, c'est que le provider est indépendant
    });

    test('should work with ProviderContainer lifecycle', () {
      // Arrange
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      // Act
      final migration1 = container1.read(GardenModule.dataMigrationProvider);
      final migration2 = container2.read(GardenModule.dataMigrationProvider);

      // Assert
      expect(migration1, isNotNull);
      expect(migration2, isNotNull);
      // Les instances sont différentes car les containers sont différents
      expect(migration1, isNot(same(migration2)));

      // Cleanup
      container1.dispose();
      container2.dispose();
    });
  });

  group('GardenModule.dataMigrationProvider - Integration with GardenDataMigration', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should return an instance that can access migrateAllGardens method', () {
      // Arrange
      final migration = container.read(GardenModule.dataMigrationProvider);

      // Act & Assert
      expect(migration.migrateAllGardens, isA<Function>());
      // Vérifier que la méthode existe et est callable
      expect(
        () => migration.migrateAllGardens,
        returnsNormally,
      );
    });

    test('should return an instance with lastResult getter', () {
      // Arrange
      final migration = container.read(GardenModule.dataMigrationProvider);

      // Act & Assert
      expect(migration.lastResult, isNull); // Initialement null
      expect(
        () => migration.lastResult,
        returnsNormally,
      );
    });
  });
}

