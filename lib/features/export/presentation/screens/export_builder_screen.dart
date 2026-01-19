import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permacalendar/features/export/domain/models/export_config.dart';
import 'package:permacalendar/features/export/domain/models/export_schema.dart';
import 'package:permacalendar/features/export/presentation/providers/export_builder_provider.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import 'package:permacalendar/core/models/garden_freezed.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

class ExportBuilderScreen extends ConsumerStatefulWidget {
  const ExportBuilderScreen({super.key});

  @override
  ConsumerState<ExportBuilderScreen> createState() =>
      _ExportBuilderScreenState();
}

class _ExportBuilderScreenState extends ConsumerState<ExportBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exportBuilderProvider);
    final notifier = ref.read(exportBuilderProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.export_builder_title),
        actions: [
          if (state.isGenerating)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(l10n.export_scope_section),
                  _buildScopeSection(state, notifier, l10n),
                  const SizedBox(height: 24),
                  _buildSectionHeader(l10n.export_blocks_section),
                  _buildBlocksSection(state, notifier, l10n),
                  const SizedBox(height: 24),
                  if (state.config.blocks.any((b) => b.isEnabled)) ...[
                    _buildSectionHeader(l10n.export_columns_section),
                    _buildColumnsSection(state, notifier, l10n),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionHeader(l10n.export_format_section),
                  _buildFormatSection(state, notifier, l10n),
                  const SizedBox(height: 80), // Space for FAB/Bottom button
                ],
              ),
            ),
            ),
          _buildBottomBar(state, notifier, l10n),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildScopeSection(
      ExportBuilderState state, ExportBuilderNotifier notifier, AppLocalizations l10n) {
    final gardens = ref.watch(activeGardensProvider);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.date_range),
            title: Text(l10n.export_scope_period),
            subtitle: Text(state.config.scope.dateRange == null
                ? l10n.export_scope_period_all
                : "${DateFormat('dd/MM/yyyy').format(state.config.scope.dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(state.config.scope.dateRange!.end)}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030));
              if (picked != null) {
                notifier.updateScope(
                    state.config.scope.copyWith(dateRange: picked));
              }
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.park_outlined),
            title: Text(l10n.export_filter_garden_title),
            subtitle: Text(state.config.scope.gardenIds.isEmpty
                ? l10n.export_filter_garden_all
                : l10n.export_filter_garden_count(
                    state.config.scope.gardenIds.length)),
            value: state.config.scope.gardenIds.isNotEmpty,
            onChanged: (val) {
              if (!val) {
                notifier
                    .updateScope(state.config.scope.copyWith(gardenIds: []));
              } else {
                _showGardenSelector(
                    context, gardens, state.config.scope.gardenIds, notifier, l10n, state.config.scope);
              }
            },
          ),
          // Link to open selector if filter is active
          if (state.config.scope.gardenIds.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 72, bottom: 12), // Align with title
              child: TextButton.icon(
                onPressed: () => _showGardenSelector(
                    context, gardens, state.config.scope.gardenIds, notifier, l10n, state.config.scope),
                icon: const Icon(Icons.edit, size: 16),
                label: Text(l10n.export_filter_garden_edit),
                style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero),
              ),
            )
        ],
      ),
    );
  }

  void _showGardenSelector(BuildContext context, List<GardenFreezed> gardens,
      List<String> currentSelection, ExportBuilderNotifier notifier, AppLocalizations l10n, ExportScope currentScope) {
    showDialog(
      context: context,
      builder: (ctx) {
        // StatefulBuilder to handle local checkbox updates
        List<String> tempSelection = List.from(currentSelection);
        // If empty init with all? No, empty means 'All' in logic, but if opening selector we want to select specific.
        // If coming from "Off" state, maybe preselect all? Use passed currentSelection.
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.export_filter_garden_select_dialog_title),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: gardens.length,
                  itemBuilder: (context, index) {
                    final garden = gardens[index];
                    final isSelected = tempSelection.contains(garden.id);
                    return CheckboxListTile(
                      title: Text(garden.name),
                      subtitle: Text(garden.location.isEmpty ? 'Sans lieu' : garden.location),
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            tempSelection.add(garden.id);
                          } else {
                            tempSelection.remove(garden.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.common_cancel),
                ),
                TextButton(
                  onPressed: () {
                    // Update global state
                    notifier.updateScope(currentScope.copyWith(gardenIds: tempSelection));
                    Navigator.pop(context);
                  },
                  child: Text(l10n.common_validate),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Widget _buildBlocksSection(
      ExportBuilderState state, ExportBuilderNotifier notifier, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: ExportSchema.blockLabels.entries
            .where((e) =>
                e.key == ExportBlockType.activity ||
                e.key == ExportBlockType.harvest)
            .map((entry) {
          final type = entry.key;
          // label is unused
          final isEnabled = state.config.isBlockEnabled(type);
          final isLast = entry.key == ExportSchema.blockLabels.keys.last;

          return Column(
            children: [
              CheckboxListTile(
                title: Text(_getBlockLabel(type, l10n),
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(_getBlockDescription(type, l10n),
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                value: isEnabled,
                onChanged: (val) => notifier.toggleBlock(type, val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColumnsSection(
      ExportBuilderState state, ExportBuilderNotifier notifier, AppLocalizations l10n) {
    final enabledBlocks = state.config.blocks.where((b) => b.isEnabled);
    
    return Column(
      children: enabledBlocks.map((block) {
        final schemaFields = ExportSchema.getFieldsFor(block.type);
        final label = _getBlockLabel(block.type, l10n);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: ExpansionTile(
              title: Text(label),
              subtitle: Text(
                  l10n.export_columns_count(block.selectedFieldIds.length)),
              children: schemaFields.map((field) {
                final isSelected = block.selectedFieldIds.contains(field.id);
                return CheckboxListTile(
                  dense: true,
                  title: Text(_getFieldLabel(field.id, l10n) +
                      (field.isAdvanced ? l10n.export_field_advanced_suffix : "")),
                  subtitle: Text(_getFieldDescription(field.id, l10n)),
                  value: isSelected,
                  onChanged: (val) =>
                      notifier.toggleField(block.type, field.id),
                  secondary: field.isAdvanced
                      ? const Icon(Icons.build_circle_outlined, size: 16)
                      : null,
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormatSection(
      ExportBuilderState state, ExportBuilderNotifier notifier, AppLocalizations l10n) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          RadioListTile<ExportFormat>(
            title: Text(l10n.export_format_separate),
            subtitle: Text(l10n.export_format_separate_subtitle),
            value: ExportFormat.separateSheets,
            groupValue: state.config.format,
            onChanged: (val) => notifier.updateFormat(val!),
          ),
          const Divider(height: 1),
          RadioListTile<ExportFormat>(
            title: Text(l10n.export_format_flat),
            subtitle: Text(
                l10n.export_format_flat_subtitle),
            value: ExportFormat.flatTable,
            groupValue: state.config.format,
            onChanged: (val) => notifier.updateFormat(val!),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar(ExportBuilderState state, ExportBuilderNotifier notifier,
      AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: state.isGenerating
                    ? null
                    : () => _generateExport(notifier, context, l10n),
                icon: const Icon(Icons.download),
                label: state.isGenerating
                    ? Text(l10n.export_generating,
                        style: const TextStyle(fontSize: 16))
                    : Text(l10n.export_action_generate,
                        style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateExport(ExportBuilderNotifier notifier,
      BuildContext context, AppLocalizations l10n) async {
    try {
      final bytes = await notifier.generate(l10n);

      // Custom Filename: Sowing 13 janvier 2026 – 09h22
      // Ensure 'fr_FR' is used for the date format as requested.
      // We assume intl is initialized. If 'fr_FR' data is not loaded, it might fallback or error.
      // Usually, standard flutter apps initialize locale data.
      final now = DateTime.now();
      final formatter = DateFormat('d MMMM yyyy – HH\'h\'mm', 'fr_FR');
      final dateStr = formatter.format(now);
      final filename = 'Sowing $dateStr.xlsx';

      // Save file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(bytes);

      // Share
      await Share.shareXFiles(
          [
            XFile(file.path,
                mimeType:
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
          ],
          text: '${l10n.export_success_share_text} ($filename)');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.export_error_snack(e))));
      }
    }
  }

  String _getBlockLabel(ExportBlockType type, AppLocalizations l10n) {
    switch (type) {
      case ExportBlockType.activity:
        return l10n.export_block_activity;
      case ExportBlockType.harvest:
        return l10n.export_block_harvest;
      case ExportBlockType.garden:
        return l10n.export_block_garden;
      case ExportBlockType.gardenBed:
        return l10n.export_block_garden_bed;
      case ExportBlockType.plant:
        return l10n.export_block_plant;
    }
  }

  String _getBlockDescription(ExportBlockType type, AppLocalizations l10n) {
    switch (type) {
      case ExportBlockType.activity:
        return l10n.export_block_desc_activity;
      case ExportBlockType.harvest:
        return l10n.export_block_desc_harvest;
      case ExportBlockType.garden:
        return l10n.export_block_desc_garden;
      case ExportBlockType.gardenBed:
        return l10n.export_block_desc_garden_bed;
      case ExportBlockType.plant:
        return l10n.export_block_desc_plant;
    }
  }

  String _getFieldLabel(String fieldId, AppLocalizations l10n) {
    switch (fieldId) {
      case 'garden_name':
        return l10n.export_field_garden_name;
      case 'garden_id':
        return l10n.export_field_garden_id;
      case 'garden_surface':
        return l10n.export_field_garden_surface;
      case 'garden_creation_date':
        return l10n.export_field_garden_creation;

      case 'bed_name':
        return l10n.export_field_bed_name;
      case 'bed_id':
        return l10n.export_field_bed_id;
      case 'bed_surface':
        return l10n.export_field_bed_surface;
      case 'bed_plant_count':
        return l10n.export_field_bed_plant_count;

      case 'plant_name':
        return l10n.export_field_plant_name;
      case 'plant_id':
        return l10n.export_field_plant_id;
      case 'plant_scientific':
        return l10n.export_field_plant_scientific;
      case 'plant_family':
        return l10n.export_field_plant_family;
      case 'plant_variety':
        return l10n.export_field_plant_variety;

      case 'harvest_date':
        return l10n.export_field_harvest_date;
      case 'harvest_qty':
        return l10n.export_field_harvest_qty;
      case 'harvest_plant_name':
        return l10n.export_field_harvest_plant_name;
      case 'harvest_price':
        return l10n.export_field_harvest_price;
      case 'harvest_value':
        return l10n.export_field_harvest_value;
      case 'harvest_notes':
        return l10n.export_field_harvest_notes;
      case 'harvest_garden_name':
        return l10n.export_field_harvest_garden_name;
      case 'harvest_garden_id':
        return l10n.export_field_harvest_garden_id;
      case 'harvest_bed_name':
        return l10n.export_field_harvest_bed_name;
      case 'harvest_bed_id':
        return l10n.export_field_harvest_bed_id;

      case 'activity_date':
        return l10n.export_field_activity_date;
      case 'activity_type':
        return l10n.export_field_activity_type;
      case 'activity_title':
        return l10n.export_field_activity_title;
      case 'activity_desc':
        return l10n.export_field_activity_desc;
      case 'activity_entity':
        return l10n.export_field_activity_entity;
      case 'activity_entity_id':
        return l10n.export_field_activity_entity_id;

      default:
        return fieldId;
    }
  }

  String _getFieldDescription(String fieldId, AppLocalizations l10n) {
    switch (fieldId) {
      case 'garden_name':
        return l10n.export_field_desc_garden_name;
      case 'garden_id':
        return l10n.export_field_desc_garden_id;
      case 'garden_surface':
        return l10n.export_field_desc_garden_surface;
      case 'garden_creation_date':
        return l10n.export_field_desc_garden_creation;

      case 'bed_name':
        return l10n.export_field_desc_bed_name;
      case 'bed_id':
        return l10n.export_field_desc_bed_id;
      case 'bed_surface':
        return l10n.export_field_desc_bed_surface;
      case 'bed_plant_count':
        return l10n.export_field_desc_bed_plant_count;

      case 'plant_name':
        return l10n.export_field_desc_plant_name;
      case 'plant_id':
        return l10n.export_field_desc_plant_id;
      case 'plant_scientific':
        return l10n.export_field_desc_plant_scientific;
      case 'plant_family':
        return l10n.export_field_desc_plant_family;
      case 'plant_variety':
        return l10n.export_field_desc_plant_variety;

      case 'harvest_date':
        return l10n.export_field_desc_harvest_date;
      case 'harvest_qty':
        return l10n.export_field_desc_harvest_qty;
      case 'harvest_plant_name':
        return l10n.export_field_desc_harvest_plant_name;
      case 'harvest_price':
        return l10n.export_field_desc_harvest_price;
      case 'harvest_value':
        return l10n.export_field_desc_harvest_value;
      case 'harvest_notes':
        return l10n.export_field_desc_harvest_notes;
      case 'harvest_garden_name':
        return l10n.export_field_desc_harvest_garden_name;
      case 'harvest_garden_id':
        return l10n.export_field_desc_harvest_garden_id;
      case 'harvest_bed_name':
        return l10n.export_field_desc_harvest_bed_name;
      case 'harvest_bed_id':
        return l10n.export_field_desc_harvest_bed_id;

      case 'activity_date':
        return l10n.export_field_desc_activity_date;
      case 'activity_type':
        return l10n.export_field_desc_activity_type;
      case 'activity_title':
        return l10n.export_field_desc_activity_title;
      case 'activity_desc':
        return l10n.export_field_desc_activity_desc;
      case 'activity_entity':
        return l10n.export_field_desc_activity_entity;
      case 'activity_entity_id':
        return l10n.export_field_desc_activity_entity_id;

      default:
        return '';
    }
  }
}

