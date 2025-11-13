ï»¿import 'dart:async';
import 'dart:developer' as developer;
import 'package:riverpod/riverpod.dart';
import 'activity_tracker_v3.dart';
import '../models/activity_v3.dart';

/// Service observateur qui capture automatiquement les événements du domaine
/// sans modifier les modèles existants (jardins, parcelles, plantations)
class ActivityObserverService {
  static final ActivityObserverService _instance =
      ActivityObserverService._internal();
  factory ActivityObserverService() => _instance;
  ActivityObserverService._internal();

  final ActivityTrackerV3 _tracker = ActivityTrackerV3();
  bool _isInitialized = false;

  /// Initialise le service observateur
  Future<void> initialize() async {
    if (_isInitialized) {
      print('ActivityObserverService déjà initialisé');
      return;
    }

    try {
      print('ActivityObserverService: Initialisation du tracker...');
      await _tracker.initialize();
      _isInitialized = true;
      print('âœ… ActivityObserverService initialisé avec succès');
      developer.log('ActivityObserverService initialisé avec succès.',
          name: 'ActivityObserver');
    } catch (e) {
      print('âŒ Erreur initialisation ActivityObserverService: $e');
      developer.log('Erreur initialisation ActivityObserverService: $e',
          name: 'ActivityObserver');
    }
  }

  /// Capture un événement de Création de jardin
  Future<void> captureGardenCreated({
    required String gardenId,
    required String gardenName,
    String? location,
    double? area,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'gardenCreated',
      description: 'Jardin "$gardenName" Créé',
      metadata: {
        'gardenId': gardenId,
        'gardenName': gardenName,
        if (location != null) 'location': location,
        if (area != null) 'area': area,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement de mise à jour de jardin
  Future<void> captureGardenUpdated({
    required String gardenId,
    required String gardenName,
    String? location,
    double? area,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'gardenUpdated',
      description: 'Jardin "$gardenName" modifié',
      metadata: {
        'gardenId': gardenId,
        'gardenName': gardenName,
        if (location != null) 'location': location,
        if (area != null) 'area': area,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement de suppression de jardin
  Future<void> captureGardenDeleted({
    required String gardenId,
    required String gardenName,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'gardenDeleted',
      description: 'Jardin "$gardenName" supprimé',
      metadata: {
        'gardenId': gardenId,
        'gardenName': gardenName,
      },
      priority: ActivityPriority.important,
    );
  }

  /// Capture un événement de Création de parcelle
  Future<void> captureGardenBedCreated({
    required String gardenBedId,
    required String gardenBedName,
    required String gardenId,
    String? gardenName,
    double? area,
    String? soilType,
    String? exposure,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'gardenBedCreated',
      description: 'Parcelle "$gardenBedName" Créée',
      metadata: {
        'gardenBedId': gardenBedId,
        'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
        if (area != null) 'area': area,
        if (soilType != null) 'soilType': soilType,
        if (exposure != null) 'exposure': exposure,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement de mise à jour de parcelle
  Future<void> captureGardenBedUpdated({
    required String gardenBedId,
    required String gardenBedName,
    required String gardenId,
    String? gardenName,
    double? area,
    String? soilType,
    String? exposure,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'gardenBedUpdated',
      description: 'Parcelle "$gardenBedName" modifiée',
      metadata: {
        'gardenBedId': gardenBedId,
        'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
        if (area != null) 'area': area,
        if (soilType != null) 'soilType': soilType,
        if (exposure != null) 'exposure': exposure,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement de suppression de parcelle
  Future<void> captureGardenBedDeleted({
    required String gardenBedId,
    required String gardenBedName,
    required String gardenId,
    String? gardenName,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'gardenBedDeleted',
      description: 'Parcelle "$gardenBedName" supprimée',
      metadata: {
        'gardenBedId': gardenBedId,
        'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
      },
      priority: ActivityPriority.important,
    );
  }

  /// Capture un événement de Création de plantation
  Future<void> capturePlantingCreated({
    required String plantingId,
    required String plantName,
    required String gardenBedId,
    String? gardenBedName,
    required String gardenId,
    String? gardenName,
    DateTime? plantingDate,
    int? quantity,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'plantingCreated',
      description: 'Plantation de "$plantName" ajoutée',
      metadata: {
        'plantingId': plantingId,
        'plantName': plantName,
        'gardenBedId': gardenBedId,
        if (gardenBedName != null) 'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
        if (plantingDate != null)
          'plantingDate': plantingDate.toIso8601String(),
        if (quantity != null) 'quantity': quantity,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement de mise à jour de plantation
  Future<void> capturePlantingUpdated({
    required String plantingId,
    required String plantName,
    required String gardenBedId,
    String? gardenBedName,
    required String gardenId,
    String? gardenName,
    String? status,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'plantingUpdated',
      description: 'Plantation de "$plantName" modifiée',
      metadata: {
        'plantingId': plantingId,
        'plantName': plantName,
        'gardenBedId': gardenBedId,
        if (gardenBedName != null) 'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
        if (status != null) 'status': status,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement de récolte
  Future<void> captureHarvestCompleted({
    required String plantingId,
    required String plantName,
    required String gardenBedId,
    String? gardenBedName,
    required String gardenId,
    String? gardenName,
    double? quantity,
    String? unit,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'harvestCompleted',
      description: 'Récolte de "$plantName" terminée',
      metadata: {
        'plantingId': plantingId,
        'plantName': plantName,
        'gardenBedId': gardenBedId,
        if (gardenBedName != null) 'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
        if (quantity != null) 'quantity': quantity,
        if (unit != null) 'unit': unit,
      },
      priority: ActivityPriority.important,
    );
  }

  /// Capture un événement de maintenance
  Future<void> captureMaintenanceCompleted({
    required String gardenBedId,
    String? gardenBedName,
    required String gardenId,
    String? gardenName,
    required String maintenanceType,
    String? description,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'maintenanceCompleted',
      description: 'Maintenance "$maintenanceType" effectuée',
      metadata: {
        'gardenBedId': gardenBedId,
        if (gardenBedName != null) 'gardenBedName': gardenBedName,
        'gardenId': gardenId,
        if (gardenName != null) 'gardenName': gardenName,
        'maintenanceType': maintenanceType,
        if (description != null) 'description': description,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement météo
  Future<void> captureWeatherUpdate({
    required String location,
    required String weatherType,
    double? temperature,
    String? description,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'weatherUpdate',
      description: 'mise à jour météo pour $location',
      metadata: {
        'location': location,
        'weatherType': weatherType,
        if (temperature != null) 'temperature': temperature,
        if (description != null) 'description': description,
      },
      priority: ActivityPriority.normal,
    );
  }

  /// Capture un événement d'erreur
  Future<void> captureError({
    required String errorType,
    required String description,
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!_isInitialized) return;

    await _tracker.trackActivity(
      type: 'error',
      description: 'Erreur: $description',
      metadata: {
        'errorType': errorType,
        'description': description,
        if (context != null) 'context': context,
        ...?additionalData,
      },
      priority: ActivityPriority.critical,
    );
  }

  /// Ferme le service
  Future<void> close() async {
    if (_isInitialized) {
      await _tracker.close();
      _isInitialized = false;
      developer.log('ActivityObserverService fermé.', name: 'ActivityObserver');
    }
  }
}

/// Provider pour le service observateur
final activityObserverServiceProvider =
    Provider<ActivityObserverService>((ref) {
  final service = ActivityObserverService();
  ref.onDispose(() => service.close());
  return service;
});


