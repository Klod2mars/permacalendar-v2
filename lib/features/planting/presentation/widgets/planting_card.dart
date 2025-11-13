import 'package:flutter/material.dart';

import '../../../../core/models/planting.dart';
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
          // Header with plant name and status
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
                      value: 'care',
                      child: Row(
                        children: [
                          Icon(Icons.healing),
                          SizedBox(width: 8),
                          Text('Ajouter soin'),
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

          // Planting details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.calendar_today,
                  'Planté le',
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

          // Progress indicator for growing plants
          if (planting.status == 'Planté' &&
              planting.expectedHarvestStartDate != null) ...[
            const SizedBox(height: 12),
            _buildProgressIndicator(theme),
          ],

          // Care actions
          if (planting.careActions.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildCareActions(theme),
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

          // Footer with creation date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Créé le ${_formatDate(planting.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              if (planting.updatedAt != planting.createdAt)
                Text(
                  'Modifié le ${_formatDate(planting.updatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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

  Widget _buildCareActions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions de soin (${planting.careActions.length})',
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
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                action,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
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
      case 'care':
        _showCareActionDialog(context);
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
          children: Planting.statusOptions.map((status) {
            if (status == planting.status) return const SizedBox.shrink();

            return ListTile(
              title: Text(status),
              onTap: () {
                Navigator.of(context).pop();
                onStatusChange?.call(status);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showCareActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une action de soin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Planting.commonCareActions.map((action) {
            return ListTile(
              title: Text(action),
              onTap: () {
                Navigator.of(context).pop();
                onAddCareAction?.call(action);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
}


