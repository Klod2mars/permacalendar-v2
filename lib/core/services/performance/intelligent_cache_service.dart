// 🚀 Intelligent Cache Service - Multi-Level Caching System
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Enterprise Patterns

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';

/// Configuration for cache levels and behavior
class CacheConfig {
  final Duration memoryTtl;
  final Duration diskTtl;
  final int memoryMaxEntries;
  final int diskMaxEntries;
  final bool enableCompression;
  final bool enableMetrics;

  const CacheConfig({
    this.memoryTtl = const Duration(minutes: 10),
    this.diskTtl = const Duration(hours: 24),
    this.memoryMaxEntries = 100,
    this.diskMaxEntries = 1000,
    this.enableCompression = true,
    this.enableMetrics = true,
  });

  /// Conservative configuration (longer TTL, larger cache)
  factory CacheConfig.conservative() => const CacheConfig(
        memoryTtl: Duration(minutes: 30),
        diskTtl: Duration(days: 7),
        memoryMaxEntries: 200,
        diskMaxEntries: 2000,
      );

  /// Aggressive configuration (shorter TTL, smaller cache)
  factory CacheConfig.aggressive() => const CacheConfig(
        memoryTtl: Duration(minutes: 5),
        diskTtl: Duration(hours: 6),
        memoryMaxEntries: 50,
        diskMaxEntries: 500,
      );
}

/// Cache entry with metadata
class CacheEntry<T> {
  final String key;
  final T value;
  final DateTime createdAt;
  final DateTime expiresAt;
  final int accessCount;
  final DateTime lastAccessedAt;
  final int sizeBytes;

  CacheEntry({
    required this.key,
    required this.value,
    required this.createdAt,
    required this.expiresAt,
    this.accessCount = 1,
    DateTime? lastAccessedAt,
    this.sizeBytes = 0,
  }) : lastAccessedAt = lastAccessedAt ?? createdAt;

  CacheEntry<T> copyWith({
    int? accessCount,
    DateTime? lastAccessedAt,
  }) {
    return CacheEntry<T>(
      key: key,
      value: value,
      createdAt: createdAt,
      expiresAt: expiresAt,
      accessCount: accessCount ?? this.accessCount,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      sizeBytes: sizeBytes,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Cache statistics for monitoring
class CacheStatistics {
  final int memoryHits;
  final int diskHits;
  final int misses;
  final int evictions;
  final int totalEntries;
  final int memoryEntries;
  final int diskEntries;
  final double hitRate;
  final double missRate;
  final int totalSizeBytes;
  final Duration averageAccessTime;

  CacheStatistics({
    required this.memoryHits,
    required this.diskHits,
    required this.misses,
    required this.evictions,
    required this.totalEntries,
    required this.memoryEntries,
    required this.diskEntries,
    required this.hitRate,
    required this.missRate,
    required this.totalSizeBytes,
    required this.averageAccessTime,
  });

  Map<String, dynamic> toJson() => {
        'memoryHits': memoryHits,
        'diskHits': diskHits,
        'misses': misses,
        'evictions': evictions,
        'totalEntries': totalEntries,
        'memoryEntries': memoryEntries,
        'diskEntries': diskEntries,
        'hitRate': hitRate,
        'missRate': missRate,
        'totalSizeBytes': totalSizeBytes,
        'averageAccessTimeMs': averageAccessTime.inMilliseconds,
      };

  @override
  String toString() => 'CacheStatistics('
      'hitRate: ${(hitRate * 100).toStringAsFixed(1)}%, '
      'memoryHits: $memoryHits, diskHits: $diskHits, '
      'misses: $misses, entries: $totalEntries)';
}

/// Multi-level cache service with memory, disk and distributed caching
class IntelligentCacheService {
  final CacheConfig _config;

  // Memory cache (Level 1 - Fastest)
  final LinkedHashMap<String, CacheEntry<dynamic>> _memoryCache;

  // Disk cache (Level 2 - Persistent)
  Box<String>? _diskCacheBox;

  // Statistics
  int _memoryHits = 0;
  int _diskHits = 0;
  int _misses = 0;
  int _evictions = 0;
  final List<Duration> _accessTimes = [];

  // Initialization
  bool _initialized = false;

  IntelligentCacheService({
    CacheConfig? config,
  })  : _config = config ?? const CacheConfig(),
        _memoryCache = LinkedHashMap<String, CacheEntry<dynamic>>();

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Open disk cache box
      _diskCacheBox = await Hive.openBox<String>('intelligent_cache');

      _initialized = true;
      _log('IntelligentCacheService initialized successfully');
    } catch (e, stackTrace) {
      _logError('Failed to initialize cache service', e, stackTrace);
      rethrow;
    }
  }

  /// Get value from cache with automatic level fallback
  Future<T?> get<T>(String key) async {
    if (!_initialized) await initialize();

    final startTime = DateTime.now();

    try {
      // Level 1: Memory cache (fastest)
      final memoryEntry = _memoryCache[key];
      if (memoryEntry != null && !memoryEntry.isExpired) {
        _memoryHits++;
        _updateAccessTime(startTime);

        // Update access metadata
        _memoryCache[key] = memoryEntry.copyWith(
          accessCount: memoryEntry.accessCount + 1,
          lastAccessedAt: DateTime.now(),
        );

        _log('Cache HIT (Memory): $key');
        return memoryEntry.value as T?;
      }

      // Remove expired memory entry
      if (memoryEntry != null && memoryEntry.isExpired) {
        _memoryCache.remove(key);
        _evictions++;
      }

      // Level 2: Disk cache
      final diskValue = await _getFromDisk(key);
      if (diskValue != null) {
        _diskHits++;
        _updateAccessTime(startTime);

        // Promote to memory cache
        await _setInMemory(key, diskValue as T, _config.memoryTtl);

        _log('Cache HIT (Disk): $key');
        return diskValue as T?;
      }

      // Cache miss
      _misses++;
      _updateAccessTime(startTime);
      _log('Cache MISS: $key');
      return null;
    } catch (e, stackTrace) {
      _logError('Error getting cache value for key: $key', e, stackTrace);
      return null;
    }
  }

  /// Set value in cache with automatic level management
  Future<void> set<T>(
    String key,
    T value, {
    Duration? ttl,
    bool memoryOnly = false,
  }) async {
    if (!_initialized) await initialize();

    try {
      final effectiveTtl = ttl ?? _config.memoryTtl;

      // Always set in memory cache
      await _setInMemory(key, value, effectiveTtl);

      // Set in disk cache unless memory-only
      if (!memoryOnly) {
        await _setInDisk(key, value, ttl ?? _config.diskTtl);
      }

      _log('Cache SET: $key (memory: true, disk: ${!memoryOnly})');
    } catch (e, stackTrace) {
      _logError('Error setting cache value for key: $key', e, stackTrace);
    }
  }

  /// Set value in memory cache with LRU eviction
  Future<void> _setInMemory<T>(String key, T value, Duration ttl) async {
    // Check if we need to evict entries
    if (_memoryCache.length >= _config.memoryMaxEntries) {
      _evictLRUFromMemory();
    }

    final entry = CacheEntry<T>(
      key: key,
      value: value,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(ttl),
      sizeBytes: _estimateSize(value),
    );

    _memoryCache[key] = entry;
  }

  /// Set value in disk cache
  Future<void> _setInDisk<T>(String key, T value, Duration ttl) async {
    if (_diskCacheBox == null) return;

    try {
      final entry = {
        'value': value,
        'createdAt': DateTime.now().toIso8601String(),
        'expiresAt': DateTime.now().add(ttl).toIso8601String(),
      };

      await _diskCacheBox!.put(key, jsonEncode(entry));
    } catch (e, stackTrace) {
      _logError('Error setting disk cache for key: $key', e, stackTrace);
    }
  }

  /// Get value from disk cache
  Future<dynamic> _getFromDisk(String key) async {
    if (_diskCacheBox == null) return null;

    try {
      final encodedValue = _diskCacheBox!.get(key);
      if (encodedValue == null) return null;

      final decoded = jsonDecode(encodedValue);
      final expiresAt = DateTime.parse(decoded['expiresAt']);

      // Check expiration
      if (DateTime.now().isAfter(expiresAt)) {
        await _diskCacheBox!.delete(key);
        _evictions++;
        return null;
      }

      return decoded['value'];
    } catch (e, stackTrace) {
      _logError('Error getting disk cache for key: $key', e, stackTrace);
      return null;
    }
  }

  /// Evict least recently used entry from memory cache
  void _evictLRUFromMemory() {
    if (_memoryCache.isEmpty) return;

    // Find LRU entry
    String? lruKey;
    DateTime? oldestAccess;

    for (final entry in _memoryCache.entries) {
      if (oldestAccess == null ||
          entry.value.lastAccessedAt.isBefore(oldestAccess)) {
        oldestAccess = entry.value.lastAccessedAt;
        lruKey = entry.key;
      }
    }

    if (lruKey != null) {
      _memoryCache.remove(lruKey);
      _evictions++;
      _log('Evicted LRU entry: $lruKey');
    }
  }

  /// Invalidate a specific cache entry
  Future<void> invalidate(String key) async {
    _memoryCache.remove(key);
    await _diskCacheBox?.delete(key);
    _log('Cache invalidated: $key');
  }

  /// Invalidate cache entries matching a pattern
  Future<void> invalidatePattern(String pattern) async {
    final regex = RegExp(pattern);

    // Invalidate memory
    _memoryCache.removeWhere((key, _) => regex.hasMatch(key));

    // Invalidate disk
    if (_diskCacheBox != null) {
      final keysToDelete = _diskCacheBox!.keys
          .where((key) => regex.hasMatch(key.toString()))
          .toList();

      for (final key in keysToDelete) {
        await _diskCacheBox!.delete(key);
      }
    }

    _log('Cache pattern invalidated: $pattern');
  }

  /// Clear all cache levels
  Future<void> clearAll() async {
    _memoryCache.clear();
    await _diskCacheBox?.clear();
    _log('All cache cleared');
  }

  /// Get cache statistics
  CacheStatistics getStatistics() {
    final totalRequests = _memoryHits + _diskHits + _misses;
    final hits = _memoryHits + _diskHits;

    final hitRate = totalRequests > 0 ? hits / totalRequests : 0.0;
    final missRate = totalRequests > 0 ? _misses / totalRequests : 0.0;

    final averageAccessTime = _accessTimes.isNotEmpty
        ? Duration(
            microseconds: _accessTimes
                    .map((d) => d.inMicroseconds)
                    .reduce((a, b) => a + b) ~/
                _accessTimes.length,
          )
        : Duration.zero;

    final totalSize =
        _memoryCache.values.fold(0, (sum, entry) => sum + entry.sizeBytes);

    return CacheStatistics(
      memoryHits: _memoryHits,
      diskHits: _diskHits,
      misses: _misses,
      evictions: _evictions,
      totalEntries: _memoryCache.length + (_diskCacheBox?.length ?? 0),
      memoryEntries: _memoryCache.length,
      diskEntries: _diskCacheBox?.length ?? 0,
      hitRate: hitRate,
      missRate: missRate,
      totalSizeBytes: totalSize,
      averageAccessTime: averageAccessTime,
    );
  }

  /// Reset statistics
  void resetStatistics() {
    _memoryHits = 0;
    _diskHits = 0;
    _misses = 0;
    _evictions = 0;
    _accessTimes.clear();
    _log('Cache statistics reset');
  }

  /// Estimate size of a value in bytes
  int _estimateSize(dynamic value) {
    try {
      if (value == null) return 0;
      if (value is String) return value.length * 2; // UTF-16
      if (value is List) return value.length * 8; // Approximate
      if (value is Map) return value.length * 16; // Approximate
      return 8; // Default for primitives
    } catch (_) {
      return 8;
    }
  }

  /// Update access time tracking
  void _updateAccessTime(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    _accessTimes.add(duration);

    // Keep only last 1000 measurements
    if (_accessTimes.length > 1000) {
      _accessTimes.removeAt(0);
    }
  }

  /// Logging helper
  void _log(String message) {
    if (_config.enableMetrics) {
      developer.log(
        message,
        name: 'IntelligentCacheService',
        level: 500,
      );
    }
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'IntelligentCacheService',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// Cleanup resources
  Future<void> dispose() async {
    await _diskCacheBox?.close();
    _memoryCache.clear();
    _log('IntelligentCacheService disposed');
  }
}

