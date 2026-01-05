import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import '../../data/repositories/export_repository_impl.dart';
import '../../data/services/excel_generator_service.dart';
import 'package:permacalendar/features/export/domain/models/export_config.dart';
import 'package:permacalendar/features/export/domain/models/export_schema.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';

/// State of the Export Builder
class ExportBuilderState {
  final ExportConfig config;
  final bool isGenerating;
  final List<ExportConfig> presets;

  ExportBuilderState({
    required this.config,
    this.isGenerating = false,
    this.presets = const [],
  });

  ExportBuilderState copyWith(
      {ExportConfig? config, bool? isGenerating, List<ExportConfig>? presets}) {
    return ExportBuilderState(
      config: config ?? this.config,
      isGenerating: isGenerating ?? this.isGenerating,
      presets: presets ?? this.presets,
    );
  }
}

class ExportBuilderNotifier extends Notifier<ExportBuilderState> {
  late final ExcelGeneratorService _service;
  // ExportRepositoryImpl? _repository;

  @override
  ExportBuilderState build() {
    _service = ExcelGeneratorService();
    
    // Try calculate initial config from persistence
    ExportConfig initialConfig = ExportConfig(
        id: const Uuid().v4(),
        name: 'Custom Export',
        scope: const ExportScope(),
        blocks: [],
        format: ExportFormat.separateSheets,
      );

    try {
      final box = GardenBoxes.exportPreferences;
      final savedMap = box.get('current_config');
      if (savedMap != null) {
        // Cast to Map<String, dynamic> safely
        final map = Map<String, dynamic>.from(savedMap as Map);
        initialConfig = ExportConfig.fromJson(map);
      }
    } catch (e) {
      print('Error loading export config: $e');
    }

    return ExportBuilderState(
      config: initialConfig,
    );
  }

  void _save(ExportConfig config) {
    try {
      final box = GardenBoxes.exportPreferences;
      box.put('current_config', config.toJson());
    } catch (e) {
      print('Error saving export config: $e');
    }
  }

  void updateScope(ExportScope newScope) {
    final newConfig = state.config.copyWith(scope: newScope);
    state = state.copyWith(config: newConfig);
    _save(newConfig);
  }

  void toggleBlock(ExportBlockType type, bool enabled) {
    final blocks = List<ExportBlockSelection>.from(state.config.blocks);
    final index = blocks.indexWhere((b) => b.type == type);

    if (index >= 0) {
      blocks[index] = blocks[index].copyWith(isEnabled: enabled);
    } else {
      // Initialize with default fields if adding
      final defaultFields = ExportSchema.fields[type]
              ?.where((f) => !f.isAdvanced)
              .map((f) => f.id)
              .toList() ??
          [];
      blocks.add(ExportBlockSelection(
          type: type, isEnabled: enabled, selectedFieldIds: defaultFields));
    }
    final newConfig = state.config.copyWith(blocks: blocks);
    state = state.copyWith(config: newConfig);
    _save(newConfig);
  }

  void toggleField(ExportBlockType type, String fieldId) {
    final blocks = List<ExportBlockSelection>.from(state.config.blocks);
    final index = blocks.indexWhere((b) => b.type == type);
    if (index >= 0) {
      final currentIds = List<String>.from(blocks[index].selectedFieldIds);
      if (currentIds.contains(fieldId)) {
        currentIds.remove(fieldId);
      } else {
        currentIds.add(fieldId);
      }
      blocks[index] = blocks[index].copyWith(selectedFieldIds: currentIds);
      final newConfig = state.config.copyWith(blocks: blocks);
      state = state.copyWith(config: newConfig);
      _save(newConfig);
    }
  }

  void updateFormat(ExportFormat format) {
    final newConfig = state.config.copyWith(format: format);
    state = state.copyWith(config: newConfig);
    _save(newConfig);
  }

  Future<List<int>> generate() async {
    state = state.copyWith(isGenerating: true);
    try {
      final bytes = await _service.generateExportInMainIsolate(state.config);
      state = state.copyWith(isGenerating: false);
      return bytes;
    } catch (e) {
      state = state.copyWith(isGenerating: false);
      rethrow;
    }
  }
}

final exportBuilderProvider =
    NotifierProvider<ExportBuilderNotifier, ExportBuilderState>(
        ExportBuilderNotifier.new);
