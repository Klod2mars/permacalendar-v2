import 'dart:convert';

/// Root Configuration holding all weather tunable parameters
class WeatherConfig {
  final RainConfig rain;
  final SnowConfig snow;
  final CloudConfig cloud;
  final GeneralConfig general;
  final AestheticConfig aesthetics;

  const WeatherConfig({
    required this.rain,
    required this.snow,
    required this.cloud,
    required this.general,
    required this.aesthetics,
  });

  /// Default configuration matching original hardcoded values
  factory WeatherConfig.defaults() {
    return const WeatherConfig(
      rain: RainConfig(),
      snow: SnowConfig(),
      cloud: CloudConfig(),
      general: GeneralConfig(),
      aesthetics: AestheticConfig.initial(),
    );
  }

  WeatherConfig copyWith({
    RainConfig? rain,
    SnowConfig? snow,
    CloudConfig? cloud,
    GeneralConfig? general,
    AestheticConfig? aesthetics,
  }) {
    return WeatherConfig(
      rain: rain ?? this.rain,
      snow: snow ?? this.snow,
      cloud: cloud ?? this.cloud,
      general: general ?? this.general,
      aesthetics: aesthetics ?? this.aesthetics,
    );
  }

  Map<String, dynamic> toJson() => {
        'rain': rain.toJson(),
        'snow': snow.toJson(),
        'cloud': cloud.toJson(),
        'general': general.toJson(),
        'aesthetics': aesthetics.toJson(),
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

/// New V3 Engine: Holistic Aesthetic Parameters
/// Decoupled controls for "Sculpting" the weather.
class AestheticConfig {
  final AestheticParams rain;
  final AestheticParams snow;

  const AestheticConfig({
    required this.rain,
    required this.snow,
  });

  /// Default values for V3
  factory AestheticConfig.defaults() {
    return const AestheticConfig(
      rain: AestheticParams(
        quantity: 0.5,
        area: 0.5,
        weight: 0.5,
        size: 0.5,
        agitation: 0.2,
      ),
      snow: AestheticParams(
        quantity: 0.3,
        area: 0.8,
        weight: 0.2,
        size: 0.6,
        agitation: 0.1,
      ),
    );
  }

  // Fallback for const constructor if needed, mostly used for defaults above
  const AestheticConfig.initial()
      : rain = const AestheticParams.initialRain(),
        snow = const AestheticParams.initialSnow();

  AestheticConfig copyWith({
    AestheticParams? rain,
    AestheticParams? snow,
  }) {
    return AestheticConfig(
      rain: rain ?? this.rain,
      snow: snow ?? this.snow,
    );
  }

  Map<String, dynamic> toJson() => {
        'rain': rain.toJson(),
        'snow': snow.toJson(),
      };
      
  factory AestheticConfig.fromJson(Map<String, dynamic> json) {
    return AestheticConfig(
      rain: json['rain'] != null 
          ? AestheticParams.fromJson(json['rain']) 
          : const AestheticParams.initialRain(),
      snow: json['snow'] != null 
          ? AestheticParams.fromJson(json['snow']) 
          : const AestheticParams.initialSnow(),
    );
  }
}

/// The 5 Pillars of Weather Sculpting
/// All values 0.0 to 1.0
class AestheticParams {
  final double quantity;  // How Much? (Density/Count)
  final double area;      // Where? (Spread/Distribution)
  final double weight;    // Physics feel (Gravity vs Float)
  final double size;      // Scale (Fine vs Chunky)
  final double agitation; // Chaos (Wind/Turbulence)
  
  // V4.1 Structural Controls
  final double clumping;    // 0.0-1.0 (Clusters vs Uniform)
  final double granularity; // 0.0-1.0 (Bursts vs Steady)
  final double lightning;   // 0.0-1.0 (Flash Intensity/Frequency)

  const AestheticParams({
    this.quantity = 0.5,
    this.area = 0.5,
    this.weight = 0.5,
    this.size = 0.5,
    this.agitation = 0.2,
    this.clumping = 0.0,
    this.granularity = 0.0,
    this.lightning = 0.0,
  });

  const AestheticParams.initialRain()
      : quantity = 0.5,
        area = 0.5,
        weight = 0.6,
        size = 0.4,
        agitation = 0.2,
        clumping = 0.0,
        granularity = 0.0,
        lightning = 0.0;

  const AestheticParams.initialSnow()
      : quantity = 0.3,
        area = 0.9,
        weight = 0.1,
        size = 0.7,
        agitation = 0.1,
        clumping = 0.2, // Default some clumping for snow
        granularity = 0.3,
        lightning = 0.0;

  AestheticParams copyWith({
    double? quantity,
    double? area,
    double? weight,
    double? size,
    double? agitation,
    double? clumping,
    double? granularity,
    double? lightning,
  }) {
    return AestheticParams(
      quantity: quantity ?? this.quantity,
      area: area ?? this.area,
      weight: weight ?? this.weight,
      size: size ?? this.size,
      agitation: agitation ?? this.agitation,
      clumping: clumping ?? this.clumping,
      granularity: granularity ?? this.granularity,
      lightning: lightning ?? this.lightning,
    );
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'area': area,
        'weight': weight,
        'size': size,
        'agitation': agitation,
        'clumping': clumping,
        'granularity': granularity,
        'lightning': lightning,
      };

  factory AestheticParams.fromJson(Map<String, dynamic> json) {
    return AestheticParams(
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.5,
      area: (json['area'] as num?)?.toDouble() ?? 0.5,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.5,
      size: (json['size'] as num?)?.toDouble() ?? 0.5,
      agitation: (json['agitation'] as num?)?.toDouble() ?? 0.2,
      clumping: (json['clumping'] as num?)?.toDouble() ?? 0.0,
      granularity: (json['granularity'] as num?)?.toDouble() ?? 0.0,
      lightning: (json['lightning'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

/// PRESETS FOR USER VALIDATION (V5)
class WeatherPresets {
  // 1. Light Rain (Readable Small Rain)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Validated by Roman as the perfect "Small Rain" (Visible but gentle).
  // Shifted up: ~Old Heavy Rain (0.4) minus 10% -> 0.35
  static const AestheticParams lightRain = AestheticParams(
    quantity: 0.35, 
    area: 1.0, 
    weight: 0.15, // Slow but falling
    size: 0.5, // Visible drops
    agitation: 0.1, 
    clumping: 0.0,
    granularity: 0.0,
    lightning: 0.0,
  );

  // NEW. 0. Empty / No-Precip preset (preset zéro)
  // Permet d'exprimer un état "visuellement nul" lorsque la confiance est trop faible.
  // [NEW / À VALIDER VISUELLEMENT]
  static const AestheticParams emptyPrecip = AestheticParams(
    quantity: 0.0,
    area: 0.0,
    weight: 0.0,
    size: 0.0,
    agitation: 0.0,
    clumping: 0.0,
    granularity: 0.0,
    lightning: 0.0,
  );

  // NEW. 0. Very Light Rain / Sprinkle (nouveau)
  // Petite pluie très légère — basé sur 'drizzle' mais légèrement atténué (-15%).
  // [NEW / À VALIDER VISUELLEMENT]
  static const AestheticParams veryLightRain = AestheticParams(
    quantity: 0.153,   // drizzle.quantity (0.18) * 0.85
    area: 0.85,        // drizzle.area (1.0) * 0.85
    weight: 0.068,     // drizzle.weight (0.08) * 0.85
    size: 0.255,       // drizzle.size (0.30) * 0.85
    agitation: 0.0425, // drizzle.agitation (0.05) * 0.85
    clumping: 0.0,
    granularity: 0.0,
    lightning: 0.0,
  );

  // 2b. Drizzle / Bruine (nouveau)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Petite bruine, subtile
  static const AestheticParams drizzle = AestheticParams(
    quantity: 0.18,
    area: 1.0,
    weight: 0.08,
    size: 0.30,
    agitation: 0.05,
    clumping: 0.0,
    granularity: 0.0,
    lightning: 0.0,
  );

  // 4. Moderate Rain (nouveau)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Marche intermédiaire entre Light et Heavy
  static const AestheticParams moderateRain = AestheticParams(
    quantity: 0.475,
    area: 1.0,
    weight: 0.20,
    size: 0.60,
    agitation: 0.25,
    clumping: 0.0,
    granularity: 0.10,
    lightning: 0.0,
  );

  // 2. Heavy Rain (Ideal Real Rain)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Validated by Roman as the perfect "Real Rain".
  // Identical to V5 Storm (0.6).
  static const AestheticParams heavyRain = AestheticParams(
    quantity: 0.50, 
    area: 1.0,
    weight: 0.25, // Good falling speed
    size: 0.7, 
    agitation: 0.4, // Windy
    clumping: 0.0,
    granularity: 0.2, 
    lightning: 0.0,
  );

  // 3. Storm (Base for Lightning)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Based on Heavy Rain (0.6) + slight boost
  static const AestheticParams storm = AestheticParams(
    quantity: 0.65, 
    area: 1.0,
    weight: 0.25, // Same speed as heavy rain
    size: 0.7,
    agitation: 0.6, // More turbulent
    clumping: 0.0,
    granularity: 0.4, 
    lightning: 0.8, // Active Lightning
  );

  // 4. Light Snow (Validated V5.5)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Qty 0.250 + Common Snow Settings
  static const AestheticParams lightSnow = AestheticParams(
    quantity: 0.300, 
    area: 0.816,
    weight: 0.179, 
    size: 0.201, 
    agitation: 0.77, 
    clumping: 0.104, 
    granularity: 0.923,
    lightning: 0.0,
  );
  
  // 5. Dense Snow (Validated V5.5)
  // [LOCKED / SANCTUARISÉ] - DO NOT TOUCH
  // Qty 1.150 + Common Snow Settings (Identical to Light except Quantity)
  static const AestheticParams denseSnow = AestheticParams(
    quantity: 0.989, 
    area: 0.816,
    weight: 0.179, 
    size: 0.201, 
    agitation: 0.77, 
    clumping: 0.104, 
    granularity: 0.923,
    lightning: 0.0,
  );
}
