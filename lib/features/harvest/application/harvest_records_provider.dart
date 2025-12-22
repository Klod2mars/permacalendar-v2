import 'dart:async';
import '../../../core/data/hive/garden_boxes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/harvest_record.dart';
import '../data/repositories/harvest_repository.dart';

class HarvestRecordsState {
  final List<HarvestRecord> records;
  final bool isLoading;
  final String? error;

  const HarvestRecordsState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });
}

class HarvestRecordsNotifier extends Notifier<HarvestRecordsState> {
  StreamSubscription? _boxSubscription;

  @override
  HarvestRecordsState build() {
    // S'abonner aux events Hive (put/delete) pour forcer un reload immédiat.
    try {
      _boxSubscription = GardenBoxes.harvests.watch().listen((event) {
        debugPrint('[HarvestRecordsProvider] Hive box event: $event');
        // recharger la liste à chaque événement
        loadRecords();
      });
    } catch (e) {
      debugPrint('[HarvestRecordsProvider] Warning: unable to watch harvests box: $e');
    }

    // Charger les données initiales de manière synchrone (Hive est rapide)
    // pour éviter "modify provider during build" et éviter le flicker de loading.
    try {
      final repo = HarvestRepository();
      final records = repo.getAllHarvests();
      records.sort((a, b) => b.date.compareTo(a.date));
      return HarvestRecordsState(records: records, isLoading: false);
    } catch (e) {
      return HarvestRecordsState(records: [], isLoading: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    _boxSubscription?.cancel();
    // super.dispose() n'existe pas sur Notifier mais bon réflexe pour classes manuelles.
    // Ici Riverpod gère le cycle de vie, mais on nettoie la sub.
  }

  Future<void> loadRecords() async {
    try {
      final repo = HarvestRepository();
      final records = repo.getAllHarvests();
      records.sort((a, b) => b.date.compareTo(a.date));
      debugPrint('[HarvestRecordsProvider] loaded ${records.length} records');
      debugPrint('[HarvestRecordsProvider] details: ${records.map((r) => {'id': r.id, 'gardenId': r.gardenId, 'date': r.date.toIso8601String(), 'total': r.totalValue}).toList()}');
      state = HarvestRecordsState(records: records, isLoading: false);
    } catch (e) {
      state = HarvestRecordsState(records: [], isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadRecords();
  }
}

final harvestRecordsProvider = NotifierProvider<HarvestRecordsNotifier, HarvestRecordsState>(HarvestRecordsNotifier.new);
