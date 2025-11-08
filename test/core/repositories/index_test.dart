import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/repositories/index.dart';
import 'package:riverpod/riverpod.dart';

/// Test d'intégration pour vérifier que tous les exports du fichier index.dart
/// sont correctement accessibles depuis un module externe.
///
/// Ce test vérifie :
/// 1. Que toutes les classes repository sont exportées
/// 2. Que les chemins d'import sont valides
/// 3. Que les classes peuvent être instanciées/utilisées
void main() {
  group('Core Repositories Index - Exports Validation', () {
    test('devrait exporter GardenRepository', () {
      expect(() => GardenRepository(), returnsNormally);
      final repository = GardenRepository();
      expect(repository, isA<GardenRepository>());
    });

    test('devrait exporter GardenHiveRepository', () {
      expect(() => GardenHiveRepository(), returnsNormally);
      final repository = GardenHiveRepository();
      expect(repository, isA<GardenHiveRepository>());
    });

    test('devrait exporter GardenRules', () {
      expect(() => GardenRules(), returnsNormally);
      final rules = GardenRules();
      expect(rules, isA<GardenRules>());
    });

    test('devrait exporter GardenHelpers', () {
      expect(() => GardenHelpers(), returnsNormally);
      expect(GardenHelpers, isA<Type>());
    });

    test('devrait exporter repository_providers (gardenRepositoryProvider)', () {
      expect(gardenRepositoryProvider, isNotNull);
      // Le provider est un Provider<GardenHiveRepository>
      expect(gardenRepositoryProvider, isA<Provider<GardenHiveRepository>>());
    });

    test('devrait exporter les exceptions de GardenRepository', () {
      expect(() => GardenValidationException('test'), returnsNormally);
      expect(() => GardenNotFoundException('test'), returnsNormally);
      expect(() => GardenLimitException('test'), returnsNormally);
      
      final validationEx = GardenValidationException('test');
      expect(validationEx, isA<GardenRepositoryException>());
    });

    test('devrait exporter GardenHiveException', () {
      expect(() => GardenHiveException('test'), returnsNormally);
      final ex = GardenHiveException('test');
      expect(ex, isA<GardenHiveException>());
    });

    test('devrait exporter ValidationResult', () {
      expect(() => ValidationResult.valid(), returnsNormally);
      expect(() => ValidationResult.invalid('error'), returnsNormally);
      
      final valid = ValidationResult.valid();
      expect(valid.isValid, isTrue);
      
      final invalid = ValidationResult.invalid('error');
      expect(invalid.isValid, isFalse);
    });

    test('devrait exporter GardenStatistics', () {
      expect(() => GardenStatistics(
        totalGardens: 0,
        activeGardens: 0,
        inactiveGardens: 0,
        totalArea: 0.0,
        activeArea: 0.0,
        averageArea: 0.0,
        totalBeds: 0,
      ), returnsNormally);
    });

    test('devrait exporter GardenValidationStats', () {
      expect(() => GardenValidationStats(
        totalGardens: 0,
        activeGardens: 0,
        inactiveGardens: 0,
        minRequired: 1,
        maxAllowed: 5,
        canAddMore: true,
        canRemove: false,
        remainingSlots: 5,
      ), returnsNormally);
    });
  });

  group('Core Repositories Index - Import Path Validation', () {
    test('devrait permettre l\'import depuis un module externe', () {
      // Ce test vérifie que l'import fonctionne sans erreur
      // Si ce test passe, cela signifie que tous les chemins sont valides
      expect(true, isTrue);
    });
  });
}

