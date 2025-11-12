import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/garden_bed.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../providers/garden_bed_provider.dart';

class CreateGardenBedDialog extends ConsumerStatefulWidget {
  final String gardenId;
  final GardenBed? gardenBed; // For editing

  const CreateGardenBedDialog({
    super.key,
    required this.gardenId,
    this.gardenBed,
  });

  @override
  ConsumerState<CreateGardenBedDialog> createState() =>
      _CreateGardenBedDialogState();
}

class _CreateGardenBedDialogState extends ConsumerState<CreateGardenBedDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizeController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSoilType = 'Argileux';
  String _selectedExposure = 'Plein soleil';
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.gardenBed != null) {
      final bed = widget.gardenBed!;
      _nameController.text = bed.name;
      _descriptionController.text = bed.description;
      _sizeController.text = bed.sizeInSquareMeters.toString();
      _notesController.text = bed.notes ?? '';
      _selectedSoilType = bed.soilType;
      _selectedExposure = bed.exposure;
      _isActive = bed.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sizeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.gardenBed != null;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit : Icons.add,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isEditing ? 'Modifier la parcelle' : 'Nouvelle parcelle',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom de la parcelle *',
                          hintText: 'Ex: Parcelle Nord, Potager principal...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le nom est obligatoire';
                          }
                          if (value.trim().length < 2) {
                            return 'Le nom doit contenir au moins 2 caractères';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Description de la parcelle...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // Size field
                      TextFormField(
                        controller: _sizeController,
                        decoration: const InputDecoration(
                          labelText: 'Surface (m²) *',
                          hintText: 'Ex: 10.5',
                          border: OutlineInputBorder(),
                          suffixText: 'm²',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La surface est obligatoire';
                          }
                          final size = double.tryParse(value);
                          if (size == null || size <= 0) {
                            return 'Veuillez entrer une surface valide';
                          }
                          if (size > 1000) {
                            return 'La surface ne peut pas dépasser 1000 m²';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Soil type dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSoilType,
                        decoration: const InputDecoration(
                          labelText: 'Type de sol *',
                          border: OutlineInputBorder(),
                        ),
                        items: GardenBed.soilTypes.map((soilType) {
                          return DropdownMenuItem(
                            value: soilType,
                            child: Row(
                              children: [
                                Icon(_getSoilTypeIcon(soilType), size: 20),
                                const SizedBox(width: 8),
                                Text(soilType),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedSoilType = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Exposure dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedExposure,
                        decoration: const InputDecoration(
                          labelText: 'Exposition *',
                          border: OutlineInputBorder(),
                        ),
                        items: GardenBed.exposureTypes.map((exposure) {
                          return DropdownMenuItem(
                            value: exposure,
                            child: Row(
                              children: [
                                Icon(_getExposureIcon(exposure), size: 20),
                                const SizedBox(width: 8),
                                Text(exposure),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedExposure = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Notes field
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          hintText: 'Notes additionnelles...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),

                      const SizedBox(height: 16),

                      // Active status switch
                      SwitchListTile(
                        title: const Text('Parcelle active'),
                        subtitle: Text(
                          _isActive
                              ? 'Cette parcelle est utilisée pour les plantations'
                              : 'Cette parcelle est temporairement désactivée',
                        ),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: isEditing ? 'Modifier' : 'Créer',
                  onPressed: _isLoading ? null : _saveGardenBed,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSoilTypeIcon(String soilType) {
    switch (soilType) {
      case 'Argileux':
        return Icons.layers;
      case 'Sableux':
        return Icons.grain;
      case 'Limoneux':
        return Icons.water_drop;
      case 'Humifère':
        return Icons.eco;
      default:
        return Icons.terrain;
    }
  }

  IconData _getExposureIcon(String exposure) {
    switch (exposure) {
      case 'Plein soleil':
        return Icons.wb_sunny;
      case 'Mi-soleil':
        return Icons.wb_sunny_outlined;
      case 'Mi-ombre':
        return Icons.wb_cloudy;
      case 'Ombre':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }

  Future<void> _saveGardenBed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final size = double.parse(_sizeController.text);

      bool success;
      if (widget.gardenBed != null) {
        // Update existing garden bed
        final updatedBed = widget.gardenBed!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          sizeInSquareMeters: size,
          soilType: _selectedSoilType,
          exposure: _selectedExposure,
          notes: _notesController.text.trim(),
          isActive: _isActive,
        );

        success = await ref
            .read(gardenBedProvider.notifier)
            .updateGardenBed(updatedBed);
      } else {
        // Create new garden bed
        final newBed = GardenBed(
          gardenId: widget.gardenId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          sizeInSquareMeters: size,
          soilType: _selectedSoilType,
          exposure: _selectedExposure,
          notes: _notesController.text.trim(),
          isActive: _isActive,
        );

        success =
            await ref.read(gardenBedProvider.notifier).createGardenBed(newBed);
      }

      if (success && mounted) {
        // Retourner true pour indiquer le succès à l'écran parent
        Navigator.of(context).pop(true);

        // Afficher un message de succès avec une icône
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.gardenBed != null
                        ? 'Parcelle modifiée avec succès'
                        : 'Parcelle créée avec succès',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Erreur lors de la sauvegarde'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Erreur: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

