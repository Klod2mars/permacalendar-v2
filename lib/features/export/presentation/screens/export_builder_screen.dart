import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// import 'package:file_saver/file_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:permacalendar/features/export/domain/models/export_config.dart';
import 'package:permacalendar/features/export/domain/models/export_schema.dart';
import 'package:permacalendar/features/export/presentation/providers/export_builder_provider.dart';

class ExportBuilderScreen extends ConsumerStatefulWidget {
  const ExportBuilderScreen({super.key});

  @override
  ConsumerState<ExportBuilderScreen> createState() =>
      _ExportBuilderScreenState();
}

class _ExportBuilderScreenState extends ConsumerState<ExportBuilderScreen> {
  int _currentStep = 0;

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
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) setState(() => _currentStep++);
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                if (_currentStep < 3)
                  ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Suivant')),
                if (_currentStep == 3)
                  ElevatedButton.icon(
                      onPressed: state.isGenerating
                          ? null
                          : () => _generateExport(notifier, context),
                      icon: const Icon(Icons.download),
                      label: const Text('Générer Export Excel')),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Retour')),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Périmètre (Scope)'),
            content: _buildScopeStep(state, notifier),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Données (Blocs)'),
            content: _buildBlocksStep(state, notifier),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Colonnes & Détails'),
            content: _buildColumnsStep(state, notifier),
            isActive: _currentStep >= 2,
          ),
          Step(
            title: const Text('Format & Validation'),
            content: _buildFormatStep(state, notifier),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildScopeStep(
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sélectionnez la période et les jardins concernés."),
        const SizedBox(height: 10),
        ListTile(
          title: const Text("Période"),
          subtitle: Text(state.config.scope.dateRange == null
              ? "Tout l'historique"
              : "${DateFormat('dd/MM/yyyy').format(state.config.scope.dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(state.config.scope.dateRange!.end)}"),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030));
            if (picked != null) {
              notifier
                  .updateScope(state.config.scope.copyWith(dateRange: picked));
            }
          },
        ),
        // Add Garden MultiSelect here (Simplified for MVP as "All Gardens")
        SwitchListTile(
          title: const Text("Filtrer par Jardin spécifique"),
          subtitle: const Text("Actuellement: Tous les jardins"),
          value: state.config.scope.gardenIds.isNotEmpty,
          onChanged: (val) {
            // Logic to open garden selector dialog would go here
            // For now just toggle 'all' or 'none' (demo)
            if (!val)
              notifier.updateScope(state.config.scope.copyWith(gardenIds: []));
          },
        ),
      ],
    );
  }

  Widget _buildBlocksStep(
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    return Column(
      children: ExportSchema.blockLabels.entries.map((entry) {
        final type = entry.key;
        final label = entry.value;
        final isEnabled = state.config.isBlockEnabled(type);

        return CheckboxListTile(
          title: Text(label),
          subtitle: Text(ExportSchema.blockDescriptions[type] ?? ''),
          value: isEnabled,
          onChanged: (val) => notifier.toggleBlock(type, val ?? false),
        );
      }).toList(),
    );
  }

  Widget _buildColumnsStep(
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    return Column(
      children: state.config.blocks.where((b) => b.isEnabled).map((block) {
        final schemaFields = ExportSchema.getFieldsFor(block.type);

        return ExpansionTile(
          title: Text(ExportSchema.blockLabels[block.type] ?? ''),
          children: schemaFields.map((field) {
            final isSelected = block.selectedFieldIds.contains(field.id);
            return CheckboxListTile(
              dense: true,
              title: Text(field.label + (field.isAdvanced ? " (Avancé)" : "")),
              subtitle: Text(field.description),
              value: isSelected,
              onChanged: (val) => notifier.toggleField(block.type, field.id),
              secondary: field.isAdvanced
                  ? const Icon(Icons.build_circle_outlined, size: 16)
                  : null,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildFormatStep(
      ExportBuilderState state, ExportBuilderNotifier notifier) {
    return Column(
      children: [
        RadioListTile<ExportFormat>(
          title: const Text("Feuilles séparées (Standard)"),
          subtitle: const Text("Une feuille par type de donnée (Recommandé)"),
          value: ExportFormat.separateSheets,
          groupValue: state.config.format,
          onChanged: (val) => notifier.updateFormat(val!),
        ),
        RadioListTile<ExportFormat>(
          title: const Text("Table Unique (Flat / BI)"),
          subtitle: const Text(
              "Une seule grande table pour Tableaux Croisés Dynamiques"),
          value: ExportFormat.flatTable,
          groupValue: state.config.format,
          onChanged: (val) => notifier.updateFormat(val!),
        ),
        const Divider(),
        const Text("Résumé:", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Blocs: ${state.config.blocks.where((b) => b.isEnabled).length}"),
        Text("Période: ${state.config.scope.dateRange?.start.year ?? 'Tout'}"),
      ],
    );
  }

  Future<void> _generateExport(
      ExportBuilderNotifier notifier, BuildContext context) async {
    try {
      final bytes = await notifier.generate();

      // Save file
      final tempDir = await getTemporaryDirectory();
      final file = File(
          '${tempDir.path}/export_permacalendar_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);

      // Share
      await Share.shareXFiles([XFile(file.path)],
          text: 'Voici votre export PermaCalendar');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur: $e")));
      }
    }
  }
}
