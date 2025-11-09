// lib/shared/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

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

/// HomeScreen - Ã©cran d'accueil principal
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final theme = Theme.of(context);
    final selectedCommune = ref.watch(selectedCommuneProvider);
    final fallbackCommune = gardenState.gardens.isNotEmpty ? gardenState.gardens.first.location : null;

    final weatherAsync = ref.watch(weatherByCommuneProvider(selectedCommune ?? fallbackCommune));

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

  // ----------------------------
  // Weather section
  // ----------------------------
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
            title: 'MÃ©tÃ©o indisponible',
            subtitle: e.toString(),
            retryText: 'RÃ©essayer',
            onRetry: () {},
          ),
          data: (data) {
            // On s'attend Ã  ce que splitByToday() retourne un record (past, forecast).
            // On utilise la destructuration de record disponible en Dart 3.
            List<DailyWeatherPoint> past = <DailyWeatherPoint>[];
            List<DailyWeatherPoint> forecast = <DailyWeatherPoint>[];

            try {
              // Si splitByToday renvoie un record (List, List), utiliser la destructuration.
              final (p, f) = data.result.splitByToday();
              if (p is List<DailyWeatherPoint>) {
                past = List<DailyWeatherPoint>.from(p);
              }
              if (f is List<DailyWeatherPoint>) {
                forecast = List<DailyWeatherPoint>.from(f);
              }
            } catch (_) {
              // Fallback silencieux : si la structure diffÃ¨re, on laisse les listes vides.
            }

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
                        'MÃ©tÃ©o â€” ${data.locationLabel}',
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
                _buildPrecipChips(theme, 'PrÃ©visions (7 jours)', forecast.take(7).toList()),
                const SizedBox(height: 12),
                _buildPrecipDetails(theme, 'Historique complet', past),
                const SizedBox(height: 12),
                _buildPrecipDetails(theme, 'PrÃ©visions dÃ©taillÃ©es', forecast),
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
        Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: points.cast<DailyWeatherPoint>().map<Widget>((p) {
            final d = '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}';
            return Chip(
              label: Text('$d â€¢ ${p.precipMm.toStringAsFixed(1)} mm'),
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
        Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Column(
          children: points.cast<DailyWeatherPoint>().map<Widget>((p) {
            final d = '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}/${p.date.year}';
            final tRange = (p.tMinC != null && p.tMaxC != null) ? ' â€¢ ${p.tMinC!.toStringAsFixed(0)}â€“${p.tMaxC!.toStringAsFixed(0)}Â°C' : '';
            return Row(
              children: [
                Expanded(child: Text(d, style: theme.textTheme.bodyMedium)),
                Text('${p.precipMm.toStringAsFixed(1)} mm$tRange', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // ----------------------------
  // Gardens / Quick Actions
  // ----------------------------
  Widget _buildQuickActions(BuildContext context, ThemeData theme, GardenState gardenState, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mes jardins', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (gardenState.isLoading)
          const ListLoadingWidget(itemCount: 4)
        else if (gardenState.error != null)
          ErrorStateWidget(
            title: 'Erreur lors du chargement des jardins',
            subtitle: gardenState.error,
            retryText: 'RÃ©essayer',
            onRetry: () => ref.read(gardenProvider.notifier).loadGardens(),
          )
        else if (gardenState.gardens.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.yard, color: theme.colorScheme.outline),
                    const SizedBox(width: 8),
                    Text('Aucun jardin', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.outline, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 12),
                  Text('CrÃ©ez votre premier jardin pour commencer.', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(onPressed: () => context.push(AppRoutes.gardenCreate), icon: const Icon(Icons.add), label: const Text('CrÃ©er un jardin')),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(onPressed: () => context.push(AppRoutes.gardens), icon: const Icon(Icons.list), label: const Text('Voir tous les jardins')),
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
              LayoutBuilder(builder: (context, constraints) {
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
                  children: gardenState.gardens.take(6).map<Widget>((garden) {
                    return GardenCardWithRealArea(garden: garden, onTap: () => context.push('/gardens/${garden.id}'), showActions: false);
                  }).toList(),
                );
              }),
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () => context.push(AppRoutes.gardenCreate), icon: const Icon(Icons.add), label: const Text('CrÃ©er un jardin'))),
            ],
          ),
      ],
    );
  }

  // ----------------------------
  // Intelligence section (organic dashboard + quick actions)
  // ----------------------------
  Widget _buildIntelligenceSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Intelligence VÃ©gÃ©tale', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomCard(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: FutureBuilder(
      future: rootBundle.load('assets/images/backgrounds/dashboard_organic_final.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 320,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Container(
            height: 320,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Center(
              child: Text(
                'Échec lecture asset : ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        final data = snapshot.data as ByteData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 220,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/backgrounds/dashboard_organic_final.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('asset:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          SizedBox(
                            width: 200,
                            child: Text(
                              'assets/images/backgrounds/dashboard_organic_final.png',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('load OK: ${data.lengthInBytes} bytes', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Si l\'image ne s\'affiche pas ci-dessus, le fichier est corrompu ou le chemin est incorrect.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      },
    ),
  ),
),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.recommendations), icon: const Icon(Icons.lightbulb, size: 20), label: const Text('Recommandations'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.notifications), icon: const Icon(Icons.notifications, size: 20), label: const Text('Notifications'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.intelligenceSettings), icon: const Icon(Icons.settings, size: 20), label: const Text('ParamÃ¨tres intelligence'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => context.push(AppRoutes.pestObservation), icon: const Icon(Icons.bug_report, size: 20), label: const Text('Observation nuisibles'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20), alignment: Alignment.centerLeft)),
          ],
        ),
      ],
    );
  }

  // ----------------------------
  // Recent activity (uses v3.recentActivitiesProvider)
  // ----------------------------
  Widget _buildRecentActivity(BuildContext context, ThemeData theme, WidgetRef ref) {
    final activitiesAsync = ref.watch(v3.recentActivitiesProvider);

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: activitiesAsync.when(
          loading: () => const LoadingWidget(),
          error: (e, st) => ErrorStateWidget(
            title: 'ActivitÃ©s indisponibles',
            subtitle: e.toString(),
            retryText: 'RÃ©essayer',
            onRetry: () => ref.read(v3.recentActivitiesProvider.notifier).refresh(),
          ),
          data: (data) {
            final items = data ?? <dynamic>[];

            if (items.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ActivitÃ© rÃ©cente', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Aucune activitÃ© rÃ©cente.'),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ActivitÃ© rÃ©cente', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...items.map<Widget>((it) {
                  final title = (it?.toString() ?? 'ActivitÃ©');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [const Icon(Icons.history, size: 18), const SizedBox(width: 8), Expanded(child: Text(title))]),
                  );
                }).toList(),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => ref.read(v3.recentActivitiesProvider.notifier).refresh(), child: const Text('Actualiser')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
