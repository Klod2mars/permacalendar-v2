// lib/features/planting/presentation/widgets/harvest_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

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

  // Use a variable for context to avoid "Build arguments ... not use across async gaps" warning if strict,
  // but for showDialog we need the original context if possible or use the one from builder.
  // We will access l10n inside builder.

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

  if (!context.mounted) return;

  await showDialog(
    context: context,
    builder: (dctx) {
        final l10n = AppLocalizations.of(dctx)!;
        return AlertDialog(
      title: Text(l10n.harvest_title(planting.plantName)),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.harvest_weight_label,
                    suffixText: 'kg',
                    prefixIcon: const Icon(Icons.scale),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return l10n.harvest_form_error_required;
                    final d = double.tryParse(v.trim().replaceAll(',', '.'));
                    if (d == null || d <= 0) return l10n.harvest_form_error_positive;
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Prix (Secondaire avec mémoire)
                TextFormField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.harvest_price_label,
                    suffixText: '€/kg',
                    prefixIcon: const Icon(Icons.euro),
                    helperText: l10n.harvest_price_helper,
                  ),
                  validator: (v) {
                    if (v != null && v.trim().isNotEmpty) {
                      final d = double.tryParse(v.trim().replaceAll(',', '.'));
                      if (d == null || d < 0) return l10n.harvest_form_error_positive; // or generic invalid
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l10n.harvest_notes_label,
                    prefixIcon: const Icon(Icons.note),
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
            child: Text(l10n.common_cancel)),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final weight =
                double.tryParse(_weightController.text.replaceAll(',', '.')) ??
                    0.0;
            final price =
                double.tryParse(_priceController.text.replaceAll(',', '.')) ??
                    0.0;
            final notes = _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim();

            // Appel métier : recordHarvest (doit exister dans PlantingNotifier)
            final notifier = ref.read(plantingProvider.notifier);
            bool success = false;
            try {
              debugPrint(
                  '[harvest_dialog] calling recordHarvest planting=${planting.id} weight=$weight price=$price');

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
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.harvest_snack_saved)));
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(l10n.harvest_snack_error)));
            }
          },
          child: Text(l10n.common_save), // or harvest_action_save
        ),
      ],
    );
    } // builder
  );
}
