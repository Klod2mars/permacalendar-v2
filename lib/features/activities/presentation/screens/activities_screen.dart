import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/activity_tracker_v3_provider.dart';
import '../../../../core/models/activity_v3.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../garden/providers/garden_provider.dart';
import '../widgets/garden_history_widget.dart';
import '../../../../core/providers/garden_aggregation_providers.dart';

/// Écran pour afficher toutes les activités
class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gardenState = ref.watch(gardenProvider);
    final  currentGardenId = gardenState.selectedGarden?.id ?? (gardenState.gardens.isNotEmpty ? gardenState.gardens.first.id : '');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activités & Historique'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Récentes'),
              Tab(text: 'Historique'),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(recentActivitiesProvider.notifier).refresh();
                if (currentGardenId.isNotEmpty) {
                   ref.read(invalidateGardenCacheProvider(currentGardenId));
                }
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'Actualiser',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Onglet 1: Activités Récentes (Existing logic)
            _buildRecentActivitiesTab(theme, currentGardenId),
            
            // Onglet 2: Historique (New Widget)
            currentGardenId.isNotEmpty 
                ? GardenHistoryWidget(gardenId: currentGardenId)
                : const Center(child: Text("Aucun jardin sélectionné")),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesTab(ThemeData theme, String currentGardenId) {
    final activitiesAsync = ref.watch(recentActivitiesProvider);
    final gardenState = ref.watch(gardenProvider);
    
    return Column(
      children: [
        // Filtres (placeholder if needed)
        
        // Liste des activités
        Expanded(
          child: activitiesAsync.when(
            data: (activities) {
                final filteredActivities = activities;

                if (filteredActivities.isEmpty) {
                  return _buildEmptyState(theme);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(recentActivitiesProvider.notifier).refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      // Résolution du nom du jardin si manquant
                      String? gardenName = activity.metadata?['gardenName'];
                      if (gardenName == null && activity.metadata?['gardenId'] != null) {
                        final gardenId = activity.metadata!['gardenId'];
                        final garden = gardenState.gardens.firstWhere(
                          (g) => g.id == gardenId,
                          orElse: () => gardenState.gardens.first, // Fallback safe
                        );
                        // On vérifie si garden contient vraiment l'ID (le fallback returns first element, check ID to be sure)
                        if (garden.id == gardenId) {
                           gardenName = garden.name;
                        }
                      }
                      
                      return _buildActivityCard(activity, theme, gardenName);
                    },
                  ),
                );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error, theme),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(ActivityV3 activity, ThemeData theme, String? resolvedGardenName) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildActivityIcon(activity, theme),
        title: Text(
          activity.description,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: activity.priority > 0 ? FontWeight.w600 : FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (resolvedGardenName != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('•', style: theme.textTheme.bodySmall),
                  ),
                  Flexible(
                    child: Text(
                      resolvedGardenName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            if (activity.metadata != null && activity.metadata!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  _formatFriendlyMetadata(activity.metadata!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        trailing: _buildPriorityIndicator(activity.priority, theme),
      ),
    );
  }

  Widget _buildActivityIcon(ActivityV3 activity, ThemeData theme) {
    IconData iconData;
    Color iconColor;

    switch (activity.type) {
      case 'gardenCreated':
        iconData = Icons.park;
        iconColor = Colors.green;
        break;
      case 'bedCreated':
        iconData = Icons.grid_view;
        iconColor = Colors.blue;
        break;
      case 'plantingCreated':
        iconData = Icons.eco;
        iconColor = Colors.green;
        break;
      case 'germinationConfirmed':
        iconData = Icons.eco;
        iconColor = Colors.lightGreen;
        break;
      case 'plantingHarvested':
        iconData = Icons.agriculture;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.history;
        iconColor = theme.colorScheme.primary;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  Widget _buildPriorityIndicator(int priority, ThemeData theme) {
    if (priority <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority > 1
            ? Colors.red.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        priority > 1 ? 'Important' : 'Normal',
        style: TextStyle(
          fontSize: 10,
          color: priority > 1 ? Colors.red : Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune activité trouvée',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les activités de jardinage apparaÃ®tront ici',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur lors du chargement',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(recentActivitiesProvider.notifier).refresh();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatFriendlyMetadata(Map<String, dynamic> metadata) {
    final parts = <String>[];

    // Add garden / bed / plant / quantity / date / maintenance / weather
    if ((metadata['gardenName']?.toString().isNotEmpty ?? false)) {
      parts.add('Jardin: ${metadata['gardenName']}');
    }
    if ((metadata['gardenBedName']?.toString().isNotEmpty ?? false)) {
      parts.add('Parcelle: ${metadata['gardenBedName']}');
    }
    if ((metadata['plantName']?.toString().isNotEmpty ?? false)) {
      parts.add('Plante: ${metadata['plantName']}');
    }
    if (metadata.containsKey('quantity')) {
      final q = metadata['quantity'];
      final unit = metadata['unit'] ?? '';
      if (q != null) {
        parts.add('Quantité: $q${unit != '' ? ' $unit' : ''}');
      }
    }
    if (metadata.containsKey('plantingDate')) {
      final raw = metadata['plantingDate']?.toString() ?? '';
      try {
        final dt = DateTime.parse(raw);
        parts.add('Date: ${dt.day}/${dt.month}/${dt.year}');
      } catch (_) {
        if (raw.isNotEmpty) parts.add('Date: $raw');
      }
    }
    if ((metadata['maintenanceType']?.toString().isNotEmpty ?? false)) {
      parts.add('Maintenance: ${metadata['maintenanceType']}');
    }
    if ((metadata['weatherType']?.toString().isNotEmpty ?? false)) {
      parts.add('Météo: ${metadata['weatherType']}');
    }

    // If no friendly metadata found, return empty string (so nothing is rendered)
    if (parts.isEmpty) return '';

    return parts.join('\n');
  }
}
