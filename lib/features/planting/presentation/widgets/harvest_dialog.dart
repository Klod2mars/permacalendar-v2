// lib/features/planting/presentation/widgets/harvest_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/planting.dart';
import '../../providers/planting_provider.dart';

/// Dialogue réutilisable pour enregistrer une récolte
Future<void> showHarvestDialog(BuildContext context, WidgetRef ref, Planting planting) async {
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  await showDialog(
    context: context,
    builder: (dctx) => AlertDialog(
      title: Text('Récolte: ${planting.plantName}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _quantityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Quantité (optionnel)'),
              validator: (v) {
                if (v != null && v.trim().isNotEmpty) {
                  final d = double.tryParse(v.trim().replaceAll(',', '.'));
                  if (d == null || d < 0) return 'Quantité invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optionnel)'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(dctx).pop(), child: const Text('Annuler')),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            final raw = _quantityController.text.trim();
            final double? qty = raw.isEmpty ? null : double.tryParse(raw.replaceAll(',', '.'));
            final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();
            Navigator.of(dctx).pop();

            // Appel métier : utiliser recordHarvest si disponible, sinon fallback sur updatePlanting
            final notifier = ref.read(plantingProvider.notifier);
            bool success = false;
            try {
              // Si recordHarvest existe, l'utiliser
              if ((notifier as dynamic).recordHarvest != null) {
                success = await (notifier as dynamic).recordHarvest(
                  planting.id,
                  DateTime.now(),
                  quantity: qty,
                  notes: notes,
                );
              } else {
                // Fallback robuste : update status à 'Récolté' + actualHarvestDate
                final updated = planting.copyWith(
                  status: 'Récolté',
                  actualHarvestDate: DateTime.now(),
                );
                success = await notifier.updatePlanting(updated);
              }
            } catch (e) {
              success = false;
            }

            if (success && context.mounted) {
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
