import 'package:flutter/material.dart';
import '../../../core/models/garden_freezed.dart';
import '../../../shared/widgets/custom_card.dart';

/// Widget de carte pour afficher les informations d'un jardin
/// Utilise le design Material 3 cohérent avec l'application
class GardenCard extends StatelessWidget {
  /// Le jardin à afficher
  final GardenFreezed garden;

  /// Callback appelé lors du tap sur la carte
  final VoidCallback? onTap;

  /// Callback appelé lors de l'édition du jardin
  final VoidCallback? onEdit;

  /// Callback appelé lors de la suppression du jardin
  final VoidCallback? onDelete;

  /// Callback appelé lors du changement de statut du jardin
  final VoidCallback? onToggleStatus;

  /// Afficher ou masquer les actions (défaut: true)
  final bool showActions;

  const GardenCard({
    super.key,
    required this.garden,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header avec nom à gauche et surface à droite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom du jardin (centré à gauche)
                Expanded(
                  child: Text(
                    garden.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                // Surface totale (en haut à droite)
                Text(
                  garden.totalAreaInSquareMeters > 0
                      ? '${garden.totalAreaInSquareMeters.toStringAsFixed(0)} m²'
                      : '-- m²',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            // Espace vide pour les futures informations
            const Expanded(
              child: SizedBox(),
            ),

            // Actions compactes en bas (si activées)
            if (showActions &&
                (onEdit != null ||
                    onDelete != null ||
                    onToggleStatus != null)) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      tooltip: 'Modifier',
                      style: IconButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  if (onToggleStatus != null)
                    IconButton(
                      onPressed: onToggleStatus,
                      icon: Icon(
                        garden.isActive ? Icons.pause : Icons.play_arrow,
                        size: 16,
                      ),
                      tooltip: garden.isActive ? 'Désactiver' : 'Activer',
                      style: IconButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16),
                      tooltip: 'Supprimer',
                      style: IconButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        padding: const EdgeInsets.all(4),
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget compact pour afficher une information avec icône
  Widget _buildCompactInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$label: $value',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Widget pour afficher une information avec icône (version originale conservée pour compatibilité)
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


