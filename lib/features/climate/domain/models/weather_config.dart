import 'dart:convert';

/// Root Configuration holding all weather tunable parameters
class WeatherConfig {
  final RainConfig rain;
  final SnowConfig snow;
  final CloudConfig cloud;
  final GeneralConfig general;

  const WeatherConfig({
    required this.rain,
    required this.snow,
    required this.cloud,
    required this.general,
  });

  /// Default configuration matching original hardcoded values
  factory WeatherConfig.defaults() {
    return const WeatherConfig(
      rain: RainConfig(),
      snow: SnowConfig(),
      cloud: CloudConfig(),
      general: GeneralConfig(),
    );
  }

  WeatherConfig copyWith({
    RainConfig? rain,
    SnowConfig? snow,
    CloudConfig? cloud,
    GeneralConfig? general,
  }) {
    return WeatherConfig(
      rain: rain ?? this.rain,
      snow: snow ?? this.snow,
      cloud: cloud ?? this.cloud,
      general: general ?? this.general,
    );
  }

  Map<String, dynamic> toJson() => {
        'rain': rain.toJson(),
        'snow': snow.toJson(),
        'cloud': cloud.toJson(),
        'general': general.toJson(),
      };

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}

/// Parameters for Rain particles
class RainConfig {
  final double gravity;
  final double velocityBase;
  final double velocityVariance;
  final double sizeBase;
  final double sizeVariance;
  final double spawnRateBase;
  final double horizontalSpread;

  const RainConfig({
    this.gravity = 0.5,
    this.velocityBase = 0.2,
    this.velocityVariance = 0.1,
    this.sizeBase = 1.0,
    this.sizeVariance = 2.0,
    this.spawnRateBase = 50.0,
    this.horizontalSpread = 1.5,
  });

  RainConfig copyWith({
    double? gravity,
    double? velocityBase,
    double? velocityVariance,
    double? sizeBase,
    double? sizeVariance,
    double? spawnRateBase,
    double? horizontalSpread,
  }) {
    return RainConfig(
      gravity: gravity ?? this.gravity,
      velocityBase: velocityBase ?? this.velocityBase,
      velocityVariance: velocityVariance ?? this.velocityVariance,
      sizeBase: sizeBase ?? this.sizeBase,
      sizeVariance: sizeVariance ?? this.sizeVariance,
      spawnRateBase: spawnRateBase ?? this.spawnRateBase,
      horizontalSpread: horizontalSpread ?? this.horizontalSpread,
    );
  }

  Map<String, dynamic> toJson() => {
        'gravity': gravity,
        'velocityBase': velocityBase,
        'velocityVariance': velocityVariance,
        'sizeBase': sizeBase,
        'sizeVariance': sizeVariance,
        'spawnRateBase': spawnRateBase,
        'horizontalSpread': horizontalSpread,
      };
}

/// Parameters for Snow particles
class SnowConfig {
  final double gravity;
  final double fallSpeedBase;
  final double fallSpeedVariance;
  final double horizontalSpread;
  final double startYSpread;
  final int spawnCap;
  final double baseMultiplier;
  final double sizeBase;
  final double sizeVariance;

  const SnowConfig({
    this.gravity = 0.05,
    this.fallSpeedBase = 0.06,
    this.fallSpeedVariance = 0.04,
    this.horizontalSpread = 6.0,
    this.startYSpread = 0.25,
    this.spawnCap = 1800,
    this.baseMultiplier = 18.0,
    this.sizeBase = 2.0,
    this.sizeVariance = 2.0,
  });

  SnowConfig copyWith({
    double? gravity,
    double? fallSpeedBase,
    double? fallSpeedVariance,
    double? horizontalSpread,
    double? startYSpread,
    int? spawnCap,
    double? baseMultiplier,
    double? sizeBase,
    double? sizeVariance,
  }) {
    return SnowConfig(
      gravity: gravity ?? this.gravity,
      fallSpeedBase: fallSpeedBase ?? this.fallSpeedBase,
      fallSpeedVariance: fallSpeedVariance ?? this.fallSpeedVariance,
      horizontalSpread: horizontalSpread ?? this.horizontalSpread,
      startYSpread: startYSpread ?? this.startYSpread,
      spawnCap: spawnCap ?? this.spawnCap,
      baseMultiplier: baseMultiplier ?? this.baseMultiplier,
      sizeBase: sizeBase ?? this.sizeBase,
      sizeVariance: sizeVariance ?? this.sizeVariance,
    );
  }

  Map<String, dynamic> toJson() => {
        'gravity': gravity,
        'fallSpeedBase': fallSpeedBase,
        'fallSpeedVariance': fallSpeedVariance,
        'horizontalSpread': horizontalSpread,
        'startYSpread': startYSpread,
        'spawnCap': spawnCap,
        'baseMultiplier': baseMultiplier,
        'sizeBase': sizeBase,
        'sizeVariance': sizeVariance,
      };
}

/// Parameters for Cloud/Mist
class CloudConfig {
  final double spawnChance;
  final double speedVariance;
  final double sizeBase;
  final double sizeVariance;
  final int maxClouds;

  const CloudConfig({
    this.spawnChance = 0.02,
    this.speedVariance = 0.01,
    this.sizeBase = 40.0,
    this.sizeVariance = 30.0,
    this.maxClouds = 4,
  });

  CloudConfig copyWith({
    double? spawnChance,
    double? speedVariance,
    double? sizeBase,
    double? sizeVariance,
    int? maxClouds,
  }) {
    return CloudConfig(
      spawnChance: spawnChance ?? this.spawnChance,
      speedVariance: speedVariance ?? this.speedVariance,
      sizeBase: sizeBase ?? this.sizeBase,
      sizeVariance: sizeVariance ?? this.sizeVariance,
      maxClouds: maxClouds ?? this.maxClouds,
    );
  }

  Map<String, dynamic> toJson() => {
        'spawnChance': spawnChance,
        'speedVariance': speedVariance,
        'sizeBase': sizeBase,
        'sizeVariance': sizeVariance,
        'maxClouds': maxClouds,
      };
}

/// General Physics/Environment
class GeneralConfig {
  final double precipThresholdMm;
  final double precipThresholdProb;
  final bool enableCollision;
  final double windFactor;

  const GeneralConfig({
    this.precipThresholdMm = 0.02,
    this.precipThresholdProb = 30.0,
    this.enableCollision = true,
    this.windFactor = 0.005,
  });

  GeneralConfig copyWith({
    double? precipThresholdMm,
    double? precipThresholdProb,
    bool? enableCollision,
    double? windFactor,
  }) {
    return GeneralConfig(
      precipThresholdMm: precipThresholdMm ?? this.precipThresholdMm,
      precipThresholdProb: precipThresholdProb ?? this.precipThresholdProb,
      enableCollision: enableCollision ?? this.enableCollision,
      windFactor: windFactor ?? this.windFactor,
    );
  }

  Map<String, dynamic> toJson() => {
        'precipThresholdMm': precipThresholdMm,
        'precipThresholdProb': precipThresholdProb,
        'enableCollision': enableCollision,
        'windFactor': windFactor,
      };
}
