import 'dart:developer' as developer;
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/plant_condition_hive.dart';
import '../../domain/entities/recommendation_hive.dart';
import '../../../../core/data/hive/garden_boxes.dart';

/// Migration script pour ajouter gardenId aux données existantes
///
/// **Prompt A15 - Multi-Garden Migration**
///
/// Cette migration ajoute le champ `gardenId` à toutes les conditions et recommandations
/// existantes en inférant le gardenId depuis la relation plant â†’ gardenBed â†’ garden.
///
/// **Stratégie :**
/// 1. Pour chaque PlantCondition/Recommendation existante sans gardenId
/// 2. Récupérer toutes les plantations (Planting) associées au plantId
/// 3. Récupérer le gardenBed de la plantation
/// 4. Récupérer le gardenId du gardenBed
/// 5. Mettre à jour la condition/recommandation avec le gardenId inféré
///
/// **Sécurité :**
/// - La migration est idempotente (peut être exécutée plusieurs fois)
/// - Les erreurs ne bloquent pas la migration des autres entités
/// - Un rapport détaillé est généré
class MultiGardenMigration {
  static const String _conditionsBoxName = 'plant_conditions';
  static const String _recommendationsBoxName = 'plant_recommendations';

  /// Exécute la migration complète
  ///
  /// Retourne un rapport de migration avec statistiques
  static Future<MigrationReport> execute() async {
    developer.log(
      'ðŸ”„ MIGRATION - Début de la migration multi-garden',
      name: 'MultiGardenMigration',
    );

    final report = MigrationReport();
    final startTime = DateTime.now();

    try {
      // Phase 1: Migrer les PlantConditions
      developer.log(
        'ðŸ“Š MIGRATION - Phase 1: Migration des PlantConditions',
        name: 'MultiGardenMigration',
      );
      final conditionsResult = await _migrateConditions();
      report.conditionsMigrated = conditionsResult['migrated'] as int;
      report.conditionsSkipped = conditionsResult['skipped'] as int;
      report.conditionsErrors = conditionsResult['errors'] as int;

      // Phase 2: Migrer les Recommendations
      developer.log(
        'ðŸ“‹ MIGRATION - Phase 2: Migration des Recommendations',
        name: 'MultiGardenMigration',
      );
      final recommendationsResult = await _migrateRecommendations();
      report.recommendationsMigrated = recommendationsResult['migrated'] as int;
      report.recommendationsSkipped = recommendationsResult['skipped'] as int;
      report.recommendationsErrors = recommendationsResult['errors'] as int;

      report.success = true;
      report.duration = DateTime.now().difference(startTime);

      developer.log(
        'âœ… MIGRATION - Migration terminée avec succès',
        name: 'MultiGardenMigration',
      );
      developer.log(
        'ðŸ“Š MIGRATION - Rapport: ${report.conditionsMigrated} conditions + ${report.recommendationsMigrated} recommandations migrées',
        name: 'MultiGardenMigration',
      );
    } catch (e, stackTrace) {
      report.success = false;
      report.error = e.toString();
      report.duration = DateTime.now().difference(startTime);

      developer.log(
        'âŒ MIGRATION - Erreur critique: $e',
        name: 'MultiGardenMigration',
        error: e,
        stackTrace: stackTrace,
      );
    }

    return report;
  }

  /// Migre les PlantConditions
  static Future<Map<String, int>> _migrateConditions() async {
    int migrated = 0;
    int skipped = 0;
    int errors = 0;

    try {
      final box = await Hive.openBox<PlantConditionHive>(_conditionsBoxName);

      developer.log(
        'ðŸ“¦ MIGRATION - Box PlantConditions ouverte: ${box.length} entrées',
        name: 'MultiGardenMigration',
      );

      for (var i = 0; i < box.length; i++) {
        try {
          final condition = box.getAt(i);
          if (condition == null) continue;

          // Vérifier si la condition a déjà un gardenId (valide)
          if (condition.gardenId.isNotEmpty && condition.gardenId != '') {
            skipped++;
            continue;
          }

          // Inférer le gardenId depuis le plantId
          final gardenId = await _inferGardenIdFromPlantId(condition.plantId);

          if (gardenId == null) {
            developer.log(
              'âš ï¸ MIGRATION - Impossible d\'inférer gardenId pour condition ${condition.id}',
              name: 'MultiGardenMigration',
              level: 900,
            );
            errors++;
            continue;
          }

          // Mettre à jour la condition avec le gardenId
          condition.gardenId = gardenId;
          await box.putAt(i, condition);

          migrated++;

          if (migrated % 10 == 0) {
            developer.log(
              'ðŸ“Š MIGRATION - Conditions migrées: $migrated',
              name: 'MultiGardenMigration',
            );
          }
        } catch (e) {
          developer.log(
            'âŒ MIGRATION - Erreur migration condition à l\'index $i: $e',
            name: 'MultiGardenMigration',
            level: 900,
          );
          errors++;
        }
      }

      await box.close();

      developer.log(
        'âœ… MIGRATION - Conditions: $migrated migrées, $skipped ignorées, $errors erreurs',
        name: 'MultiGardenMigration',
      );
    } catch (e) {
      developer.log(
        'âŒ MIGRATION - Erreur lors de l\'ouverture de la box conditions: $e',
        name: 'MultiGardenMigration',
        level: 1000,
      );
      errors++;
    }

    return {'migrated': migrated, 'skipped': skipped, 'errors': errors};
  }

  /// Migre les Recommendations
  static Future<Map<String, int>> _migrateRecommendations() async {
    int migrated = 0;
    int skipped = 0;
    int errors = 0;

    try {
      final box =
          await Hive.openBox<RecommendationHive>(_recommendationsBoxName);

      developer.log(
        'ðŸ“¦ MIGRATION - Box Recommendations ouverte: ${box.length} entrées',
        name: 'MultiGardenMigration',
      );

      for (var i = 0; i < box.length; i++) {
        try {
          final recommendation = box.getAt(i);
          if (recommendation == null) continue;

          // Vérifier si la recommandation a déjà un gardenId (valide)
          if (recommendation.gardenId.isNotEmpty &&
              recommendation.gardenId != '') {
            skipped++;
            continue;
          }

          // Inférer le gardenId depuis le plantId
          final gardenId =
              await _inferGardenIdFromPlantId(recommendation.plantId);

          if (gardenId == null) {
            developer.log(
              'âš ï¸ MIGRATION - Impossible d\'inférer gardenId pour recommandation ${recommendation.id}',
              name: 'MultiGardenMigration',
              level: 900,
            );
            errors++;
            continue;
          }

          // Mettre à jour la recommandation avec le gardenId
          recommendation.gardenId = gardenId;
          await box.putAt(i, recommendation);

          migrated++;

          if (migrated % 10 == 0) {
            developer.log(
              'ðŸ“Š MIGRATION - Recommandations migrées: $migrated',
              name: 'MultiGardenMigration',
            );
          }
        } catch (e) {
          developer.log(
            'âŒ MIGRATION - Erreur migration recommandation à l\'index $i: $e',
            name: 'MultiGardenMigration',
            level: 900,
          );
          errors++;
        }
      }

      await box.close();

      developer.log(
        'âœ… MIGRATION - Recommandations: $migrated migrées, $skipped ignorées, $errors erreurs',
        name: 'MultiGardenMigration',
      );
    } catch (e) {
      developer.log(
        'âŒ MIGRATION - Erreur lors de l\'ouverture de la box recommandations: $e',
        name: 'MultiGardenMigration',
        level: 1000,
      );
      errors++;
    }

    return {'migrated': migrated, 'skipped': skipped, 'errors': errors};
  }

  /// Infère le gardenId depuis un plantId
  ///
  /// Stratégie : plant â†’ planting â†’ gardenBed â†’ garden
  static Future<String?> _inferGardenIdFromPlantId(String plantId) async {
    try {
      // Récupérer toutes les plantations depuis toutes les parcelles
      final allGardenBeds = GardenBoxes.gardenBeds.values.toList();

      for (final gardenBed in allGardenBeds) {
        // Récupérer les plantations pour cette parcelle
        final bedPlantings = GardenBoxes.getPlantings(gardenBed.id);

        // Chercher une plantation correspondant au plantId
        final matchingPlanting =
            bedPlantings.where((p) => p.plantId == plantId).firstOrNull;

        if (matchingPlanting != null) {
          // Trouvé ! Retourner le gardenId de la parcelle
          final gardenId = gardenBed.gardenId;

          developer.log(
            'âœ… MIGRATION - gardenId inféré: $gardenId pour plantId: $plantId',
            name: 'MultiGardenMigration',
          );

          return gardenId;
        }
      }

      // Aucune plantation trouvée pour cette plante
      developer.log(
        'â„¹ï¸ MIGRATION - Aucune plantation trouvée pour plantId: $plantId',
        name: 'MultiGardenMigration',
        level: 800,
      );
      return null;
    } catch (e) {
      developer.log(
        'âŒ MIGRATION - Erreur inférence gardenId pour plantId $plantId: $e',
        name: 'MultiGardenMigration',
        level: 900,
      );
      return null;
    }
  }

  /// Vérifie si la migration est nécessaire
  ///
  /// Retourne true si des données nécessitent une migration
  static Future<bool> isMigrationNeeded() async {
    try {
      // Vérifier les conditions
      final conditionsBox =
          await Hive.openBox<PlantConditionHive>(_conditionsBoxName);
      for (var i = 0; i < conditionsBox.length; i++) {
        final condition = conditionsBox.getAt(i);
        if (condition != null &&
            (condition.gardenId.isEmpty || condition.gardenId == '')) {
          await conditionsBox.close();
          return true;
        }
      }
      await conditionsBox.close();

      // Vérifier les recommandations
      final recommendationsBox =
          await Hive.openBox<RecommendationHive>(_recommendationsBoxName);
      for (var i = 0; i < recommendationsBox.length; i++) {
        final recommendation = recommendationsBox.getAt(i);
        if (recommendation != null &&
            (recommendation.gardenId.isEmpty ||
                recommendation.gardenId == '')) {
          await recommendationsBox.close();
          return true;
        }
      }
      await recommendationsBox.close();

      return false;
    } catch (e) {
      developer.log(
        'âŒ MIGRATION - Erreur vérification besoin migration: $e',
        name: 'MultiGardenMigration',
        level: 1000,
      );
      return false;
    }
  }
}

/// Rapport de migration
class MigrationReport {
  bool success = false;
  Duration? duration;
  String? error;

  int conditionsMigrated = 0;
  int conditionsSkipped = 0;
  int conditionsErrors = 0;

  int recommendationsMigrated = 0;
  int recommendationsSkipped = 0;
  int recommendationsErrors = 0;

  int get totalMigrated => conditionsMigrated + recommendationsMigrated;
  int get totalSkipped => conditionsSkipped + recommendationsSkipped;
  int get totalErrors => conditionsErrors + recommendationsErrors;

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•');
    buffer.writeln('        RAPPORT DE MIGRATION MULTI-GARDEN');
    buffer.writeln('â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•');
    buffer.writeln();
    buffer.writeln('Statut: ${success ? "âœ… SUCCÃˆS" : "âŒ ÉCHEC"}');
    buffer.writeln('Durée: ${duration?.inSeconds ?? 0}s');
    if (error != null) {
      buffer.writeln('Erreur: $error');
    }
    buffer.writeln();
    buffer.writeln('â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€');
    buffer.writeln('  PLANT CONDITIONS');
    buffer.writeln('â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€');
    buffer.writeln('  âœ“ Migrées:  $conditionsMigrated');
    buffer.writeln('  âŠ˜ Ignorées:  $conditionsSkipped');
    buffer.writeln('  âœ— Erreurs:   $conditionsErrors');
    buffer.writeln();
    buffer.writeln('â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€');
    buffer.writeln('  RECOMMENDATIONS');
    buffer.writeln('â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€');
    buffer.writeln('  âœ“ Migrées:  $recommendationsMigrated');
    buffer.writeln('  âŠ˜ Ignorées:  $recommendationsSkipped');
    buffer.writeln('  âœ— Erreurs:   $recommendationsErrors');
    buffer.writeln();
    buffer.writeln('â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€');
    buffer.writeln('  TOTAL');
    buffer.writeln('â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€');
    buffer.writeln('  âœ“ Migrées:  $totalMigrated');
    buffer.writeln('  âŠ˜ Ignorées:  $totalSkipped');
    buffer.writeln('  âœ— Erreurs:   $totalErrors');
    buffer.writeln('â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•');

    return buffer.toString();
  }
}


