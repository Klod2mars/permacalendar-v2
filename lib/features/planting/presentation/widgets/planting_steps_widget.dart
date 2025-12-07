// lib/features/planting/presentation/widgets/planting_steps_widget.dart
import 'package:flutter/material.dart';

import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../core/models/planting.dart';
import '../../domain/plant_step.dart';
import '../../domain/plant_steps_generator.dart';

typedef OnAddCareAction = Future<void> Function(String action);
typedef OnMarkDone = Future<void> Function(PlantStep step);

/// Widget d'affichage du pas-à-pas (compact / détaillé).
class PlantingStepsWidget extends StatefulWidget {
  final PlantFreezed plant;
  final Planting planting;
  final OnAddCareAction? onAddCareAction;
  final OnMarkDone? onMarkDone;

  const PlantingStepsWidget({
    Key? key,
    required this.plant,
    required this.planting,
    this.onAddCareAction,
    this.onMarkDone,
  }) : super(key: key);

  @override
  State<PlantingStepsWidget> createState() => _PlantingStepsWidgetState();
}

class _PlantingStepsWidgetState extends State<PlantingStepsWidget> {
  bool _expanded = false;

  List<PlantStep> get _computedSteps =>
      generateSteps(widget.plant, widget.planting);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = _computedSteps;

    final toShow = _expanded ? steps : steps.take(3).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pas-à-pas',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        // Quick add: show dialog minimal
                        final action = await _showAddActionDialog(context);
                        if (action != null && action.trim().isNotEmpty) {
                          if (widget.onAddCareAction != null) {
                            await widget.onAddCareAction!(action.trim());
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 6),
                          Text('Ajouter',
                              style:
                                  TextStyle(color: theme.colorScheme.primary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => setState(() => _expanded = !_expanded),
                      child: Text(_expanded ? 'Voir moins' : 'Voir tout'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (toShow.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.flag,
                        size: 40,
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.6)),
                    const SizedBox(height: 8),
                    Text('Aucune étape recommandée',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              )
            else
              Column(
                children: toShow.map((s) => _buildStepTile(s)).toList(),
              ),
            if (!_expanded && steps.length > 3) ...[
              const SizedBox(height: 8),
              Text('+ ${steps.length - 3} autres étapes',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile(PlantStep step) {
    final theme = Theme.of(context);
    final completed = step.completed ||
        widget.planting.careActions
            .any((a) => a.toLowerCase().contains(step.title.toLowerCase()));

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor:
            completed ? Colors.green.shade100 : Colors.grey.shade200,
        child: Icon(
          completed ? Icons.check : Icons.arrow_forward,
          size: 18,
          color: completed ? Colors.green.shade700 : Colors.black54,
        ),
      ),
      title: Row(
        children: [
          Expanded(
              child: Text(step.title,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600))),
          if (step.recommended && !completed)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Prédiction',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.blue.shade700, fontSize: 10)),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (step.description.isNotEmpty) Text(step.description),
          if (step.scheduledDate != null)
            Text(
              'Le ${_formatDate(step.scheduledDate!)}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
        ],
      ),
      trailing: completed
          ? TextButton(
              onPressed: () async {
                // Option to unmark? For now, do nothing
              },
              child:
                  Text('Fait', style: TextStyle(color: Colors.green.shade700)),
            )
          : ElevatedButton(
              onPressed: () async {
                if (widget.onMarkDone != null) {
                  await widget.onMarkDone!(step);
                  setState(() {});
                }
              },
              child: const Text('Marquer fait'),
            ),
    );
  }

  Future<String?> _showAddActionDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final res = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter étape'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ex: Paillage léger'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
              child: const Text('Ajouter')),
        ],
      ),
    );
    return res;
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
