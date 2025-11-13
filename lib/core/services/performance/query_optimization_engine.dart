ï»¿// ðŸš€ Query Optimization Engine - Smart Query Optimization
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Performance Patterns

import 'dart:async';
import 'dart:developer' as developer;
import 'package:hive/hive.dart';

/// Query optimization strategies
enum OptimizationStrategy {
  /// Use indexes when available
  indexed,

  /// Batch multiple queries
  batched,

  /// Cache query results
  cached,

  /// Lazy load data
  lazy,

  /// Eager load related data
  eager,
}

/// Query execution plan
class QueryPlan {
  final String queryId;
  final List<OptimizationStrategy> strategies;
  final Duration estimatedDuration;
  final int estimatedResultCount;
  final bool useCache;
  final bool useIndex;

  const QueryPlan({
    required this.queryId,
    required this.strategies,
    required this.estimatedDuration,
    required this.estimatedResultCount,
    this.useCache = true,
    this.useIndex = true,
  });

  @override
  String toString() => 'QueryPlan('
      'id: $queryId, '
      'strategies: $strategies, '
      'estimated: ${estimatedDuration.inMilliseconds}ms, '
      'cache: $useCache)';
}

/// Query execution result with metrics
class QueryResult<T> {
  final T data;
  final Duration executionTime;
  final int itemCount;
  final bool fromCache;
  final String queryId;

  const QueryResult({
    required this.data,
    required this.executionTime,
    required this.itemCount,
    required this.fromCache,
    required this.queryId,
  });

  @override
  String toString() => 'QueryResult('
      'items: $itemCount, '
      'time: ${executionTime.inMilliseconds}ms, '
      'cached: $fromCache)';
}

/// Query optimization statistics
class QueryOptimizationStats {
  final int totalQueries;
  final int optimizedQueries;
  final int cachedQueries;
  final int batchedQueries;
  final Duration averageExecutionTime;
  final Duration totalTimeSaved;
  final double optimizationRate;

  QueryOptimizationStats({
    required this.totalQueries,
    required this.optimizedQueries,
    required this.cachedQueries,
    required this.batchedQueries,
    required this.averageExecutionTime,
    required this.totalTimeSaved,
    required this.optimizationRate,
  });

  Map<String, dynamic> toJson() => {
        'totalQueries': totalQueries,
        'optimizedQueries': optimizedQueries,
        'cachedQueries': cachedQueries,
        'batchedQueries': batchedQueries,
        'averageExecutionTimeMs': averageExecutionTime.inMilliseconds,
        'totalTimeSavedMs': totalTimeSaved.inMilliseconds,
        'optimizationRate': optimizationRate,
      };
}

/// Query optimization engine for Hive operations
class QueryOptimizationEngine {
  // Query cache
  final Map<String, dynamic> _queryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheTtl;

  // Statistics
  int _totalQueries = 0;
  int _optimizedQueries = 0;
  int _cachedQueries = 0;
  int _batchedQueries = 0;
  final List<Duration> _executionTimes = [];
  Duration _totalTimeSaved = Duration.zero;

  // Batch query queue
  final Map<String, List<Future<dynamic>>> _batchQueue = {};
  Timer? _batchTimer;
  final Duration _batchWindow;

  QueryOptimizationEngine({
    Duration? cacheTtl,
    Duration? batchWindow,
  })  : _cacheTtl = cacheTtl ?? const Duration(minutes: 5),
        _batchWindow = batchWindow ?? const Duration(milliseconds: 50);

  /// Execute an optimized query
  Future<QueryResult<T>> executeQuery<T>({
    required String queryId,
    required Future<T> Function() query,
    bool forceRefresh = false,
    List<OptimizationStrategy>? strategies,
  }) async {
    _totalQueries++;
    final startTime = DateTime.now();

    try {
      // Generate query plan
      final plan = _generateQueryPlan(
        queryId: queryId,
        strategies: strategies,
        forceRefresh: forceRefresh,
      );

      _log('Executing query: $queryId with plan: $plan');

      T? result;
      bool fromCache = false;

      // Try cache first if enabled
      if (plan.useCache && !forceRefresh) {
        result = _getFromCache<T>(queryId);
        if (result != null) {
          fromCache = true;
          _cachedQueries++;
          _log('Query served from cache: $queryId');
        }
      }

      // Execute query if not cached
      if (result == null) {
        result = await query();
        _optimizedQueries++;

        // Cache result
        if (plan.useCache && result != null) {
          _setInCache(queryId, result);
        }
      }

      final executionTime = DateTime.now().difference(startTime);
      _executionTimes.add(executionTime);

      // Calculate time saved if cached
      if (fromCache && plan.estimatedDuration > executionTime) {
        _totalTimeSaved += plan.estimatedDuration - executionTime;
      }

      // Ensure result is not null before returning
      if (result == null) {
        throw Exception('Query returned null result: $queryId');
      }

      final itemCount = _countItems(result);

      return QueryResult<T>(
        data: result,
        executionTime: executionTime,
        itemCount: itemCount,
        fromCache: fromCache,
        queryId: queryId,
      );
    } catch (e, stackTrace) {
      _logError('Error executing query: $queryId', e, stackTrace);
      rethrow;
    }
  }

  /// Execute batched queries for better performance
  Future<List<QueryResult<T>>> executeBatch<T>({
    required Map<String, Future<T> Function()> queries,
    List<OptimizationStrategy>? strategies,
  }) async {
    _batchedQueries += queries.length;

    _log('Executing batch of ${queries.length} queries');

    final results = <QueryResult<T>>[];

    // Execute all queries in parallel
    final futures = queries.entries.map((entry) async {
      return executeQuery<T>(
        queryId: entry.key,
        query: entry.value,
        strategies: strategies,
      );
    }).toList();

    results.addAll(await Future.wait(futures));

    return results;
  }

  /// Optimize Hive box queries with lazy loading
  Future<QueryResult<List<T>>> optimizeBoxQuery<T>({
    required Box<T> box,
    required String queryId,
    bool Function(T)? filter,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  }) async {
    return executeQuery<List<T>>(
      queryId: queryId,
      forceRefresh: forceRefresh,
      query: () async {
        final items = <T>[];
        final values = box.values;

        int skipCount = 0;
        int itemCount = 0;

        for (final value in values) {
          // Skip offset items
          if (offset != null && skipCount < offset) {
            skipCount++;
            continue;
          }

          // Apply filter
          if (filter != null && !filter(value)) {
            continue;
          }

          items.add(value);
          itemCount++;

          // Apply limit
          if (limit != null && itemCount >= limit) {
            break;
          }
        }

        return items;
      },
    );
  }

  /// Optimize sorted queries with indexed access
  Future<QueryResult<List<T>>> optimizeSortedQuery<T>({
    required Box<T> box,
    required String queryId,
    required int Function(T, T) compare,
    int? limit,
    bool forceRefresh = false,
  }) async {
    return executeQuery<List<T>>(
      queryId: queryId,
      forceRefresh: forceRefresh,
      query: () async {
        final items = box.values.toList();

        // Sort items
        items.sort(compare);

        // Apply limit
        if (limit != null && items.length > limit) {
          return items.sublist(0, limit);
        }

        return items;
      },
      strategies: [
        OptimizationStrategy.cached,
        OptimizationStrategy.indexed,
      ],
    );
  }

  /// Optimize aggregation queries
  Future<QueryResult<Map<String, dynamic>>> optimizeAggregationQuery<T>({
    required Box<T> box,
    required String queryId,
    required Map<String, dynamic> Function(List<T>) aggregate,
    bool forceRefresh = false,
  }) async {
    return executeQuery<Map<String, dynamic>>(
      queryId: queryId,
      forceRefresh: forceRefresh,
      query: () async {
        final items = box.values.toList();
        return aggregate(items);
      },
      strategies: [OptimizationStrategy.cached],
    );
  }

  /// Generate query execution plan
  QueryPlan _generateQueryPlan({
    required String queryId,
    List<OptimizationStrategy>? strategies,
    bool forceRefresh = false,
  }) {
    final effectiveStrategies = strategies ??
        [
          OptimizationStrategy.cached,
          OptimizationStrategy.indexed,
        ];

    // Estimate duration based on cache hit probability
    final cachedResult = _getFromCache(queryId);
    final estimatedDuration = cachedResult != null && !forceRefresh
        ? const Duration(milliseconds: 1) // Cache hit
        : const Duration(milliseconds: 10); // Cache miss

    return QueryPlan(
      queryId: queryId,
      strategies: effectiveStrategies,
      estimatedDuration: estimatedDuration,
      estimatedResultCount: 0,
      useCache: effectiveStrategies.contains(OptimizationStrategy.cached) &&
          !forceRefresh,
      useIndex: effectiveStrategies.contains(OptimizationStrategy.indexed),
    );
  }

  /// Get value from cache
  T? _getFromCache<T>(String queryId) {
    final timestamp = _cacheTimestamps[queryId];
    if (timestamp == null) return null;

    // Check if cache is expired
    if (DateTime.now().difference(timestamp) > _cacheTtl) {
      _queryCache.remove(queryId);
      _cacheTimestamps.remove(queryId);
      return null;
    }

    return _queryCache[queryId] as T?;
  }

  /// Set value in cache
  void _setInCache(String queryId, dynamic value) {
    _queryCache[queryId] = value;
    _cacheTimestamps[queryId] = DateTime.now();
  }

  /// Invalidate cache for a specific query
  void invalidateCache(String queryId) {
    _queryCache.remove(queryId);
    _cacheTimestamps.remove(queryId);
    _log('Cache invalidated for query: $queryId');
  }

  /// Invalidate cache matching pattern
  void invalidateCachePattern(String pattern) {
    final regex = RegExp(pattern);
    _queryCache.removeWhere((key, _) => regex.hasMatch(key));
    _cacheTimestamps.removeWhere((key, _) => regex.hasMatch(key));
    _log('Cache pattern invalidated: $pattern');
  }

  /// Clear all cache
  void clearCache() {
    _queryCache.clear();
    _cacheTimestamps.clear();
    _log('All query cache cleared');
  }

  /// Get optimization statistics
  QueryOptimizationStats getStatistics() {
    final optimizationRate =
        _totalQueries > 0 ? _optimizedQueries / _totalQueries : 0.0;

    final averageTime = _executionTimes.isNotEmpty
        ? Duration(
            microseconds: _executionTimes
                    .map((d) => d.inMicroseconds)
                    .reduce((a, b) => a + b) ~/
                _executionTimes.length,
          )
        : Duration.zero;

    return QueryOptimizationStats(
      totalQueries: _totalQueries,
      optimizedQueries: _optimizedQueries,
      cachedQueries: _cachedQueries,
      batchedQueries: _batchedQueries,
      averageExecutionTime: averageTime,
      totalTimeSaved: _totalTimeSaved,
      optimizationRate: optimizationRate,
    );
  }

  /// Reset statistics
  void resetStatistics() {
    _totalQueries = 0;
    _optimizedQueries = 0;
    _cachedQueries = 0;
    _batchedQueries = 0;
    _executionTimes.clear();
    _totalTimeSaved = Duration.zero;
    _log('Query optimization statistics reset');
  }

  /// Count items in result
  int _countItems(dynamic result) {
    if (result == null) return 0;
    if (result is List) return result.length;
    if (result is Map) return result.length;
    return 1;
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'QueryOptimizationEngine',
      level: 500,
    );
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'QueryOptimizationEngine',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  /// Dispose resources
  void dispose() {
    _batchTimer?.cancel();
    _queryCache.clear();
    _cacheTimestamps.clear();
    _log('QueryOptimizationEngine disposed');
  }
}


