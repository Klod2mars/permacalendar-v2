import 'dart:convert';
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
  final String? persistenceStatus; // DEBUG: To show status/errors in UI

  ExportBuilderState({
    required this.config,
    this.isGenerating = false,
    this.presets = const [],
    this.persistenceStatus,
  });

  ExportBuilderState copyWith(
      {ExportConfig? config,
      bool? isGenerating,
      List<ExportConfig>? presets,
      String? persistenceStatus}) {
    return ExportBuilderState(
      config: config ?? this.config,
      isGenerating: isGenerating ?? this.isGenerating,
      presets: presets ?? this.presets,
      persistenceStatus: persistenceStatus ?? this.persistenceStatus,
    );
  }
}

class ExportBuilderNotifier extends Notifier<ExportBuilderState> {
  late final ExcelGeneratorService _service;
  // ExportRepositoryImpl? _repository;

  // Helper to sanitize Hive data (LinkedMap<dynamic, dynamic> -> Map<String, dynamic>)
  Map<String, dynamic> _sanitizeHiveMap(dynamic map) {
    // Determine the most robust way: round-trip through JSON
    // This handles nested maps (e.g. inside blocks) which are also dynamic
    return json.decode(json.encode(map)) as Map<String, dynamic>;
  }

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
        // Robust sanitization
        final map = _sanitizeHiveMap(savedMap); 
        initialConfig = ExportConfig.fromJson(map);
      }
    } catch (e, stack) {
      print('Error loading export config: $e');
      print(stack);
    }

    return ExportBuilderState(
      config: initialConfig,
    );
  }

  Future<void> _save(ExportConfig config) async {
    try {
      final box = GardenBoxes.exportPreferences;
      // Convert to pure JSON-compatible map to avoid any custom object issues
      final data = json.decode(json.encode(config.toJson()));
      await box.put('current_config', data);
    } catch (e) {
      print('Error saving export config: $e');
    }
  }

  Future<void> updateScope(ExportScope newScope) async {
    final newConfig = state.config.copyWith(scope: newScope);
    state = state.copyWith(config: newConfig);
    await _save(newConfig);
  }

  Future<void> toggleBlock(ExportBlockType type, bool enabled) async {
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
    await _save(newConfig);
  }

  Future<void> toggleField(ExportBlockType type, String fieldId) async {
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
      await _save(newConfig);
    }
  }

  Future<void> updateFormat(ExportFormat format) async {
    final newConfig = state.config.copyWith(format: format);
    state = state.copyWith(config: newConfig);
    await _save(newConfig);
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
