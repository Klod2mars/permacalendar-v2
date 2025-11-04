import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app_router.dart';
import '../../../core/services/open_meteo_service.dart';
import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import '../../../core/models/garden_state.dart';
import '../../../features/garden/widgets/garden_card_with_real_area.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/loading_widgets.dart';
import '../../../features/weather/providers/weather_provider.dart';
import '../../../features/weather/providers/commune_provider.dart';
import '../../../core/providers/activity_tracker_v3_provider.dart' as v3;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final theme = Theme.of(context);
    final selectedCommune = ref.watch(selectedCommuneProvider);
    final fallbackCommune = gardenState.gardens.isNotEmpty
        ? gardenState.gardens.first.location
        : null;
    final weatherAsync = ref.watch(
      weatherByCommuneProvider(selectedCommune ?? fallbackCommune),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PermaCalendar 2.0',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
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
              // Météo (Open-Meteo)
              _buildWeatherHome(context, theme, weatherAsync),
              const SizedBox(height: 24),

              // Mes Jardins (sélection rapide)
              _buildQuickActions(context, theme, gardenState, ref),
              const SizedBox(height: 24),

              // Intelligence Végétale
              _buildIntelligenceSection(context, theme),
              const SizedBox(height: 24),

              // Recent Activity (placeholder for now)
              _buildRecentActivity(context, theme, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherHome(
    BuildContext context,
    ThemeData theme,
    AsyncValue<WeatherViewData> weatherAsync,
  ) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: weatherAsync.when(
          loading: () => const LoadingWidget(),
          error: (e, st) => ErrorStateWidget(
            title: 'Météo indisponible',
            subtitle: e.toString(),
            retryText: 'Réessayer',
            onRetry: () {},
          ),
          data: (data) {
            final (past, forecast) = data.result.splitByToday();
            final todayPrecip =
                forecast.isNotEmpty ? forecast.first.precipMm : 0.0;
            return ExpansionTile(
              tilePadding: EdgeInsets.zero,
              initiallyExpanded: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Météo — ${data.locationLabel}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pluie aujourd\'hui: ${todayPrecip.toStringAsFixed(1)} mm',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.wb_sunny, color: Colors.orange),
                ],
              ),
              children: [
                const SizedBox(height: 12),
                // Aperçu compact: derniers 7 jours
                _buildPrecipChips(
                    theme, 'Historique (7 jours)', past.take(7).toList()),
                const SizedBox(height: 12),
                // Aperçu compact: prochains 7 jours
                _buildPrecipChips(
                    theme, 'Prévisions (7 jours)', forecast.take(7).toList()),
                const SizedBox(height: 12),
                // Détails développés
                _buildPrecipDetails(theme, 'Historique complet', past),
                const SizedBox(height: 12),
                _buildPrecipDetails(theme, 'Prévisions détaillées', forecast),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => context.push(AppRoutes.settings),
                    icon: const Icon(Icons.location_city),
                    label: const Text('Choisir ma commune'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrecipChips(
      ThemeData theme, String label, List<DailyWeatherPoint> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: points
              .cast<DailyWeatherPoint>()
              .map<Widget>((DailyWeatherPoint p) {
            final d =
                '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}';
            return Chip(
              label: Text('$d • ${p.precipMm.toStringAsFixed(1)} mm'),
              avatar: const Icon(Icons.grain, size: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrecipDetails(
      ThemeData theme, String label, List<DailyWeatherPoint> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Column(
          children: points
              .cast<DailyWeatherPoint>()
              .map<Widget>((DailyWeatherPoint p) {
            final d =
                '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}/${p.date.year}';
            final tRange = (p.tMinC != null && p.tMaxC != null)
                ? ' • ${p.tMinC!.toStringAsFixed(0)}–${p.tMaxC!.toStringAsFixed(0)}°C'
                : '';
            return Row(
              children: [
                Expanded(
                  child: Text(
                    d,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '${p.precipMm.toStringAsFixed(1)} mm$tRange',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    ThemeData theme,
    GardenState gardenState,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mes jardins',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // États de chargement et d'erreur
        if (gardenState.isLoading)
          const ListLoadingWidget(itemCount: 4)
        else if (gardenState.error != null)
          ErrorStateWidget(
            title: 'Erreur lors du chargement des jardins',
            subtitle: gardenState.error,
            retryText: 'Réessayer',
            onRetry: () => ref.read(gardenProvider.notifier).loadGardens(),
          )
        else if (gardenState.gardens.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.yard, color: theme.colorScheme.outline),
                      const SizedBox(width: 8),
                      Text(
                        'Aucun jardin',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Créez votre premier jardin pour commencer.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.push(AppRoutes.gardenCreate),
                        icon: const Icon(Icons.add),
                        label: const Text('Créer un jardin'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.push(AppRoutes.gardens),
                        icon: const Icon(Icons.list),
                        label: const Text('Voir tous les jardins'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calcul adaptatif du nombre de colonnes selon la largeur de l'écran
                  final screenWidth = constraints.maxWidth;
                  int crossAxisCount;
                  double childAspectRatio;

                  if (screenWidth < 600) {
                    // Écrans petits (téléphones) - rectangles équivalents à 2 carrés superposés
                    crossAxisCount = 1;
                    childAspectRatio = 2.0; // Rectangle horizontal (2:1)
                  } else if (screenWidth < 900) {
                    // Écrans moyens (tablettes) - 2 colonnes de rectangles
                    crossAxisCount = 2;
                    childAspectRatio = 2.0; // Rectangle horizontal (2:1)
                  } else {
                    // Grands écrans - 3 colonnes de rectangles
                    crossAxisCount = 3;
                    childAspectRatio = 2.0; // Rectangle horizontal (2:1)
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
                    children: gardenState.gardens
                        .take(6)
                        .map<Widget>((garden) => GardenCardWithRealArea(
                              garden: garden,
                              onTap: () =>
                                  context.push('/gardens/${garden.id}'),
                              showActions: false,
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.push(AppRoutes.gardenCreate),
                  icon: const Icon(Icons.add),
                  label: const Text('Créer un jardin'),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildIntelligenceSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intelligence Végétale',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: InkWell(
            onTap: () {
              print(
                  '🔴🔴🔴 [DIAGNOSTIC CRITIQUE] HomeScreen - Clic sur Intelligence Végétale 🔴🔴🔴');
              print(
                  '🔴🔴🔴 [DIAGNOSTIC CRITIQUE] Navigation vers: ${AppRoutes.intelligence} 🔴🔴🔴');
              context.push(AppRoutes.intelligence);
              print(
                  '🔴🔴🔴 [DIAGNOSTIC CRITIQUE] context.push() exécuté 🔴🔴🔴');
            },
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
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.secondary.withOpacity(0.1),
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
                          'Analysez vos plantes avec l\'IA',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Obtenez des recommandations personnalisées pour optimiser la santé de vos plantes',
                          style: theme.textTheme.bodyMedium?.copyWith(
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
        ),
        const SizedBox(height: 12),
        // Boutons d'accès rapide (optimisés pour mobile)
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.recommendations),
              icon: const Icon(Icons.lightbulb, size: 20),
              label: const Text('Recommandations'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.notifications),
              icon: const Icon(Icons.notifications, size: 20),
              label: const Text('Notifications'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.intelligenceSettings),
              icon: const Icon(Icons.settings, size: 20),
              label: const Text('Paramètres'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(
      BuildContext context, ThemeData theme, WidgetRef ref) {
    // ✅ NOUVEAU : Utiliser le nouveau provider ActivityTrackerV3
    final recentActivitiesAsync = ref.watch(v3.recentActivitiesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox
                        .shrink(), // Placeholder pour maintenir l'alignement
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.activities);
                      },
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
                recentActivitiesAsync.when(
                  data: (activities) {
                    // ✅ NOUVEAU : Afficher les 2-3 dernières activités avec le nouveau système
                    final displayActivities = activities.take(3).toList();

                    if (displayActivities.isEmpty) {
                      return _buildEmptyActivitiesState(theme);
                    }

                    return Column(
                      children: displayActivities
                          .map(
                              (activity) => _buildActivityItem(activity, theme))
                          .toList(),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 32,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Erreur de chargement',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              // ✅ NOUVEAU : Rafraîchir le nouveau provider
                              ref.refresh(v3.recentActivitiesProvider);
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Réessayer'),
                            style: TextButton.styleFrom(
                              textStyle: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ✅ NOUVEAU : Widget pour l'état vide des activités
  Widget _buildEmptyActivitiesState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'Aucune activité récente',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Les activités de jardinage apparaîtront ici',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ NOUVEAU : Widget pour afficher une activité individuelle
  Widget _buildActivityItem(activity, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Icône de l'activité
          CircleAvatar(
            radius: 16,
            backgroundColor: _getActivityColor(activity.type).withOpacity(0.1),
            child: Icon(
              _getActivityIcon(activity.type),
              color: _getActivityColor(activity.type),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          // Contenu de l'activité
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: activity.priority > 0
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Indicateur de priorité
          if (activity.priority > 0)
            Icon(
              activity.priority == 2 ? Icons.warning : Icons.priority_high,
              color: activity.priority == 2 ? Colors.red : Colors.orange,
              size: 16,
            ),
        ],
      ),
    );
  }

  // ✅ NOUVEAU : Obtenir l'icône selon le type d'activité
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
      case 'maintenanceCompleted':
        return Icons.build;
      case 'weatherUpdate':
        return Icons.wb_sunny;
      default:
        return Icons.info;
    }
  }

  // ✅ NOUVEAU : Obtenir la couleur selon le type d'activité
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
      case 'maintenanceCompleted':
        return Colors.brown;
      case 'weatherUpdate':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  // ✅ NOUVEAU : Formater le timestamp
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
}
