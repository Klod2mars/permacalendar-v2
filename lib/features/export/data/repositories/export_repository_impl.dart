
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:permacalendar/features/export/domain/models/export_config.dart';
import 'package:permacalendar/features/export/domain/repositories/export_repository.dart';

class ExportRepositoryImpl implements ExportRepository {
  final Box _box; // Assume a generic settings box or specialized 'export_presets' box

  ExportRepositoryImpl(this._box);

  @override
  Future<List<ExportConfig>> getPresets() async {
     try {
       final rawList = _box.get('presets', defaultValue: []);
       if (rawList is List) {
         return rawList.map((e) => ExportConfig.fromJson(jsonDecode(e))).toList();
       }
       return [];
     } catch (e) {
       return [];
     }
  }

  @override
  Future<void> savePreset(ExportConfig config) async {
    final list = await getPresets();
    final index = list.indexWhere((c) => c.id == config.id);
    if (index >= 0) {
      list[index] = config;
    } else {
      list.add(config);
    }
    await _box.put('presets', list.map((c) => jsonEncode(c.toJson())).toList());
  }

  @override
  Future<void> deletePreset(String id) async {
    final list = await getPresets();
    list.removeWhere((c) => c.id == id);
    await _box.put('presets', list.map((c) => jsonEncode(c.toJson())).toList());
  }
}
