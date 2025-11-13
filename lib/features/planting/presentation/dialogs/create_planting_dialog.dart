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
  DateTime? _expectedHarvestStartDate;
  DateTime? _expectedHarvestEndDate;
  String _status = 'Planté';
  bool _isLoading = false;

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
    _expectedHarvestStartDate = planting.expectedHarvestStartDate;
    _expectedHarvestEndDate = planting.expectedHarvestEndDate;
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
                // Plant selection
                _buildPlantSelection(theme),
                const SizedBox(height: 16),

                // Plant name (if custom)
                if (_selectedPlantId == null) ...[
                  CustomTextField(
                    controller: _plantNameController,
                    label: 'Nom de la plante',
                    hint: 'Ex: Tomate cerise',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le nom de la plante est requis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Quantity
                CustomTextField(
                  controller: _quantityController,
                  label: 'Quantité',
                  hint: 'Nombre de plants',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La quantité est requise';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'La quantité doit être un nombre positif';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Planted date
                _buildDateField(
                  label: 'Date de plantation',
                  date: _plantedDate,
                  onChanged: (date) => setState(() => _plantedDate = date),
                  theme: theme,
                ),
                const SizedBox(height: 16),

                // Expected harvest date range
                _buildHarvestDateRange(theme),
                const SizedBox(height: 16),

                // Status
                _buildStatusDropdown(theme),
                const SizedBox(height: 16),

                // Notes
                CustomTextField(
                  controller: _notesController,
                  label: 'Notes (optionnel)',
                  hint: 'Informations supplémentaires...',
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                // Tips
                _buildTips(theme),
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
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.planting == null ? 'Créer' : 'Modifier'),
        ),
      ],
    );
  }

  Widget _buildPlantSelection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sélection de la plante',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Plant catalog selection (placeholder)
        Card(
          child: ListTile(
            leading: const Icon(Icons.eco),
            title: const Text('Choisir depuis le catalogue'),
            subtitle: _selectedPlantId != null
                ? Text(
                    'Plante sélectionnée: ${_getPlantName(_selectedPlantId!)}')
                : const Text('Aucune plante sélectionnée'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showPlantCatalog,
          ),
        ),

        const SizedBox(height: 8),

        // Or custom plant
        Row(
          children: [
            Expanded(child: Divider(color: theme.colorScheme.outline)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OU',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            Expanded(child: Divider(color: theme.colorScheme.outline)),
          ],
        ),

        const SizedBox(height: 8),

        SwitchListTile(
          title: const Text('Plante personnalisée'),
          subtitle: const Text('Créer une plantation avec un nom personnalisé'),
          value: _selectedPlantId == null,
          onChanged: (value) {
            setState(() {
              if (value) {
                _selectedPlantId = null;
              } else {
                _plantNameController.clear();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildHarvestDateRange(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Période de récolte prévue (optionnel)',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Date de début de récolte
        _buildDateField(
          label: 'Début de récolte',
          date: _expectedHarvestStartDate,
          onChanged: (date) => setState(() => _expectedHarvestStartDate = date),
          theme: theme,
          optional: true,
        ),
        const SizedBox(height: 12),

        // Date de fin de récolte
        _buildDateField(
          label: 'Fin de récolte',
          date: _expectedHarvestEndDate,
          onChanged: (date) => setState(() => _expectedHarvestEndDate = date),
          theme: theme,
          optional: true,
        ),

        // Validation de la fourchette
        if (_expectedHarvestStartDate != null &&
            _expectedHarvestEndDate != null)
          if (_expectedHarvestStartDate!.isAfter(_expectedHarvestEndDate!))
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'âš ï¸ La date de début doit être antérieure à la date de fin',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.orange,
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(DateTime) onChanged,
    required ThemeData theme,
    bool optional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, date ?? DateTime.now(), onChanged),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    date != null
                        ? _formatDate(date)
                        : optional
                            ? 'Aucune date sélectionnée'
                            : 'Sélectionner une date',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: date != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (optional && date != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      if (label.contains('récolte')) {
                        _expectedHarvestStartDate = null;
                      }
                    }),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statut',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _status,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: Planting.statusOptions.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _status = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTips(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Conseils',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Utilisez le catalogue pour des informations précises sur les plantes\n'
            '• La période de récolte reflète mieux la réalité du jardinage\n'
            '• Choisissez "Semé" pour les graines, "Planté" pour les plants\n'
            '• Ajoutez des notes pour suivre les conditions spéciales',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onChanged) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      onChanged(date);
    }
  }

  void _showPlantCatalog() async {
    // Navigate to plant catalog in selection mode and wait for selected plant
    final selectedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlantCatalogScreen(isSelectionMode: true),
      ),
    );

    if (selectedPlant != null && selectedPlant is String) {
      setState(() {
        _selectedPlantId = selectedPlant;
        _plantNameController.clear(); // Clear custom plant name
      });
    }
  }

  String _getPlantName(String plantId) {
    // Get plant name from plant catalog
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

      if (widget.planting == null) {
        // Create new planting
        await ref.read(plantingProvider.notifier).createPlanting(
              gardenBedId: widget.gardenBedId,
              plantId: _selectedPlantId ?? 'custom',
              plantName: plantName,
              quantity: quantity,
              plantedDate: _plantedDate,
              expectedHarvestStartDate: _expectedHarvestStartDate,
              expectedHarvestEndDate: _expectedHarvestEndDate,
              notes: notes,
            );
      } else {
        // Update existing planting
        final updatedPlanting = widget.planting!.copyWith(
          plantName: plantName,
          quantity: quantity,
          plantedDate: _plantedDate,
          expectedHarvestStartDate: _expectedHarvestStartDate,
          expectedHarvestEndDate: _expectedHarvestEndDate,
          status: _status,
          notes: notes,
        );

        await ref
            .read(plantingProvider.notifier)
            .updatePlanting(updatedPlanting);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.planting == null
                ? 'Plantation Créée avec succès'
                : 'Plantation modifiée avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        // Forcer le rechargement des activités récentes
        ref.refresh(recentActivitiesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}


