import 'package:freezed_annotation/freezed_annotation.dart';
import 'condition_enums.dart';

part 'condition_models.freezed.dart';
part 'condition_models.g.dart';

/// Condition de température pour une plante
@freezed
class TemperatureCondition with _$TemperatureCondition {
  const factory TemperatureCondition({
    /// Température actuelle (°C)
    required double current,

    /// Température optimale pour la plante (°C)
    required double optimal,

    /// Température minimale tolérée (°C)
    required double min,

    /// Température maximale tolérée (°C)
    required double max,

    /// Indique si la température actuelle est dans la plage optimale
    required bool isOptimal,

    /// Description textuelle de l'état
    required String status,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _TemperatureCondition;

  factory TemperatureCondition.fromJson(Map<String, dynamic> json) =>
      _$TemperatureConditionFromJson(json);

  /// Factory pour créer une condition de température
  factory TemperatureCondition.create({
    required double current,
    required double optimal,
    required double min,
    required double max,
  }) {
    final isOptimal = current >= (optimal - 2) && current <= (optimal + 2);
    final status = _getTemperatureStatus(current, optimal, min, max);

    return TemperatureCondition(
      current: current,
      optimal: optimal,
      min: min,
      max: max,
      isOptimal: isOptimal,
      status: status,
    );
  }

  static String _getTemperatureStatus(
      double current, double optimal, double min, double max) {
    if (current < min) return 'Trop froid';
    if (current > max) return 'Trop chaud';
    if ((current - optimal).abs() <= 2) return 'Optimal';
    if ((current - optimal).abs() <= 5) return 'Acceptable';
    return 'Défavorable';
  }
}

/// Condition d'humidité pour une plante
@freezed
class MoistureCondition with _$MoistureCondition {
  const factory MoistureCondition({
    /// Niveau d'humidité actuel (0-100%)
    required double current,

    /// Niveau d'humidité optimal (0-100%)
    required double optimal,

    /// Niveau minimum toléré (0-100%)
    required double min,

    /// Niveau maximum toléré (0-100%)
    required double max,

    /// Indique si l'humidité est dans la plage optimale
    required bool isOptimal,

    /// Description textuelle de l'état
    required String status,

    /// Type de mesure (sol, air, etc.)
    @Default('soil') String measurementType,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _MoistureCondition;

  factory MoistureCondition.fromJson(Map<String, dynamic> json) =>
      _$MoistureConditionFromJson(json);

  /// Factory pour créer une condition d'humidité
  factory MoistureCondition.create({
    required double current,
    required double optimal,
    required double min,
    required double max,
    String measurementType = 'soil',
  }) {
    final isOptimal = current >= (optimal - 10) && current <= (optimal + 10);
    final status = _getMoistureStatus(current, optimal, min, max);

    return MoistureCondition(
      current: current,
      optimal: optimal,
      min: min,
      max: max,
      isOptimal: isOptimal,
      status: status,
      measurementType: measurementType,
    );
  }

  static String _getMoistureStatus(
      double current, double optimal, double min, double max) {
    if (current < min) return 'Trop sec';
    if (current > max) return 'Trop humide';
    if ((current - optimal).abs() <= 10) return 'Optimal';
    if ((current - optimal).abs() <= 20) return 'Acceptable';
    return 'Défavorable';
  }
}

/// Condition de luminosité pour une plante
@freezed
class LightCondition with _$LightCondition {
  const factory LightCondition({
    /// Intensité lumineuse actuelle (lux)
    required double current,

    /// Intensité optimale (lux)
    required double optimal,

    /// Intensité minimale tolérée (lux)
    required double min,

    /// Intensité maximale tolérée (lux)
    required double max,

    /// Heures de lumière directe par jour
    required double dailyHours,

    /// Heures optimales de lumière par jour
    required double optimalHours,

    /// Indique si la luminosité est optimale
    required bool isOptimal,

    /// Description textuelle de l'état
    required String status,

    /// Type d'exposition requis
    required ExposureType exposureType,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _LightCondition;

  factory LightCondition.fromJson(Map<String, dynamic> json) =>
      _$LightConditionFromJson(json);

  /// Factory pour créer une condition de luminosité
  factory LightCondition.create({
    required double current,
    required double optimal,
    required double min,
    required double max,
    required double dailyHours,
    required double optimalHours,
    required ExposureType exposureType,
  }) {
    final isOptimal = current >= (optimal * 0.8) &&
        current <= (optimal * 1.2) &&
        dailyHours >= (optimalHours * 0.8);
    final status =
        _getLightStatus(current, optimal, min, max, dailyHours, optimalHours);

    return LightCondition(
      current: current,
      optimal: optimal,
      min: min,
      max: max,
      dailyHours: dailyHours,
      optimalHours: optimalHours,
      isOptimal: isOptimal,
      status: status,
      exposureType: exposureType,
    );
  }

  static String _getLightStatus(double current, double optimal, double min,
      double max, double dailyHours, double optimalHours) {
    if (current < min || dailyHours < (optimalHours * 0.5))
      return 'Insuffisant';
    if (current > max) return 'Trop intense';
    if (current >= (optimal * 0.8) && dailyHours >= (optimalHours * 0.8))
      return 'Optimal';
    if (current >= (optimal * 0.6) && dailyHours >= (optimalHours * 0.6))
      return 'Acceptable';
    return 'Défavorable';
  }
}

/// Condition du sol pour une plante
@freezed
class SoilCondition with _$SoilCondition {
  const factory SoilCondition({
    /// pH actuel du sol
    required double ph,

    /// pH optimal pour la plante
    required double optimalPh,

    /// pH minimum toléré
    required double minPh,

    /// pH maximum toléré
    required double maxPh,

    /// Type de sol
    required SoilType soilType,

    /// Niveau de nutriments (0-100%)
    required double nutrientLevel,

    /// Niveau de drainage (0-100%)
    required double drainageLevel,

    /// Niveau de compaction (0-100%, 0 = pas compacté)
    required double compactionLevel,

    /// Indique si les conditions du sol sont optimales
    required bool isOptimal,

    /// Description textuelle de l'état
    required String status,

    /// Métadonnées additionnelles (analyses, amendements, etc.)
    @Default({}) Map<String, dynamic> metadata,
  }) = _SoilCondition;

  factory SoilCondition.fromJson(Map<String, dynamic> json) =>
      _$SoilConditionFromJson(json);

  /// Factory pour créer une condition de sol
  factory SoilCondition.create({
    required double ph,
    required double optimalPh,
    required double minPh,
    required double maxPh,
    required SoilType soilType,
    required double nutrientLevel,
    required double drainageLevel,
    required double compactionLevel,
  }) {
    final isOptimal = ph >= minPh &&
        ph <= maxPh &&
        nutrientLevel >= 60 &&
        drainageLevel >= 50 &&
        compactionLevel <= 30;
    final status = _getSoilStatus(ph, optimalPh, minPh, maxPh, nutrientLevel,
        drainageLevel, compactionLevel);

    return SoilCondition(
      ph: ph,
      optimalPh: optimalPh,
      minPh: minPh,
      maxPh: maxPh,
      soilType: soilType,
      nutrientLevel: nutrientLevel,
      drainageLevel: drainageLevel,
      compactionLevel: compactionLevel,
      isOptimal: isOptimal,
      status: status,
    );
  }

  static String _getSoilStatus(
      double ph,
      double optimalPh,
      double minPh,
      double maxPh,
      double nutrientLevel,
      double drainageLevel,
      double compactionLevel) {
    final List<String> issues = [];

    if (ph < minPh) issues.add('pH trop acide');
    if (ph > maxPh) issues.add('pH trop basique');
    if (nutrientLevel < 40) issues.add('Manque de nutriments');
    if (drainageLevel < 30) issues.add('Drainage insuffisant');
    if (compactionLevel > 50) issues.add('Sol trop compacté');

    if (issues.isEmpty) {
      if ((ph - optimalPh).abs() <= 0.2 &&
          nutrientLevel >= 80 &&
          drainageLevel >= 70) {
        return 'Optimal';
      }
      return 'Bon';
    } else if (issues.length == 1) {
      return 'Acceptable - ${issues.first}';
    } else {
      return 'Défavorable - ${issues.length} problèmes détectés';
    }
  }
}

/// Facteur de risque identifié
@freezed
class RiskFactor with _$RiskFactor {
  const factory RiskFactor({
    /// Identifiant unique du risque
    required String id,

    /// Type de risque (maladie, parasite, météo, etc.)
    required String type,

    /// Nom du risque
    required String name,

    /// Description du risque
    required String description,

    /// Niveau de risque (0.0 à 1.0)
    required double severity,

    /// Probabilité d'occurrence (0.0 à 1.0)
    required double probability,

    /// Actions préventives recommandées
    required List<String> preventiveActions,

    /// Conditions favorisant ce risque
    required List<String> favoringConditions,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _RiskFactor;

  factory RiskFactor.fromJson(Map<String, dynamic> json) =>
      _$RiskFactorFromJson(json);
}

/// Opportunité identifiée
@freezed
class Opportunity with _$Opportunity {
  const factory Opportunity({
    /// Identifiant unique de l'opportunité
    required String id,

    /// Type d'opportunité (plantation, récolte, traitement, etc.)
    required String type,

    /// Nom de l'opportunité
    required String name,

    /// Description de l'opportunité
    required String description,

    /// Bénéfice potentiel (0.0 à 1.0)
    required double benefit,

    /// Facilité de mise en œuvre (0.0 à 1.0)
    required double feasibility,

    /// Actions recommandées pour saisir l'opportunité
    required List<String> recommendedActions,

    /// Fenêtre temporelle optimale
    required String timeWindow,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _Opportunity;

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);
}

/// Prévision météorologique
@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    /// Date de la prévision
    required DateTime date,

    /// Température minimale (°C)
    required double minTemperature,

    /// Température maximale (°C)
    required double maxTemperature,

    /// Humidité relative (%)
    required double humidity,

    /// Précipitations prévues (mm)
    required double precipitation,

    /// Probabilité de précipitations (%)
    required double precipitationProbability,

    /// Vitesse du vent (km/h)
    required double windSpeed,

    /// Couverture nuageuse (%)
    required int cloudCover,

    /// Condition météorologique générale
    required String condition,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}

/// Plante compagne
@freezed
class CompanionPlant with _$CompanionPlant {
  const factory CompanionPlant({
    /// Identifiant de la plante compagne
    required String plantId,

    /// Nom de la plante compagne
    required String name,

    /// Type de relation (bénéfique, neutre, défavorable)
    required String relationshipType,

    /// Bénéfices de l'association
    required List<String> benefits,

    /// Distance recommandée (cm)
    required double recommendedDistance,

    /// Période d'association optimale
    required String optimalPeriod,

    /// Métadonnées additionnelles
    @Default({}) Map<String, dynamic> metadata,
  }) = _CompanionPlant;

  factory CompanionPlant.fromJson(Map<String, dynamic> json) =>
      _$CompanionPlantFromJson(json);
}

/// Extensions pour les calculs et utilitaires
extension TemperatureConditionExtension on TemperatureCondition {
  /// Calcule l'écart par rapport à l'optimal
  double get deviationFromOptimal => (current - optimal).abs();

  /// Détermine si la température est dans la plage de tolérance
  bool get isWithinTolerance => current >= min && current <= max;

  /// Score de condition (0.0 à 1.0)
  double get score {
    if (!isWithinTolerance) return 0.0;
    if (isOptimal) return 1.0;

    final deviation = deviationFromOptimal;
    final maxDeviation = ((max - min) / 2).abs();
    return (1.0 - (deviation / maxDeviation)).clamp(0.0, 1.0);
  }
}

extension MoistureConditionExtension on MoistureCondition {
  /// Calcule l'écart par rapport à l'optimal
  double get deviationFromOptimal => (current - optimal).abs();

  /// Détermine si l'humidité est dans la plage de tolérance
  bool get isWithinTolerance => current >= min && current <= max;

  /// Score de condition (0.0 à 1.0)
  double get score {
    if (!isWithinTolerance) return 0.0;
    if (isOptimal) return 1.0;

    final deviation = deviationFromOptimal;
    final maxDeviation = ((max - min) / 2).abs();
    return (1.0 - (deviation / maxDeviation)).clamp(0.0, 1.0);
  }
}

extension LightConditionExtension on LightCondition {
  /// Score de condition (0.0 à 1.0)
  double get score {
    final intensityScore = current >= min && current <= max
        ? (1.0 - ((current - optimal).abs() / optimal)).clamp(0.0, 1.0)
        : 0.0;
    final hoursScore = dailyHours >= (optimalHours * 0.5)
        ? (dailyHours / optimalHours).clamp(0.0, 1.0)
        : 0.0;

    return (intensityScore + hoursScore) / 2.0;
  }
}

extension SoilConditionExtension on SoilCondition {
  /// Score global du sol (0.0 à 1.0)
  double get score {
    final phScore = ph >= minPh && ph <= maxPh
        ? (1.0 - ((ph - optimalPh).abs() / ((maxPh - minPh) / 2)))
            .clamp(0.0, 1.0)
        : 0.0;
    final nutrientScore = nutrientLevel / 100.0;
    final drainageScore = drainageLevel / 100.0;
    final compactionScore = (100.0 - compactionLevel) / 100.0;

    return (phScore + nutrientScore + drainageScore + compactionScore) / 4.0;
  }

  /// Détermine si le sol nécessite des amendements
  bool get needsAmendments {
    return ph < minPh ||
        ph > maxPh ||
        nutrientLevel < 50 ||
        drainageLevel < 40 ||
        compactionLevel > 40;
  }
}

extension RiskFactorExtension on RiskFactor {
  /// Score de risque global (0.0 à 1.0)
  double get riskScore => severity * probability;

  /// Détermine si le risque est critique
  bool get isCritical => riskScore > 0.7;

  /// Détermine si le risque nécessite une action immédiate
  bool get requiresImmediateAction =>
      severity > 0.8 || (severity > 0.6 && probability > 0.8);
}

extension OpportunityExtension on Opportunity {
  /// Score d'opportunité global (0.0 à 1.0)
  double get opportunityScore => benefit * feasibility;

  /// Détermine si l'opportunité est prioritaire
  bool get isPriority => opportunityScore > 0.7;

  /// Détermine si l'opportunité est facile à saisir
  bool get isEasyWin => feasibility > 0.8 && benefit > 0.6;
}


