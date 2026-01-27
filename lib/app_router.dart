import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/climate/presentation/screens/weather_detail_screen.dart';
import 'features/climate/presentation/screens/soil_temp_page.dart';
import 'features/garden_management/presentation/screens/garden_list_screen.dart';
import 'features/garden_management/presentation/screens/garden_detail_screen.dart';
import 'features/garden_management/presentation/screens/garden_create_screen.dart';

import 'features/garden_bed/presentation/screens/garden_bed_detail_screen.dart';
import 'features/planting/presentation/screens/planting_list_screen.dart';
import 'features/planting/presentation/screens/planting_detail_screen.dart';
import 'features/plant_catalog/presentation/screens/plant_catalog_screen.dart';
import 'features/plant_catalog/presentation/screens/plant_detail_screen.dart';

import 'features/activities/presentation/screens/activities_screen.dart';

import 'features/home/screens/calendar_view_screen.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'shared/presentation/screens/home_screen.dart';
import 'shared/presentation/screens/settings_screen.dart';

import 'features/statistics/presentation/screens/garden_statistics_screen.dart';
import 'features/statistics/presentation/screens/garden_economy_screen.dart';
import 'features/statistics/presentation/screens/garden_nutrition_screen.dart';

import 'features/statistics/presentation/screens/garden_alignment_screen.dart';
import 'package:permacalendar/features/export/presentation/screens/export_builder_screen.dart';
import 'shared/presentation/screens/credit_contact_screen.dart';

import 'core/feature_flags.dart';

class AppRoutes {
  static const String home = '/';
  static const String gardens = '/gardens';
  static const String gardenDetail = '/gardens/:id';
  static const String gardenCreate = '/gardens/create';
  static const String gardenBeds = '/garden/:gardenId/beds';

  static const String plants = '/plants';
  static const String plantDetail = '/plants/:id';
  static const String plantingDetail = '/plantings/:id';

  static const String activities = '/activities';
  static const String settings = '/settings';
  static const String calendar = '/calendar';
  static const String weather = '/weather';

  static const String statistics = '/statistics';
  static const String export = '/export';
  static const String soilTemperature = '/soil-temperature';
  static const String credits = '/credits';
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
          final fromOrganic =
              state.uri.queryParameters['fromOrganic'] == 'true';
          return GardenDetailScreen(
            gardenId: id,
            openPlantingsOnBedTap: fromOrganic,
          );
        },
      ),

      GoRoute(
        path: '/gardens/:id/stats',
        name: 'garden-stats',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return GardenStatisticsScreen(gardenId: id);
        },
        routes: [
          GoRoute(
            path: 'economie',
            name: 'garden-stats-economie',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GardenEconomyScreen(gardenId: id);
            },
          ),
          GoRoute(
            path: 'sante',
            name: 'garden-stats-sante',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GardenNutritionScreen(gardenId: id);
            },
          ),
          GoRoute(
            path: 'alignement',
            name: 'garden-stats-alignement',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GardenAlignmentScreen(gardenId: id);
            },
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.statistics,
        name: 'statistics-global',
        builder: (context, state) {
          return const GardenStatisticsScreen(gardenId: null);
        },
        routes: [
          GoRoute(
            path: 'economie',
            name: 'statistics-global-economie',
            builder: (context, state) {
              return const GardenEconomyScreen(gardenId: null);
            },
          ),
          GoRoute(
            path: 'sante',
            name: 'statistics-global-sante',
            builder: (context, state) {
              return const GardenNutritionScreen(gardenId: null); // OK updated
            },
          ),
          /* 
          // TODO: Update other screens to support null gardenId before enabling these routes
          ...
          */
        ],
      ),

      // --- Parcelles : fallback vers GardenDetailScreen, mais conserver le détail d'une parcelle
      GoRoute(
        path: AppRoutes.gardenBeds,
        name: 'garden-beds',
        builder: (context, state) {
          final gardenId = state.pathParameters['gardenId']!;
          // Fallback : afficher la page GardenDetailScreen (aperçu),
          // la gestion complète ayant été mise en quarantaine.
          return GardenDetailScreen(
            gardenId: gardenId,
            openPlantingsOnBedTap: false,
          );
        },
        routes: [
          GoRoute(
            path: ':bedId/detail',
            name: 'garden-bed-detail',
            builder: (context, state) {
              final gardenId = state.pathParameters['gardenId']!;
              final bedId = state.pathParameters['bedId']!;
              // Planche 2 : page de détail — aucun onPop forcé
              return GardenBedDetailScreen(
                gardenId: gardenId,
                bedId: bedId,
              );
            },
          ),
        ],
      ),

      // Plantings (liste des plantations pour une parcelle)
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

      GoRoute(
        path: AppRoutes.plantingDetail,
        name: 'planting-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PlantingDetailScreen(plantingId: id);
        },
      ),

      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      if (flags.calendarView)
        GoRoute(
          path: AppRoutes.calendar,
          name: 'calendar',
          builder: (context, state) => const CalendarViewScreen(),
        ),

      GoRoute(
        path: AppRoutes.weather,
        name: 'weather',
        builder: (context, state) => const WeatherDetailScreen(),
      ),

      GoRoute(
        path: AppRoutes.activities,
        name: 'activities',
        builder: (context, state) => const ActivitiesScreen(),
      ),

      GoRoute(
        path: AppRoutes.export,
        name: 'export',
        builder: (context, state) => const ExportBuilderScreen(),
      ),

      GoRoute(
        path: AppRoutes.soilTemperature,
        name: 'soil-temperature',
        builder: (context, state) => const SoilTempPage(),
      ),

      GoRoute(
        path: AppRoutes.credits,
        name: 'credits',
        builder: (context, state) => const CreditContactScreen(),
      ),
    ],
    errorBuilder: (context, state) {
    // Basic 404 page
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.error_page_title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              l10n.error_page_message(state.uri.toString()),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: Text(l10n.error_page_back),
            ),
          ],
        ),
      ),
    );
  },);
});
