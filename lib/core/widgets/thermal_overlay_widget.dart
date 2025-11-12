import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/thermal_theme_provider.dart';
import '../../shared/presentation/widgets/thermal_transition_widget.dart';

/// Widget overlay halo global subtil pour ambiance thermique
/// Overlay jamais agressif (max 8% opacity)
class ThermalOverlayWidget extends StatelessWidget {
  final Widget child;
  final Color overlayColor;
  final double intensity;

  const ThermalOverlayWidget({
    super.key,
    required this.child,
    required this.overlayColor,
    this.intensity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenu principal
        child,

        // Overlay thermique subtil (seulement si couleur définie)
        if (overlayColor != Colors.transparent)
          Positioned.fill(
            child: IgnorePointer(
              // Pas d'interaction avec l'overlay
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [
                      overlayColor
                          .withOpacity(0.02 * intensity), // Centre très subtil
                      overlayColor.withOpacity(
                          0.08 * intensity), // Bordures plus marquées
                      overlayColor.withOpacity(
                          0.03 * intensity), // Dégradé vers transparence
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Widget pour intégration complète thermique dans écrans
/// Wrapper complet avec transitions et overlay
class ThermalScreenWrapper extends ConsumerWidget {
  final Widget child;
  final String commune;

  const ThermalScreenWrapper({
    super.key,
    required this.child,
    required this.commune,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(currentThermalColorSchemeProvider(commune));
    final overlayColor = ref.watch(currentOverlayColorProvider(commune));

    if (colorScheme == null) {
      return child; // Fallback sans transformation
    }

    return ThermalTransitionWidget(
      targetColorScheme: colorScheme,
      child: ThermalOverlayWidget(
        overlayColor: overlayColor,
        child: child,
      ),
    );
  }
}

/// Widget pour bulles avec glow thermique
/// Intègre automatiquement la couleur glow selon la température
class ThermalBubbleWidget extends ConsumerWidget {
  final Widget child;
  final String commune;
  final double glowIntensity;

  const ThermalBubbleWidget({
    super.key,
    required this.child,
    required this.commune,
    this.glowIntensity = 0.6,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glowColor = ref.watch(currentGlowColorProvider(commune));

    return ThermalGlowWidget(
      glowColor: glowColor,
      intensity: glowIntensity,
      child: child,
    );
  }
}

/// Widget pour bulles avec glow thermique et transition
/// Permet de changer la couleur du glow avec transition fluide
class ThermalBubbleTransitionWidget extends ConsumerWidget {
  final Widget child;
  final String commune;
  final double glowIntensity;
  final Duration transitionDuration;

  const ThermalBubbleTransitionWidget({
    super.key,
    required this.child,
    required this.commune,
    this.glowIntensity = 0.6,
    this.transitionDuration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glowColor = ref.watch(currentGlowColorProvider(commune));

    return ThermalGlowTransitionWidget(
      targetGlowColor: glowColor,
      intensity: glowIntensity,
      transitionDuration: transitionDuration,
      child: child,
    );
  }
}

/// Widget pour affichage debug de l'état thermique
/// Utile pour développement et tests
class ThermalDebugWidget extends ConsumerWidget {
  final String commune;

  const ThermalDebugWidget({
    super.key,
    required this.commune,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paletteName = ref.watch(currentPaletteNameProvider(commune));
    final intensity = ref.watch(currentThermalIntensityProvider(commune));
    final debugMode = ref.watch(debugThermalModeProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌡️ Thermal Debug',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Palette: $paletteName',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Text(
            'Intensité: ${(intensity * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          if (debugMode != null)
            Text(
              'Mode: ${debugMode.name}',
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
        ],
      ),
    );
  }
}

