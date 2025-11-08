import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:permacalendar/core/services/network_service.dart';
import 'package:permacalendar/features/plant_intelligence/data/datasources/plant_intelligence_remote_datasource.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';

class _MockNetworkService extends Mock implements NetworkService {}

void main() {
  late _MockNetworkService networkService;
  late PlantIntelligenceRemoteDataSourceImpl dataSource;

  setUp(() {
    networkService = _MockNetworkService();
    dataSource = PlantIntelligenceRemoteDataSourceImpl(
      networkService: networkService,
      requestTimeout: const Duration(milliseconds: 20),
      isBackendEnabled: () => true,
    );

    when(networkService.isInitialized).thenReturn(true);
  });

  group('PlantIntelligenceRemoteDataSourceImpl', () {
    test('getRemotePlantCondition returns parsed PlantCondition on success',
        () async {
      final now = DateTime.now();

      when(networkService.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((invocation) async {
        final path = invocation.positionalArguments.first as String;
        return Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: {
            'id': 'condition-1',
            'plantId': 'plant-123',
            'gardenId': 'garden-42',
            'type': 'temperature',
            'status': 'good',
            'value': 20.5,
            'optimalValue': 19.0,
            'minValue': 15.0,
            'maxValue': 25.0,
            'unit': 'C',
            'measuredAt': now.toIso8601String(),
          },
        );
      });

      final condition =
          await dataSource.getRemotePlantCondition('plant-123');

      expect(condition, isNotNull);
      expect(condition!.id, 'condition-1');
      expect(condition.type, ConditionType.temperature);
      expect(condition.status, ConditionStatus.good);
    });

    test('getRemotePlantConditionHistory returns empty list on server error',
        () async {
      when(networkService.get<List<dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenThrow(const NetworkException(
        'Server error',
        type: NetworkExceptionType.serverError,
      ));

      final history = await dataSource.getRemotePlantConditionHistory(
        plantId: 'plant-123',
      );

      expect(history, isEmpty);
    });

    test('getRemoteWeatherData returns default value on timeout', () async {
      when(networkService.get<List<dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer(
        (invocation) => Future.delayed(
          const Duration(milliseconds: 80),
          () => Response<List<dynamic>>(
            requestOptions: RequestOptions(
              path: invocation.positionalArguments.first as String,
            ),
            statusCode: 200,
            data: const [],
          ),
        ),
      );

      final weather = await dataSource.getRemoteWeatherData(
        gardenId: 'garden-1',
      );

      expect(weather, isEmpty);
    });

    test('getRemoteRecommendations throws when payload is corrupted',
        () async {
      when(networkService.post<List<dynamic>>(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((invocation) async {
        final path = invocation.positionalArguments.first as String;
        return Response<List<dynamic>>(
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
          data: const ['invalid'],
        );
      });

      expect(
        () => dataSource.getPersonalizedRecommendations(
          plantId: 'plant-1',
          context: const {'mode': 'test'},
        ),
        throwsA(isA<PlantIntelligenceRemoteDataSourceException>()),
      );
    });
  });
}

