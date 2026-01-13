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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Builder'),
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
                  _buildSectionHeader("1. Périmètre (Scope)"),
                  _buildScopeSection(state, notifier),
                  const SizedBox(height: 24),
                  _buildSectionHeader("2. Données (Blocs)"),
                  _buildBlocksSection(state, notifier),
                  const SizedBox(height: 24),
                  if (state.config.blocks.any((b) => b.isEnabled)) ...[
                    _buildSectionHeader("3. Colonnes & Détails"),
                    _buildColumnsSection(state, notifier),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionHeader("4. Format"),
                  _buildFormatSection(state, notifier),
                  const SizedBox(height: 80), // Space for FAB/Bottom button
                ],
              ),
            ),
          ),
          _buildBottomBar(state, notifier),
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
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    final gardens = ref.watch(activeGardensProvider);

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text("Période"),
            subtitle: Text(state.config.scope.dateRange == null
                ? "Tout l'historique"
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
            title: const Text("Filtrer par Jardin"),
            subtitle: Text(state.config.scope.gardenIds.isEmpty
                ? "Tous les jardins"
                : "${state.config.scope.gardenIds.length} jardin(s) sélectionné(s)"),
            value: state.config.scope.gardenIds.isNotEmpty,
            onChanged: (val) {
              if (!val) {
                notifier
                    .updateScope(state.config.scope.copyWith(gardenIds: []));
              } else {
                _showGardenSelector(context, gardens, state.config.scope.gardenIds, notifier);
              }
            },
          ),
          // Link to open selector if filter is active
          if (state.config.scope.gardenIds.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 72, bottom: 12), // Align with title
              child: TextButton.icon(
                onPressed: () => _showGardenSelector(context, gardens, state.config.scope.gardenIds, notifier),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text("Modifier la sélection"),
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero
                ),
              ),
            )
        ],
      ),
    );
  }

  void _showGardenSelector(BuildContext context, List<GardenFreezed> gardens,
      List<String> currentSelection, ExportBuilderNotifier notifier) {
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
              title: const Text("Sélectionner les jardins"),
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
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () {
                    // Update global state
                    notifier.updateScope(notifier.state.config.scope.copyWith(gardenIds: tempSelection));
                    Navigator.pop(context);
                  },
                  child: const Text("Valider"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  Widget _buildBlocksSection(
      ExportBuilderState state, ExportBuilderNotifier notifier) {
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
          final label = entry.value;
          final isEnabled = state.config.isBlockEnabled(type);
          final isLast = entry.key == ExportSchema.blockLabels.keys.last;

          return Column(
            children: [
              CheckboxListTile(
                title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(ExportSchema.blockDescriptions[type] ?? '', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    final enabledBlocks = state.config.blocks.where((b) => b.isEnabled);
    
    return Column(
      children: enabledBlocks.map((block) {
        final schemaFields = ExportSchema.getFieldsFor(block.type);
        final label = ExportSchema.blockLabels[block.type] ?? '';

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
              subtitle: Text("${block.selectedFieldIds.length} colonnes sélectionnées"),
              children: schemaFields.map((field) {
                final isSelected = block.selectedFieldIds.contains(field.id);
                return CheckboxListTile(
                  dense: true,
                  title: Text(field.label + (field.isAdvanced ? " (Avancé)" : "")),
                  subtitle: Text(field.description),
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
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          RadioListTile<ExportFormat>(
            title: const Text("Feuilles séparées (Standard)"),
            subtitle:
                const Text("Une feuille par type de donnée (Recommandé)"),
            value: ExportFormat.separateSheets,
            groupValue: state.config.format,
            onChanged: (val) => notifier.updateFormat(val!),
          ),
          const Divider(height: 1),
          RadioListTile<ExportFormat>(
            title: const Text("Table Unique (Flat / BI)"),
            subtitle: const Text(
                "Une seule grande table pour Tableaux Croisés Dynamiques"),
            value: ExportFormat.flatTable,
            groupValue: state.config.format,
            onChanged: (val) => notifier.updateFormat(val!),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomBar(ExportBuilderState state, ExportBuilderNotifier notifier) {
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
                    : () => _generateExport(notifier, context),
                icon: const Icon(Icons.download),
                label: const Text('Générer Export Excel',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateExport(
      ExportBuilderNotifier notifier, BuildContext context) async {
    try {
      final bytes = await notifier.generate();

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
          text: 'Voici votre export PermaCalendar ($filename)');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur: $e")));
      }
    }
  }
}
