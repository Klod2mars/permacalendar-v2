import '../../domain/repositories/soil_metrics_repository.dart';
import '../datasources/soil_metrics_local_ds.dart';

/// Implementation of soil metrics repository using local data source
///
/// Handles all soil metrics operations through the local Hive storage.
/// Provides error handling and data validation.
class SoilMetricsRepositoryImpl implements SoilMetricsRepository {
  final SoilMetricsLocalDataSource _localDataSource;

  const SoilMetricsRepositoryImpl({
    required SoilMetricsLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<double?> getSoilTempC(String scopeKey) async {
    try {
      final dto = await _localDataSource.read(scopeKey);
      return dto?.soilTempC;
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error getting soil temp for $scopeKey: $e');
      return null;
    }
  }

  @override
  Future<double?> getSoilPH(String scopeKey) async {
    try {
      final dto = await _localDataSource.read(scopeKey);
      return dto?.soilPH;
    } catch (e) {
      print('[SoilMetricsRepository] Error getting soil pH for $scopeKey: $e');
      return null;
    }
  }

  @override
  Future<void> setSoilTempC(String scopeKey, double tempC) async {
    try {
      // Validate temperature range
      if (tempC < -50.0 || tempC > 60.0) {
        throw ArgumentError(
            'Temperature must be between -50Â°C and 60Â°C, got $tempC');
      }

      final existingDto = await _localDataSource.read(scopeKey);
      final updatedDto = existingDto?.copyWith(
            soilTempC: tempC,
            lastUpdated: DateTime.now(),
          ) ??
          SoilMetricsDto.create(
            soilTempC: tempC,
            lastUpdated: DateTime.now(),
          );

      await _localDataSource.write(scopeKey, updatedDto);
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error setting soil temp for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<void> setSoilPH(String scopeKey, double ph) async {
    try {
      // Validate pH range
      if (ph < 0.0 || ph > 14.0) {
        throw ArgumentError('pH must be between 0.0 and 14.0, got $ph');
      }

      final existingDto = await _localDataSource.read(scopeKey);
      final updatedDto = existingDto?.copyWith(
            soilPH: ph,
            lastUpdated: DateTime.now(),
          ) ??
          SoilMetricsDto.create(
            soilPH: ph,
            lastUpdated: DateTime.now(),
          );

      await _localDataSource.write(scopeKey, updatedDto);
    } catch (e) {
      print('[SoilMetricsRepository] Error setting soil pH for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<DateTime?> getLastUpdated(String scopeKey) async {
    try {
      final dto = await _localDataSource.read(scopeKey);
      return dto?.lastUpdated;
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error getting last updated for $scopeKey: $e');
      return null;
    }
  }

  @override
  Future<void> setLastUpdated(String scopeKey, DateTime timestamp) async {
    try {
      final existingDto = await _localDataSource.read(scopeKey);
      if (existingDto != null) {
        final updatedDto = existingDto.copyWith(lastUpdated: timestamp);
        await _localDataSource.write(scopeKey, updatedDto);
      }
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error setting last updated for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getAllMetrics(String scopeKey) async {
    try {
      final dto = await _localDataSource.read(scopeKey);
      if (dto == null) return null;

      return {
        'soilTempC': dto.soilTempC,
        'soilPH': dto.soilPH,
        'lastUpdated': dto.lastUpdated,
        'hasData': dto.hasData,
        'isSoilTempUpdatedToday': dto.isSoilTempUpdatedToday,
      };
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error getting all metrics for $scopeKey: $e');
      return null;
    }
  }

  @override
  Future<void> setAllMetrics(
      String scopeKey, Map<String, dynamic> metrics) async {
    try {
      final soilTempC = metrics['soilTempC'] as double?;
      final soilPH = metrics['soilPH'] as double?;
      final lastUpdated = metrics['lastUpdated'] as DateTime?;

      // Validate inputs
      if (soilTempC != null && (soilTempC < -50.0 || soilTempC > 60.0)) {
        throw ArgumentError(
            'Temperature must be between -50Â°C and 60Â°C, got $soilTempC');
      }
      if (soilPH != null && (soilPH < 0.0 || soilPH > 14.0)) {
        throw ArgumentError('pH must be between 0.0 and 14.0, got $soilPH');
      }

      final dto = SoilMetricsDto.create(
        soilTempC: soilTempC,
        soilPH: soilPH,
        lastUpdated: lastUpdated ?? DateTime.now(),
      );

      await _localDataSource.write(scopeKey, dto);
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error setting all metrics for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMetrics(String scopeKey) async {
    try {
      await _localDataSource.delete(scopeKey);
    } catch (e) {
      print('[SoilMetricsRepository] Error deleting metrics for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasMetrics(String scopeKey) async {
    try {
      return await _localDataSource.exists(scopeKey);
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error checking metrics existence for $scopeKey: $e');
      return false;
    }
  }

  @override
  Future<List<String>> getAllScopeKeys() async {
    try {
      return _localDataSource.getAllScopeKeys();
    } catch (e) {
      print('[SoilMetricsRepository] Error getting all scope keys: $e');
      return [];
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getMetricsForScopes(
      List<String> scopeKeys) async {
    try {
      final result = <String, Map<String, dynamic>>{};

      for (final scopeKey in scopeKeys) {
        final metrics = await getAllMetrics(scopeKey);
        if (metrics != null) {
          result[scopeKey] = metrics;
        }
      }

      return result;
    } catch (e) {
      print('[SoilMetricsRepository] Error getting metrics for scopes: $e');
      return {};
    }
  }

  @override
  Future<void> clearAllMetrics() async {
    try {
      await _localDataSource.clearAll();
    } catch (e) {
      print('[SoilMetricsRepository] Error clearing all metrics: $e');
      rethrow;
    }
  }
}
