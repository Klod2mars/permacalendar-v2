import 'package:flutter/material.dart';

import '../../../../core/models/garden_bed.dart';
import '../../../../shared/widgets/custom_card.dart';

class GardenBedCard extends StatelessWidget {
  final GardenBed gardenBed;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Widget? extraContent;

  const GardenBedCard({
    super.key,
    required this.gardenBed,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and actions
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gardenBed.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (gardenBed.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        gardenBed.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Status indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gardenBed.isActive
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  gardenBed.isActive ? 'Actif' : 'Inactif',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: gardenBed.isActive
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Actions menu
              PopupMenuButton<String>(
                onSelected: (value) => _handleAction(value),
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

          // Garden bed details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.straighten,
                  'Surface',
                  gardenBed.formattedSize,
                  theme,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  Icons.terrain,
                  'Sol',
                  gardenBed.soilType,
                  theme,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  _getExposureIcon(gardenBed.exposure),
                  'Exposition',
                  gardenBed.exposure,
                  theme,
                ),
              ),
            ],
          ),

          if (gardenBed.notes != null && gardenBed.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.3),
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
                      gardenBed.notes ?? '',
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

          // Extra content (e.g., germination preview)
          if (extraContent != null) ...[
            const SizedBox(height: 12),
            extraContent!,
          ],

          const SizedBox(height: 12),

          // Footer with creation date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CrÃ©Ã© le ${_formatDate(gardenBed.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              if (gardenBed.updatedAt != gardenBed.createdAt)
                Text(
                  'ModifiÃ© le ${_formatDate(gardenBed.updatedAt)}',
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handleAction(String action) {
    switch (action) {
      case 'edit':
        onEdit?.call();
        break;
      case 'delete':
        onDelete?.call();
        break;
    }
  }
}



