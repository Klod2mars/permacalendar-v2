import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/activity_tracker_v3_provider.dart';
import '../../core/models/activity_v3.dart';

/// Widget pour afficher les activités récentes
class RecentActivitiesWidget extends ConsumerWidget {
  final int maxItems;
  final bool showOnlyImportant;
  final VoidCallback? onRefresh;

  const RecentActivitiesWidget({
    super.key,
    this.maxItems = 10,
    this.showOnlyImportant = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Choisir le provider selon le type d'activités à afficher
    final activitiesProvider = showOnlyImportant
        ? importantActivitiesProvider
        : recentActivitiesProvider;

    final activitiesAsync = ref.watch(activitiesProvider);

    // Fonction de refresh
    void refreshActivities() {
      if (showOnlyImportant) {
        ref.read(importantActivitiesProvider.notifier).refresh();
      } else {
        ref.read(recentActivitiesProvider.notifier).refresh();
      }
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  showOnlyImportant
                      ? 'Activités Importantes'
                      : 'Activités Récentes',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: onRefresh ?? refreshActivities,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Actualiser',
                ),
              ],
            ),
            const SizedBox(height: 16),
            activitiesAsync.when(
              data: (activities) {
                if (activities.isEmpty) {
                  return _buildEmptyState(theme);
                }
                return _buildActivitiesList(activities, theme);
              },
              loading: () => _buildLoadingState(theme),
              error: (error, stack) => _buildErrorState(error, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune activité récente',
            style: theme.textTheme.bodyLarge?.copyWith(
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

  Widget _buildLoadingState(ThemeData theme) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(Object error, ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur lors du chargement',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(List<ActivityV3> activities, ThemeData theme) {
    final displayActivities = activities.take(maxItems).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayActivities.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final activity = displayActivities[index];
        return _buildActivityItem(activity, theme);
      },
    );
  }

  Widget _buildActivityItem(ActivityV3 activity, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: _buildActivityIcon(activity, theme),
      title: Text(
        activity.description,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight:
              activity.priority > 0 ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTimestamp(activity.timestamp),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (activity.metadata != null && activity.metadata!.isNotEmpty)
            Text(
              _formatMetadata(activity.metadata!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      trailing: _buildPriorityIndicator(activity.priority, theme),
    );
  }

  Widget _buildActivityIcon(ActivityV3 activity, ThemeData theme) {
    IconData iconData;
    Color iconColor;

    switch (activity.type) {
      case 'gardenCreated':
      case 'gardenUpdated':
        iconData = Icons.park;
        iconColor = Colors.green;
        break;
      case 'gardenBedCreated':
      case 'gardenBedUpdated':
        iconData = Icons.grid_view;
        iconColor = Colors.blue;
        break;
      case 'plantingCreated':
      case 'plantingUpdated':
        iconData = Icons.eco;
        iconColor = Colors.lightGreen;
        break;
      case 'harvestCompleted':
        iconData = Icons.agriculture;
        iconColor = Colors.orange;
        break;
      case 'maintenanceCompleted':
        iconData = Icons.build;
        iconColor = Colors.brown;
        break;
      case 'weatherUpdate':
        iconData = Icons.wb_sunny;
        iconColor = Colors.yellow;
        break;
      default:
        iconData = Icons.info;
        iconColor = theme.colorScheme.primary;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildPriorityIndicator(int priority, ThemeData theme) {
    if (priority == 0) return const SizedBox.shrink();

    Color color;
    IconData icon;

    switch (priority) {
      case 1:
        color = Colors.orange;
        icon = Icons.priority_high;
        break;
      case 2:
        color = Colors.red;
        icon = Icons.warning;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Icon(
      icon,
      color: color,
      size: 16,
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

  String _formatMetadata(Map<String, dynamic> metadata) {
    final entries = metadata.entries.take(2).toList();
    return entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }
}


