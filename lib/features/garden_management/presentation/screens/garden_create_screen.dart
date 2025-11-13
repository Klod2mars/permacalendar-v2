import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/garden_freezed.dart';
import '../../../../core/utils/validators.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../../shared/widgets/loading_widgets.dart';

/// Écran de création d'un jardin.
class GardenCreateScreen extends ConsumerStatefulWidget {
  final String? slot; // <- depuis le router

  const GardenCreateScreen({
    super.key,
    this.slot,
  });

  @override
  ConsumerState<GardenCreateScreen> createState() =>
      _GardenCreateScreenState();
}

class _GardenCreateScreenState extends ConsumerState<GardenCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final newGarden = GardenFreezed(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        imageUrl: _imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      bool success = false;

      // Si un slot est passé par le router → création + assignation.
      if (widget.slot != null) {
        final slotNumber = int.tryParse(widget.slot!);
        if (slotNumber != null) {
          success = await ref
              .read(gardenProvider.notifier)
              .createGardenForSlot(slotNumber, newGarden);
        }
      } else {
        // Sinon → simple création normale
        success = await ref
            .read(gardenProvider.notifier)
            .createGarden(newGarden);
      }

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jardin créé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la création du jardin'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création : $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Créer un jardin'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'Nom du jardin',
                    prefixIcon: const Icon(Icons.eco),
                    validator: (v) => Validators.validateName(v)
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    prefixIcon: const Icon(Icons.description),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Image du jardin (optionnel)',
                    style: theme.textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: _imageUrlController,
                    label: "URL de l'image",
                    hint: 'https://exemple.com/image.jpg',
                    prefixIcon: const Icon(Icons.image),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 16),

                  if (_imageUrlController.text.isNotEmpty)
                    _buildImagePreview(theme),
                ],
              ),
            ),
          ),

          if (_isSubmitting)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black45,
                child: Center(child: LoadingWidget()),
              ),
            ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: CustomButton(
          text: _isSubmitting ? 'Création...' : 'Créer le jardin',
          onPressed: _isSubmitting ? null : _submit,
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    final url = _imageUrlController.text.trim();
    if (url.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: theme.colorScheme.surfaceVariant,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.broken_image, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    "Impossible de charger l'image",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
