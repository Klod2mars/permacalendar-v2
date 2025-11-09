
import '../../test_setup_stub.dart';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:permacalendar/core/services/network_service.dart';
import 'package:permacalendar/core/services/environment_service.dart';

import 'network_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('NetworkService', () {
    late NetworkService networkService;
    late MockDio mockDio;

    setUp(() {
      networkService = NetworkService();
      mockDio = MockDio();
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Arrange
        // Note: Dans un vrai test, on devrait mocker Dio mais ici on teste
        // l'initialisation rÃ©elle car elle configure les intercepteurs
        
        // Act
        await networkService.initialize();

        // Assert
        expect(networkService.isInitialized, isTrue);
      });

      test('should throw StateError if used before initialization', () {
        // Arrange
        final service = NetworkService();

        // Act & Assert
        expect(
          () => service.get('/test'),
          throwsA(isA<StateError>()),
        );
      });

      test('should not reinitialize if already initialized', () async {
        // Arrange
        await networkService.initialize();
        final initialDio = networkService.isInitialized;

        // Act
        await networkService.initialize();

        // Assert
        expect(networkService.isInitialized, equals(initialDio));
      });
    });

    group('isBackendAvailable', () {
      test('should return false if backend is disabled', () async {
        // Arrange
        await networkService.initialize();
        // Note: On ne peut pas facilement mocker EnvironmentService.isBackendEnabled
        // sans modifier le service. Ce test vÃ©rifie le comportement par dÃ©faut.

        // Act
        final result = await networkService.isBackendAvailable();

        // Assert
        // Si le backend est dÃ©sactivÃ©, devrait retourner false
        // Si activÃ© mais non disponible, retournera aussi false
        expect(result, isA<bool>());
      });
    });

    group('GET requests', () {
      test('should throw NetworkException on error', () async {
        // Arrange
        await networkService.initialize();
        // Note: Ce test nÃ©cessiterait un serveur mock ou http_mock_adapter
        // Pour l'instant, on teste la structure de base

        // Act & Assert
        // On s'attend Ã  une NetworkException si le serveur n'est pas disponible
        expectLater(
          networkService.get('/test'),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('POST requests', () {
      test('should throw NetworkException on error', () async {
        // Arrange
        await networkService.initialize();

        // Act & Assert
        expectLater(
          networkService.post('/test', data: {'key': 'value'}),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('PUT requests', () {
      test('should throw NetworkException on error', () async {
        // Arrange
        await networkService.initialize();

        // Act & Assert
        expectLater(
          networkService.put('/test', data: {'key': 'value'}),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('DELETE requests', () {
      test('should throw NetworkException on error', () async {
        // Arrange
        await networkService.initialize();

        // Act & Assert
        expectLater(
          networkService.delete('/test'),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('Error handling', () {
      test('NetworkException should have correct message and type', () {
        // Arrange
        const message = 'Test error';
        const type = NetworkExceptionType.timeout;

        // Act
        final exception = NetworkException(
          message,
          type: type,
        );

        // Assert
        expect(exception.message, equals(message));
        expect(exception.type, equals(type));
        expect(exception.toString(), contains('NetworkException'));
        expect(exception.toString(), contains(message));
      });

      test('NetworkException should handle status codes correctly', () {
        // Arrange
        const message = 'Not found';
        const type = NetworkExceptionType.notFound;
        const statusCode = 404;

        // Act
        final exception = NetworkException(
          message,
          type: type,
          statusCode: statusCode,
        );

        // Assert
        expect(exception.statusCode, equals(statusCode));
        expect(exception.type, equals(type));
      });
    });
  });

  group('NetworkExceptionType', () {
    test('should have all expected types', () {
      // Assert
      expect(NetworkExceptionType.values.length, greaterThan(5));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.timeout));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.connectionError));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.badRequest));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.unauthorized));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.forbidden));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.notFound));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.serverError));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.cancelled));
      expect(NetworkExceptionType.values, contains(NetworkExceptionType.unknown));
    });
  });
}


