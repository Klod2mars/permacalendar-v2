// lib/features/planting/presentation/widgets/harvest_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/planting.dart';
import '../../../../core/utils/calibration_storage.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';
import '../../providers/planting_provider.dart';

/// Dialogue réutilisable pour enregistrer une récolte
Future<void> showHarvestDialog(
    BuildContext context, WidgetRef ref, Planting planting) async {
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Charger le prix par défaut
  double? initialPrice;
  // 1. Essayer les préférences utilisateur
  final userPrices =
      await CalibrationStorage.loadProfile('userHarvestPrices') ?? {};
  if (userPrices.containsKey(planting.plantId)) {
    initialPrice = (userPrices[planting.plantId] as num).toDouble();
  } else {
    // 2. Essayer le catalogue de plantes
    // On doit chercher la plante dans le provider. Risque: catalogue pas chargé.
    // On suppose que le catalogue est souvent déjà chargé ou partiel.
    // Sinon on laisse vide.
    try {
      final catalogState = ref.read(plantCatalogProvider);
      final plant = catalogState.plants.firstWhere(
        (p) => p.id == planting.plantId,
        orElse: () => throw Exception('Not found'),
      );
      initialPrice = plant.marketPricePerKg;
    } catch (_) {
      // Plante non trouvée ou catalogue vide
    }
  }

  if (initialPrice != null) {
    _priceController.text = initialPrice.toString();
  }

  // Si on est en "update" (déjà récolté), on pourrait préremplir avec les valeurs existantes
  // Mais ici c'est un dialogue "Nouvelle récolte" pour clore une plantation.

  await showDialog(
    context: context,
    builder: (dctx) => AlertDialog(
      title: Text('Récolte: ${planting.plantName}'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poids (Principal)
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Poids récolté (kg) *',
                    suffixText: 'kg',
                    prefixIcon: Icon(Icons.scale),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Requis';
                    final d = double.tryParse(v.trim().replaceAll(',', '.'));
                    if (d == null || d <= 0) return 'Invalide (> 0)';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Prix (Secondaire avec mémoire)
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Prix estimé (€/kg)',
                    suffixText: '€/kg',
                    prefixIcon: Icon(Icons.euro),
                    helperText:
                        'Sera mémorisé pour les prochaines récoltes de cette plante',
                  ),
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty) {
                      final d = double.tryParse(v.trim().replaceAll(',', '.'));
                      if (d == null || d < 0) return 'Invalide (>= 0)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes / Qualité',
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dctx).pop(),
            child: const Text('Annuler')),
        FilledButton(
onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final weight = double.tryParse(_weightController.text.replaceAll(',', '.')) ?? 0.0;
            final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
            final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();


              // Appel métier : recordHarvest (doit exister dans PlantingNotifier)
              final notifier = ref.read(plantingProvider.notifier);
              bool success = false;
              try {
                debugPrint('[harvest_dialog] calling recordHarvest planting=${planting.id} weight=$weight price=$price');

                success = await notifier.recordHarvest(
                  planting.id,
                  DateTime.now(),
                  weightKg: weight,
                  pricePerKg: price,
                  notes: notes,
                );
              
            } catch (e) {
              success = false;
              debugPrint('Erreur recordHarvest: $e');
            }

            if (success && context.mounted) {
              Navigator.of(dctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Récolte enregistrée')));
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erreur lors de l\'enregistrement')));
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    ),
  );
}
