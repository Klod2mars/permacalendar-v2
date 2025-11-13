import 'package:riverpod/riverpod.dart';

/// Feature flags pour activer/désactiver les nouvelles fonctionnalités UI
///
/// Permet un rollback instantané sans recompilation en changeant simplement les valeurs.
///
/// Usage:
/// ```dart
/// final flags = ref.watch(featureFlagsProvider);
/// if (flags.homeV2) {
///   return const HomeScreenOptimized();
/// }
/// ```
class FeatureFlags {
  /// Active la nouvelle version optimisée de l'écran d'accueil
  ///
  /// Inclut:
  /// - Tuiles d'actions rapides 2×2
  /// - Carrousel horizontal des jardins
  /// - Activités récentes compactes
  final bool homeV2;

  /// Active la vue calendrier des plantations et récoltes
  ///
  /// Fonctionnalités:
  /// - Calendrier mensuel interactif
  /// - Affichage des dates de plantation
  /// - Dates de récolte prévues avec alertes retard
  final bool calendarView;

  /// Active le widget de récolte rapide multi-sélection
  ///
  /// Permet:
  /// - Sélection multiple de plantes prêtes
  /// - Récolte groupée en un seul clic
  /// - FAB contextuel (apparaît seulement si plantes prêtes)
  final bool quickHarvest;

  /// Active le nouveau thème Material Design 3
  ///
  /// Améliore:
  /// - Cohérence visuelle (border-radius, spacing, colors)
  /// - Accessibilité (contraste, tailles de toucher)
  /// - Support dark mode natif
  final bool materialDesign3;

  const FeatureFlags({
    this.homeV2 = true,
    this.calendarView = true,
    this.quickHarvest = true,
    this.materialDesign3 = true,
  });

  /// Désactive toutes les nouvelles fonctionnalités (rollback d'urgence)
  const FeatureFlags.allDisabled()
      : homeV2 = false,
        calendarView = false,
        quickHarvest = false,
        materialDesign3 = false;

  /// Active seulement le thème M3 (changement visuel minimal)
  const FeatureFlags.onlyTheme()
      : homeV2 = false,
        calendarView = false,
        quickHarvest = false,
        materialDesign3 = true;

  /// Mode bêta: toutes les nouvelles fonctionnalités activées
  const FeatureFlags.beta()
      : homeV2 = true,
        calendarView = true,
        quickHarvest = true,
        materialDesign3 = true;

  @override
  String toString() {
    return 'FeatureFlags(homeV2: $homeV2, calendarView: $calendarView, '
        'quickHarvest: $quickHarvest, materialDesign3: $materialDesign3)';
  }
}

/// Provider global des feature flags
///
/// Pour désactiver toutes les nouvelles fonctionnalités (rollback):
/// ```dart
/// final featureFlagsProvider = Provider<FeatureFlags>(
///   (_) => const FeatureFlags.allDisabled(),
/// );
/// ```
final featureFlagsProvider = Provider<FeatureFlags>(
  (_) => const FeatureFlags.beta(), // Mode bêta par défaut
);

/// Provider pour vérifier si au moins une nouvelle fonctionnalité est active
final hasNewFeaturesProvider = Provider<bool>((ref) {
  final flags = ref.watch(featureFlagsProvider);
  return flags.homeV2 || flags.calendarView || flags.quickHarvest;
});


