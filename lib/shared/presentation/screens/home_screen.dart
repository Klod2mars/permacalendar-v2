// lib/shared/presentation/screens/home_screen.dart
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
import '../../widgets/organic_dashboard.dart';

/// HomeScreen - écran d'accueil principal
/// Regroupe : météo, mes jardins, intelligence végétale (dashboard organique),
/// activité récente.
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

    final weatherAsync =
        ref.watch(weatherByCommuneProvider(selectedCommune ?? fallbackCommune));

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
        onRefresh: () async {
          await ref.read(gardenProvider.notifier).loadGardens();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWeatherHome(context, theme, weatherAsync),
              const SizedBox(height: 24),
              _buildQuickActions(context, theme, gardenState, ref),
              const SizedBox(height: 24),
              _buildIntelligenceSection(context, theme),
              const SizedBox(height: 24),
              _buildRecentActivity(context, theme, ref),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // Weather Home
  // ============================
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
            // splitByToday() expected on WeatherViewData.result (existing in project)
            final result = data.result;
            final splitted = result.splitByToday();
            final past = splitted.$1;
            final forecast = splitted.$2;
            final todayPrecip = forecast.isNotEmpty ? forecast.first.precipMm : 0.0;

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
                _buildPrecipChips(theme, 'Historique (7 jours)', past.take(7).toList()),
                const SizedBox(height: 12),
                _buildPrecipChips(theme, 'Prévisions (7 jours)', forecast.take(7).toList()),
                const SizedBox(height: 12),
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

  Widget _buildPrecipChips(ThemeData theme, String label, List<DailyWeatherPoint> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: points.cast<DailyWeatherPoint>().map<Widget>((DailyWeatherPoint p) {
            final d = '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}';
            return Chip(
              label: Text('$d • ${p.precipMm.toStringAsFixed(1)} mm'),
              avatar: const Icon(Icons.grain, size: 16),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrecipDetails(ThemeData theme, String label, List<DailyWeatherPoint> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Column(
          children: points.cast<DailyWeatherPoint>().map<Widget>((DailyWeatherPoint p) {
            final d = '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}/${p.date.year}';
            final tRange = (p.tMinC != null && p.tMaxC != null) ? ' • ${p.tMinC!.toStringAsFixed(0)}–${p.tMaxC!.toStringAsFixed(0)}°C' : '';
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
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ============================
  // Quick actions / Gardens
  // ============================
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
                  final screenWidth = constraints.maxWidth;
                  int crossAxisCount;
                  double childAspectRatio;

                  if (screenWidth < 600) {
                    crossAxisCount = 1;
                    childAspectRatio = 2.0;
                  } else if (screenWidth < 900) {
                    crossAxisCount = 2;
                    childAspectRatio = 2.0;
                  } else {
                    crossAxisCount = 3;
                    childAspectRatio = 2.0;
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
                              onTap: () => context.push('/gardens/${garden.id}'),
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

  // ============================
  // Intelligence section (organic dashboard + quick actions)
  // ============================
  Widget _buildIntelligenceSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intelligence Végétale',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: OrganicDashboardWidget(
              assetPath: 'assets/images/backgrounds/organic_dashboard.png',
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Quick access buttons related to intelligence
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.recommendations),
              icon: const Icon(Icons.lightbulb, size: 20),
              label: const Text('Recommandations'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.notifications),
              icon: const Icon(Icons.notifications, size: 20),
              label: const Text('Notifications'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.intelligenceSettings),
              icon: const Icon(Icons.settings, size: 20),
              label: const Text('Paramètres intelligence'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.pestObservation),
              icon: const Icon(Icons.bug_report, size: 20),
              label: const Text('Observation nuisibles'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================
  // Recent Activity (placeholder)
  // ============================
  Widget _buildRecentActivity(BuildContext context, ThemeData theme, WidgetRef ref) {
    // Use ActivityTrackerV3 provider if available; otherwise placeholder
    final trackerProvider = v3.activityTrackerV3Provider;
    final activityAsync = ref.watch(trackerProvider);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: activityAsync.when(
          loading: () => const LoadingWidget(),
          error: (e, st) => ErrorStateWidget(
            title: 'Activités indisponibles',
            subtitle: e.toString(),
            retryText: 'Réessayer',
            onRetry: () {},
          ),
          data: (data) {
            // data is expected to be a list or view model; show simplified view
            final items = (data is List) ? data.cast<dynamic>().take(5).toList() : <dynamic>[];

            if (items.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activité récente',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text('Aucune activité récente.'),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activité récente',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...items.map<Widget>((it) {
                  // Render a minimal row per activity; the exact fields depend on your model
                  final title = (it?.toString() ?? 'Activité');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.history, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(title)),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
