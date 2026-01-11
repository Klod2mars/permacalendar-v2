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
      return dto?.soilTempEstimatedC;
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
  Future<void> setManualAnchor(String scopeKey, double anchorTempC, DateTime timestamp) async {
    try {
      // Validate
      if (anchorTempC < -50.0 || anchorTempC > 60.0) {
        throw ArgumentError(
            'Temperature must be between -50°C and 60°C, got $anchorTempC');
      }

      final existingDto = await _localDataSource.read(scopeKey);
      final updatedDto = existingDto?.copyWith(
            anchorTempC: anchorTempC,
            anchorTimestamp: timestamp,
            soilTempEstimatedC: anchorTempC, // Reset estimated to anchor
            lastComputed: timestamp,
          ) ??
          SoilMetricsDto.create(
            anchorTempC: anchorTempC,
            anchorTimestamp: timestamp,
            soilTempEstimatedC: anchorTempC,
            lastComputed: timestamp,
          );

      await _localDataSource.write(scopeKey, updatedDto);
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error setting manual anchor for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<void> setEstimatedTemp(String scopeKey, double estimated, DateTime computedAt) async {
    try {
       // Validate
      if (estimated < -50.0 || estimated > 60.0) {
        throw ArgumentError(
            'Temperature must be between -50°C and 60°C, got $estimated');
      }

      final existingDto = await _localDataSource.read(scopeKey);
      final updatedDto = existingDto?.copyWith(
            soilTempEstimatedC: estimated,
            lastComputed: computedAt,
          ) ??
          SoilMetricsDto.create(
            soilTempEstimatedC: estimated,
            lastComputed: computedAt,
          );

      await _localDataSource.write(scopeKey, updatedDto);
    } catch (e) {
      print(
          '[SoilMetricsRepository] Error setting estimated temp for $scopeKey: $e');
      rethrow;
    }
  }

  @override
  Future<void> setSoilTempC(String scopeKey, double tempC) async {
    // Backward compatibility: treat as estimated update or manual without anchor logic?
    // The user prompt analysis suggested "SoilTempController.updateFromAirTemp calculates a nextTemp and saves it...".
    // So this is likely used for estimated updates.
    await setEstimatedTemp(scopeKey, tempC, DateTime.now());
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
            lastComputed: DateTime.now(),
          ) ??
          SoilMetricsDto.create(
            soilPH: ph,
            lastComputed: DateTime.now(),
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
      return dto?.lastComputed;
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
        final updatedDto = existingDto.copyWith(lastComputed: timestamp);
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
    print('[SoilMetricsRepo] getAllMetrics($scopeKey)');
    try {
      final dto = await _localDataSource.read(scopeKey);
      if (dto == null) {
        print('[SoilMetricsRepo] No data found for $scopeKey');
        return null;
      }
      
      print('[SoilMetricsRepo] Found DTO: $dto');

      return {
        'soilTempC': dto.soilTempEstimatedC, // OLD KEY COMPATIBILITY
        'soilPH': dto.soilPH,
        'lastUpdated': dto.lastComputed, // OLD KEY COMPATIBILITY
        
        'soilTempEstimatedC': dto.soilTempEstimatedC,
        'lastComputed': dto.lastComputed,
        'anchorTempC': dto.anchorTempC,
        'anchorTimestamp': dto.anchorTimestamp,
      };
    } catch (e) {
      print('[SoilMetricsRepo] Error reading metrics: $e');
      return null;
    }
  }

  @override
  Future<void> setAllMetrics(
      String scopeKey, Map<String, dynamic> metrics) async {
    try {
      final soilTempEstimatedC = metrics['soilTempEstimatedC'] as double? ?? metrics['soilTempC'] as double?;
      final anchorTempC = metrics['anchorTempC'] as double?;
      final anchorTimestamp = metrics['anchorTimestamp'] as DateTime?;
      final soilPH = metrics['soilPH'] as double?;
      final lastComputed = metrics['lastComputed'] as DateTime? ?? metrics['lastUpdated'] as DateTime?;

      // Validate inputs
      if (soilTempEstimatedC != null && (soilTempEstimatedC < -50.0 || soilTempEstimatedC > 60.0)) {
        throw ArgumentError(
            'Temperature must be between -50°C and 60°C, got $soilTempEstimatedC');
      }
      if (soilPH != null && (soilPH < 0.0 || soilPH > 14.0)) {
        throw ArgumentError('pH must be between 0.0 and 14.0, got $soilPH');
      }

      final dto = SoilMetricsDto.create(
        soilTempEstimatedC: soilTempEstimatedC,
        soilPH: soilPH,
        lastComputed: lastComputed ?? DateTime.now(),
        anchorTempC: anchorTempC,
        anchorTimestamp: anchorTimestamp,
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
