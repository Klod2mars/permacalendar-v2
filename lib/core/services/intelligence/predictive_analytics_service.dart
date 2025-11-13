// 🧠 Predictive Analytics Service - AI-Powered Predictions
// PermaCalendar v2.8.0 - Prompt 5 Implementation
// Clean Architecture + Machine Learning Patterns

import 'dart:async';
import 'dart:math' as math;
import 'dart:developer' as developer;

/// Prediction confidence level
enum PredictionConfidence {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
}

/// Time series prediction
class TimeSeriesPrediction {
  final DateTime timestamp;
  final double predictedValue;
  final double? actualValue;
  final double confidence;
  final PredictionConfidence confidenceLevel;
  final Map<String, dynamic> metadata;

  TimeSeriesPrediction({
    required this.timestamp,
    required this.predictedValue,
    this.actualValue,
    required this.confidence,
    required this.confidenceLevel,
    this.metadata = const {},
  });

  /// Prediction error if actual value is known
  double? get error =>
      actualValue != null ? (predictedValue - actualValue!).abs() : null;

  /// Prediction accuracy if actual value is known
  double? get accuracy {
    if (actualValue == null || actualValue == 0) return null;
    final errorRate = error! / actualValue!.abs();
    return math.max(0.0, 1.0 - errorRate);
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'predictedValue': predictedValue,
        'actualValue': actualValue,
        'confidence': confidence,
        'confidenceLevel': confidenceLevel.toString(),
        'error': error,
        'accuracy': accuracy,
        'metadata': metadata,
      };
}

/// Trend analysis result
class TrendAnalysis {
  final String trendType; // upward, downward, stable, volatile
  final double slope;
  final double rSquared; // Goodness of fit (0-1)
  final List<double> values;
  final double volatility;
  final Map<String, dynamic> seasonalFactors;

  TrendAnalysis({
    required this.trendType,
    required this.slope,
    required this.rSquared,
    required this.values,
    required this.volatility,
    this.seasonalFactors = const {},
  });

  bool get isUpward => slope > 0.01;
  bool get isDownward => slope < -0.01;
  bool get isStable => slope.abs() <= 0.01;
  bool get isVolatile => volatility > 0.3;

  Map<String, dynamic> toJson() => {
        'trendType': trendType,
        'slope': slope,
        'rSquared': rSquared,
        'volatility': volatility,
        'isUpward': isUpward,
        'isDownward': isDownward,
        'isStable': isStable,
        'isVolatile': isVolatile,
        'seasonalFactors': seasonalFactors,
      };
}

/// Anomaly detection result
class AnomalyDetectionResult {
  final DateTime timestamp;
  final double value;
  final bool isAnomaly;
  final double anomalyScore; // 0-1, higher = more anomalous
  final String? reason;
  final Map<String, dynamic> context;

  AnomalyDetectionResult({
    required this.timestamp,
    required this.value,
    required this.isAnomaly,
    required this.anomalyScore,
    this.reason,
    this.context = const {},
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'value': value,
        'isAnomaly': isAnomaly,
        'anomalyScore': anomalyScore,
        'reason': reason,
        'context': context,
      };
}

/// Predictive analytics service for ML-powered insights
class PredictiveAnalyticsService {
  // Model parameters
  final int _lookbackPeriod;
  final double _anomalyThreshold;
  final int _minDataPoints;

  // Historical predictions for accuracy tracking
  final List<TimeSeriesPrediction> _predictionHistory = [];

  // Statistics
  int _totalPredictions = 0;
  double _averageAccuracy = 0.0;

  PredictiveAnalyticsService({
    int? lookbackPeriod,
    double? anomalyThreshold,
    int? minDataPoints,
  })  : _lookbackPeriod = lookbackPeriod ?? 30,
        _anomalyThreshold = anomalyThreshold ?? 2.5, // 2.5 standard deviations
        _minDataPoints = minDataPoints ?? 7;

  /// Predict future values using linear regression
  Future<List<TimeSeriesPrediction>> predictTimeSeries({
    required List<double> values,
    required List<DateTime> timestamps,
    required int forecastSteps,
    String? seriesName,
  }) async {
    _log(
        'Predicting time series: ${seriesName ?? "unnamed"}, steps: $forecastSteps');

    if (values.length < _minDataPoints) {
      _log('Insufficient data points: ${values.length} < $_minDataPoints');
      return [];
    }

    try {
      // Calculate linear regression
      final regression = _calculateLinearRegression(values);

      // Generate predictions
      final predictions = <TimeSeriesPrediction>[];
      final lastTimestamp = timestamps.last;

      for (int i = 1; i <= forecastSteps; i++) {
        final x = values.length + i;
        final predictedValue =
            regression['slope']! * x + regression['intercept']!;

        // Calculate confidence based on R² and distance from training data
        final confidence = _calculateConfidence(
          rSquared: regression['rSquared']!,
          distanceFromData: i.toDouble(),
          volatility: regression['volatility']!,
        );

        final prediction = TimeSeriesPrediction(
          timestamp: lastTimestamp.add(Duration(days: i)),
          predictedValue: predictedValue,
          confidence: confidence,
          confidenceLevel: _getConfidenceLevel(confidence),
          metadata: {
            'seriesName': seriesName ?? 'unnamed',
            'forecastStep': i,
            'slope': regression['slope'],
            'rSquared': regression['rSquared'],
          },
        );

        predictions.add(prediction);
        _predictionHistory.add(prediction);
        _totalPredictions++;
      }

      return predictions;
    } catch (e, stackTrace) {
      _logError('Error predicting time series', e, stackTrace);
      return [];
    }
  }

  /// Analyze trend in historical data
  Future<TrendAnalysis> analyzeTrend({
    required List<double> values,
    Map<String, dynamic>? metadata,
  }) async {
    _log('Analyzing trend for ${values.length} data points');

    if (values.length < _minDataPoints) {
      _log('Insufficient data for trend analysis');
      return TrendAnalysis(
        trendType: 'insufficient_data',
        slope: 0.0,
        rSquared: 0.0,
        values: values,
        volatility: 0.0,
      );
    }

    try {
      // Calculate linear regression
      final regression = _calculateLinearRegression(values);

      // Determine trend type
      String trendType;
      if (regression['slope']!.abs() <= 0.01) {
        trendType = 'stable';
      } else if (regression['volatility']! > 0.3) {
        trendType = 'volatile';
      } else if (regression['slope']! > 0) {
        trendType = 'upward';
      } else {
        trendType = 'downward';
      }

      // Detect seasonal patterns
      final seasonalFactors = _detectSeasonalPatterns(values);

      return TrendAnalysis(
        trendType: trendType,
        slope: regression['slope']!,
        rSquared: regression['rSquared']!,
        values: values,
        volatility: regression['volatility']!,
        seasonalFactors: seasonalFactors,
      );
    } catch (e, stackTrace) {
      _logError('Error analyzing trend', e, stackTrace);
      rethrow;
    }
  }

  /// Detect anomalies in data using statistical methods
  Future<List<AnomalyDetectionResult>> detectAnomalies({
    required List<double> values,
    required List<DateTime> timestamps,
    double? threshold,
  }) async {
    _log('Detecting anomalies in ${values.length} data points');

    if (values.length < _minDataPoints) {
      return [];
    }

    try {
      // Calculate mean and standard deviation
      final mean = _calculateMean(values);
      final stdDev = _calculateStdDev(values, mean);

      final effectiveThreshold = threshold ?? _anomalyThreshold;
      final anomalies = <AnomalyDetectionResult>[];

      for (int i = 0; i < values.length; i++) {
        final value = values[i];
        final zScore = stdDev > 0 ? (value - mean) / stdDev : 0.0;
        final anomalyScore = zScore.abs() / effectiveThreshold;

        final isAnomaly = zScore.abs() > effectiveThreshold;

        if (isAnomaly) {
          anomalies.add(AnomalyDetectionResult(
            timestamp: timestamps[i],
            value: value,
            isAnomaly: true,
            anomalyScore: math.min(1.0, anomalyScore),
            reason: zScore > 0
                ? 'Value significantly above average (z-score: ${zScore.toStringAsFixed(2)})'
                : 'Value significantly below average (z-score: ${zScore.toStringAsFixed(2)})',
            context: {
              'mean': mean,
              'stdDev': stdDev,
              'zScore': zScore,
              'threshold': effectiveThreshold,
            },
          ));
        }
      }

      _log('Detected ${anomalies.length} anomalies');
      return anomalies;
    } catch (e, stackTrace) {
      _logError('Error detecting anomalies', e, stackTrace);
      return [];
    }
  }

  /// Predict harvest yield based on historical data
  Future<TimeSeriesPrediction> predictHarvestYield({
    required String plantId,
    required List<double> historicalYields,
    required List<DateTime> timestamps,
    required DateTime targetDate,
    Map<String, dynamic>? factors,
  }) async {
    _log('Predicting harvest yield for plant: $plantId');

    if (historicalYields.length < _minDataPoints) {
      _log('Insufficient historical data for yield prediction');
      return TimeSeriesPrediction(
        timestamp: targetDate,
        predictedValue: 0.0,
        confidence: 0.0,
        confidenceLevel: PredictionConfidence.veryLow,
        metadata: {'reason': 'insufficient_data'},
      );
    }

    try {
      // Calculate trend
      final regression = _calculateLinearRegression(historicalYields);

      // Adjust prediction based on factors (weather, soil, etc.)
      double adjustmentFactor = 1.0;
      if (factors != null) {
        adjustmentFactor = _calculateAdjustmentFactor(factors);
      }

      // Predict yield
      final x = historicalYields.length + 1;
      final baseYield = regression['slope']! * x + regression['intercept']!;
      final adjustedYield = math.max(0.0, baseYield * adjustmentFactor);

      // Calculate confidence
      final confidence = _calculateConfidence(
        rSquared: regression['rSquared']!,
        distanceFromData: 1.0,
        volatility: regression['volatility']!,
      );

      return TimeSeriesPrediction(
        timestamp: targetDate,
        predictedValue: adjustedYield,
        confidence: confidence,
        confidenceLevel: _getConfidenceLevel(confidence),
        metadata: {
          'plantId': plantId,
          'baseYield': baseYield,
          'adjustmentFactor': adjustmentFactor,
          'factors': factors ?? {},
        },
      );
    } catch (e, stackTrace) {
      _logError('Error predicting harvest yield', e, stackTrace);
      rethrow;
    }
  }

  /// Calculate linear regression for time series
  Map<String, double> _calculateLinearRegression(List<double> values) {
    final n = values.length;
    if (n < 2) {
      return {
        'slope': 0.0,
        'intercept': 0.0,
        'rSquared': 0.0,
        'volatility': 0.0
      };
    }

    // Calculate means
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    for (int i = 0; i < n; i++) {
      final x = i.toDouble();
      final y = values[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    }

    final meanX = sumX / n;
    final meanY = sumY / n;

    // Calculate slope and intercept
    final numerator = sumXY - n * meanX * meanY;
    final denominator = sumX2 - n * meanX * meanX;
    final slope = denominator != 0 ? numerator / denominator : 0.0;
    final intercept = meanY - slope * meanX;

    // Calculate R² (coefficient of determination)
    double ssTotal = 0, ssResidual = 0;
    for (int i = 0; i < n; i++) {
      final predicted = slope * i + intercept;
      ssResidual += math.pow(values[i] - predicted, 2);
      ssTotal += math.pow(values[i] - meanY, 2);
    }

    final rSquared = ssTotal != 0 ? 1 - (ssResidual / ssTotal) : 0.0;

    // Calculate volatility (coefficient of variation)
    final stdDev = _calculateStdDev(values, meanY);
    final volatility = meanY != 0 ? stdDev / meanY.abs() : 0.0;

    return {
      'slope': slope,
      'intercept': intercept,
      'rSquared': math.max(0.0, rSquared),
      'volatility': volatility,
    };
  }

  /// Calculate mean
  double _calculateMean(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calculate standard deviation
  double _calculateStdDev(List<double> values, double mean) {
    if (values.length < 2) return 0.0;
    final variance =
        values.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) /
            values.length;
    return math.sqrt(variance);
  }

  /// Calculate confidence based on multiple factors
  double _calculateConfidence({
    required double rSquared,
    required double distanceFromData,
    required double volatility,
  }) {
    // Base confidence from R²
    double confidence = rSquared;

    // Reduce confidence for distant predictions
    final distancePenalty = math.exp(-distanceFromData / 10);
    confidence *= distancePenalty;

    // Reduce confidence for volatile data
    final volatilityPenalty = math.max(0.3, 1.0 - volatility);
    confidence *= volatilityPenalty;

    return math.max(0.0, math.min(1.0, confidence));
  }

  /// Get confidence level from numeric confidence
  PredictionConfidence _getConfidenceLevel(double confidence) {
    if (confidence >= 0.9) return PredictionConfidence.veryHigh;
    if (confidence >= 0.75) return PredictionConfidence.high;
    if (confidence >= 0.5) return PredictionConfidence.medium;
    if (confidence >= 0.25) return PredictionConfidence.low;
    return PredictionConfidence.veryLow;
  }

  /// Detect seasonal patterns (simplified)
  Map<String, dynamic> _detectSeasonalPatterns(List<double> values) {
    if (values.length < 12) return {};

    // Calculate average for each "season" (quarter)
    final quarters = <int, List<double>>{};
    for (int i = 0; i < values.length; i++) {
      final quarter = i % 4;
      quarters[quarter] = quarters[quarter] ?? [];
      quarters[quarter]!.add(values[i]);
    }

    final seasonalFactors = <String, dynamic>{};
    quarters.forEach((quarter, values) {
      seasonalFactors['Q${quarter + 1}'] = _calculateMean(values);
    });

    return seasonalFactors;
  }

  /// Calculate adjustment factor based on external factors
  double _calculateAdjustmentFactor(Map<String, dynamic> factors) {
    double adjustment = 1.0;

    // Weather factor (-0.3 to +0.3)
    if (factors.containsKey('weatherScore')) {
      final weatherScore = factors['weatherScore'] as double;
      adjustment += (weatherScore - 0.5) * 0.6; // Scale to -0.3 to +0.3
    }

    // Soil health factor (-0.2 to +0.2)
    if (factors.containsKey('soilHealth')) {
      final soilHealth = factors['soilHealth'] as double;
      adjustment += (soilHealth - 0.5) * 0.4;
    }

    // Care level factor (-0.1 to +0.1)
    if (factors.containsKey('careLevel')) {
      final careLevel = factors['careLevel'] as double;
      adjustment += (careLevel - 0.5) * 0.2;
    }

    return math.max(0.5, math.min(1.5, adjustment));
  }

  /// Update prediction with actual value for accuracy tracking
  void updatePredictionWithActual({
    required DateTime timestamp,
    required double actualValue,
  }) {
    final prediction = _predictionHistory.firstWhere(
      (p) => p.timestamp == timestamp,
      orElse: () => TimeSeriesPrediction(
        timestamp: timestamp,
        predictedValue: 0,
        confidence: 0,
        confidenceLevel: PredictionConfidence.veryLow,
      ),
    );

    if (prediction.predictedValue != 0) {
      final updatedPrediction = TimeSeriesPrediction(
        timestamp: prediction.timestamp,
        predictedValue: prediction.predictedValue,
        actualValue: actualValue,
        confidence: prediction.confidence,
        confidenceLevel: prediction.confidenceLevel,
        metadata: prediction.metadata,
      );

      // Update average accuracy
      if (updatedPrediction.accuracy != null) {
        _averageAccuracy = (_averageAccuracy + updatedPrediction.accuracy!) / 2;
      }

      _log('Prediction updated with actual: error=${updatedPrediction.error}');
    }
  }

  /// Get average prediction accuracy
  double getAverageAccuracy() => _averageAccuracy;

  /// Get total predictions count
  int getTotalPredictions() => _totalPredictions;

  /// Reset statistics
  void resetStatistics() {
    _totalPredictions = 0;
    _averageAccuracy = 0.0;
    _predictionHistory.clear();
    _log('Predictive analytics statistics reset');
  }

  /// Logging helper
  void _log(String message) {
    developer.log(
      message,
      name: 'PredictiveAnalyticsService',
      level: 500,
    );
  }

  /// Error logging helper
  void _logError(String message, Object error, StackTrace stackTrace) {
    developer.log(
      '$message: $error',
      name: 'PredictiveAnalyticsService',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}


