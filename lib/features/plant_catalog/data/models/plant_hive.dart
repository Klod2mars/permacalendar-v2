import 'package:hive/hive.dart';
import '../../../../core/hive/type_ids.dart';

part 'plant_hive.g.dart';

/// Modèle Hive pour les plantes avec toutes les propriétés du JSON plants.json
///
/// TypeId: utiliser la constante centrale kTypeIdPlantHive (lib/core/hive/type_ids.dart)
///
@HiveType(typeId: kTypeIdPlantHive)
class PlantHive extends HiveObject {
  /// Identifiant unique de la plante
  @HiveField(0)
  String id;

  /// Nom commun de la plante
  @HiveField(1)
  String commonName;

  /// Nom scientifique de la plante
  @HiveField(2)
  String scientificName;

  /// Famille botanique
  @HiveField(3)
  String family;

  /// Saison de plantation
  @HiveField(4)
  String plantingSeason;

  /// Saison de récolte
  @HiveField(5)
  String harvestSeason;

  /// Nombre de jours jusqu'à maturité
  @HiveField(6)
  int daysToMaturity;

  /// Espacement entre plants (en cm)
  @HiveField(7)
  int spacing;

  /// Profondeur de plantation (en cm)
  @HiveField(8)
  double depth;

  /// Exposition au soleil requise
  @HiveField(9)
  String sunExposure;

  /// Besoins en eau
  @HiveField(10)
  String waterNeeds;

  /// Description de la plante
  @HiveField(11)
  String description;

  /// Mois de semis (codes courts: F, M, A, etc.)
  @HiveField(12)
  List<String> sowingMonths;

  /// Mois de récolte (codes courts: F, M, A, etc.)
  @HiveField(13)
  List<String> harvestMonths;

  /// Prix du marché par kg
  @HiveField(14)
  double? marketPricePerKg;

  /// Unité par défaut (kg, pièce, etc.)
  @HiveField(15)
  String? defaultUnit;

  /// Informations nutritionnelles pour 100g
  @HiveField(16)
  Map<String, dynamic>? nutritionPer100g;

  /// Informations sur la germination
  @HiveField(17)
  Map<String, dynamic>? germination;

  /// Informations sur la croissance
  @HiveField(18)
  Map<String, dynamic>? growth;

  /// Informations sur l'arrosage
  @HiveField(19)
  Map<String, dynamic>? watering;

  /// Informations sur l'éclaircissement
  @HiveField(20)
  Map<String, dynamic>? thinning;

  /// Informations sur le désherbage
  @HiveField(21)
  Map<String, dynamic>? weeding;

  /// Conseils culturaux
  @HiveField(22)
  List<String>? culturalTips;

  /// Contrôle biologique
  @HiveField(23)
  Map<String, dynamic>? biologicalControl;

  /// Temps de récolte
  @HiveField(24)
  String? harvestTime;

  /// Associations de plantes
  @HiveField(25)
  Map<String, dynamic>? companionPlanting;

  /// Paramètres de notification
  @HiveField(26)
  Map<String, dynamic>? notificationSettings;

  /// Variétés recommandées
  @HiveField(27)
  Map<String, dynamic>? varieties;

  /// Métadonnées additionnelles flexibles
  @HiveField(28)
  Map<String, dynamic>? metadata;

  /// Date de Création
  @HiveField(29)
  DateTime? createdAt;

  /// Date de dernière mise à jour
  @HiveField(30)
  DateTime? updatedAt;

  /// Indique si la plante est active
  @HiveField(31)
  bool isActive;
  
  /// Profil de référence (Europe Ouest)
  @HiveField(32)
  Map<String, dynamic>? referenceProfile;

  /// Profils de zones spécifiques (mapping override, règles relatives)
  @HiveField(33)
  Map<String, dynamic>? zoneProfiles;

  PlantHive({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.plantingSeason,
    required this.harvestSeason,
    required this.daysToMaturity,
    required this.spacing,
    required this.depth,
    required this.sunExposure,
    required this.waterNeeds,
    required this.description,
    required this.sowingMonths,
    required this.harvestMonths,
    this.marketPricePerKg,
    this.defaultUnit,
    this.nutritionPer100g,
    this.germination,
    this.growth,
    this.watering,
    this.thinning,
    this.weeding,
    this.culturalTips,
    this.biologicalControl,
    this.harvestTime,
    this.companionPlanting,
    this.notificationSettings,
    this.varieties,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.referenceProfile,
    this.zoneProfiles,
  });

  /// Factory constructor pour Créer depuis JSON
  factory PlantHive.fromJson(Map<String, dynamic> json) {
    return PlantHive(
      id: json['id'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      family: json['family'] as String,
      plantingSeason: json['plantingSeason'] as String,
      harvestSeason: json['harvestSeason'] as String,
      daysToMaturity: json['daysToMaturity'] as int,
      spacing: json['spacing'] as int,
      depth: (json['depth'] as num).toDouble(),
      sunExposure: json['sunExposure'] as String,
      waterNeeds: json['waterNeeds'] as String,
      description: json['description'] as String,
      sowingMonths: List<String>.from(json['sowingMonths'] as List),
      harvestMonths: List<String>.from(json['harvestMonths'] as List),
      marketPricePerKg: json['marketPricePerKg'] != null
          ? (json['marketPricePerKg'] as num).toDouble()
          : null,
      defaultUnit: json['defaultUnit'] as String?,
      nutritionPer100g: json['nutritionPer100g'] as Map<String, dynamic>?,
      germination: json['germination'] as Map<String, dynamic>?,
      growth: json['growth'] as Map<String, dynamic>?,
      watering: json['watering'] as Map<String, dynamic>?,
      thinning: json['thinning'] as Map<String, dynamic>?,
      weeding: json['weeding'] as Map<String, dynamic>?,
      culturalTips: json['culturalTips'] != null
          ? List<String>.from(json['culturalTips'] as List)
          : null,
      biologicalControl: json['biologicalControl'] as Map<String, dynamic>?,
      harvestTime: json['harvestTime'] as String?,
      companionPlanting: json['companionPlanting'] as Map<String, dynamic>?,
      notificationSettings:
          json['notificationSettings'] as Map<String, dynamic>?,
      varieties: json['varieties'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
      referenceProfile: json['referenceProfile'] as Map<String, dynamic>?,
      zoneProfiles: json['zoneProfiles'] as Map<String, dynamic>?,
    );
  }

  /// Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'family': family,
      'plantingSeason': plantingSeason,
      'harvestSeason': harvestSeason,
      'daysToMaturity': daysToMaturity,
      'spacing': spacing,
      'depth': depth,
      'sunExposure': sunExposure,
      'waterNeeds': waterNeeds,
      'description': description,
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
      'varieties': varieties,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'referenceProfile': referenceProfile,
      'zoneProfiles': zoneProfiles,
    };
  }

  /// Marquer comme mis à jour
  PlantHive markAsUpdated() {
    updatedAt = DateTime.now();
    return this;
  }

  /// Validation des données essentielles
  bool get isValid {
    return id.isNotEmpty &&
        commonName.isNotEmpty &&
        scientificName.isNotEmpty &&
        family.isNotEmpty &&
        daysToMaturity > 0 &&
        spacing > 0 &&
        depth >= 0;
  }

  @override
  String toString() {
    return 'PlantHive(id: $id, commonName: $commonName, scientificName: $scientificName, family: $family)';
  }
}
