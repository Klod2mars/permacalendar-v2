import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/climate/presentation/providers/weather_providers.dart'
    as weather_providers;
import '../../../../features/climate/domain/models/weather_view_data.dart';
import '../../../../core/models/daily_weather_point.dart';
import '../../../../core/providers/app_settings_provider.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../../../core/theme/app_icons.dart';

/// Widget autonome pour l'affichage du climat du jardin
///
/// Ce widget extrait la fonctionnalitÃ© mÃ©tÃ©o de home_screen.dart
/// et la rend disponible comme composant rÃ©utilisable.
///
/// Phase P2: Grille de mini-cartes mÃ©tÃ©o (J0, J+1, J+2) avec responsive
class GardenClimatePanel extends ConsumerWidget {
  const GardenClimatePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final theme = Theme.of(context);
    // Use unified providers
    final currentAsync = ref.watch(weather_providers.currentWeatherProvider);
    final forecastAsync = ref.watch(weather_providers.forecastProvider);

    return _FrostCard(
      emphasis: FrostEmphasis.normal,
      child: Column(
        children: [
          // Header "Climat du Jardin"
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wb_sunny, color: Colors.white, size: 28),
            ),
            title: const Text(
              'Climat du Jardin',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
            subtitle: const Text(
              'Conditions mÃ©tÃ©orologiques actuelles',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: () {
              // TODO P3: Navigate to detailed climate dashboard
              // context.push(AppRoutes.climate);
            },
          ),

          const Divider(color: Colors.white24, height: 0.5),

          // Grille de mini-cartes mÃ©tÃ©o
          currentAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: LoadingWidget(),
            ),
            error: (e, st) => const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'MÃ©tÃ©o indisponible',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            data: (current) =>
                _buildWeatherGrid(context, theme, current, forecastAsync.value),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherGrid(
    BuildContext context,
    ThemeData theme,
    WeatherViewData data,
    List<DailyWeatherPoint>? forecast,
  ) {
    // Pour l'instant, crÃ©er des cartes basÃ©es sur les donnÃ©es actuelles
    // TODO: IntÃ©grer avec les prÃ©visions complÃ¨tes quand disponible
    final weatherCards = <DailyWeatherPoint>[];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Localisation
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(
                'MÃ©tÃ©o actuelle',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Carte mÃ©tÃ©o actuelle (temporaire)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${(data.temperature ?? data.currentTemperatureC ?? 0.0).toStringAsFixed(1)}Â°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      data.description ?? 'DonnÃ©es indisponibles',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if ((forecast ?? const []).isNotEmpty)
                  const Text(
                    'PrÃ©visions disponibles',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Bouton "Voir plus (climat complet)"
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO P3: Navigate to detailed climate dashboard
                // context.push(AppRoutes.climate);
              },
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text(
                'Voir plus (climat complet)',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REUSABLE FROSTED GLASS COMPONENTS (extracted from home_screen.dart)
// ============================================================================

enum FrostEmphasis { low, normal, high }

class _FrostCard extends StatelessWidget {
  const _FrostCard({
    required this.child,
    this.emphasis = FrostEmphasis.normal,
  });

  final Widget child;
  final FrostEmphasis emphasis;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final blur = switch (emphasis) {
      FrostEmphasis.high => 16.0,
      FrostEmphasis.normal => 12.0,
      FrostEmphasis.low => 8.0,
    };
    final opacity = switch (emphasis) {
      FrostEmphasis.high => 0.28,
      FrostEmphasis.normal => 0.22,
      FrostEmphasis.low => 0.16,
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(opacity),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }
}



