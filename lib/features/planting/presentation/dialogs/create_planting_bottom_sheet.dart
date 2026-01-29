// lib/features/planting/presentation/dialogs/create_planting_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/planting.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../providers/planting_provider.dart';
import '../../../plant_catalog/presentation/screens/plant_catalog_screen.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../../../core/providers/activity_tracker_v3_provider.dart';

/// Usage:
/// showCreatePlantingBottomSheet(context, gardenBedId: 'bed1', planting: null);
Future<void> showCreatePlantingBottomSheet(
  BuildContext context, {
  required String gardenBedId,
  Planting? planting,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _CreatePlantingBottomSheetContent(
          gardenBedId: gardenBedId, planting: planting);
    },
  );
}

class _CreatePlantingBottomSheetContent extends ConsumerStatefulWidget {
  final String gardenBedId;
  final Planting? planting;

  const _CreatePlantingBottomSheetContent(
      {required this.gardenBedId, this.planting});

  @override
  ConsumerState<_CreatePlantingBottomSheetContent> createState() =>
      _CreatePlantingBottomSheetContentState();
}

class _CreatePlantingBottomSheetContentState
    extends ConsumerState<_CreatePlantingBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _plantNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedPlantId;
  DateTime _plantedDate = DateTime.now();
  String _status = 'Planté';
  bool _isLoading = false;
  bool _isPreset = false;

  bool _customPlantExpanded = false;
  bool _notesExpanded = false;
  bool _tipsExpanded = false;

  @override
  void initState() {
    super.initState();
    _isPreset = widget.planting?.metadata['preset'] == true;
    if (widget.planting != null) _initializeForEdit();
    _plantNameController.addListener(() {
      final text = _plantNameController.text;
      if (text.trim().isNotEmpty && _selectedPlantId != null) {
        setState(() {
          _selectedPlantId = null;
        });
      }
    });
  }

  void _initializeForEdit() {
    final planting = widget.planting!;
    _selectedPlantId = planting.plantId;
    _plantNameController.text = planting.plantName;
    _quantityController.text = planting.quantity.toString();
    _plantedDate = planting.plantedDate;
    _status = planting.status;
    _notesController.text = planting.notes ?? '';
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final keyboardInset = mq.viewInsets.bottom;

    final double sheetMaxHeight = mq.size.height * 0.92;
    final double sheetWidth = mq.size.width;
    final double constrainedHeight = sheetMaxHeight - 12.0;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: constrainedHeight, maxWidth: sheetWidth),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(2)),
              ),
              Text(
                  (widget.planting == null || _isPreset)
                      ? 'Nouvelle culture'
                      : 'Modifier la culture',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: keyboardInset + 8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionBlock(theme),
                        const SizedBox(height: 12),
                        _buildPlantReminder(theme),
                        const SizedBox(height: 8),
                        _buildCustomPlantTile(theme),
                        const SizedBox(height: 8),
                        ExpansionTile(
                          title: Text('Notes (optionnel)',
                              style: theme.textTheme.bodyMedium),
                          initiallyExpanded: _notesExpanded,
                          onExpansionChanged: (v) =>
                              setState(() => _notesExpanded = v),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: CustomTextField(
                                controller: _notesController,
                                hint: 'Informations supplémentaires...',
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ExpansionTile(
                          title: Row(
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  color: theme.colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              Text('Conseils',
                                  style: theme.textTheme.titleSmall),
                            ],
                          ),
                          initiallyExpanded: _tipsExpanded,
                          onExpansionChanged: (v) =>
                              setState(() => _tipsExpanded = v),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '• Utilisez le catalogue pour sélectionner une plante.',
                                      style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 6),
                                  Text(
                                      '• Choisissez "Semer" pour les graines, "Planter" pour les plants.',
                                      style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 6),
                                  Text(
                                      '• Ajoutez des notes pour suivre les conditions spéciales.',
                                      style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                child: const Text('Annuler')),
                            const SizedBox(width: 8),
                            ElevatedButton(
                                onPressed: _isLoading ? null : _savePlanting,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2))
                                    : Text(
                                        (widget.planting == null || _isPreset)
                                            ? 'Créer'
                                            : 'Modifier')),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------
  // UI BUILDERS
  // --------------------
  Widget _buildActionBlock(ThemeData theme) {
    final bool isSown = _status == 'Semé';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120, maxWidth: 220),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ToggleButtons(
                    isSelected: [_status == 'Semé', _status == 'Planté'],
                    onPressed: (index) {
                      setState(() {
                        _status = index == 0 ? 'Semé' : 'Planté';
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    fillColor: theme.colorScheme.primary.withOpacity(0.12),
                    selectedBorderColor: theme.colorScheme.primary,
                    children: const [
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text('Semé')),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text('Planté')),
                    ],
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8)),
                  onPressed: () => _selectDate(context, _plantedDate,
                      (d) => setState(() => _plantedDate = d)),
                  icon: Icon(Icons.calendar_today,
                      size: 18, color: theme.colorScheme.primary),
                  label: Text(_formatDate(_plantedDate)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: _quantityController,
            hint: isSown ? 'Nombre de graines' : 'Nombre de plants',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            validator: (value) {
              if (value == null || value.trim().isEmpty)
                return 'La quantité est requise';
              final q = int.tryParse(value);
              if (q == null || q <= 0)
                return 'La quantité doit être un nombre positif';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlantReminder(ThemeData theme) {
    final plantName = _selectedPlantId != null
        ? _getPlantName(_selectedPlantId!)
        : 'Aucune plante sélectionnée';
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.eco),
      title: _selectedPlantId != null
          ? Text('Plante : $plantName')
          : Text(plantName, style: theme.textTheme.bodyMedium),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: _showPlantCatalog,
    );
  }

  Widget _buildCustomPlantTile(ThemeData theme) {
    return ExpansionTile(
      title: Text('Plante personnalisée', style: theme.textTheme.bodyMedium),
      initiallyExpanded: _customPlantExpanded,
      onExpansionChanged: (v) => setState(() => _customPlantExpanded = v),
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      children: [
        CustomTextField(
          controller: _plantNameController,
          label: 'Nom de la plante',
          hint: 'Ex: Tomate cerise',
          onChanged: (text) {
            if (text.trim().isNotEmpty && _selectedPlantId != null) {
              setState(() {
                _selectedPlantId = null;
              });
            }
          },
          validator: (value) {
            if (_plantNameController.text.trim().isNotEmpty) {
              if (value == null || value.trim().isEmpty)
                return 'Le nom de la plante est requis';
            }
            return null;
          },
        ),
      ],
    );
  }

  // --------------------
  // Helpers & Actions (same as dialog)
  // --------------------
  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onChanged) async {
    final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (date != null) onChanged(date);
  }

  void _showPlantCatalog() async {
    final selectedPlant = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const PlantCatalogScreen(isSelectionMode: true)));
    if (selectedPlant != null && selectedPlant is String) {
      setState(() {
        _selectedPlantId = selectedPlant;
        _plantNameController.clear();
        _customPlantExpanded = false;
      });
    }
  }

  String _getPlantName(String plantId) {
    final plantCatalogState = ref.read(
        plantCatalog_provider); // if your provider variable name differs, adapt
    final plant = plantCatalogState.plants.firstWhere(
      (plant) => plant.id == plantId,
      orElse: () => PlantFreezed(
        id: plantId,
        commonName: 'Plante inconnue',
        scientificName: '',
        family: '',
        description: '',
        plantingSeason: '',
        harvestSeason: '',
        daysToMaturity: 0,
        spacing: 0,
        depth: 0.0,
        sunExposure: '',
        waterNeeds: '',
        sowingMonths: [],
        harvestMonths: [],
      ),
    );
    return plant.commonName;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _savePlanting() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final plantName = (_plantNameController.text.trim().isNotEmpty)
          ? _plantNameController.text.trim()
          : (_selectedPlantId != null ? _getPlantName(_selectedPlantId!) : '');
      final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      if (quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('La quantité doit être un nombre positif'),
            backgroundColor: Colors.orange));
        setState(() => _isLoading = false);
        return;
      }

      if (_plantedDate.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('La date de plantation ne peut pas être dans le futur'),
            backgroundColor: Colors.orange));
        setState(() => _isLoading = false);
        return;
      }

      if (widget.planting == null || _isPreset) {
        PlantFreezed? selectedPlantObj;
        if (_selectedPlantId != null) {
          final plantCatalogState =
              ref.read(plant_catalog_provider); // adapt name if needed
          try {
            selectedPlantObj = plantCatalogState.plants
                .firstWhere((p) => p.id == _selectedPlantId);
          } catch (e) {
            selectedPlantObj = null;
          }
        }

        double initialGrowthPercent = 0.0;
        if (_status == 'Planté') {
          double? plantSpecific;
          if (selectedPlantObj != null && selectedPlantObj.growth != null) {
            final raw = selectedPlantObj.growth!['transplantInitialPercent'];
            if (raw is num)
              plantSpecific = raw.toDouble();
            else if (raw is String) plantSpecific = double.tryParse(raw);
          }
          initialGrowthPercent =
              ((plantSpecific ?? 0.3).clamp(0.0, 1.0)) as double;
        } else {
          initialGrowthPercent = 0.0;
        }

        final metadataForCreation = <String, dynamic>{
          'initialGrowthPercent': initialGrowthPercent
        };

        final success =
            await ref.read(plantingProvider.notifier).createPlanting(
                  gardenBedId: widget.gardenBedId,
                  plantId: _selectedPlantId ?? 'custom',
                  plantName: plantName,
                  quantity: quantity,
                  plantedDate: _plantedDate,
                  expectedHarvestStartDate: null,
                  expectedHarvestEndDate: null,
                  notes: notes,
                  status: _status,
                  metadata: metadataForCreation,
                );

        if (!success) {
          if (mounted) {
            final error = ref.read(plantingProvider).error ??
                'Erreur lors de la Création';
            // Utiliser une couleur orange pour les messages "polis" de validation
            final isLimitation = error.contains('limite') ||
                error.contains('confort') ||
                error.contains('performances');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(error),
                backgroundColor: isLimitation ? Colors.orange : Colors.red));
          }
          setState(() => _isLoading = false);
          return;
        }
      } else {
        final updatedPlanting = widget.planting!.copyWith(
          plantName: plantName,
          quantity: quantity,
          plantedDate: _plantedDate,
          status: _status,
          notes: notes,
          expectedHarvestStartDate: widget.planting!.expectedHarvestStartDate,
          expectedHarvestEndDate: widget.planting!.expectedHarvestEndDate,
        );
        final success = await ref
            .read(plantingProvider.notifier)
            .updatePlanting(updatedPlanting);

        if (!success) {
          if (mounted) {
            final error = ref.read(plantingProvider).error ??
                'Erreur lors de la mise à jour';
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((widget.planting == null || _isPreset)
                ? 'Culture créée avec succès'
                : 'Culture modifiée avec succès'),
            backgroundColor: Colors.green));
        ref.refresh(recentActivitiesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
