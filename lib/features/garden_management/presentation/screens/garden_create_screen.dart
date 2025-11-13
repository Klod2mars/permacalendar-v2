ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/garden_freezed.dart';
import '../../../../core/utils/validators.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../../shared/widgets/loading_widgets.dart';

class GardenCreateScreen extends ConsumerStatefulWidget {
  final String? slot;
  const GardenCreateScreen({super.key, this.slot});

  @override
  ConsumerState<GardenCreateScreen> createState() => _GardenCreateScreenState();
}

class _GardenCreateScreenState extends ConsumerState<GardenCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'CrÃƒÂ©er un jardin',
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveGarden,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Information Section
                  _buildSectionTitle('Informations gÃƒÂ©nÃƒÂ©rales', theme),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _nameController,
                    label: 'Nom du jardin',
                    hint: 'Mon potager, Jardin des aromates...',
                    prefixIcon: const Icon(Icons.eco),
                    validator: Validators.validateName,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description (optionnel)',
                    hint: 'DÃƒÂ©crivez votre jardin...',
                    prefixIcon: const Icon(Icons.description),
                    maxLines: 3,
                    validator: Validators.validateDescription,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 24),

                  // Section Localisation et taille supprimÃƒÂ©e (la superficie est calculÃƒÂ©e via les parcelles)
                  const SizedBox(height: 8),

                  // Image Section
                  _buildSectionTitle('Image (optionnel)', theme),
                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _imageUrlController,
                    label: 'URL de l\\'image',
                    hint: 'https://exemple.com/image.jpg',
                    prefixIcon: const Icon(Icons.image),
                    validator: Validators.validateImageUrl,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),

                  // Image Preview
                  if (_imageUrlController.text.isNotEmpty) ...[
                    _buildImagePreview(theme),
                    const SizedBox(height: 24),
                  ],

                  // Tips Section (mise ÃƒÂ  jour)
                  _buildTipsSection(theme),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Annuler',
                          onPressed: _isLoading ? null : () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'CrÃƒÂ©er le jardin',
                          onPressed: _isLoading ? null : _saveGarden,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),

                  // Bottom padding for keyboard
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          LoadingOverlay(
            isLoading: _isLoading,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _imageUrlController.text,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: theme.colorScheme.errorContainer,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 8),
                Text(
                  'Impossible de charger l\\'image',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipsSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
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
                'Conseils pour crÃƒÂ©er votre jardin',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ââ‚¬Â¢ CrÃƒÂ©ez votre jardin avec un nom et une description.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ââ‚¬Â¢ Ajoutez ensuite des parcelles et attribuez une superficie ÃƒÂ  chacune.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ââ‚¬Â¢ La superficie totale du jardin sera calculÃƒÂ©e automatiquement (somme des parcelles).',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'ââ‚¬Â¢ Vous pourrez modifier ces informations plus tard.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveGarden() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final garden = GardenFreezed.create(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        totalAreaInSquareMeters: null,
        location: null,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );

            // Si l\\'écran a été ouvert avec un paramètre ""slot"", tenter la Création atomique pour le slot
      final String? slotParam = widget.slot;
      bool success;
      if (slotParam != null && slotParam.isNotEmpty) {
        final slotNumber = int.tryParse(slotParam);
        if (slotNumber != null && slotNumber >= 0) {
          success = await ref
              .read(gardenProvider.notifier)
              .createGardenForSlot(slotNumber, garden);
        } else {
          // slot invalide -> fallback sur Création normale
          success = await ref.read(gardenProvider.notifier).createGarden(garden);
        }
      } else {
        success = await ref.read(gardenProvider.notifier).createGarden(garden);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Jardin crÃƒÂ©ÃƒÂ© avec succÃƒÂ¨s'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la crÃƒÂ©ation du jardin'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la crÃƒÂ©ation : $e'),
            backgroundColor: Colors.red,
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







