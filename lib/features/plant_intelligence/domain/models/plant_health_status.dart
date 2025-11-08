// 🌱 PlantHealthStatus - Modèle agrégé de santé végétale
// PermaCalendar v2.8.0 - Migration Riverpod 3
//
// Rôle dans l'écosystème d'intelligence :
// - Centralise l'état de santé d'une plante à partir des conditions analysées
// - Sert de contrat entre les services d'analyse (RealTimeDataProcessor,
//   PlantConditionAnalyzer) et les entités orientées UI (IntelligentSuggestion,
//   indicateurs de santé)
// - Permet la persistance locale (Hive) et la sérialisation (JSON, API)
//
// Interactions clés :
// - `RealTimeDataProcessor` : produit et met à jour les composantes temps réel
// - `IntelligentSuggestion` : consomme le score global et les facteurs critiques
//   pour contextualiser les recommandations
// - Providers Riverpod 3 : exposent les instances via `ref.watch()` sans état
//   global, garantissant la compatibilité avec Riverpod 3
//
// Usages typiques :
// - Dashboard santé des plantes (indicateurs, graphiques, alertes)
// - Synchronisation et cache hors-ligne via Hive
// - Génération de notifications ciblées selon les facteurs critiques
//
// Notes Riverpod 3 :
// - Modèle entièrement immuable (Freezed)
// - Aucune dépendance mutable ou globale
// - Sérialisable pour être consommé dans des providers asynchrones

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'plant_health_status.freezed.dart';
part 'plant_health_status.g.dart';

/// Niveau de santé global d'une plante
@HiveType(typeId: 54, adapterName: 'PlantHealthLevelAdapter')
enum PlantHealthLevel {
  /// Santé optimale, aucun risque détecté
  @HiveField(0)
  excellent,

  /// Santé bonne, surveiller les légères variations
  @HiveField(1)
  good,

  /// Santé moyenne, opportunités d'amélioration
  @HiveField(2)
  fair,

  /// Santé faible, des actions correctives sont requises
  @HiveField(3)
  poor,

  /// Santé critique, intervention immédiate nécessaire
  @HiveField(4)
  critical,
}

/// Facteurs suivis pour la santé végétale
@HiveType(typeId: 55, adapterName: 'PlantHealthFactorAdapter')
enum PlantHealthFactor {
  /// Humidité ambiante ou du sol
  @HiveField(0)
  humidity,

  /// Luminosité reçue par la plante
  @HiveField(1)
  light,

  /// Température ambiante
  @HiveField(2)
  temperature,

  /// Disponibilité des nutriments
  @HiveField(3)
  nutrients,

  /// Humidité du sol dédiée (si disponible)
  @HiveField(4)
  soilMoisture,

  /// Stress hydrique (fréquence d'arrosage)
  @HiveField(5)
  waterStress,

  /// Pression des nuisibles ou maladies
  @HiveField(6)
  pestPressure,
}

/// Score détaillé pour un facteur de santé
@freezed
class PlantHealthComponent with _$PlantHealthComponent {
  @JsonSerializable()
  @HiveType(typeId: 56, adapterName: 'PlantHealthComponentAdapter')
  const factory PlantHealthComponent({
    /// Facteur mesuré (humidité, lumière, etc.)
    @HiveField(0) required PlantHealthFactor factor,

    /// Score (0-100) issu de l'analyse
    @HiveField(1) required double score,

    /// Niveau de santé associé au score
    @HiveField(2) required PlantHealthLevel level,

    /// Valeur brute mesurée (ex: % humidité)
    @HiveField(3) double? value,

    /// Valeur optimale attendue
    @HiveField(4) double? optimalValue,

    /// Valeur minimale acceptable
    @HiveField(5) double? minValue,

    /// Valeur maximale acceptable
    @HiveField(6) double? maxValue,

    /// Unité de mesure (°, %, lux, etc.)
    @HiveField(7) String? unit,

    /// Tendance textuelle (up, down, stable)
    @HiveField(8) @Default('stable') String trend,
  }) = _PlantHealthComponent;

  const PlantHealthComponent._();

  factory PlantHealthComponent.fromJson(Map<String, dynamic> json) =>
      _$PlantHealthComponentFromJson(json);

  /// Score normalisé entre 0 et 1
  double get normalizedScore => (score / 100).clamp(0.0, 1.0);

  /// Indique si le facteur est critique
  bool get isCritical => level == PlantHealthLevel.critical;
}

/// Statut de santé complet d'une plante
@freezed
class PlantHealthStatus with _$PlantHealthStatus {
  @JsonSerializable(explicitToJson: true)
  @HiveType(typeId: 57, adapterName: 'PlantHealthStatusAdapter')
  const factory PlantHealthStatus._data({
    /// Identifiant unique de la plante
    @HiveField(0) required String plantId,

    /// Identifiant du jardin pour le multi-garden
    @HiveField(1) required String gardenId,

    /// Score global de santé (0-100)
    @HiveField(2) required double overallScore,

    /// Niveau global calculé selon le score
    @HiveField(3) required PlantHealthLevel level,

    /// Analyse de l'humidité
    @HiveField(4) required PlantHealthComponent humidity,

    /// Analyse de la lumière
    @HiveField(5) required PlantHealthComponent light,

    /// Analyse de la température
    @HiveField(6) required PlantHealthComponent temperature,

    /// Analyse des nutriments
    @HiveField(7) required PlantHealthComponent nutrients,

    /// Analyse de l'humidité du sol
    @HiveField(8) PlantHealthComponent? soilMoisture,

    /// Analyse du stress hydrique
    @HiveField(9) PlantHealthComponent? waterStress,

    /// Analyse de la pression des nuisibles
    @HiveField(10) PlantHealthComponent? pestPressure,

    /// Dernière mise à jour du calcul
    @HiveField(11) required DateTime lastUpdated,

    /// Date de dernière synchronisation avec les capteurs
    @HiveField(12) DateTime? lastSyncedAt,

    /// Liste d'alertes actives pour l'utilisateur
    @HiveField(13) @Default(<String>[]) List<String> activeAlerts,

    /// Actions recommandées par l'intelligence
    @HiveField(14) @Default(<String>[]) List<String> recommendedActions,

    /// Tendance globale sur 7/30 jours (`improving`, `declining`, `stable`)
    @HiveField(15) @Default('unknown') String healthTrend,

    /// Scores de tendances par facteur (clé = facteur)
    @HiveField(16) @Default(<String, double>{}) Map<String, double> factorTrends,

    /// Métadonnées additionnelles (source, version modèle, etc.)
    @HiveField(17) @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
  }) = _PlantHealthStatus;

  const PlantHealthStatus._();

  factory PlantHealthStatus({
    required String plantId,
    required String gardenId,
    required double overallScore,
    required PlantHealthLevel level,
    required PlantHealthComponent humidity,
    required PlantHealthComponent light,
    required PlantHealthComponent temperature,
    required PlantHealthComponent nutrients,
    PlantHealthComponent? soilMoisture,
    PlantHealthComponent? waterStress,
    PlantHealthComponent? pestPressure,
    required DateTime lastUpdated,
    DateTime? lastSyncedAt,
    List<String> activeAlerts = const <String>[],
    List<String> recommendedActions = const <String>[],
    String healthTrend = 'unknown',
    Map<String, double> factorTrends = const <String, double>{},
    Map<String, dynamic> metadata = const <String, dynamic>{},
  }) {
    assert(
      humidity.factor == PlantHealthFactor.humidity,
      'Le facteur humidité doit être PlantHealthFactor.humidity',
    );
    assert(
      light.factor == PlantHealthFactor.light,
      'Le facteur lumière doit être PlantHealthFactor.light',
    );
    assert(
      temperature.factor == PlantHealthFactor.temperature,
      'Le facteur température doit être PlantHealthFactor.temperature',
    );
    assert(
      nutrients.factor == PlantHealthFactor.nutrients,
      'Le facteur nutriments doit être PlantHealthFactor.nutrients',
    );

    return PlantHealthStatus._data(
      plantId: plantId,
      gardenId: gardenId,
      overallScore: overallScore,
      level: level,
      humidity: humidity,
      light: light,
      temperature: temperature,
      nutrients: nutrients,
      soilMoisture: soilMoisture,
      waterStress: waterStress,
      pestPressure: pestPressure,
      lastUpdated: lastUpdated,
      lastSyncedAt: lastSyncedAt,
      activeAlerts: activeAlerts,
      recommendedActions: recommendedActions,
      healthTrend: healthTrend,
      factorTrends: factorTrends,
      metadata: metadata,
    );
  }

  /// Factory pour créer un statut initial neutre
  factory PlantHealthStatus.initial({
    required String plantId,
    required String gardenId,
    DateTime? timestamp,
  }) {
    DateTime lastUpdated = timestamp ?? DateTime.now();
    PlantHealthComponent emptyComponent(PlantHealthFactor factor) =>
        PlantHealthComponent(
          factor: factor,
          score: 50,
          level: PlantHealthLevel.fair,
          trend: 'stable',
        );

    return PlantHealthStatus(
      plantId: plantId,
      gardenId: gardenId,
      overallScore: 50,
      level: PlantHealthLevel.fair,
      humidity: emptyComponent(PlantHealthFactor.humidity),
      light: emptyComponent(PlantHealthFactor.light),
      temperature: emptyComponent(PlantHealthFactor.temperature),
      nutrients: emptyComponent(PlantHealthFactor.nutrients),
      soilMoisture: emptyComponent(PlantHealthFactor.soilMoisture),
      waterStress: emptyComponent(PlantHealthFactor.waterStress),
      pestPressure: emptyComponent(PlantHealthFactor.pestPressure),
      lastUpdated: lastUpdated,
      lastSyncedAt: lastUpdated,
      healthTrend: 'stable',
    );
  }

  factory PlantHealthStatus.fromJson(Map<String, dynamic> json) =>
      _$PlantHealthStatusFromJson(json);

  /// Score normalisé entre 0 et 1
  double get normalizedScore => (overallScore / 100).clamp(0.0, 1.0);

  /// Composantes listées (inclut les facteurs optionnels disponibles)
  List<PlantHealthComponent> get components => [
        humidity,
        light,
        temperature,
        nutrients,
        if (soilMoisture != null) soilMoisture!,
        if (waterStress != null) waterStress!,
        if (pestPressure != null) pestPressure!,
      ];

  /// Récupère une composante spécifique
  PlantHealthComponent? componentFor(PlantHealthFactor factor) {
    for (final component in components) {
      if (component.factor == factor) return component;
    }
    return null;
  }

  /// Composantes critiques
  List<PlantHealthComponent> get criticalComponents =>
      components.where((c) => c.level == PlantHealthLevel.critical).toList();

  /// Indique si la plante est en bonne santé
  bool get isHealthy => level == PlantHealthLevel.excellent || level == PlantHealthLevel.good;

  /// Indique si la plante est en état critique
  bool get isCritical => level == PlantHealthLevel.critical;
}

extension PlantHealthLevelExtension on PlantHealthLevel {
  /// Nom affichable pour l'UI
  String get displayName {
    switch (this) {
      case PlantHealthLevel.excellent:
        return 'Excellent';
      case PlantHealthLevel.good:
        return 'Bon';
      case PlantHealthLevel.fair:
        return 'Moyen';
      case PlantHealthLevel.poor:
        return 'Faible';
      case PlantHealthLevel.critical:
        return 'Critique';
    }
  }

  /// Seuil minimal du score global pour ce niveau (0-1)
  double get scoreThreshold {
    switch (this) {
      case PlantHealthLevel.excellent:
        return 0.9;
      case PlantHealthLevel.good:
        return 0.75;
      case PlantHealthLevel.fair:
        return 0.6;
      case PlantHealthLevel.poor:
        return 0.4;
      case PlantHealthLevel.critical:
        return 0.0;
    }
  }
}