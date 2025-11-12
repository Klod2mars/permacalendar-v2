import 'package:riverpod/riverpod.dart';
import 'alignment_raw_data_provider.dart';

/// Insight d'alignement au vivant
class AlignmentInsight {
  final double score; // Pourcentage d'alignement (0-100)
  final bool hasData; // Indique s'il y a des données disponibles
  final int totalActions; // Nombre total d'actions
  final int alignedActions; // Nombre d'actions alignées
  final int misalignedActions; // Nombre d'actions non alignées
  final String message; // Message descriptif
  final AlignmentLevel level; // Niveau d'alignement

  const AlignmentInsight({
    required this.score,
    required this.hasData,
    required this.totalActions,
    required this.alignedActions,
    required this.misalignedActions,
    required this.message,
    required this.level,
  });

  /// Insight par défaut quand il n'y a pas de données
  static const AlignmentInsight empty = AlignmentInsight(
    score: 0.0,
    hasData: false,
    totalActions: 0,
    alignedActions: 0,
    misalignedActions: 0,
    message: 'Aucune action enregistrée pour le moment',
    level: AlignmentLevel.noData,
  );
}

/// Niveaux d'alignement
enum AlignmentLevel {
  noData, // Aucune donnée
  excellent, // 90-100%
  good, // 70-89%
  average, // 50-69%
  poor, // 30-49%
  veryPoor, // 0-29%
}

/// Provider pour l'insight d'alignement au vivant
///
/// Ce provider :
/// 1. Calcule le pourcentage d'alignement = (alignées / totales) * 100
/// 2. Détermine le niveau d'alignement
/// 3. Génère un message descriptif approprié
/// 4. Gère le cas spécial où aucune action n'est disponible
final alignmentInsightProvider = FutureProvider<AlignmentInsight>((ref) async {
  final rawData = await ref.watch(alignmentRawDataProvider.future);

  // Si aucune donnée, retourner l'insight vide
  if (!rawData.hasData) {
    return AlignmentInsight.empty;
  }

  // Calculer le score d'alignement
  final score = rawData.alignmentPercentage;

  // Déterminer le niveau d'alignement
  final level = _determineAlignmentLevel(score);

  // Générer le message descriptif
  final message = _generateAlignmentMessage(score, rawData.totalActions, level);

  return AlignmentInsight(
    score: score,
    hasData: true,
    totalActions: rawData.totalActions,
    alignedActions: rawData.alignedActions,
    misalignedActions: rawData.misalignedActions,
    message: message,
    level: level,
  );
});

/// Détermine le niveau d'alignement basé sur le score
AlignmentLevel _determineAlignmentLevel(double score) {
  if (score >= 90) return AlignmentLevel.excellent;
  if (score >= 70) return AlignmentLevel.good;
  if (score >= 50) return AlignmentLevel.average;
  if (score >= 30) return AlignmentLevel.poor;
  return AlignmentLevel.veryPoor;
}

/// Génère un message descriptif basé sur le score et le niveau
String _generateAlignmentMessage(
    double score, int totalActions, AlignmentLevel level) {
  final scoreInt = score.round();

  switch (level) {
    case AlignmentLevel.excellent:
      return '$scoreInt% de tes actions sont parfaitement alignées avec le rythme naturel ! 🌱';
    case AlignmentLevel.good:
      return '$scoreInt% de tes actions respectent bien le calendrier naturel. Continue comme ça ! 🌿';
    case AlignmentLevel.average:
      return '$scoreInt% de tes actions suivent le rythme naturel. Quelques ajustements pourraient t\'aider. 🌾';
    case AlignmentLevel.poor:
      return '$scoreInt% de tes actions sont alignées. Consulte l\'Agenda Intelligent pour optimiser tes périodes. 📅';
    case AlignmentLevel.veryPoor:
      return '$scoreInt% de tes actions suivent le calendrier naturel. L\'Agenda Intelligent peut t\'aider à mieux planifier. 📚';
    case AlignmentLevel.noData:
      return 'Aucune action enregistrée pour le moment. Commence à planter et récolter pour voir ton alignement ! 🌱';
  }
}

/// Provider pour obtenir le message d'encouragement spécifique à l'alignement
final alignmentEncouragementMessageProvider =
    FutureProvider<String>((ref) async {
  final insight = await ref.watch(alignmentInsightProvider.future);

  if (!insight.hasData) {
    return 'Commence ton premier semis pour découvrir ton alignement au vivant !';
  }

  switch (insight.level) {
    case AlignmentLevel.excellent:
      return 'Tu maîtrises parfaitement le rythme naturel ! Un vrai jardinier permaculteur !';
    case AlignmentLevel.good:
      return 'Excellent travail ! Tu respectes bien les cycles naturels.';
    case AlignmentLevel.average:
      return 'Pas mal ! Quelques ajustements et tu seras parfaitement aligné.';
    case AlignmentLevel.poor:
      return 'L\'Agenda Intelligent peut t\'aider à mieux synchroniser tes actions.';
    case AlignmentLevel.veryPoor:
      return 'Consulte l\'Agenda Intelligent pour découvrir les meilleures périodes !';
    case AlignmentLevel.noData:
      return 'Commence ton premier semis pour découvrir ton alignement au vivant !';
  }
});

