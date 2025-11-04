import 'package:riverpod/riverpod.dart';
import '../../../domain/models/seasonal_performance.dart';
import 'performance_raw_data_provider.dart';

/// Provider pour la comparaison entre saisons (n vs n-1)
///
/// Ce provider calcule les insights comparatifs entre la saison actuelle
/// et la saison précédente, incluant :
/// - Amélioration du taux de complétion
/// - Amélioration de la durée de maturation
/// - Amélioration de la valeur des récoltes
/// - Amélioration du rendement
/// - Score global de performance
final seasonalComparisonProvider =
    FutureProvider<SeasonalComparison>((ref) async {
  final rawData = await ref.watch(seasonalPerformanceRawDataProvider.future);
  final currentYear = DateTime.now().year;
  final previousYear = currentYear - 1;

  final currentSeason = rawData[currentYear];
  final previousSeason = rawData[previousYear];

  // Vérifier s'il y a des données pour l'année précédente ou antérieure
  bool hasPreviousData = false;
  for (int year = currentYear - 1; year >= currentYear - 5; year--) {
    if (rawData.containsKey(year) && rawData[year]!.totalCulturesStarted > 0) {
      hasPreviousData = true;
      break;
    }
  }

  // Si pas de saison actuelle, retourner une comparaison vide
  if (currentSeason == null) {
    return SeasonalComparison(
      currentSeason: SeasonalPerformance(
        year: DateTime.now().year,
        totalCulturesStarted: 0,
        totalCulturesCompleted: 0,
        averageMaturationDuration: 0.0,
        totalHarvestValue: 0.0,
        averageYieldPerCulture: 0.0,
        completionRate: 0.0,
      ),
      previousSeason: null,
      hasPreviousSeason: false,
      completionRateImprovement: 0.0,
      maturationDurationImprovement: 0.0,
      harvestValueImprovement: 0.0,
      yieldImprovement: 0.0,
      overallScore: 0.0,
    );
  }

  // Si pas de saison précédente, retourner une comparaison sans amélioration
  if (!hasPreviousData || previousSeason == null) {
    return SeasonalComparison(
      currentSeason: currentSeason,
      previousSeason: null,
      hasPreviousSeason: false,
      completionRateImprovement: 0.0,
      maturationDurationImprovement: 0.0,
      harvestValueImprovement: 0.0,
      yieldImprovement: 0.0,
      overallScore: 0.0,
    );
  }

  // Calculer les améliorations
  final completionRateImprovement =
      currentSeason.completionRate - previousSeason.completionRate;

  // Pour la durée de maturation, une amélioration = réduction (négative)
  final maturationDurationImprovement =
      previousSeason.averageMaturationDuration -
          currentSeason.averageMaturationDuration;

  // Calculer l'amélioration de la valeur des récoltes en pourcentage
  final harvestValueImprovement = previousSeason.totalHarvestValue > 0
      ? (currentSeason.totalHarvestValue - previousSeason.totalHarvestValue) /
          previousSeason.totalHarvestValue
      : 0.0;

  // Calculer l'amélioration du rendement en pourcentage
  final yieldImprovement = previousSeason.averageYieldPerCulture > 0
      ? (currentSeason.averageYieldPerCulture -
              previousSeason.averageYieldPerCulture) /
          previousSeason.averageYieldPerCulture
      : 0.0;

  // Calculer le score global de performance (0-100)
  // Pondération : 40% taux de complétion, 30% valeur récoltes, 20% rendement, 10% durée
  final completionScore = completionRateImprovement * 40; // -40 à +40 points
  final valueScore = harvestValueImprovement * 30; // -30 à +30 points
  final yieldScore = yieldImprovement * 20; // -20 à +20 points
  final durationScore = (maturationDurationImprovement / 30) *
      10; // -10 à +10 points (30 jours = 10 points)

  final overallScore =
      completionScore + valueScore + yieldScore + durationScore;

  return SeasonalComparison(
    currentSeason: currentSeason,
    previousSeason: previousSeason,
    hasPreviousSeason: true,
    completionRateImprovement: completionRateImprovement,
    maturationDurationImprovement: maturationDurationImprovement,
    harvestValueImprovement: harvestValueImprovement,
    yieldImprovement: yieldImprovement,
    overallScore: overallScore,
  );
});

/// Provider pour le KPI principal de Performance Saisonnière
///
/// Retourne le score global de performance pour l'affichage dans la carte KPI
final performanceSeasonalKpiProvider = FutureProvider<double>((ref) async {
  final comparison = await ref.watch(seasonalComparisonProvider.future);

  // Si pas de saison précédente, retourner 0 (pas de comparaison possible)
  if (!comparison.hasPreviousSeason) {
    return 0.0;
  }

  // Retourner le score global (peut être négatif, positif ou zéro)
  return comparison.overallScore;
});

/// Provider pour déterminer si l'utilisateur est dans sa première saison
final isFirstSeasonProvider = FutureProvider<bool>((ref) async {
  final comparison = await ref.watch(seasonalComparisonProvider.future);
  return !comparison.hasPreviousSeason;
});

/// Provider pour obtenir le message d'encouragement selon la performance
final performanceEncouragementMessageProvider =
    FutureProvider<String>((ref) async {
  final comparison = await ref.watch(seasonalComparisonProvider.future);

  if (!comparison.hasPreviousSeason) {
    return "Continue à cultiver ! Tes premières statistiques de performance saisonnière apparaîtront bientôt.";
  }

  if (comparison.isImproving) {
    return "Excellent ! Tu deviens un meilleur jardinier au fil des saisons ! 🌱";
  } else if (comparison.isDeclining) {
    return "Pas de panique ! Chaque saison est différente. Continue à apprendre ! 📚";
  } else {
    return "Performance stable ! C'est déjà un bon signe de constance ! ⚖️";
  }
});
