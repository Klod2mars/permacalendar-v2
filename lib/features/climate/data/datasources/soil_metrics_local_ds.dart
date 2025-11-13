ï»¿import 'package:hive/hive.dart';
import '../../../../core/hive/type_ids.dart';

part 'soil_metrics_local_ds.g.dart';

/// Data Transfer Object for soil metrics storage
///
/// Compact model to store latest soil temperature and pH values
/// with timestamp for daily update heuristics.
@HiveType(typeId: kTypeIdSoilMetrics)
class SoilMetricsDto {
  @HiveField(0)
  final double? soilTempC;

  @HiveField(1)
  final double? soilPH;

  @HiveField(2)
  final DateTime? lastUpdated;

  const SoilMetricsDto({
    this.soilTempC,
    this.soilPH,
    this.lastUpdated,
  });

  /// Factory constructor for creating new DTO
  factory SoilMetricsDto.create({
    double? soilTempC,
    double? soilPH,
    DateTime? lastUpdated,
  }) {
    return SoilMetricsDto(
      soilTempC: soilTempC,
      soilPH: soilPH,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  /// Copy with method for updates
  SoilMetricsDto copyWith({
    double? soilTempC,
    double? soilPH,
    DateTime? lastUpdated,
  }) {
    return SoilMetricsDto(
      soilTempC: soilTempC ?? this.soilTempC,
      soilPH: soilPH ?? this.soilPH,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Check if this DTO has any data
  bool get hasData => soilTempC != null || soilPH != null;

  /// Check if soil temperature was updated today
  bool get isSoilTempUpdatedToday {
    if (lastUpdated == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastUpdate = DateTime(
      lastUpdated!.year,
      lastUpdated!.month,
      lastUpdated!.day,
    );
    return today.isAtSameMomentAs(lastUpdate);
  }

  @override
  String toString() {
    return 'SoilMetricsDto(soilTempC: $soilTempC, soilPH: $soilPH, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SoilMetricsDto &&
        other.soilTempC == soilTempC &&
        other.soilPH == soilPH &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return soilTempC.hashCode ^ soilPH.hashCode ^ lastUpdated.hashCode;
  }
}

/// Local data source for soil metrics persistence
///
/// Handles Hive storage for soil temperature and pH data
/// with scope-based keys (garden:<gardenId>).
abstract class SoilMetricsLocalDataSource {
  /// Read soil metrics for a specific scope
  Future<SoilMetricsDto?> read(String scopeKey);

  /// Write soil metrics for a specific scope
  Future<void> write(String scopeKey, SoilMetricsDto value);

  /// Delete soil metrics for a specific scope
  Future<void> delete(String scopeKey);

  /// Check if data exists for a scope
  Future<bool> exists(String scopeKey);

  /// Get all scope keys (for debugging/migration)
  List<String> getAllScopeKeys();

  /// Clear all data (for testing/reset)
  Future<void> clearAll();
}

/// Implementation of soil metrics local data source using Hive
class SoilMetricsLocalDataSourceImpl implements SoilMetricsLocalDataSource {
  static const String _boxName = 'soil_metrics.box';
  late final Box<SoilMetricsDto> _box;

  /// Initialize the data source and open Hive box
  Future<void> initialize() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<SoilMetricsDto>(_boxName);
    } else {
      _box = Hive.box<SoilMetricsDto>(_boxName);
    }
  }

  @override
  Future<SoilMetricsDto?> read(String scopeKey) async {
    try {
      return _box.get(scopeKey);
    } catch (e) {
      // Log error but don't throw to maintain app stability
      print('[SoilMetricsLocalDataSource] Error reading $scopeKey: $e');
      return null;
    }
  }

  @override
  Future<void> write(String scopeKey, SoilMetricsDto value) async {
    try {
      await _box.put(scopeKey, value);
    } catch (e) {
      // Log error but don't throw to maintain app stability
      print('[SoilMetricsLocalDataSource] Error writing $scopeKey: $e');
    }
  }

  @override
  Future<void> delete(String scopeKey) async {
    try {
      await _box.delete(scopeKey);
    } catch (e) {
      // Log error but don't throw to maintain app stability
      print('[SoilMetricsLocalDataSource] Error deleting $scopeKey: $e');
    }
  }

  @override
  Future<bool> exists(String scopeKey) async {
    try {
      return _box.containsKey(scopeKey);
    } catch (e) {
      print(
          '[SoilMetricsLocalDataSource] Error checking existence $scopeKey: $e');
      return false;
    }
  }

  /// Get all scope keys (for debugging/migration)
  @override
  List<String> getAllScopeKeys() {
    try {
      return _box.keys.cast<String>().toList();
    } catch (e) {
      print('[SoilMetricsLocalDataSource] Error getting scope keys: $e');
      return [];
    }
  }

  /// Clear all data (for testing/reset)
  @override
  Future<void> clearAll() async {
    try {
      await _box.clear();
    } catch (e) {
      print('[SoilMetricsLocalDataSource] Error clearing all data: $e');
    }
  }
}


