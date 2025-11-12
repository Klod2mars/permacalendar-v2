import 'package:hive_flutter/hive_flutter.dart';
import '../models/germination_event.dart';

/// Service pour gérer les événements de germination
class GerminationService {
  static const String _boxName = 'germination_events';
  Box<GerminationEvent>? _box;

  /// Initialise le service et ouvre la box Hive
  Future<void> init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<GerminationEvent>(_boxName);
    }
  }

  /// Ajoute un événement de germination
  Future<void> addGerminationEvent(GerminationEvent event) async {
    await init();
    await _box!.put(event.id, event);
  }

  /// Récupère un événement de germination par ID
  Future<GerminationEvent?> getGerminationEvent(String id) async {
    await init();
    return _box!.get(id);
  }

  /// Récupère tous les événements de germination
  Future<List<GerminationEvent>> getAllGerminationEvents() async {
    await init();
    return _box!.values.toList();
  }

  /// Récupère les événements de germination pour une plantation spécifique
  Future<List<GerminationEvent>> getGerminationEventsForPlanting(
    String plantingId,
  ) async {
    await init();
    return _box!.values
        .where((event) => event.plantingId == plantingId)
        .toList();
  }

  /// Vérifie si une plantation a un événement de germination
  Future<bool> hasGerminationEvent(String plantingId) async {
    await init();
    return _box!.values.any((event) => event.plantingId == plantingId);
  }

  /// Récupère le premier événement de germination pour une plantation
  Future<GerminationEvent?> getGerminationEventForPlanting(
    String plantingId,
  ) async {
    await init();
    final events =
        _box!.values.where((event) => event.plantingId == plantingId).toList();
    return events.isNotEmpty ? events.first : null;
  }

  /// Supprime un événement de germination
  Future<void> deleteGerminationEvent(String id) async {
    await init();
    await _box!.delete(id);
  }

  /// Met à jour un événement de germination
  Future<void> updateGerminationEvent(GerminationEvent event) async {
    await init();
    await _box!.put(event.id, event);
  }

  /// Supprime tous les événements de germination pour une plantation
  Future<void> deleteGerminationEventsForPlanting(String plantingId) async {
    await init();
    final events =
        _box!.values.where((event) => event.plantingId == plantingId).toList();

    for (final event in events) {
      await _box!.delete(event.id);
    }
  }

  /// Ferme la box Hive
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}

