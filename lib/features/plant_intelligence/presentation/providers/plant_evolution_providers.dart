import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/plant_evolution_report.dart';
import '../../../../core/di/intelligence_module.dart';

// ==================== CURSOR PROMPT A8 - EVOLUTION PROVIDERS ====================

/// Provider pour récupérer l'historique des évolutions d'une plante
///
/// **Usage:**
/// ```dart
/// final evolutionsAsync = ref.watch(plantEvolutionHistoryProvider('plantId'));
///
/// evolutionsAsync.when(
///   data: (evolutions) => PlantEvolutionTimeline(evolutions: evolutions),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => ErrorWidget(),
/// );
/// ```
///
/// **Responsabilités:**
/// - Récupérer l'historique complet depuis IAnalyticsRepository
/// - Gérer les états: loading, data, error
/// - Mise en cache automatique par Riverpod
/// - Auto-refresh possible via ref.invalidate()
final plantEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, String>((ref, plantId) async {
  final analyticsRepo =
      ref.read(IntelligenceModule.analyticsRepositoryProvider);
  return await analyticsRepo.getEvolutionReports(plantId);
});

/// Provider pour filtrer les évolutions par période
///
/// Filtre l'historique des évolutions selon une période donnée.
/// Utile pour afficher uniquement les 30 derniers jours, 90 jours, etc.
///
/// **Usage:**
/// ```dart
/// final filtered = ref.watch(filteredEvolutionHistoryProvider(
///   FilterParams(plantId: 'id', days: 30),
/// ));
/// ```
final filteredEvolutionHistoryProvider = FutureProvider.autoDispose
    .family<List<PlantEvolutionReport>, FilterParams>((ref, params) async {
  final allEvolutions =
      await ref.watch(plantEvolutionHistoryProvider(params.plantId).future);

  if (params.days == null) {
    return allEvolutions;
  }

  final cutoffDate = DateTime.now().subtract(Duration(days: params.days!));
  return allEvolutions
      .where((evolution) => evolution.currentDate.isAfter(cutoffDate))
      .toList();
});

/// Notifier d'état pour le filtre temporel sélectionné
///
/// Permet à l'utilisateur de choisir la période d'affichage:
/// - null: tout l'historique
/// - 30: derniers 30 jours
/// - 90: derniers 90 jours
/// - 365: dernière année
class SelectedTimePeriodNotifier extends Notifier<int?> {
  @override
  int? build() => null;
}

final selectedTimePeriodProvider =
    NotifierProvider<SelectedTimePeriodNotifier, int?>(
        SelectedTimePeriodNotifier.new);

/// Provider pour obtenir la dernière évolution d'une plante
///
/// Pratique pour afficher uniquement le dernier changement détecté.
final latestEvolutionProvider = FutureProvider.autoDispose
    .family<PlantEvolutionReport?, String>((ref, plantId) async {
  final evolutions =
      await ref.watch(plantEvolutionHistoryProvider(plantId).future);

  if (evolutions.isEmpty) return null;

  // Les évolutions sont déjà triées par date dans le repository
  return evolutions.last;
});

// ==================== DATA CLASSES ====================

/// Paramètres pour le filtre d'évolutions
class FilterParams {
  final String plantId;
  final int? days;

  const FilterParams({
    required this.plantId,
    this.days,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterParams &&
          runtimeType == other.runtimeType &&
          plantId == other.plantId &&
          days == other.days;

  @override
  int get hashCode => plantId.hashCode ^ days.hashCode;
}


