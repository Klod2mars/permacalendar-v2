import 'package:hive/hive.dart';
import '../../../../core/hive/type_ids.dart';

part 'soil_metrics_local_ds.g.dart';

/// Data Transfer Object for soil metrics storage
///
/// Compact model to store latest soil temperature and pH values
/// with timestamp for daily update heuristics.
@HiveType(typeId: kTypeIdSoilMetrics)
class SoilMetricsDto {
  @HiveField(0)
  final double? soilTempEstimatedC;

  @HiveField(1)
  final double? soilPH;

  @HiveField(2)
  final DateTime? lastComputed;

  @HiveField(3)
  final double? anchorTempC;

  @HiveField(4)
  final DateTime? anchorTimestamp;

  const SoilMetricsDto({
    this.soilTempEstimatedC,
    this.soilPH,
    this.lastComputed,
    this.anchorTempC,
    this.anchorTimestamp,
  });

  /// Factory constructor for creating new DTO
  factory SoilMetricsDto.create({
    double? soilTempEstimatedC,
    double? soilPH,
    DateTime? lastComputed,
    double? anchorTempC,
    DateTime? anchorTimestamp,
  }) {
    return SoilMetricsDto(
      soilTempEstimatedC: soilTempEstimatedC,
      soilPH: soilPH,
      lastComputed: lastComputed ?? DateTime.now(),
      anchorTempC: anchorTempC,
      anchorTimestamp: anchorTimestamp,
    );
  }

  /// Copy with method for updates
  SoilMetricsDto copyWith({
    double? soilTempEstimatedC,
    double? soilPH,
    DateTime? lastComputed,
    double? anchorTempC,
    DateTime? anchorTimestamp, // <-- corrigé ici
  }) {
    return SoilMetricsDto(
      soilTempEstimatedC: soilTempEstimatedC ?? this.soilTempEstimatedC,
      soilPH: soilPH ?? this.soilPH,
      lastComputed: lastComputed ?? this.lastComputed,
      anchorTempC: anchorTempC ?? this.anchorTempC,
      anchorTimestamp: anchorTimestamp ?? this.anchorTimestamp,
    );
  }

  /// Check if this DTO has any data
  bool get hasData =>
      soilTempEstimatedC != null || soilPH != null || anchorTempC != null;

  /// Check if soil temperature was updated today
  bool get isSoilTempUpdatedToday {
    if (lastComputed == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastUpdate = DateTime(
      lastComputed!.year,
      lastComputed!.month,
      lastComputed!.day,
    );
    return today.isAtSameMomentAs(lastUpdate);
  }

  @override
  String toString() {
    return 'SoilMetricsDto(soilTempEstimatedC: $soilTempEstimatedC, soilPH: $soilPH, lastComputed: $lastComputed, anchorTempC: $anchorTempC, anchorTimestamp: $anchorTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SoilMetricsDto &&
        other.soilTempEstimatedC == soilTempEstimatedC &&
        other.soilPH == soilPH &&
        other.lastComputed == lastComputed &&
        other.anchorTempC == anchorTempC &&
        other.anchorTimestamp == anchorTimestamp;
  }

  @override
  int get hashCode {
    return soilTempEstimatedC.hashCode ^
        soilPH.hashCode ^
        lastComputed.hashCode ^
        anchorTempC.hashCode ^
        anchorTimestamp.hashCode;
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

  /// Valeur par défaut : 8°C
  static const double kDefaultSoilTempC = 8.0;

  // Désactive les logs par défaut pour éviter les messages en masse.
  final bool _enableLogs;
  SoilMetricsLocalDataSourceImpl({bool enableLogs = false})
      : _enableLogs = enableLogs;

  void _log(String msg) {
    if (_enableLogs) {
      // Remplacez par votre logger si besoin (logger nommé, niveaux, etc.)
      print(msg);
    }
  }

  Box<SoilMetricsDto>? _box;
  bool _initializing = false;

  /// Initialize the data source and open Hive box
  Future<void> initialize() async {
    if (_box != null && _box!.isOpen) return;

    if (_initializing) {
      // Wait minor delay to avoid race if multiple calls?
      // Simple spin-wait or just proceed (Hive handles double open usually but best to lock)
      _log('[SoilMetricsLocalDS] Already initializing, waiting...');
      while (_initializing) {
        await Future.delayed(const Duration(milliseconds: 50));
        if (_box != null && _box!.isOpen) return;
      }
      return;
    }

    _initializing = true;
    _log('[SoilMetricsLocalDS] Initializing Hive Box: $_boxName');
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox<SoilMetricsDto>(_boxName);
      } else {
        _box = Hive.box<SoilMetricsDto>(_boxName);
      }
      _log('[SoilMetricsLocalDS] Box opened. Keys: ${_box?.keys.toList()}');
    } catch (e) {
      // Keep a visible error for failures to open the box.
      print('[SoilMetricsLocalDS] FATAL Error opening box: $e');
    } finally {
      _initializing = false;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await initialize();
    }
  }

  @override
  Future<SoilMetricsDto?> read(String scopeKey) async {
    await _ensureInitialized();
    try {
      final val = _box?.get(scopeKey);

      // If no data exists, create a default DTO with 8°C and persist it.
      if (val == null) {
        final defaultDto = SoilMetricsDto.create(
          soilTempEstimatedC: kDefaultSoilTempC,
          lastComputed: DateTime.now(),
        );

        // Silent write unless logs enabled
        await _box?.put(scopeKey, defaultDto);
        _log(
            '[SoilMetricsLocalDS] Default soil metrics created for $scopeKey (soilTempEstimatedC: $kDefaultSoilTempC)');
        return defaultDto;
      }

      _log('[SoilMetricsLocalDS] Read $scopeKey: $val');
      return val;
    } catch (e) {
      // Errors are printed to ensure they are visible (rare).
      print('[SoilMetricsLocalDS] Error reading $scopeKey: $e');
      return null;
    }
  }

  @override
  Future<void> write(String scopeKey, SoilMetricsDto value) async {
    await _ensureInitialized();
    try {
      _log('[SoilMetricsLocalDS] Writing $scopeKey: $value');
      await _box?.put(scopeKey, value);
      // Verify write
      final verify = _box?.get(scopeKey);
      _log('[SoilMetricsLocalDS] Verification read after write: $verify');
    } catch (e) {
      print('[SoilMetricsLocalDS] Error writing $scopeKey: $e');
    }
  }

  @override
  Future<void> delete(String scopeKey) async {
    await _ensureInitialized();
    try {
      _log('[SoilMetricsLocalDS] Deleting $scopeKey');
      await _box?.delete(scopeKey);
    } catch (e) {
      print('[SoilMetricsLocalDS] Error deleting $scopeKey: $e');
    }
  }

  @override
  Future<bool> exists(String scopeKey) async {
    await _ensureInitialized();
    try {
      return _box?.containsKey(scopeKey) ?? false;
    } catch (e) {
      print('[SoilMetricsLocalDS] Error checking existence $scopeKey: $e');
      return false;
    }
  }

  /// Get all scope keys (for debugging/migration)
  @override
  List<String> getAllScopeKeys() {
    // Sync method can't await. We assume initialized or return empty.
    if (_box == null || !_box!.isOpen) {
      _log('[SoilMetricsLocalDS] Warning: getAllScopeKeys called before init');
      return [];
    }
    try {
      return _box!.keys.cast<String>().toList();
    } catch (e) {
      print('[SoilMetricsLocalDS] Error getting scope keys: $e');
      return [];
    }
  }

  /// Clear all data (for testing/reset)
  @override
  Future<void> clearAll() async {
    await _ensureInitialized();
    try {
      await _box?.clear();
    } catch (e) {
      print('[SoilMetricsLocalDS] Error clearing all data: $e');
    }
  }
}
