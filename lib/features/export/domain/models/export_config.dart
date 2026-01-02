import 'package:flutter/material.dart';

/// Define the available data blocks for export
enum ExportBlockType {
  garden,
  gardenBed,
  plant,
  activity,
  harvest,
}

/// Define the export format
enum ExportFormat {
  separateSheets,
  flatTable,
}

/// Configuration for a specific field in the export
class ExportField {
  final String id;
  final String label;
  final String description; // For META dictionary
  final bool isAdvanced;
  final bool isContext; // e.g. gardenId, bedName

  const ExportField({
    required this.id,
    required this.label,
    required this.description,
    this.isAdvanced = false,
    this.isContext = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'description': description,
        'isAdvanced': isAdvanced,
        'isContext': isContext,
      };

  factory ExportField.fromJson(Map<String, dynamic> json) => ExportField(
        id: json['id'] as String,
        label: json['label'] as String,
        description: json['description'] as String,
        isAdvanced: json['isAdvanced'] as bool? ?? false,
        isContext: json['isContext'] as bool? ?? false,
      );
}

/// Selection state for a block
class ExportBlockSelection {
  final ExportBlockType type;
  final List<String> selectedFieldIds;
  final bool isEnabled;

  const ExportBlockSelection({
    required this.type,
    this.selectedFieldIds = const [],
    this.isEnabled = false,
  });

  ExportBlockSelection copyWith({
    List<String>? selectedFieldIds,
    bool? isEnabled,
  }) {
    return ExportBlockSelection(
      type: type,
      selectedFieldIds: selectedFieldIds ?? this.selectedFieldIds,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'selectedFieldIds': selectedFieldIds,
        'isEnabled': isEnabled,
      };

  factory ExportBlockSelection.fromJson(Map<String, dynamic> json) =>
      ExportBlockSelection(
        type: ExportBlockType.values.firstWhere((e) => e.name == json['type']),
        selectedFieldIds: List<String>.from(json['selectedFieldIds'] ?? []),
        isEnabled: json['isEnabled'] as bool? ?? false,
      );
}

/// Scope configuration (Filters)
class ExportScope {
  final DateTimeRange? dateRange;
  final List<String> gardenIds;
  final List<String> gardenBedIds; // Norm: GardenBed

  const ExportScope({
    this.dateRange,
    this.gardenIds = const [],
    this.gardenBedIds = const [],
  });

  ExportScope copyWith({
    DateTimeRange? dateRange,
    List<String>? gardenIds,
    List<String>? gardenBedIds,
  }) {
    return ExportScope(
      dateRange: dateRange ?? this.dateRange,
      gardenIds: gardenIds ?? this.gardenIds,
      gardenBedIds: gardenBedIds ?? this.gardenBedIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'start': dateRange?.start.toIso8601String(),
        'end': dateRange?.end.toIso8601String(),
        'gardenIds': gardenIds,
        'gardenBedIds': gardenBedIds,
      };

  factory ExportScope.fromJson(Map<String, dynamic> json) {
    DateTimeRange? range;
    if (json['start'] != null && json['end'] != null) {
      range = DateTimeRange(
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
      );
    }
    return ExportScope(
      dateRange: range,
      gardenIds: List<String>.from(json['gardenIds'] ?? []),
      gardenBedIds: List<String>.from(json['gardenBedIds'] ?? []),
    );
  }
}

/// Root Configuration Object
class ExportConfig {
  final String id;
  final String name; // Name of the preset or "Custom"
  final ExportScope scope;
  final List<ExportBlockSelection> blocks;
  final ExportFormat format;
  final bool includeContextIds;
  final bool includeContextNames;

  const ExportConfig({
    required this.id,
    required this.name,
    required this.scope,
    required this.blocks,
    required this.format,
    this.includeContextIds = true,
    this.includeContextNames = true,
  });

  ExportConfig copyWith({
    String? id,
    String? name,
    ExportScope? scope,
    List<ExportBlockSelection>? blocks,
    ExportFormat? format,
    bool? includeContextIds,
    bool? includeContextNames,
  }) {
    return ExportConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      blocks: blocks ?? this.blocks,
      format: format ?? this.format,
      includeContextIds: includeContextIds ?? this.includeContextIds,
      includeContextNames: includeContextNames ?? this.includeContextNames,
    );
  }

  // Helpers
  bool isBlockEnabled(ExportBlockType type) {
    return blocks
        .firstWhere((b) => b.type == type,
            orElse: () => ExportBlockSelection(type: type))
        .isEnabled;
  }

  List<String> getSelectedFieldsFor(ExportBlockType type) {
    return blocks
        .firstWhere((b) => b.type == type,
            orElse: () => ExportBlockSelection(type: type))
        .selectedFieldIds;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'scope': scope.toJson(),
        'blocks': blocks.map((b) => b.toJson()).toList(),
        'format': format.name,
        'includeContextIds': includeContextIds,
        'includeContextNames': includeContextNames,
      };

  factory ExportConfig.fromJson(Map<String, dynamic> json) => ExportConfig(
        id: json['id'],
        name: json['name'],
        scope: ExportScope.fromJson(json['scope']),
        blocks: (json['blocks'] as List)
            .map((b) => ExportBlockSelection.fromJson(b))
            .toList(),
        format: ExportFormat.values.firstWhere((e) => e.name == json['format']),
        includeContextIds: json['includeContextIds'] as bool? ?? true,
        includeContextNames: json['includeContextNames'] as bool? ?? true,
      );
}
