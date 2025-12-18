import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/harvest_record.dart';

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
    // Return dummy data for now
    return HarvestRecordsState(records: _getDummyRecords());
  }
  
  List<HarvestRecord> _getDummyRecords() {
    // Generate some meaningful dummy data for economy testing
    final now = DateTime.now();
    return [
      HarvestRecord(id: '1', gardenId: 'garden1', plantId: 'tomate_1', plantName: 'Tomate', quantityKg: 10, pricePerKg: 3.5, date: now.subtract(const Duration(days: 2))),
      HarvestRecord(id: '2', gardenId: 'garden1', plantId: 'courgette_1', plantName: 'Courgette', quantityKg: 20, pricePerKg: 2.0, date: now.subtract(const Duration(days: 5))),
      HarvestRecord(id: '3', gardenId: 'garden1', plantId: 'basilic_1', plantName: 'Basilic', quantityKg: 1, pricePerKg: 40.0, date: now.subtract(const Duration(days: 10))),
      HarvestRecord(id: '4', gardenId: 'garden1', plantId: 'patate_1', plantName: 'Pomme de terre', quantityKg: 50, pricePerKg: 1.5, date: now.subtract(const Duration(days: 20))),
       HarvestRecord(id: '5', gardenId: 'garden1', plantId: 'tomate_1', plantName: 'Tomate', quantityKg: 15, pricePerKg: 3.5, date: now.subtract(const Duration(days: 40))),
    ];
  }
}

final harvestRecordsProvider = NotifierProvider<HarvestRecordsNotifier, HarvestRecordsState>(HarvestRecordsNotifier.new);
