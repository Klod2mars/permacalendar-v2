// lib/features/planting/presentation/widgets/planting_card.dart
import 'package:flutter/material.dart';

import '../../../../core/models/planting.dart';
import '../../../../core/utils/planting_utils.dart';
import '../../../../shared/widgets/custom_card.dart';

class PlantingCard extends StatelessWidget {
  final Planting planting;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onStatusChange;
  final VoidCallback? onHarvest;
  final Function(String)? onAddCareAction;

  const PlantingCard({
    super.key,
    required this.planting,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
    this.onHarvest,
    this.onAddCareAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: nom + quantité + statut + menu
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planting.plantName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.numbers,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Quantité: ${planting.quantity}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(planting.status, theme),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  planting.status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getStatusTextColor(planting.status, theme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Actions menu
              PopupMenuButton<String>(
                onSelected: (value) => _handleAction(value, context),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  if (planting.status != 'Récolté' &&
                      planting.status != 'Échoué') ...[
                    const PopupMenuItem(
                      value: 'status',
                      child: Row(
                        children: [
                          Icon(Icons.update),
                          SizedBox(width: 8),
                          Text('Changer statut'),
                        ],
                      ),
                    ),
                    if (planting.status == 'Prêt à récolter')
                      const PopupMenuItem(
                        value: 'harvest',
                        child: Row(
                          children: [
                            Icon(Icons.agriculture, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Récolter'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'steps',
                      child: Row(
                        children: [
                          Icon(Icons.flag),
                          SizedBox(width: 8),
                          Text('Ajouter étape'),
                        ],
                      ),
                    ),
                  ],
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // DETAILS: plantation / récolte prévue / récolté
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.calendar_today,
                  planting.status == 'Semé' ? 'Semé le' : 'Planté le',
                  _formatDate(planting.plantedDate),
                  theme,
                ),
              ),
              if (planting.expectedHarvestStartDate != null)
                Expanded(
                  child: _buildDetailItem(
                    Icons.schedule,
                    'Récolte prévue',
                    _formatDate(planting.expectedHarvestStartDate!),
                    theme,
                  ),
                ),
              if (planting.actualHarvestDate != null)
                Expanded(
                  child: _buildDetailItem(
                    Icons.agriculture,
                    'Récolté le',
                    _formatDate(planting.actualHarvestDate!),
                    theme,
                  ),
                ),
            ],
          ),

          // Progression (uniquement pour 'Planté' et si dates existantes)
          if (planting.status == 'Planté' &&
              planting.expectedHarvestStartDate != null) ...[
            const SizedBox(height: 12),
            _buildProgressIndicator(theme),
          ],

          // Étapes (anciennement "Care Actions")
          if (planting.careActions.isNotEmpty ||
              planting.careActions.length == 0) ...[
            const SizedBox(height: 12),
            _buildSteps(theme),
          ],

          // Notes
          if (planting.notes != null && planting.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      planting.notes!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Footer: Créé / Modifié — n'affiche "Créé" que si différent de plantedDate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (planting.createdAt != planting.plantedDate)
                Text(
                  'Créé le ${_formatDate(planting.createdAt)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
              if (planting.updatedAt != planting.createdAt)
                Text(
                  'Modifié le ${_formatDate(planting.updatedAt)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      IconData icon, String label, String value, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    final now = DateTime.now();
    final totalDays = planting.expectedHarvestStartDate!
        .difference(planting.plantedDate)
        .inDays;
    final elapsedDays = now.difference(planting.plantedDate).inDays;
    final progress =
        totalDays > 0 ? (elapsedDays / totalDays).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? Colors.green : theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSteps(ThemeData theme) {
    // On conserve la structure de stockage existante : planting.careActions (compatibility)
    // On affiche le compteur et la liste (les premières 5 valeurs) comme précédemment,
    // mais on renomme l'intitulé en "Étapes".
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Étapes (${planting.careActions.length})',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: planting.careActions.take(5).map((action) {
            // Action affichée en tant que texte (ex: "Arrosage - 2025-12-03T...")
            final label = action.split(' - ').first;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSecondaryContainer),
              ),
            );
          }).toList(),
        ),
        if (planting.careActions.length > 5)
          Text(
            '+${planting.careActions.length - 5} autres...',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté':
        return Colors.blue.withOpacity(0.2);
      case 'En croissance':
        return Colors.green.withOpacity(0.2);
      case 'Prêt à récolter':
        return Colors.orange.withOpacity(0.2);
      case 'Récolté':
        return Colors.green.withOpacity(0.3);
      case 'Échoué':
        return Colors.red.withOpacity(0.2);
      default:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getStatusTextColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté':
        return Colors.blue.shade700;
      case 'En croissance':
        return Colors.green.shade700;
      case 'Prêt à récolter':
        return Colors.orange.shade700;
      case 'Récolté':
        return Colors.green.shade800;
      case 'Échoué':
        return Colors.red.shade700;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handleAction(String action, BuildContext context) {
    switch (action) {
      case 'edit':
        onEdit?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
      case 'status':
        _showStatusChangeDialog(context);
        break;
      case 'harvest':
        onHarvest?.call();
        break;
      case 'steps':
        _showStepActionDialog(context);
        break;
      case 'care': // compatibilité ancienne valeur si elle existe ailleurs
        _showStepActionDialog(context);
        break;
    }
  }

  void _showStatusChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Planting.statusOptions.map((statusOption) {
            if (statusOption == planting.status) return const SizedBox.shrink();
            return ListTile(
              title: Text(statusOption),
              onTap: () {
                Navigator.of(context).pop();
                // préférer le callback pour la persistance (notifier / provider)
                if (onStatusChange != null) {
                  onStatusChange!(statusOption);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStepActionDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter étape'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Liste d'actions communes (depuis Planting.commonCareActions)
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: Planting.commonCareActions.map((a) {
                    return ListTile(
                      title: Text(a),
                      onTap: () {
                        Navigator.of(context).pop();
                        onAddCareAction?.call(a);
                      },
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Autre étape',
                  hintText: 'Ex: Paillage léger',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop();
                onAddCareAction?.call(text);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
