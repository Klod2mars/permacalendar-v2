// ðŸš€ Data Compression Service - Memory Footprint Optimization
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Performance Patterns

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io' show gzip, GZipCodec;

/// Compression strategy
enum CompressionStrategy {
  /// No compression
  none,

  /// Fast compression with moderate ratio
  fast,

  /// Balanced compression
  balanced,

  /// Maximum compression with slower speed
  maximum,

  /// Adaptive based on data size
  adaptive,
}

/// Compression result with metrics
class CompressionResult {
  final dynamic compressedData;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final Duration compressionTime;
  final CompressionStrategy strategy;

  const CompressionResult({
    required this.compressedData,
    required this.originalSize,
    required this.compressedSize,
    required this.compressionRatio,
    required this.compressionTime,
    required this.strategy,
  });

  /// Savings in bytes
  int get savedBytes => originalSize - compressedSize;

  /// Savings percentage
  double get savedPercentage => compressionRatio * 100;

  Map<String, dynamic> toJson() => {
        'originalSize': originalSize,
        'compressedSize': compressedSize,
        'compressionRatio': compressionRatio,
        'savedBytes': savedBytes,
        'savedPercentage': savedPercentage,
        'compressionTimeMs': compressionTime.inMilliseconds,
        'strategy': strategy.toString(),
      };

  @override
  String toString() => 'CompressionResult('
      'ratio: ${(compressionRatio * 100).toStringAsFixed(1)}%, '
      'saved: $savedBytes bytes, '
      'time: ${compressionTime.inMilliseconds}ms)';
}

/// Compression statistics
class CompressionStatistics {
  final int totalCompressions;
  final int totalDecompressions;
  final int totalBytesProcessed;
  final int totalBytesSaved;
  final double averageCompressionRatio;
  final Duration totalCompressionTime;
  final Duration averageCompressionTime;

  CompressionStatistics({
    required this.totalCompressions,
    required this.totalDecompressions,
    required this.totalBytesProcessed,
    required this.totalBytesSaved,
    required this.averageCompressionRatio,
    required this.totalCompressionTime,
    required this.averageCompressionTime,
  });

  Map<String, dynamic> toJson() => {
        'totalCompressions': totalCompressions,
        'totalDecompressions': totalDecompressions,
        'totalBytesProcessed': totalBytesProcessed,
        'totalBytesSaved': totalBytesSaved,
        'averageCompressionRatio': averageCompressionRatio,
        'totalCompressionTimeMs': totalCompressionTime.inMilliseconds,
        'averageCompressionTimeMs': averageCompressionTime.inMilliseconds,
      };
}

/// Data compression service for reducing memory footprint
class DataCompressionService {
  // Statistics
  int _totalCompressions = 0;
  int _totalDecompressions = 0;
  int _totalBytesProcessed = 0;
  int _totalBytesSaved = 0;
  final List<double> _compressionRatios = [];
  final List<Duration> _compressionTimes = [];

  // Configuration
  final int _adaptiveThreshold;
  final CompressionStrategy _defaultStrategy;

  DataCompressionService({
    int? adaptiveThreshold,
    CompressionStrategy? defaultStrategy,
  })  : _adaptiveThreshold = adaptiveThreshold ?? 1024, // 1KB
        _defaultStrategy = defaultStrategy ?? CompressionStrategy.adaptive;

  /// Compress data with automatic strategy selection
  Future<CompressionResult> compress({
    required dynamic data,
    CompressionStrategy? strategy,
  }) async {
    final startTime = DateTime.now();
    _totalCompressions++;

    try {
      // Convert data to bytes
      final bytes = _toBytes(data);
      final originalSize = bytes.length;
      _totalBytesProcessed += originalSize;

      // Determine compression strategy
      final effectiveStrategy = strategy ?? _selectStrategy(originalSize);

      _log('Compressing $originalSize bytes with strategy: $effectiveStrategy');

      // Apply compression
      final compressedBytes = await _compressBytes(
        bytes,
        effectiveStrategy,
      );

      final compressedSize = compressedBytes.length;
      final savedBytes = originalSize - compressedSize;
      _totalBytesSaved += savedBytes;

      final compressionRatio = originalSize > 0
          ? (originalSize - compressedSize) / originalSize
          : 0.0;

      _compressionRatios.add(compressionRatio);

      final compressionTime = DateTime.now().difference(startTime);
      _compressionTimes.add(compressionTime);

      _log(
          'Compression completed: ${(compressionRatio * 100).toStringAsFixed(1)}% ratio');

      return CompressionResult(
        compressedData: compressedBytes,
        originalSize: originalSize,
        compressedSize: compressedSize,
        compressionRatio: compressionRatio,
        compressionTime: compressionTime,
        strategy: effectiveStrategy,
      );
    } catch (e, stackTrace) {
      _logError('Error compressing data', e, stackTrace);
      rethrow;
    }
  }

  /// Decompress previously compressed data
  Future<dynamic> decompress({
    required dynamic compressedData,
    CompressionStrategy? strategy,
  }) async {
    _totalDecompressions++;

    try {
      final compressedBytes = compressedData as List<int>;

      _log('Decompressing ${compressedBytes.length} bytes');

      // Decompress based on strategy
      final decompressedBytes = await _decompressBytes(
        compressedBytes,
        strategy ?? _defaultStrategy,
      );

      // Convert back to original format
      return _fromBytes(decompressedBytes);
    } catch (e, stackTrace) {
      _logError('Error decompressing data', e, stackTrace);
      rethrow;
    }
  }

  /// Compress a string
  Future<CompressionResult> compressString(
    String data, {
    CompressionStrategy? strategy,
  }) async {
    return compress(data: data, strategy: strategy);
  }

  /// Decompress to string
  Future<String> decompressString(
    dynamic compressedData, {
    CompressionStrategy? strategy,
  }) async {
    final decompressed = await decompress(
      compressedData: compressedData,
      strategy: strategy,
    );
    return decompressed.toString();
  }

  /// Compress JSON data
  Future<CompressionResult> compressJson(
    Map<String, dynamic> data, {
    CompressionStrategy? strategy,
  }) async {
    final jsonString = jsonEncode(data);
    return compressString(jsonString, strategy: strategy);
  }

  /// Decompress JSON data
  Future<Map<String, dynamic>> decompressJson(
    dynamic compressedData, {
    CompressionStrategy? strategy,
  }) async {
    final jsonString = await decompressString(
      compressedData,
      strategy: strategy,
    );
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Compress list of items
  Future<CompressionResult> compressList(
    List<dynamic> data, {
    CompressionStrategy? strategy,
  }) async {
    final jsonString = jsonEncode(data);
    return compressString(jsonString, strategy: strategy);
  }

  /// Decompress list of items
  Future<List<dynamic>> decompressList(
    dynamic compressedData, {
    CompressionStrategy? strategy,
  }) async {
    final jsonString = await decompressString(
      compressedData,
      strategy: strategy,
    );
    return jsonDecode(jsonString) as List<dynamic>;
  }

  /// Select compression strategy based on data size
  CompressionStrategy _selectStrategy(int dataSize) {
    if (_defaultStrategy != CompressionStrategy.adaptive) {
      return _defaultStrategy;
    }

    // Small data: no compression (overhead not worth it)
    if (dataSize < 100) {
      return CompressionStrategy.none;
    }

    // Medium data: fast compression
    if (dataSize < _adaptiveThreshold) {
      return CompressionStrategy.fast;
    }

    // Large data: balanced compression
    if (dataSize < _adaptiveThreshold * 10) {
      return CompressionStrategy.balanced;
    }

    // Very large data: maximum compression
    return CompressionStrategy.maximum;
  }

  /// Compress bytes with selected strategy
  Future<List<int>> _compressBytes(
    List<int> bytes,
    CompressionStrategy strategy,
  ) async {
    switch (strategy) {
      case CompressionStrategy.none:
        return bytes;

      case CompressionStrategy.fast:
        return GZipCodec(level: 1).encode(bytes);

      case CompressionStrategy.balanced:
        return GZipCodec(level: 6).encode(bytes);

      case CompressionStrategy.maximum:
        return GZipCodec(level: 9).encode(bytes);

      case CompressionStrategy.adaptive:
        // Should not happen as adaptive is resolved before
        return GZipCodec(level: 6).encode(bytes);
    }
  }

  /// Decompress bytes
  Future<List<int>> _decompressBytes(
    List<int> compressedBytes,
    CompressionStrategy strategy,
  ) async {
    if (strategy == CompressionStrategy.none) {
      return compressedBytes;
    }

    return gzip.decode(compressedBytes);
  }

  /// Convert data to bytes
  List<int> _toBytes(dynamic data) {
    if (data is List<int>) return data;
    if (data is String) return utf8.encode(data);

    // For complex types, encode as JSON then to bytes
    final jsonString = jsonEncode(data);
    return utf8.encode(jsonString);
  }

  /// Convert bytes back to data
  dynamic _fromBytes(List<int> bytes) {
    try {
      // Try to decode as UTF-8 string
      return utf8.decode(bytes);
    } catch (_) {
      // If not a string, return raw bytes
      return bytes;
    }
  }

  /// Estimate compressed size without actually compressing
  int estimateCompressedSize(int originalSize,
      {CompressionStrategy? strategy}) {
    final effectiveStrategy = strategy ?? _selectStrategy(originalSize);

    switch (effectiveStrategy) {
      case CompressionStrategy.none:
        return originalSize;

      case CompressionStrategy.fast:
        return (originalSize * 0.7).round(); // ~30% compression

      case CompressionStrategy.balanced:
        return (originalSize * 0.5).round(); // ~50% compression

      case CompressionStrategy.maximum:
        return (originalSize * 0.3).round(); // ~70% compression

      case CompressionStrategy.adaptive:
        return (originalSize * 0.5).round(); // Average estimate
    }
  }

  /// Check if compression is beneficial
  bool shouldCompress(int dataSize) {
    // Compression overhead not worth it for very small data
    if (dataSize < 100) return false;

    // Always compress large data
    if (dataSize > 10240) return true; // 10KB

    // For medium data, compress if ratio is good historically
    if (_compressionRatios.isNotEmpty) {
      final avgRatio = _compressionRatios.reduce((a, b) => a + b) /
          _compressionRatios.length;
      return avgRatio > 0.2; // 20% minimum compression
    }

    // Default: compress medium to large data
    return dataSize > 1024; // 1KB
  }

  /// Get compression statistics
  CompressionStatistics getStatistics() {
    final avgRatio = _compressionRatios.isNotEmpty
        ? _compressionRatios.reduce((a, b) => a + b) / _compressionRatios.length
        : 0.0;

    final totalTime = _compressionTimes.isNotEmpty
        ? Duration(
            microseconds: _compressionTimes
                .map((d) => d.inMicroseconds)
                .reduce((a, b) => a + b),
          )
        : Duration.zero;

    final avgTime = _compressionTimes.isNotEmpty
        ? Duration(
            microseconds: _compressionTimes
                    .map((d) => d.inMicroseconds)
                    .reduce((a, b) => a + b) ~/
                _compressionTimes.length,
          )
        : Duration.zero;

    return CompressionStatistics(
      totalCompressions: _totalCompressions,
      totalDecompressions: _totalDecompressions,
      totalBytesProcessed: _totalBytesProcessed,
      totalBytesSaved: _totalBytesSaved,
      averageCompressionRatio: avgRatio,
      totalCompressionTime: totalTime,
      averageCompressionTime: avgTime,
    );
  }

  /// Reset statistics
  void resetStatistics() {
    _totalCompressions = 0;
    _totalDecompressions = 0;
    _totalBytesProcessed = 0;
    _totalBytesSaved = 0;
    _compressionRatios.clear();
    _compressionTimes.clear();
    _log('Compression statistics reset');
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'DataCompressionService',
      level: 500,
    );
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'DataCompressionService',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}


