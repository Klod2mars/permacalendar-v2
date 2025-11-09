// ðŸ§ª Tests unitaires pour IntelligentSuggestion
// PermaCalendar v2.8.0 - Migration Riverpod 3
// Tests complets du modÃ¨le de suggestion intelligente


import '../../../../test_setup_stub.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/intelligent_suggestion.dart';

void main() {
  group('IntelligentSuggestion', () {
    // ==================== INSTANCIATION ====================

    group('Instanciation', () {
      test('devrait crÃ©er une suggestion avec tous les champs requis', () {
        // Arrange & Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-001',
          gardenId: 'garden-123',
          message: 'C\'est le moment idÃ©al pour semer vos tomates',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.seasonal,
          createdAt: DateTime(2024, 1, 15, 10, 30),
        );

        // Assert
        expect(suggestion.id, equals('suggestion-001'));
        expect(suggestion.gardenId, equals('garden-123'));
        expect(suggestion.message,
            equals('C\'est le moment idÃ©al pour semer vos tomates'));
        expect(suggestion.priority, equals(SuggestionPriority.high));
        expect(suggestion.category, equals(SuggestionCategory.seasonal));
        expect(suggestion.createdAt, equals(DateTime(2024, 1, 15, 10, 30)));
      });

      test('devrait crÃ©er une suggestion avec valeurs par dÃ©faut', () {
        // Arrange & Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-002',
          gardenId: 'garden-456',
          message: 'Test suggestion',
          priority: SuggestionPriority.medium,
          category: SuggestionCategory.maintenance,
          createdAt: DateTime.now(),
        );

        // Assert - VÃ©rifier les valeurs par dÃ©faut
        expect(suggestion.isRead, isFalse);
        expect(suggestion.isActioned, isFalse);
        expect(suggestion.expiresAt, isNull);
      });

      test('devrait crÃ©er une suggestion avec expiration', () {
        // Arrange
        final expiresAt = DateTime.now().add(const Duration(days: 7));

        // Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-003',
          gardenId: 'garden-789',
          message: 'Suggestion avec expiration',
          priority: SuggestionPriority.low,
          category: SuggestionCategory.weather,
          expiresAt: expiresAt,
          createdAt: DateTime.now(),
        );

        // Assert
        expect(suggestion.expiresAt, equals(expiresAt));
      });

      test('devrait crÃ©er une suggestion avec tous les champs optionnels', () {
        // Arrange
        final createdAt = DateTime(2024, 1, 1);
        final expiresAt = DateTime(2024, 1, 8);

        // Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-004',
          gardenId: 'garden-999',
          message: 'Suggestion complÃ¨te',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.pest,
          expiresAt: expiresAt,
          isRead: true,
          isActioned: true,
          createdAt: createdAt,
        );

        // Assert
        expect(suggestion.id, equals('suggestion-004'));
        expect(suggestion.gardenId, equals('garden-999'));
        expect(suggestion.message, equals('Suggestion complÃ¨te'));
        expect(suggestion.priority, equals(SuggestionPriority.high));
        expect(suggestion.category, equals(SuggestionCategory.pest));
        expect(suggestion.expiresAt, equals(expiresAt));
        expect(suggestion.isRead, isTrue);
        expect(suggestion.isActioned, isTrue);
        expect(suggestion.createdAt, equals(createdAt));
      });
    });

    // ==================== SÃ‰RIALISATION JSON ====================

    group('SÃ©rialisation JSON', () {
      test('devrait sÃ©rialiser une suggestion en JSON', () {
        // Arrange
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-json-001',
          gardenId: 'garden-json-123',
          message: 'Test sÃ©rialisation',
          priority: SuggestionPriority.medium,
          category: SuggestionCategory.harvest,
          expiresAt: DateTime(2024, 1, 20, 12, 0),
          isRead: false,
          isActioned: false,
          createdAt: DateTime(2024, 1, 15, 10, 0),
        );

        // Act
        final json = suggestion.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('suggestion-json-001'));
        expect(json['gardenId'], equals('garden-json-123'));
        expect(json['message'], equals('Test sÃ©rialisation'));
        expect(json['priority'], equals('medium'));
        expect(json['category'], equals('harvest'));
        expect(json['expiresAt'], equals('2024-01-20T12:00:00.000'));
        expect(json['isRead'], isFalse);
        expect(json['isActioned'], isFalse);
        expect(json['createdAt'], equals('2024-01-15T10:00:00.000'));
      });

      test('devrait sÃ©rialiser une suggestion sans expiration', () {
        // Arrange
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-json-002',
          gardenId: 'garden-json-456',
          message: 'Suggestion permanente',
          priority: SuggestionPriority.low,
          category: SuggestionCategory.maintenance,
          expiresAt: null,
          createdAt: DateTime(2024, 1, 15),
        );

        // Act
        final json = suggestion.toJson();

        // Assert
        expect(json['expiresAt'], isNull);
      });

      test('devrait dÃ©sÃ©rialiser une suggestion depuis JSON', () {
        // Arrange
        final json = {
          'id': 'suggestion-from-json-001',
          'gardenId': 'garden-from-json-123',
          'message': 'Test dÃ©sÃ©rialisation',
          'priority': 'high',
          'category': 'lunar',
          'expiresAt': '2024-01-25T14:30:00.000',
          'isRead': true,
          'isActioned': false,
          'createdAt': '2024-01-15T10:00:00.000',
        };

        // Act
        final suggestion = IntelligentSuggestion.fromJson(json);

        // Assert
        expect(suggestion.id, equals('suggestion-from-json-001'));
        expect(suggestion.gardenId, equals('garden-from-json-123'));
        expect(suggestion.message, equals('Test dÃ©sÃ©rialisation'));
        expect(suggestion.priority, equals(SuggestionPriority.high));
        expect(suggestion.category, equals(SuggestionCategory.lunar));
        expect(suggestion.expiresAt, equals(DateTime(2024, 1, 25, 14, 30)));
        expect(suggestion.isRead, isTrue);
        expect(suggestion.isActioned, isFalse);
        expect(suggestion.createdAt, equals(DateTime(2024, 1, 15, 10, 0)));
      });

      test('devrait dÃ©sÃ©rialiser une suggestion sans expiration depuis JSON',
          () {
        // Arrange
        final json = {
          'id': 'suggestion-from-json-002',
          'gardenId': 'garden-from-json-456',
          'message': 'Suggestion permanente',
          'priority': 'low',
          'category': 'weather',
          'expiresAt': null,
          'isRead': false,
          'isActioned': false,
          'createdAt': '2024-01-15T10:00:00.000',
        };

        // Act
        final suggestion = IntelligentSuggestion.fromJson(json);

        // Assert
        expect(suggestion.expiresAt, isNull);
      });

      test('devrait faire un round-trip JSON complet', () {
        // Arrange
        final original = IntelligentSuggestion(
          id: 'suggestion-roundtrip-001',
          gardenId: 'garden-roundtrip-123',
          message: 'Test round-trip complet',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.seasonal,
          expiresAt: DateTime(2024, 2, 1, 15, 45),
          isRead: true,
          isActioned: true,
          createdAt: DateTime(2024, 1, 15, 9, 30),
        );

        // Act
        final json = original.toJson();
        final restored = IntelligentSuggestion.fromJson(json);

        // Assert
        expect(restored.id, equals(original.id));
        expect(restored.gardenId, equals(original.gardenId));
        expect(restored.message, equals(original.message));
        expect(restored.priority, equals(original.priority));
        expect(restored.category, equals(original.category));
        expect(restored.expiresAt, equals(original.expiresAt));
        expect(restored.isRead, equals(original.isRead));
        expect(restored.isActioned, equals(original.isActioned));
        expect(restored.createdAt, equals(original.createdAt));
      });

      test('devrait gÃ©rer les valeurs par dÃ©faut lors de la dÃ©sÃ©rialisation',
          () {
        // Arrange - JSON sans isRead et isActioned (devraient Ãªtre false par dÃ©faut)
        final json = {
          'id': 'suggestion-defaults-001',
          'gardenId': 'garden-defaults-123',
          'message': 'Test valeurs par dÃ©faut',
          'priority': 'medium',
          'category': 'maintenance',
          'createdAt': '2024-01-15T10:00:00.000',
        };

        // Act
        final suggestion = IntelligentSuggestion.fromJson(json);

        // Assert
        expect(suggestion.isRead, isFalse);
        expect(suggestion.isActioned, isFalse);
      });
    });

    // ==================== COMPARAISON D'INSTANCES ====================

    group('Comparaison d\'instances', () {
      test('devrait comparer deux suggestions identiques avec ==', () {
        // Arrange
        final date = DateTime(2024, 1, 15, 10, 0);
        final suggestion1 = IntelligentSuggestion(
          id: 'suggestion-eq-001',
          gardenId: 'garden-eq-123',
          message: 'Test Ã©galitÃ©',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.seasonal,
          expiresAt: date.add(const Duration(days: 7)),
          isRead: false,
          isActioned: false,
          createdAt: date,
        );

        final suggestion2 = IntelligentSuggestion(
          id: 'suggestion-eq-001',
          gardenId: 'garden-eq-123',
          message: 'Test Ã©galitÃ©',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.seasonal,
          expiresAt: date.add(const Duration(days: 7)),
          isRead: false,
          isActioned: false,
          createdAt: date,
        );

        // Act & Assert
        expect(suggestion1, equals(suggestion2));
        expect(suggestion1.hashCode, equals(suggestion2.hashCode));
      });

      test('devrait diffÃ©rencier deux suggestions diffÃ©rentes avec ==', () {
        // Arrange
        final date = DateTime(2024, 1, 15, 10, 0);
        final suggestion1 = IntelligentSuggestion(
          id: 'suggestion-diff-001',
          gardenId: 'garden-diff-123',
          message: 'Test diffÃ©rence',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.seasonal,
          createdAt: date,
        );

        final suggestion2 = IntelligentSuggestion(
          id: 'suggestion-diff-002', // ID diffÃ©rent
          gardenId: 'garden-diff-123',
          message: 'Test diffÃ©rence',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.seasonal,
          createdAt: date,
        );

        // Act & Assert
        expect(suggestion1, isNot(equals(suggestion2)));
      });

      test('devrait utiliser copyWith pour crÃ©er une copie modifiÃ©e', () {
        // Arrange
        final original = IntelligentSuggestion(
          id: 'suggestion-copy-001',
          gardenId: 'garden-copy-123',
          message: 'Message original',
          priority: SuggestionPriority.low,
          category: SuggestionCategory.maintenance,
          isRead: false,
          isActioned: false,
          createdAt: DateTime(2024, 1, 15),
        );

        // Act
        final modified = original.copyWith(
          message: 'Message modifiÃ©',
          priority: SuggestionPriority.high,
          isRead: true,
        );

        // Assert
        expect(modified.id, equals(original.id));
        expect(modified.gardenId, equals(original.gardenId));
        expect(modified.message, equals('Message modifiÃ©'));
        expect(modified.priority, equals(SuggestionPriority.high));
        expect(modified.category, equals(original.category));
        expect(modified.isRead, isTrue);
        expect(modified.isActioned, equals(original.isActioned));
        expect(modified.createdAt, equals(original.createdAt));
      });

      test('devrait utiliser copyWith pour marquer comme lu', () {
        // Arrange
        final original = IntelligentSuggestion(
          id: 'suggestion-read-001',
          gardenId: 'garden-read-123',
          message: 'Suggestion non lue',
          priority: SuggestionPriority.medium,
          category: SuggestionCategory.weather,
          isRead: false,
          isActioned: false,
          createdAt: DateTime.now(),
        );

        // Act
        final markedAsRead = original.copyWith(isRead: true);

        // Assert
        expect(markedAsRead.isRead, isTrue);
        expect(original.isRead, isFalse); // Original inchangÃ© (immuable)
      });

      test('devrait utiliser copyWith pour marquer comme actionnÃ©e', () {
        // Arrange
        final original = IntelligentSuggestion(
          id: 'suggestion-action-001',
          gardenId: 'garden-action-123',
          message: 'Suggestion non actionnÃ©e',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.harvest,
          isRead: true,
          isActioned: false,
          createdAt: DateTime.now(),
        );

        // Act
        final markedAsActioned = original.copyWith(isActioned: true);

        // Assert
        expect(markedAsActioned.isActioned, isTrue);
        expect(original.isActioned, isFalse); // Original inchangÃ©
      });

      test('devrait utiliser copyWith pour modifier l\'expiration', () {
        // Arrange
        final original = IntelligentSuggestion(
          id: 'suggestion-expire-001',
          gardenId: 'garden-expire-123',
          message: 'Suggestion avec expiration',
          priority: SuggestionPriority.low,
          category: SuggestionCategory.seasonal,
          expiresAt: DateTime(2024, 1, 20),
          createdAt: DateTime(2024, 1, 15),
        );

        final newExpiration = DateTime(2024, 1, 25);

        // Act
        final modified = original.copyWith(expiresAt: newExpiration);

        // Assert
        expect(modified.expiresAt, equals(newExpiration));
        expect(original.expiresAt, equals(DateTime(2024, 1, 20))); // Original inchangÃ©
      });

      test('devrait utiliser copyWith pour supprimer l\'expiration', () {
        // Arrange
        final original = IntelligentSuggestion(
          id: 'suggestion-noexpire-001',
          gardenId: 'garden-noexpire-123',
          message: 'Suggestion avec expiration',
          priority: SuggestionPriority.medium,
          category: SuggestionCategory.pest,
          expiresAt: DateTime(2024, 1, 20),
          createdAt: DateTime(2024, 1, 15),
        );

        // Act
        final withoutExpiration = original.copyWith(expiresAt: null);

        // Assert
        expect(withoutExpiration.expiresAt, isNull);
        expect(original.expiresAt, isNotNull); // Original inchangÃ©
      });
    });

    // ==================== ENUMS ====================

    group('Enums', () {
      test('SuggestionPriority devrait avoir toutes les valeurs attendues', () {
        // Assert
        expect(SuggestionPriority.values, hasLength(3));
        expect(SuggestionPriority.values, contains(SuggestionPriority.high));
        expect(SuggestionPriority.values, contains(SuggestionPriority.medium));
        expect(SuggestionPriority.values, contains(SuggestionPriority.low));
      });

      test('SuggestionCategory devrait avoir toutes les valeurs attendues', () {
        // Assert
        expect(SuggestionCategory.values, hasLength(6));
        expect(SuggestionCategory.values, contains(SuggestionCategory.weather));
        expect(SuggestionCategory.values, contains(SuggestionCategory.lunar));
        expect(SuggestionCategory.values, contains(SuggestionCategory.seasonal));
        expect(SuggestionCategory.values, contains(SuggestionCategory.pest));
        expect(SuggestionCategory.values, contains(SuggestionCategory.harvest));
        expect(
            SuggestionCategory.values, contains(SuggestionCategory.maintenance));
      });

      test('devrait sÃ©rialiser/dÃ©sÃ©rialiser correctement les enums', () {
        // Arrange
        final priorities = SuggestionPriority.values;
        final categories = SuggestionCategory.values;

        for (final priority in priorities) {
          for (final category in categories) {
            final suggestion = IntelligentSuggestion(
              id: 'test-enum-${priority.name}-${category.name}',
              gardenId: 'garden-enum-123',
              message: 'Test enum',
              priority: priority,
              category: category,
              createdAt: DateTime.now(),
            );

            // Act
            final json = suggestion.toJson();
            final restored = IntelligentSuggestion.fromJson(json);

            // Assert
            expect(restored.priority, equals(priority));
            expect(restored.category, equals(category));
          }
        }
      });
    });

    // ==================== CAS LIMITES ====================

    group('Cas limites', () {
      test('devrait gÃ©rer une suggestion avec message vide', () {
        // Arrange & Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-empty-msg',
          gardenId: 'garden-empty-123',
          message: '',
          priority: SuggestionPriority.low,
          category: SuggestionCategory.maintenance,
          createdAt: DateTime.now(),
        );

        // Assert
        expect(suggestion.message, isEmpty);
        expect(suggestion.toJson()['message'], equals(''));
      });

      test('devrait gÃ©rer une suggestion avec message trÃ¨s long', () {
        // Arrange
        final longMessage = 'A' * 1000;

        // Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-long-msg',
          gardenId: 'garden-long-123',
          message: longMessage,
          priority: SuggestionPriority.medium,
          category: SuggestionCategory.weather,
          createdAt: DateTime.now(),
        );

        // Assert
        expect(suggestion.message, hasLength(1000));
        expect(suggestion.toJson()['message'], equals(longMessage));
      });

      test('devrait gÃ©rer une expiration dans le passÃ©', () {
        // Arrange
        final pastDate = DateTime(2020, 1, 1);

        // Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-past-expire',
          gardenId: 'garden-past-123',
          message: 'Suggestion expirÃ©e',
          priority: SuggestionPriority.low,
          category: SuggestionCategory.seasonal,
          expiresAt: pastDate,
          createdAt: DateTime.now(),
        );

        // Assert
        expect(suggestion.expiresAt, equals(pastDate));
        expect(suggestion.expiresAt!.isBefore(DateTime.now()), isTrue);
      });

      test('devrait gÃ©rer une expiration trÃ¨s lointaine', () {
        // Arrange
        final farFuture = DateTime(2100, 12, 31);

        // Act
        final suggestion = IntelligentSuggestion(
          id: 'suggestion-future-expire',
          gardenId: 'garden-future-123',
          message: 'Suggestion future',
          priority: SuggestionPriority.high,
          category: SuggestionCategory.harvest,
          expiresAt: farFuture,
          createdAt: DateTime.now(),
        );

        // Assert
        expect(suggestion.expiresAt, equals(farFuture));
        expect(suggestion.expiresAt!.isAfter(DateTime.now()), isTrue);
      });
    });
  });
}


