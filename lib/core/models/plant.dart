ï»¿import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'plant.g.dart';

@HiveType(typeId: 2)
class Plant extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String commonName;

  @HiveField(2)
  String scientificName;

  @HiveField(3)
  String family;

  @HiveField(4)
  String description;

  @HiveField(5)
  String plantingSeason;

  @HiveField(6)
  String harvestSeason;

  @HiveField(7)
  int daysToMaturity;

  @HiveField(8)
  double spacing;

  @HiveField(9)
  double depth;

  @HiveField(10)
  String sunExposure;

  @HiveField(11)
  String waterNeeds;

  @HiveField(12)
  List<String> sowingMonths;

  @HiveField(13)
  List<String> harvestMonths;

  @HiveField(14)
  double marketPricePerKg;

  @HiveField(15)
  String defaultUnit;

  @HiveField(16)
  Map<String, dynamic> nutritionPer100g;

  @HiveField(17)
  Map<String, dynamic> germination;

  @HiveField(18)
  Map<String, dynamic> growth;

  @HiveField(19)
  Map<String, dynamic> watering;

  @HiveField(20)
  Map<String, dynamic> thinning;

  @HiveField(21)
  Map<String, dynamic> weeding;

  @HiveField(22)
  List<String> culturalTips;

  @HiveField(23)
  Map<String, dynamic> biologicalControl;

  @HiveField(24)
  String harvestTime;

  @HiveField(25)
  Map<String, dynamic> companionPlanting;

  @HiveField(26)
  Map<String, dynamic> notificationSettings;

  @HiveField(27)
  String? imageUrl;

  @HiveField(28)
  DateTime createdAt;

  @HiveField(29)
  DateTime updatedAt;

  @HiveField(30)
  Map<String, dynamic> metadata;

  @HiveField(31)
  bool isActive;

  @HiveField(32)
  String? notes;

  Plant({
    String? id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.description,
    required this.plantingSeason,
    required this.harvestSeason,
    required this.daysToMaturity,
    required this.spacing,
    required this.depth,
    required this.sunExposure,
    required this.waterNeeds,
    required this.sowingMonths,
    required this.harvestMonths,
    required this.marketPricePerKg,
    required this.defaultUnit,
    required this.nutritionPer100g,
    required this.germination,
    required this.growth,
    required this.watering,
    required this.thinning,
    required this.weeding,
    required this.culturalTips,
    required this.biologicalControl,
    required this.harvestTime,
    required this.companionPlanting,
    required this.notificationSettings,
    this.imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    this.isActive = true,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        metadata = metadata ?? {};

  // Catégories de plantes basées sur les familles botaniques
  static const List<String> families = [
    'Solanaceae',
    'Asteraceae',
    'Brassicaceae',
    'Fabaceae',
    'Cucurbitaceae',
    'Apiaceae',
    'Lamiaceae',
    'Amaryllidaceae',
    'Chenopodiaceae',
    'Rosaceae',
  ];

  // Saisons de plantation
  static const List<String> plantingSeasons = [
    'Printemps',
    'Été',
    'Automne',
    'Hiver',
    'Printemps,Été',
    'Printemps,Automne',
    'Été,Automne',
  ];

  // Types d'exposition
  static const List<String> sunExposureTypes = [
    'Plein soleil',
    'Mi-soleil',
    'Mi-ombre',
    'Ombre',
  ];

  // Besoins en eau
  static const List<String> waterNeedLevels = [
    'Faible',
    'Moyen',
    'Élevé',
  ];

  // Mois abrégés pour les cycles
  static const List<String> monthAbbreviations = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D'
  ];

  // Getters utilitaires
  bool get isQuickGrowing => daysToMaturity <= 45;
  bool get isSlowGrowing => daysToMaturity >= 90;

  String get category {
    // Détermine la catégorie basée sur la famille
    switch (family) {
      case 'Solanaceae':
        return 'Légumes-fruits';
      case 'Asteraceae':
        return 'Légumes-feuilles';
      case 'Brassicaceae':
        return 'Légumes-feuilles';
      case 'Fabaceae':
        return 'Légumineuses';
      case 'Cucurbitaceae':
        return 'Légumes-fruits';
      case 'Apiaceae':
        return 'Aromates';
      case 'Lamiaceae':
        return 'Aromates';
      case 'Amaryllidaceae':
        return 'Légumes-bulbes';
      case 'Chenopodiaceae':
        return 'Légumes-feuilles';
      case 'Rosaceae':
        return 'Arbres fruitiers';
      default:
        return 'Autres';
    }
  }

  String get difficulty {
    // Détermine la difficulté basée sur les jours de maturité et les besoins
    if (daysToMaturity <= 30 && waterNeeds == 'Faible') {
      return 'Très facile';
    } else if (daysToMaturity <= 60 && waterNeeds != 'Élevé') {
      return 'Facile';
    } else if (daysToMaturity <= 90) {
      return 'Modéré';
    } else {
      return 'Difficile';
    }
  }

  List<String> get beneficialCompanions {
    final companions = companionPlanting['beneficial'] as List<dynamic>?;
    return companions?.cast<String>() ?? [];
  }

  List<String> get incompatiblePlants {
    final avoid = companionPlanting['avoid'] as List<dynamic>?;
    return avoid?.cast<String>() ?? [];
  }

  // Méthodes utilitaires
  void markAsUpdated() {
    updatedAt = DateTime.now();
  }

  Plant copyWith({
    String? commonName,
    String? scientificName,
    String? family,
    String? description,
    String? plantingSeason,
    String? harvestSeason,
    int? daysToMaturity,
    double? spacing,
    double? depth,
    String? sunExposure,
    String? waterNeeds,
    List<String>? sowingMonths,
    List<String>? harvestMonths,
    double? marketPricePerKg,
    String? defaultUnit,
    Map<String, dynamic>? nutritionPer100g,
    Map<String, dynamic>? germination,
    Map<String, dynamic>? growth,
    Map<String, dynamic>? watering,
    Map<String, dynamic>? thinning,
    Map<String, dynamic>? weeding,
    List<String>? culturalTips,
    Map<String, dynamic>? biologicalControl,
    String? harvestTime,
    Map<String, dynamic>? companionPlanting,
    Map<String, dynamic>? notificationSettings,
    String? imageUrl,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
    bool? isActive,
    String? notes,
  }) {
    return Plant(
      id: id,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      family: family ?? this.family,
      description: description ?? this.description,
      plantingSeason: plantingSeason ?? this.plantingSeason,
      harvestSeason: harvestSeason ?? this.harvestSeason,
      daysToMaturity: daysToMaturity ?? this.daysToMaturity,
      spacing: spacing ?? this.spacing,
      depth: depth ?? this.depth,
      sunExposure: sunExposure ?? this.sunExposure,
      waterNeeds: waterNeeds ?? this.waterNeeds,
      sowingMonths: sowingMonths ?? this.sowingMonths,
      harvestMonths: harvestMonths ?? this.harvestMonths,
      marketPricePerKg: marketPricePerKg ?? this.marketPricePerKg,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      nutritionPer100g: nutritionPer100g ?? this.nutritionPer100g,
      germination: germination ?? this.germination,
      growth: growth ?? this.growth,
      watering: watering ?? this.watering,
      thinning: thinning ?? this.thinning,
      weeding: weeding ?? this.weeding,
      culturalTips: culturalTips ?? this.culturalTips,
      biologicalControl: biologicalControl ?? this.biologicalControl,
      harvestTime: harvestTime ?? this.harvestTime,
      companionPlanting: companionPlanting ?? this.companionPlanting,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'family': family,
      'description': description,
      'plantingSeason': plantingSeason,
      'harvestSeason': harvestSeason,
      'daysToMaturity': daysToMaturity,
      'spacing': spacing,
      'depth': depth,
      'sunExposure': sunExposure,
      'waterNeeds': waterNeeds,
      'sowingMonths': sowingMonths,
      'harvestMonths': harvestMonths,
      'marketPricePerKg': marketPricePerKg,
      'defaultUnit': defaultUnit,
      'nutritionPer100g': nutritionPer100g,
      'germination': germination,
      'growth': growth,
      'watering': watering,
      'thinning': thinning,
      'weeding': weeding,
      'culturalTips': culturalTips,
      'biologicalControl': biologicalControl,
      'harvestTime': harvestTime,
      'companionPlanting': companionPlanting,
      'notificationSettings': notificationSettings,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      commonName: json['commonName'],
      scientificName: json['scientificName'],
      family: json['family'],
      description: json['description'],
      plantingSeason: json['plantingSeason'],
      harvestSeason: json['harvestSeason'],
      daysToMaturity: json['daysToMaturity'],
      spacing: (json['spacing'] as num).toDouble(),
      depth: (json['depth'] as num).toDouble(),
      sunExposure: json['sunExposure'],
      waterNeeds: json['waterNeeds'],
      sowingMonths: List<String>.from(json['sowingMonths']),
      harvestMonths: List<String>.from(json['harvestMonths']),
      marketPricePerKg: (json['marketPricePerKg'] as num).toDouble(),
      defaultUnit: json['defaultUnit'],
      nutritionPer100g: Map<String, dynamic>.from(json['nutritionPer100g']),
      germination: Map<String, dynamic>.from(json['germination']),
      growth: Map<String, dynamic>.from(json['growth']),
      watering: Map<String, dynamic>.from(json['watering']),
      thinning: Map<String, dynamic>.from(json['thinning']),
      weeding: Map<String, dynamic>.from(json['weeding']),
      culturalTips: List<String>.from(json['culturalTips']),
      biologicalControl: Map<String, dynamic>.from(json['biologicalControl']),
      harvestTime: json['harvestTime'],
      companionPlanting: Map<String, dynamic>.from(json['companionPlanting']),
      notificationSettings:
          Map<String, dynamic>.from(json['notificationSettings']),
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isActive: json['isActive'] ?? true,
      notes: json['notes'],
    );
  }

  @override
  String toString() {
    return 'Plant(id: $id, commonName: $commonName, scientificName: $scientificName, family: $family)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}


