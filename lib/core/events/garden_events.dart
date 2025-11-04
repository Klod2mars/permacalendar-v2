import 'package:freezed_annotation/freezed_annotation.dart';

part 'garden_events.freezed.dart';

/// Événement domain pour les actions dans le jardin
///
/// Utilisé par le GardenEventBus pour notifier l'Intelligence Végétale
/// des changements dans le jardin qui nécessitent une analyse.
///
/// **Architecture :**
/// - Pattern Event Sourcing pour découpler les features
/// - Événements immuables (Freezed)
/// - Communication asynchrone via EventBus
///
/// **Types d'événements :**
/// - PlantingAddedEvent : Nouvelle plantation ajoutée
/// - PlantingHarvestedEvent : Plantation récoltée
/// - WeatherChangedEvent : Changement météo significatif
/// - ActivityPerformedEvent : Activité utilisateur (arrosage, fertilisation, etc.)
@freezed
class GardenEvent with _$GardenEvent {
  /// Événement : Nouvelle plantation ajoutée
  ///
  /// Déclenche une analyse complète de l'Intelligence Végétale
  /// pour cette nouvelle plante.
  const factory GardenEvent.plantingAdded({
    required String gardenId,
    required String plantingId,
    required String plantId,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = PlantingAddedEvent;

  /// Événement : Plantation récoltée
  ///
  /// Enregistre les données de récolte et met à jour les statistiques.
  const factory GardenEvent.plantingHarvested({
    required String gardenId,
    required String plantingId,
    required double harvestYield,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = PlantingHarvestedEvent;

  /// Événement : Changement météorologique significatif
  ///
  /// Déclenche une réévaluation de toutes les plantes du jardin
  /// si le changement est supérieur à 5°C.
  const factory GardenEvent.weatherChanged({
    required String gardenId,
    required double previousTemperature,
    required double currentTemperature,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = WeatherChangedEvent;

  /// Événement : Activité utilisateur effectuée
  ///
  /// Certaines activités (arrosage, fertilisation) déclenchent
  /// une mise à jour de l'analyse pour la plante concernée.
  const factory GardenEvent.activityPerformed({
    required String gardenId,
    required String activityType, // watering, fertilizing, pruning, etc.
    String? targetId, // planting ou bed ID
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = ActivityPerformedEvent;

  /// Événement : Mise à jour du contexte jardin
  ///
  /// Déclenche une mise à jour du GardenContext dans l'Intelligence Végétale.
  const factory GardenEvent.gardenContextUpdated({
    required String gardenId,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) = GardenContextUpdatedEvent;
}
