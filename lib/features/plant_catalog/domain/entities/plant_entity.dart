import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'plant_entity.freezed.dart';
part 'plant_entity.g.dart';

/// Entité Plant utilisant Freezed pour l'immutabilité et la sérialisation
/// Modèle de domaine pour les plantes avec toutes les propriétés du JSON plants.json
@freezed
class PlantFreezed with _$PlantFreezed {
  const factory PlantFreezed({
    /// Identifiant unique de la plante
    required String id,

    /// Nom commun de la plante
    required String commonName,

    /// Nom scientifique de la plante
    required String scientificName,

    /// Famille botanique
    required String family,

    /// Saison de plantation
    required String plantingSeason,

    /// Saison de récolte
    required String harvestSeason,

    /// Nombre de jours jusqu'à maturité
    required int daysToMaturity,

    /// Espacement entre plants (en cm)
    required int spacing,

    /// Profondeur de plantation (en cm)
    required double depth,

    /// Exposition au soleil requise
    required String sunExposure,

    /// Besoins en eau
    required String waterNeeds,

    /// Description de la plante
    required String description,

    /// Mois de semis (codes courts: F, M, A, etc.)
    required List<String> sowingMonths,

    /// Mois de récolte (codes courts: F, M, A, etc.)
    required List<String> harvestMonths,

    /// Prix du marché par kg
    double? marketPricePerKg,

    /// Unité par défaut (kg, pièce, etc.)
    String? defaultUnit,

    /// Informations nutritionnelles pour 100g
    Map<String, dynamic>? nutritionPer100g,

    /// Informations sur la germination
    Map<String, dynamic>? germination,

    /// Informations sur la croissance
    Map<String, dynamic>? growth,

    /// Informations sur l'arrosage
    Map<String, dynamic>? watering,

    /// Informations sur l'éclaircissement
    Map<String, dynamic>? thinning,

    /// Informations sur le désherbage
    Map<String, dynamic>? weeding,

    /// Conseils culturaux
    List<String>? culturalTips,

    /// Contrôle biologique
    Map<String, dynamic>? biologicalControl,

    /// Temps de récolte
    String? harvestTime,

    /// Associations de plantes
    Map<String, dynamic>? companionPlanting,

    /// Paramètres de notification
    Map<String, dynamic>? notificationSettings,

    /// Variétés recommandées
    Map<String, dynamic>? varieties,

    /// Métadonnées additionnelles flexibles
    @Default({}) Map<String, dynamic> metadata,

    /// Date de Création
    DateTime? createdAt,

    /// Date de dernière mise à jour
    DateTime? updatedAt,

    /// Indique si la plante est active
    @Default(true) bool isActive,

    /// Profil de référence
    Map<String, dynamic>? referenceProfile,

    /// Profils de zones
    Map<String, dynamic>? zoneProfiles,

    /// Notes personnelles
    String? notes,
  }) = _PlantFreezed;

  factory PlantFreezed.fromJson(Map<String, dynamic> json) =>
      _$PlantFreezedFromJson(json);

  /// Factory constructor pour Créer une nouvelle plante
  factory PlantFreezed.create({
    required String commonName,
    required String scientificName,
    required String family,
    required String plantingSeason,
    required String harvestSeason,
    required int daysToMaturity,
    required int spacing,
    required double depth,
    required String sunExposure,
    required String waterNeeds,
    required String description,
    required List<String> sowingMonths,
    required List<String> harvestMonths,
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
    Map<String, dynamic>? varieties,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? referenceProfile,
    Map<String, dynamic>? zoneProfiles,
    String? notes,
  }) {
    final now = DateTime.now();
    return PlantFreezed(
      id: const Uuid().v4(),
      commonName: commonName,
      scientificName: scientificName,
      family: family,
      plantingSeason: plantingSeason,
      harvestSeason: harvestSeason,
      daysToMaturity: daysToMaturity,
      spacing: spacing,
      depth: depth,
      sunExposure: sunExposure,
      waterNeeds: waterNeeds,
      description: description,
      sowingMonths: sowingMonths,
      harvestMonths: harvestMonths,
      marketPricePerKg: marketPricePerKg,
      defaultUnit: defaultUnit,
      nutritionPer100g: nutritionPer100g,
      germination: germination,
      growth: growth,
      watering: watering,
      thinning: thinning,
      weeding: weeding,
      culturalTips: culturalTips,
      biologicalControl: biologicalControl,
      harvestTime: harvestTime,
      companionPlanting: companionPlanting,
      notificationSettings: notificationSettings,
      varieties: varieties,
      metadata: metadata ?? {},
      createdAt: now,
      updatedAt: now,
      referenceProfile: referenceProfile,
      zoneProfiles: zoneProfiles,
      notes: notes,
    );
  }
}

/// Extension pour ajouter des méthodes utilitaires et des calculs
extension PlantFreezedExtension on PlantFreezed {
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

  /// Marquer comme mis à jour
  PlantFreezed markAsUpdated() {
    return copyWith(updatedAt: DateTime.now());
  }

  /// Mettre à jour les métadonnées
  PlantFreezed updateMetadata(String key, dynamic value) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata[key] = value;
    return copyWith(
      metadata: newMetadata,
      updatedAt: DateTime.now(),
    );
  }

  /// Supprimer une métadonnée
  PlantFreezed removeMetadata(String key) {
    final newMetadata = Map<String, dynamic>.from(metadata);
    newMetadata.remove(key);
    return copyWith(
      metadata: newMetadata,
      updatedAt: DateTime.now(),
    );
  }

  // === CALCULS UTILES ===

  /// Détermine si la plante est annuelle
  bool get isAnnual {
    // Les plantes avec un cycle de vie court (< 365 jours) sont généralement annuelles
    return daysToMaturity <= 365;
  }

  /// Détermine si la plante est pérenne
  bool get isPerennial {
    // Les plantes pérennes ont généralement des cycles plus longs ou des métadonnées spécifiques
    final lifespan = metadata['lifespan'] as String?;
    return lifespan?.toLowerCase().contains('perennial') == true ||
        lifespan?.toLowerCase().contains('pérenne') == true ||
        daysToMaturity > 365;
  }

  /// Détermine si la plante est bisannuelle
  bool get isBiennial {
    final lifespan = metadata['lifespan'] as String?;
    return lifespan?.toLowerCase().contains('biennial') == true ||
        lifespan?.toLowerCase().contains('bisannuelle') == true;
  }

  /// Calcule la densité de plantation (plants par mÂ²)
  double get plantDensityPerSquareMeter {
    if (spacing <= 0) return 0;
    // Conversion cm vers m et calcul de la surface par plant
    final spacingInMeters = spacing / 100.0;
    final areaPerPlant = spacingInMeters * spacingInMeters;
    return 1.0 / areaPerPlant;
  }

  /// Détermine si la plante nécessite beaucoup d'eau
  bool get isWaterIntensive {
    return waterNeeds.toLowerCase().contains('élevé') ||
        waterNeeds.toLowerCase().contains('high') ||
        waterNeeds.toLowerCase().contains('beaucoup');
  }

  /// Détermine si la plante tolère la sécheresse
  bool get isDroughtTolerant {
    return waterNeeds.toLowerCase().contains('faible') ||
        waterNeeds.toLowerCase().contains('low') ||
        waterNeeds.toLowerCase().contains('sec') ||
        waterNeeds.toLowerCase().contains('drought');
  }

  /// Détermine si la plante préfère le plein soleil
  bool get prefersFullSun {
    return sunExposure.toLowerCase().contains('plein soleil') ||
        sunExposure.toLowerCase().contains('full sun');
  }

  /// Détermine si la plante tolère l'ombre
  bool get toleratesShade {
    return sunExposure.toLowerCase().contains('ombre') ||
        sunExposure.toLowerCase().contains('shade') ||
        sunExposure.toLowerCase().contains('mi-ombre');
  }

  /// Calcule la température optimale de germination (moyenne)
  double? get optimalGerminationTemperature {
    if (germination == null) return null;

    final optimal = germination!['optimalTemperature'];
    if (optimal is num) {
      return optimal.toDouble();
    } else if (optimal is Map<String, dynamic>) {
      final min = optimal['min'] as num?;
      final max = optimal['max'] as num?;
      if (min != null && max != null) {
        return (min + max) / 2.0;
      }
    }
    return null;
  }

  /// Calcule la température minimale de germination
  double? get minGerminationTemperature {
    if (germination == null) return null;
    return (germination!['minTemperature'] as num?)?.toDouble();
  }

  /// Calcule le temps moyen de germination en jours
  double? get averageGerminationDays {
    if (germination == null) return null;

    final germinationTime =
        germination!['germinationTime'] as Map<String, dynamic>?;
    if (germinationTime == null) return null;

    final min = germinationTime['min'] as num?;
    final max = germinationTime['max'] as num?;

    if (min != null && max != null) {
      return (min + max) / 2.0;
    }
    return null;
  }

  /// Détermine si la plante est facile à cultiver (basé sur plusieurs critères)
  bool get isEasyToGrow {
    // Critères : germination rapide, pas trop d'exigences spéciales, résistante
    final quickGermination =
        averageGerminationDays != null && averageGerminationDays! <= 10;
    final notTooFussy = !isWaterIntensive && (toleratesShade || prefersFullSun);
    final hasResistantVarieties =
        varieties?.toString().toLowerCase().contains('résistant') == true;

    return quickGermination && (notTooFussy || hasResistantVarieties);
  }

  /// Calcule la valeur nutritionnelle totale (score approximatif)
  double get nutritionalScore {
    if (nutritionPer100g == null) return 0.0;

    double score = 0.0;
    final nutrition = nutritionPer100g!;

    // Points pour les vitamines (valeurs approximatives)
    score += (nutrition['vitaminCmg'] as num?)?.toDouble() ?? 0.0;
    score += ((nutrition['vitaminAmcg'] as num?)?.toDouble() ?? 0.0) /
        100; // Conversion mcg
    score += ((nutrition['vitaminB9ug'] as num?)?.toDouble() ?? 0.0) /
        10; // Conversion ug

    // Points pour les minéraux
    score += ((nutrition['calciumMg'] as num?)?.toDouble() ?? 0.0) / 10;
    score += ((nutrition['ironMg'] as num?)?.toDouble() ?? 0.0) * 10;
    score += ((nutrition['potassiumMg'] as num?)?.toDouble() ?? 0.0) / 100;

    // Points pour les fibres
    score += ((nutrition['fiberG'] as num?)?.toDouble() ?? 0.0) * 5;

    return score;
  }

  /// Détermine si la plante est riche en nutriments
  bool get isNutrientRich {
    return nutritionalScore > 50.0; // Seuil arbitraire
  }

  /// Calcule le rendement économique potentiel (prix Ã— facilité de culture)
  double get economicPotential {
    if (marketPricePerKg == null) return 0.0;

    double multiplier = 1.0;
    if (isEasyToGrow) multiplier += 0.5;
    if (plantDensityPerSquareMeter > 4) multiplier += 0.3; // Densité élevée
    if (daysToMaturity < 60) multiplier += 0.2; // Croissance rapide

    return marketPricePerKg! * multiplier;
  }

  /// Détermine les mois de plantation possibles (codes de mois)
  List<String> get plantingMonths {
    return sowingMonths;
  }

  /// Détermine si on peut planter maintenant (basé sur le mois actuel)
  bool get canPlantNow {
    final currentMonth = _getCurrentMonthCode();
    return sowingMonths.contains(currentMonth);
  }

  /// Détermine si on peut récolter maintenant (basé sur le mois actuel)
  bool get canHarvestNow {
    final currentMonth = _getCurrentMonthCode();
    return harvestMonths.contains(currentMonth);
  }

  /// Calcule les plantes compagnes bénéfiques
  List<String> get beneficialCompanions {
    if (companionPlanting == null) return [];
    final beneficial = companionPlanting!['beneficial'];
    if (beneficial is List) {
      return List<String>.from(beneficial);
    }
    return [];
  }

  /// Calcule les plantes à éviter
  List<String> get plantsToAvoid {
    if (companionPlanting == null) return [];
    final avoid = companionPlanting!['avoid'];
    if (avoid is List) {
      return List<String>.from(avoid);
    }
    return [];
  }

  /// Méthode privée pour obtenir le code du mois actuel
  String _getCurrentMonthCode() {
    final month = DateTime.now().month;
    const monthCodes = [
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
    return monthCodes[month - 1];
  }

  /// Résumé textuel de la plante
  String get summary {
    return '$commonName ($scientificName) - Famille: $family, '
        'Maturité: $daysToMaturity jours, '
        'Espacement: ${spacing}cm, '
        'Exposition: $sunExposure';
  }
}
