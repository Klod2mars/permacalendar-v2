import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/climate/presentation/screens/weather_detail_screen.dart';
import 'features/garden_management/presentation/screens/garden_list_screen.dart';
import 'features/garden_management/presentation/screens/garden_detail_screen.dart';
import 'features/garden_management/presentation/screens/garden_create_screen.dart';
import 'features/garden_bed/presentation/screens/garden_bed_list_screen.dart';
import 'features/garden_bed/presentation/screens/garden_bed_detail_screen.dart';
import 'features/planting/presentation/screens/planting_list_screen.dart';
import 'features/planting/presentation/screens/planting_detail_screen.dart';
import 'features/plant_catalog/presentation/screens/plant_catalog_screen.dart';
import 'features/plant_catalog/presentation/screens/plant_detail_screen.dart';
import 'features/export/presentation/screens/export_screen.dart';
import 'features/activities/presentation/screens/activities_screen.dart';
import 'features/plant_intelligence/presentation/screens/plant_intelligence_dashboard_screen.dart';
import 'features/plant_intelligence/presentation/screens/recommendations_screen.dart';
import 'features/plant_intelligence/presentation/screens/intelligence_settings_simple.dart';
import 'features/plant_intelligence/presentation/screens/pest_observation_screen.dart';
import 'features/plant_intelligence/presentation/screens/bio_control_recommendations_screen.dart';
import 'features/plant_intelligence/presentation/screens/notifications_screen.dart';
import 'features/home/screens/calendar_view_screen.dart';
import 'shared/presentation/screens/home_screen.dart';
import 'shared/presentation/screens/settings_screen.dart';

import 'core/feature_flags.dart';

/// Routes principales
class AppRoutes {
  static const String home = '/';
  static const String gardens = '/gardens';
  static const String gardenDetail = '/gardens/:id';
  static const String gardenCreate = '/gardens/create';
  static const String gardenBeds = '/garden/:gardenId/beds';

  static const String plants = '/plants';
  static const String plantDetail = '/plants/:id';
  static const String plantingDetail = '/plantings/:id';

  static const String export = '/export';
  static const String activities = '/activities';
  static const String settings = '/settings';
  static const String calendar = '/calendar';
  static const String weather = '/weather';

  // Routes d'intelligence végétale
  static const String intelligence = '/intelligence';
  static const String intelligenceDetail = '/intelligence/plant/:id';
  static const String recommendations = '/intelligence/recommendations';
  static const String intelligenceSettings = '/intelligence/settings';
  static const String pestObservation = '/intelligence/pest-observation';
  static const String bioControlRecommendations = '/intelligence/biocontrol';
  static const String notifications = '/intelligence/notifications';

  // Routes sociales (désactivées)
  // static const String profile = '/profile';
  // static const String community = '/community';
  // static const String publicProfile = '/profile/:userId';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final flags = ref.watch(featureFlagsProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      // Gestion des jardins
      GoRoute(
        path: AppRoutes.gardens,
        name: 'gardens',
        builder: (context, state) => const GardenListScreen(),
      ),
      GoRoute(
        path: AppRoutes.gardenCreate,
        name: 'garden-create',
        builder: (context, state) {
          final slot = state.uri.queryParameters['slot'];
          return GardenCreateScreen(slot: slot);
        },
      ),
      GoRoute(
        path: AppRoutes.gardenDetail,
        name: 'garden-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GardenDetailScreen(gardenId: id);
        },
      ),

      // Parcelles
      GoRoute(
        path: AppRoutes.gardenBeds,
        name: 'garden-beds',
        builder: (context, state) {
          final gardenId = state.pathParameters['gardenId']!;
          final gardenName = state.extra as String? ?? 'Jardin';

          return GardenBedListScreen(
            gardenId: gardenId,
            gardenName: gardenName,
          );
        },
        routes: [
          GoRoute(
            path: ':bedId/detail',
            name: 'garden-bed-detail',
            builder: (context, state) {
              final gardenId = state.pathParameters['gardenId']!;
              final bedId = state.pathParameters['bedId']!;

              return GardenBedDetailScreen(
                gardenId: gardenId,
                bedId: bedId,
                onPop: () {
                  context.go(
                    AppRoutes.gardenBeds.replaceFirst(':gardenId', gardenId),
                  );
                },
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/garden/:gardenId/beds/:bedId/plantings',
        name: 'garden-bed-plantings',
        builder: (context, state) {
          final bedId = state.pathParameters['bedId']!;
          final bedName = state.extra as String? ?? 'Parcelle';

          return PlantingListScreen(
            gardenBedId: bedId,
            gardenBedName: bedName,
          );
        },
      ),

      // Catalogue de plantes
      GoRoute(
        path: AppRoutes.plants,
        name: 'plants',
        builder: (context, state) => const PlantCatalogScreen(),
      ),
      GoRoute(
        path: AppRoutes.plantDetail,
        name: 'plant-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PlantDetailScreen(plantId: id);
        },
      ),

      // Plantation detail
      GoRoute(
        path: AppRoutes.plantingDetail,
        name: 'planting-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PlantingDetailScreen(plantingId: id);
        },
      ),

      // Export
      GoRoute(
        path: AppRoutes.export,
        name: 'export',
        builder: (context, state) => const ExportScreen(),
      ),

      // Paramètres
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Calendrier conditionnel
      if (flags.calendarView)
        GoRoute(
          path: AppRoutes.calendar,
          name: 'calendar',
          builder: (context, state) => const CalendarViewScreen(),
        ),

      // Météo
      GoRoute(
        path: AppRoutes.weather,
        name: 'weather',
        builder: (context, state) => const WeatherDetailScreen(),
      ),

      // Activités
      GoRoute(
        path: AppRoutes.activities,
        name: 'activities',
        builder: (context, state) => const ActivitiesScreen(),
      ),

      // Intelligence végétale
      GoRoute(
        path: AppRoutes.intelligence,
        name: 'intelligence',
        builder: (context, state) {
          print('ðŸ”´ [DIAGNOSTIC] builder() pour /intelligence appelé.');
          return const PlantIntelligenceDashboardScreen();
        },
        routes: [
          GoRoute(
            path: 'plant/:id',
            name: 'intelligence-detail',
            builder: (context, state) {
              final plantId = state.pathParameters['id']!;
              return const Scaffold(
                body: Center(
                  child: Text('Détail de la plante (à implémenter)'),
                ),
              );
            },
          ),
          GoRoute(
            path: 'recommendations',
            name: 'recommendations',
            builder: (context, state) => const RecommendationsScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'intelligence-settings',
            builder: (context, state) => const IntelligenceSettingsSimple(),
          ),
          GoRoute(
            path: 'pest-observation',
            name: 'pest-observation',
            builder: (context, state) {
              final gardenId = state.uri.queryParameters['gardenId'] ?? '';
              final plantId = state.uri.queryParameters['plantId'] ?? '';
              final bedId = state.uri.queryParameters['bedId'];

              return PestObservationScreen(
                gardenId: gardenId,
                plantId: plantId,
                bedId: bedId,
              );
            },
          ),
          GoRoute(
            path: 'biocontrol',
            name: 'biocontrol-recommendations',
            builder: (context, state) {
              final gardenId = state.uri.queryParameters['gardenId'] ?? '';
              return BioControlRecommendationsScreen(
                gardenId: gardenId,
              );
            },
          ),
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
    ],

    /// Gestion 404
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La page "${state.uri}" n’existe pas.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Retour à l’accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});
