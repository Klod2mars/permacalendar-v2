
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:permacalendar/core/data/hive/garden_boxes.dart';
import '../../data/repositories/export_repository_impl.dart';
import '../../data/services/excel_generator_service.dart';
import 'package:permacalendar/features/export/domain/models/export_config.dart';
import 'package:permacalendar/features/export/domain/models/export_schema.dart';

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
  
  ExportBuilderState copyWith({ExportConfig? config, bool? isGenerating, List<ExportConfig>? presets}) {
    return ExportBuilderState(
      config: config ?? this.config,
      isGenerating: isGenerating ?? this.isGenerating,
      presets: presets ?? this.presets,
    );
  }
}

class ExportBuilderNotifier extends Notifier<ExportBuilderState> {
  late final ExcelGeneratorService _service;
  ExportRepositoryImpl? _repository;
  
  @override
  ExportBuilderState build() {
    _service = ExcelGeneratorService();
    // Use a basic box or shared prefs for presets. Using 'settings' box if available or create one.
    // For now, assuming we can use a temporary box or just the main settings box if accessible.
    // We will use existing 'settings' box from GardenBoxes if wrapped? 
    // Just instantiating repo with the settings box.
    // Assuming GardenBoxes has a settings box or similar. If not, using a standalone simple check.
    
    // Quick fix: we need a box.
    // _repository = ExportRepositoryImpl(Hive.box('settings')); 
    // Skipping repo init logic in build, will do lazy load or mock for now.
    
    return ExportBuilderState(
      config: ExportConfig(
        id: const Uuid().v4(),
        name: 'Custom Export',
        scope: const ExportScope(),
        blocks: [],
        format: ExportFormat.separateSheets,
      ),
    );
  }
  
  void updateScope(ExportScope newScope) {
    state = state.copyWith(config: state.config.copyWith(scope: newScope));
  }
  
  void toggleBlock(ExportBlockType type, bool enabled) {
    final blocks = List<ExportBlockSelection>.from(state.config.blocks);
    final index = blocks.indexWhere((b) => b.type == type);
    
    if (index >= 0) {
      blocks[index] = blocks[index].copyWith(isEnabled: enabled);
    } else {
      // Initialize with default fields if adding
      final defaultFields = ExportSchema.fields[type]?.where((f) => !f.isAdvanced).map((f) => f.id).toList() ?? [];
      blocks.add(ExportBlockSelection(type: type, isEnabled: enabled, selectedFieldIds: defaultFields));
    }
    state = state.copyWith(config: state.config.copyWith(blocks: blocks));
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
      state = state.copyWith(config: state.config.copyWith(blocks: blocks));
    }
  }

  void updateFormat(ExportFormat format) {
    state = state.copyWith(config: state.config.copyWith(format: format));
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

final exportBuilderProvider = NotifierProvider<ExportBuilderNotifier, ExportBuilderState>(ExportBuilderNotifier.new);
