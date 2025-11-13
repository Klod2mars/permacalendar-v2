import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/activity_tracker_v3_provider.dart';
import '../../../../core/models/activity_v3.dart';
import '../../../../shared/widgets/custom_card.dart';

/// Écran pour afficher toutes les activités
class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> {
  String _selectedFilter = 'Toutes';

  final List<String> _filters = [
    'Toutes',
    'Jardins',
    'Parcelles',
    'Plantations',
    'Germination',
    'Récoltes',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(recentActivitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les Activités'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(recentActivitiesProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Liste des activités
          Expanded(
            child: activitiesAsync.when(
              data: (activities) {
                final filteredActivities =
                    _filterActivities(activities, _selectedFilter);

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
                      return _buildActivityCard(activity, theme);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(error, theme),
            ),
          ),
        ],
      ),
    );
  }

  List<ActivityV3> _filterActivities(
      List<ActivityV3> activities, String filter) {
    if (filter == 'Toutes') return activities;

    return activities.where((activity) {
      switch (filter) {
        case 'Jardins':
          return activity.type.contains('garden');
        case 'Parcelles':
          return activity.type.contains('bed');
        case 'Plantations':
          return activity.type.contains('planting');
        case 'Germination':
          return activity.type.contains('germination');
        case 'Récoltes':
          return activity.type.contains('harvest');
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildActivityCard(ActivityV3 activity, ThemeData theme) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildActivityIcon(activity, theme),
        title: Text(
          activity.description,
          style: theme.textTheme.bodyLarge?.copyWith(
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
            'Les activités de jardinage apparaîtront ici',
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

  String _formatMetadata(Map<String, dynamic> metadata) {
    final entries = metadata.entries.take(2).toList();
    return entries.map((e) => '${e.key}: ${e.value}').join(', ');
  }
}


