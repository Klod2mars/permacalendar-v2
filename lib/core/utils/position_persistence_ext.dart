import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Position persistence helper dedicated to Riverpod-centric calibration flows.
///
/// Role:
/// - Centralises the normalized storage of widget positions (`x`, `y`, `size`, `enabled`).
/// - Acts as the single entry point used by calibration, zone orchestration and widget
///   placement services to read/write persisted layouts.
///
/// Integration:
/// - Consumed by calibration/coaching state (`CalibrationState`) to persist organic layouts.
/// - Compatible with visual models (`GardenZone`, `WidgetPlacement`) through JSON maps using
///   `{x, y, size, enabled}` keys.
/// - Use through Riverpod providers by injecting [`SharedPreferences`] via `ref.read`.
///
/// Best practices:
/// - Always await async operations to avoid UI desync.
/// - Validate inputs (normalized coordinates, positive size) before persisting.
/// - Handle [PositionPersistenceException] to surface storage issues without crashing UI.
///
/// Example:
/// ```dart
/// final prefs = ref.read(sharedPreferencesProvider);
/// await PositionPersistenceExt.savePosition(
///   'organic',
///   'METEO',
///   const NormalizedPosition(x: 0.45, y: 0.18, size: 0.3, enabled: true),
/// );
/// final restored =
///     await PositionPersistenceExt.restorePosition('organic', 'METEO');
/// ```
class PositionPersistenceExt {
  PositionPersistenceExt._();

  static Future<void> _writeChain = Future<void>.value();
  static Future<SharedPreferences> Function() _prefsFactory =
      SharedPreferences.getInstance;

  @visibleForTesting
  static void setPrefsFactory(
      Future<SharedPreferences> Function() prefsFactory) {
    _prefsFactory = prefsFactory;
  }

  @visibleForTesting
  static void resetPrefsFactory() {
    _prefsFactory = SharedPreferences.getInstance;
  }

  static Future<void> savePosition(
    String prefix,
    String key,
    NormalizedPosition position,
  ) async {
    final sanitized = position.clamp();
    if (!sanitized.isFinite) {
      throw ArgumentError(
        'Invalid normalized position for $prefix/$key: $position',
      );
    }

    await _runLocked(() async {
      try {
        final prefs = await _prefsFactory();
        await prefs.setDouble(_xKey(prefix, key), sanitized.x);
        await prefs.setDouble(_yKey(prefix, key), sanitized.y);
        await prefs.setDouble(_sizeKey(prefix, key), sanitized.size);
        await prefs.setBool(_enabledKey(prefix, key), sanitized.enabled);

        _log(
          '✅ savePosition($prefix, $key) - '
          'x:${sanitized.x}, y:${sanitized.y}, size:${sanitized.size}, enabled:${sanitized.enabled}',
        );
      } catch (error, stackTrace) {
        _log('❌ savePosition($prefix, $key) - Error: $error');
        throw PositionPersistenceException(
          'Failed to save position for $prefix/$key',
          error,
          stackTrace,
        );
      }
    });
  }

  static Future<NormalizedPosition?> restorePosition(
    String prefix,
    String key, {
    NormalizedPosition? fallback,
  }) async {
    try {
      final prefs = await _prefsFactory();
      final restored = NormalizedPosition.tryParse(
        x: prefs.getDouble(_xKey(prefix, key)),
        y: prefs.getDouble(_yKey(prefix, key)),
        size: prefs.getDouble(_sizeKey(prefix, key)),
        enabled: prefs.getBool(_enabledKey(prefix, key)),
      );

      if (restored != null) {
        _log(
          '✅ restorePosition($prefix, $key) - '
          'x:${restored.x}, y:${restored.y}, size:${restored.size}, enabled:${restored.enabled}',
        );
        return restored;
      }

      _log(
        '⚠️ restorePosition($prefix, $key) - No stored position, '
        'fallback used: $fallback',
      );
      return fallback;
    } catch (error, stackTrace) {
      _log('❌ restorePosition($prefix, $key) - Error: $error');
      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }
      return fallback;
    }
  }

  static Future<void> clearPosition(String prefix, String key) async {
    await _runLocked(() async {
      try {
        final prefs = await _prefsFactory();
        await prefs.remove(_xKey(prefix, key));
        await prefs.remove(_yKey(prefix, key));
        await prefs.remove(_sizeKey(prefix, key));
        await prefs.remove(_enabledKey(prefix, key));
        _log('✅ clearPosition($prefix, $key) - Keys removed');
      } catch (error, stackTrace) {
        _log('❌ clearPosition($prefix, $key) - Error: $error');
        throw PositionPersistenceException(
          'Failed to clear position for $prefix/$key',
          error,
          stackTrace,
        );
      }
    });
  }

  static Map<String, dynamic> toJson(NormalizedPosition position) =>
      position.toJson();

  static NormalizedPosition? fromJson(
    Map<String, dynamic>? json, {
    NormalizedPosition? fallback,
  }) =>
      NormalizedPosition.fromJson(json) ?? fallback;

  static Future<void> writePosition(
    String prefix,
    String key,
    double x,
    double y, {
    double? size,
    bool enabled = true,
  }) {
    return savePosition(
      prefix,
      key,
      NormalizedPosition(
        x: x,
        y: y,
        size: size ?? NormalizedPosition.defaultSize,
        enabled: enabled,
      ),
    );
  }

  static Future<Map<String, dynamic>?> readPosition(
    String prefix,
    String key,
  ) async {
    final restored = await restorePosition(prefix, key);
    return restored?.toJson();
  }

  static void _log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static String _xKey(String prefix, String key) => '${prefix}_${key}_x';
  static String _yKey(String prefix, String key) => '${prefix}_${key}_y';
  static String _sizeKey(String prefix, String key) => '${prefix}_${key}_size';
  static String _enabledKey(String prefix, String key) =>
      '${prefix}_${key}_bool';

  static Future<T> _runLocked<T>(Future<T> Function() action) {
    final future = _writeChain.then((_) => action());
    _writeChain = future.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return future;
  }
}

@immutable
class NormalizedPosition {
  const NormalizedPosition({
    required this.x,
    required this.y,
    this.size = defaultSize,
    this.enabled = true,
  });

  static const double minAxis = 0.0;
  static const double maxAxis = 1.0;
  static const double minSize = 0.01;
  static const double maxSize = 1.0;
  static const double defaultSize = 0.22;

  final double x;
  final double y;
  final double size;
  final bool enabled;

  bool get isFinite => x.isFinite && y.isFinite && size.isFinite;

  bool get isValid =>
      isFinite &&
      x >= minAxis &&
      x <= maxAxis &&
      y >= minAxis &&
      y <= maxAxis &&
      size >= minSize &&
      size <= maxSize;

  NormalizedPosition clamp() => NormalizedPosition(
        x: x.clamp(minAxis, maxAxis).toDouble(),
        y: y.clamp(minAxis, maxAxis).toDouble(),
        size: size.clamp(minSize, maxSize).toDouble(),
        enabled: enabled,
      );

  NormalizedPosition copyWith({
    double? x,
    double? y,
    double? size,
    bool? enabled,
  }) {
    return NormalizedPosition(
      x: x ?? this.x,
      y: y ?? this.y,
      size: size ?? this.size,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': x,
        'y': y,
        'size': size,
        'enabled': enabled,
      };

  static NormalizedPosition? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return tryParse(
      x: _asDouble(json['x']),
      y: _asDouble(json['y']),
      size: _asDouble(json['size']),
      enabled: json['enabled'] is bool ? json['enabled'] as bool : null,
    );
  }

  static NormalizedPosition? tryParse({
    double? x,
    double? y,
    double? size,
    bool? enabled,
  }) {
    if (!_isFinite(x) || !_isFinite(y)) {
      return null;
    }

    final candidate = NormalizedPosition(
      x: x!,
      y: y!,
      size: _isFinite(size) ? size! : defaultSize,
      enabled: enabled ?? true,
    ).clamp();

    return candidate.isValid ? candidate : null;
  }

  static double? _asDouble(Object? value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static bool _isFinite(double? value) =>
      value != null && value.isFinite && !value.isNaN;

  @override
  String toString() => 'NormalizedPosition(x: $x, y: $y, size: $size, '
      'enabled: $enabled)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NormalizedPosition) return false;
    return x == other.x &&
        y == other.y &&
        size == other.size &&
        enabled == other.enabled;
  }

  @override
  int get hashCode => Object.hash(x, y, size, enabled);
}

class PositionPersistenceException implements Exception {
  PositionPersistenceException(this.message, this.cause, [this.stackTrace]);

  final String message;
  final Object cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'PositionPersistenceException($message, $cause)';
}
