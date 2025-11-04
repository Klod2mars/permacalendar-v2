import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_router.dart';
import '../../../core/providers/activity_tracker_v3_provider.dart' as v3;
import '../../../features/garden/providers/garden_provider.dart';
import '../../../features/planting/providers/planting_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/quick_harvest_widget.dart';

/// Version optimisée de l'écran d'accueil avec navigation simplifiée
class HomeScreenOptimized extends ConsumerWidget {
  const HomeScreenOptimized({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final theme = Theme.of(context);
    final readyForHarvest = ref.watch(plantingsReadyForHarvestProvider);
    final recentActivities = ref.watch(v3.recentActivitiesProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PermaCalendar',
        actions: [
          // Accès rapide au calendrier
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push('/calendar'),
            tooltip: 'Calendrier',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(gardenProvider.notifier).loadGardens(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Actions rapides prioritaires
              _buildQuickActions(context, theme, readyForHarvest.length),
              const SizedBox(height: 24),

              // Mes jardins (simplifié)
              _buildMyGardens(context, theme, gardenState, ref),
              const SizedBox(height: 24),

              // Aperçu des activités récentes
              _buildRecentActivitiesCompact(context, theme, recentActivities),
              const SizedBox(height: 24),

              // Intelligence végétale (accès rapide)
              _buildIntelligenceQuickAccess(context, theme),
            ],
          ),
        ),
      ),
      floatingActionButton: readyForHarvest.isNotEmpty
          ? const QuickHarvestFAB()
          : FloatingActionButton.extended(
              onPressed: () => _showQuickCreate(context),
              icon: const Icon(Icons.add),
              label: const Text('Créer'),
            ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, ThemeData theme, int harvestCount) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions rapides',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Grille d'actions rapides (2x2)
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionTile(
                    context,
                    'Calendrier',
                    'Voir plantations',
                    Icons.calendar_month,
                    theme.colorScheme.primary,
                    () => context.push('/calendar'),
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionTile(
                    context,
                    'Récolter',
                    '$harvestCount prête(s)',
                    Icons.agriculture,
                    Colors.green,
                    () {
                      showDialog(
                        context: context,
                        builder: (context) => const QuickHarvestWidget(),
                      );
                    },
                    theme,
                    badge: harvestCount > 0 ? harvestCount : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionTile(
                    context,
                    'Planter',
                    'Nouvelle plantation',
                    Icons.eco,
                    Colors.lightGreen,
                    () => _showQuickPlanting(context),
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionTile(
                    context,
                    'Intelligence',
                    'Analyses IA',
                    Icons.psychology,
                    theme.colorScheme.secondary,
                    () => context.push(AppRoutes.intelligence),
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeData theme, {
    int? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (badge != null && badge > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyGardens(
    BuildContext context,
    ThemeData theme,
    dynamic gardenState,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mes jardins',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push(AppRoutes.gardens),
              icon: const Icon(Icons.chevron_right),
              label: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (gardenState.gardens.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.yard,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucun jardin',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Créez votre premier jardin pour commencer',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.gardenCreate),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer un jardin'),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gardenState.gardens.take(5).length,
              itemBuilder: (context, index) {
                try {
                  final garden = gardenState.gardens[index];
                  // Skip null or invalid gardens
                  if (garden == null) return const SizedBox.shrink();
                  return _buildGardenChip(garden, context, theme, ref);
                } catch (e) {
                  // Fallback for any error in rendering a garden card
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Erreur',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildGardenChip(
      dynamic garden, BuildContext context, ThemeData theme, WidgetRef ref) {
    // Add null safety checks
    if (garden == null || garden.name == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          try {
            context.push('/gardens/${garden.id}');
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Impossible d\'ouvrir le jardin: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.secondaryContainer,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.park,
                    color: theme.colorScheme.primary,
                  ),
                  if (!garden.isActive) ...[
                    const Spacer(),
                    Icon(
                      Icons.archive,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garden.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    garden.location,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesCompact(
    BuildContext context,
    ThemeData theme,
    AsyncValue<List> activities,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activité récente',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => context.push(AppRoutes.activities),
              icon: const Icon(Icons.chevron_right),
              label: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        activities.when(
          data: (list) {
            if (list.isEmpty) {
              return CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Aucune activité récente',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }

            return CustomCard(
              child: Column(
                children: list.take(3).map((activity) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          _getActivityColor(activity.type).withOpacity(0.1),
                      child: Icon(
                        _getActivityIcon(activity.type),
                        color: _getActivityColor(activity.type),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      activity.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      _formatTimestamp(activity.timestamp),
                      style: theme.textTheme.bodySmall,
                    ),
                    dense: true,
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Erreur de chargement',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntelligenceQuickAccess(BuildContext context, ThemeData theme) {
    return CustomCard(
      child: InkWell(
        onTap: () => context.push(AppRoutes.intelligence),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.2),
                      theme.colorScheme.secondary.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intelligence Végétale',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Analyses IA • Recommandations • Alertes',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: theme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickCreate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Création rapide',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.park, color: Colors.green),
              title: const Text('Créer un jardin'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.gardenCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view, color: Colors.blue),
              title: const Text('Créer une planche'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigation vers création de planche
              },
            ),
            ListTile(
              leading: const Icon(Icons.eco, color: Colors.lightGreen),
              title: const Text('Nouvelle plantation'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                _showQuickPlanting(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickPlanting(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plantation rapide - À implémenter'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'gardenCreated':
      case 'gardenUpdated':
        return Icons.park;
      case 'gardenBedCreated':
      case 'gardenBedUpdated':
        return Icons.grid_view;
      case 'plantingCreated':
      case 'plantingUpdated':
        return Icons.eco;
      case 'harvestCompleted':
        return Icons.agriculture;
      default:
        return Icons.info;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'gardenCreated':
      case 'gardenUpdated':
        return Colors.green;
      case 'gardenBedCreated':
      case 'gardenBedUpdated':
        return Colors.blue;
      case 'plantingCreated':
      case 'plantingUpdated':
        return Colors.lightGreen;
      case 'harvestCompleted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
      return 'Il y a ${difference.inDays} j';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
