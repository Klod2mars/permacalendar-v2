import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/data/hive/garden_boxes.dart';
import '../../domain/models/harvest_record.dart';

class HarvestRepository {
  /// Accès direct à la box Hive via GardenBoxes
  Box _box() {
    return GardenBoxes.harvests;
  }

  /// Sauvegarder (ou écraser) un record
  Future<void> saveHarvest(HarvestRecord record) async {
    await _box().put(record.id, record.toJson());
    debugPrint('[HarvestRepository] saveHarvest id=${record.id} plant=${record.plantId} qty=${record.quantityKg} price=${record.pricePerKg}');
  }

  /// Récupérer tous les records
  List<HarvestRecord> getAllHarvests() {
    return _box().values.map((e) {
      // Hive stocke parfois des LinkedMap, on assure le cast en Map<String, dynamic>
      final map = Map<String, dynamic>.from(e as Map);
      return HarvestRecord.fromJson(map);
    }).toList();
  }

  /// Récupérer les records d'un jardin spécifique
  List<HarvestRecord> getHarvestsByGarden(String gardenId) {
    return getAllHarvests().where((r) => r.gardenId == gardenId).toList();
  }
  
  /// Récupérer les records d'une plante spécifique
  List<HarvestRecord> getHarvestsByPlant(String plantId) {
    return getAllHarvests().where((r) => r.plantId == plantId).toList();
  }

  /// Supprimer un record
  Future<void> deleteHarvest(String id) async {
    await _box().delete(id);
  }
}
