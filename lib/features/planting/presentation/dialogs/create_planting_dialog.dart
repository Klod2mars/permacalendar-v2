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

class CreatePlantingDialog extends ConsumerStatefulWidget {
  final String gardenBedId;
  final Planting? planting; // null for create, non-null for edit

  const CreatePlantingDialog({
    super.key,
    required this.gardenBedId,
    this.planting,
  });

  @override
  ConsumerState<CreatePlantingDialog> createState() =>
      _CreatePlantingDialogState();
}

class _CreatePlantingDialogState extends ConsumerState<CreatePlantingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _plantNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedPlantId;
  DateTime _plantedDate = DateTime.now();
  String _status = 'Planté';
  bool _isLoading = false;
  bool _customPlantExpanded = false;
  bool _notesExpanded = false;
  bool _tipsExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.planting != null) {
      _initializeForEdit();
    }
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

    return AlertDialog(
      title: Text(widget.planting == null
          ? 'Nouvelle plantation'
          : 'Modifier la plantation'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ACTION BLOCK (compact, always visible)
                _buildActionBlock(theme),
                const SizedBox(height: 12),

                // PLANT SELECTION (compact)
                _buildPlantReminder(theme),
                const SizedBox(height: 8),

                // Plante personnalisée (repliable)
                _buildCustomPlantTile(theme),
                const SizedBox(height: 8),

                // Statut (compact)
                _buildStatusDropdown(theme),
                const SizedBox(height: 8),

                // Notes (repliable)
                ExpansionTile(
                  title: Text('Notes (optionnel)',
                      style: theme.textTheme.bodyMedium),
                  initiallyExpanded: _notesExpanded,
                  onExpansionChanged: (v) => setState(() => _notesExpanded = v),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomTextField(
                        controller: _notesController,
                        hint: 'Informations supplémentaires...',
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tips (repliable)
                ExpansionTile(
                  title: Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: theme.colorScheme.primary, size: 18),
                      const SizedBox(width: 8),
                      Text('Conseils', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  initiallyExpanded: _tipsExpanded,
                  onExpansionChanged: (v) => setState(() => _tipsExpanded = v),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: Text(
                        '• Utilisez le catalogue pour des informations précises sur les plantes\n'
                        '• La période de récolte sera gérée par la parcelle\n'
                        '• Choisissez "Semé" pour les graines, "Planté" pour les plants\n'
                        '• Ajoutez des notes pour suivre les conditions spéciales',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _savePlanting,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(widget.planting == null ? 'Créer' : 'Modifier'),
        ),
      ],
    );
  }

  // --------------------
  // UI BUILDERS
  // --------------------

  Widget _buildActionBlock(ThemeData theme) {
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
          // Operation toggle
          Row(
            children: [
              ToggleButtons(
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
              const Spacer(),
              // Small planted date preview / compact
              TextButton.icon(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8)),
                onPressed: () => _selectDate(context, _plantedDate,
                    (d) => setState(() => _plantedDate = d)),
                icon: Icon(Icons.calendar_today,
                    size: 18, color: theme.colorScheme.primary),
                label: Text(_formatDate(_plantedDate)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Quantity (compact)
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _quantityController,
                  hint: 'Nombre de plants',
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
              ),
            ],
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
      title: Text(_selectedPlantId != null ? 'Plante : $plantName' : plantName),
      trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: _showPlantCatalog),
      onTap: _showPlantCatalog,
    );
  }

  Widget _buildCustomPlantTile(ThemeData theme) {
    final isCustom = _selectedPlantId == null;
    return ExpansionTile(
      title: Text('Plante personnalisée', style: theme.textTheme.bodyMedium),
      subtitle: Text('Créer une plantation avec un nom personnalisé',
          style: theme.textTheme.bodySmall),
      initiallyExpanded: _customPlantExpanded,
      onExpansionChanged: (v) => setState(() => _customPlantExpanded = v),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: isCustom,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _selectedPlantId = null;
                } else {
                  // Prefer clearing plant name but keep selection empty (user must pick from catalog)
                  _plantNameController.clear();
                }
              });
            },
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            children: [
              if (_selectedPlantId == null)
                CustomTextField(
                  controller: _plantNameController,
                  label: 'Nom de la plante',
                  hint: 'Ex: Tomate cerise',
                  validator: (value) {
                    if (_selectedPlantId == null) {
                      if (value == null || value.trim().isEmpty)
                        return 'Le nom de la plante est requis';
                    }
                    return null;
                  },
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statut',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: Planting.statusOptions
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => v != null ? setState(() => _status = v) : null,
        ),
      ],
    );
  }

  // --------------------
  // Helpers & Actions
  // --------------------

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onChanged) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) onChanged(date);
  }

  void _showPlantCatalog() async {
    final selectedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const PlantCatalogScreen(isSelectionMode: true)),
    );
    if (selectedPlant != null && selectedPlant is String) {
      setState(() {
        _selectedPlantId = selectedPlant;
        _plantNameController.clear();
      });
    }
  }

  String _getPlantName(String plantId) {
    final plantCatalogState = ref.read(plantCatalogProvider);
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
      final plantName = _selectedPlantId != null
          ? _getPlantName(_selectedPlantId!)
          : _plantNameController.text.trim();
      final quantity = int.parse(_quantityController.text.trim());
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      // Validate plantedDate
      if (_plantedDate.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('La date de plantation ne peut pas être dans le futur'),
            backgroundColor: Colors.orange));
        setState(() => _isLoading = false);
        return;
      }

      if (widget.planting == null) {
        // Create
        await ref.read(plantingProvider.notifier).createPlanting(
              gardenBedId: widget.gardenBedId,
              plantId: _selectedPlantId ?? 'custom',
              plantName: plantName,
              quantity: quantity,
              plantedDate: _plantedDate,
              expectedHarvestStartDate: null, // removed from UI
              expectedHarvestEndDate: null, // removed from UI
              notes: notes,
            );
      } else {
        // Update — preserve existing expectedHarvest values (do not overwrite)
        final updatedPlanting = widget.planting!.copyWith(
          plantName: plantName,
          quantity: quantity,
          plantedDate: _plantedDate,
          status: _status,
          notes: notes,
          expectedHarvestStartDate: widget.planting!.expectedHarvestStartDate,
          expectedHarvestEndDate: widget.planting!.expectedHarvestEndDate,
        );
        await ref
            .read(plantingProvider.notifier)
            .updatePlanting(updatedPlanting);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.planting == null
              ? 'Plantation Créée avec succès'
              : 'Plantation modifiée avec succès'),
          backgroundColor: Colors.green,
        ));
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
