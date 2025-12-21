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
  @override
  HarvestRecordsState build() {
    loadRecords();
    return const HarvestRecordsState(isLoading: true);
  }

  Future<void> loadRecords() async {
    try {
      final repo = HarvestRepository();
      final records = repo.getAllHarvests();
      records.sort((a, b) => b.date.compareTo(a.date));
      debugPrint('[HarvestRecordsProvider] loaded ${records.length} records');
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
