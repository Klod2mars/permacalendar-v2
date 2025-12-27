
import 'package:permacalendar/features/export/domain/models/export_config.dart';

abstract class ExportRepository {
  Future<List<ExportConfig>> getPresets();
  Future<void> savePreset(ExportConfig config);
  Future<void> deletePreset(String id);
}
