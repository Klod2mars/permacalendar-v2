import 'dart:convert';
import 'dart:io';

/// 🌱 Script de validation de plants.json selon le schéma v2.1.0
/// 
/// **Vérifications :**
/// 1. ✅ Présence de `schema_version`
/// 2. ✅ Validité des métadonnées
/// 3. ✅ Cohérence total_plants vs length(plants)
/// 4. ✅ Champs requis pour chaque plante
/// 5. ✅ Format des sowingMonths et harvestMonths
/// 6. ✅ Valeurs numériques dans les ranges valides
/// 7. ✅ Absence de champs dépréciés (plantingSeason, harvestSeason, notificationSettings)
/// 
/// **Usage :**
/// ```bash
/// dart tools/validate_plants_json.dart [fichier]
/// dart tools/validate_plants_json.dart assets/data/plants_v2.json
/// ```
void main(List<String> args) async {
  print('🌱 ========================================');
  print('   Validation plants.json v2.1.0');
  print('========================================\n');

  // Déterminer le fichier à valider
  final filePath = args.isNotEmpty 
      ? args[0] 
      : 'assets/data/plants_v2.json';
  
  print('📂 Fichier : $filePath\n');

  try {
    // ==================== LECTURE ====================
    final file = File(filePath);
    if (!await file.exists()) {
      print('❌ Erreur : Le fichier $filePath n\'existe pas !');
      exit(1);
    }
    
    final content = await file.readAsString();
    final Map<String, dynamic> data = json.decode(content);
    
    int errors = 0;
    int warnings = 0;
    
    // ==================== VALIDATION STRUCTURE ====================
    print('🔍 Validation de la structure...\n');
    
    // 1. schema_version
    if (!data.containsKey('schema_version')) {
      print('❌ Erreur : Champ "schema_version" manquant');
      errors++;
    } else {
      final version = data['schema_version'] as String;
      if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version)) {
        print('❌ Erreur : Format de schema_version invalide : $version');
        errors++;
      } else {
        print('✅ schema_version : $version');
      }
    }
    
    // 2. metadata
    if (!data.containsKey('metadata')) {
      print('❌ Erreur : Champ "metadata" manquant');
      errors++;
    } else {
      print('\n📋 Validation des métadonnées...\n');
      final metadata = data['metadata'] as Map<String, dynamic>;
      
      // Champs requis
      final requiredFields = ['version', 'updated_at', 'total_plants', 'source'];
      for (final field in requiredFields) {
        if (!metadata.containsKey(field)) {
          print('❌ Erreur : metadata.$field manquant');
          errors++;
        } else {
          print('✅ metadata.$field : ${metadata[field]}');
        }
      }
      
      // Champs optionnels
      if (metadata.containsKey('description')) {
        print('✅ metadata.description : ${metadata['description']}');
      }
    }
    
    // 3. plants
    if (!data.containsKey('plants')) {
      print('❌ Erreur : Champ "plants" manquant');
      errors++;
      exit(1);
    }
    
    final List<dynamic> plants = data['plants'] as List;
    print('\n🌱 Validation des plantes (${plants.length} plantes)...\n');
    
    // Vérifier cohérence total_plants
    if (data.containsKey('metadata')) {
      final metadata = data['metadata'] as Map<String, dynamic>;
      if (metadata.containsKey('total_plants')) {
        final declaredTotal = metadata['total_plants'] as int;
        if (declaredTotal != plants.length) {
          print('⚠️  Warning : total_plants ($declaredTotal) != nombre réel (${plants.length})');
          warnings++;
        } else {
          print('✅ Cohérence total_plants : $declaredTotal = ${plants.length}');
        }
      }
    }
    
    // ==================== VALIDATION DES PLANTES ====================
    print('\n🔍 Validation détaillée des plantes...\n');
    
    final requiredPlantFields = ['id', 'commonName', 'scientificName', 'family'];
    final deprecatedFields = ['plantingSeason', 'harvestSeason', 'notificationSettings'];
    final validMonths = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    
    int plantsWithErrors = 0;
    int deprecatedFieldsFound = 0;
    
    for (int i = 0; i < plants.length; i++) {
      final plant = plants[i] as Map<String, dynamic>;
      final plantId = plant['id'] ?? 'plante_$i';
      bool hasError = false;
      
      // Vérifier champs requis
      for (final field in requiredPlantFields) {
        if (!plant.containsKey(field) || plant[field] == null || plant[field] == '') {
          print('❌ [$plantId] Champ requis "$field" manquant ou vide');
          errors++;
          hasError = true;
        }
      }
      
      // Vérifier champs dépréciés
      for (final field in deprecatedFields) {
        if (plant.containsKey(field)) {
          print('⚠️  [$plantId] Champ déprécié "$field" présent (devrait être supprimé)');
          warnings++;
          deprecatedFieldsFound++;
        }
      }
      
      // Vérifier format sowingMonths
      if (plant.containsKey('sowingMonths')) {
        final sowingMonths = plant['sowingMonths'] as List?;
        if (sowingMonths != null) {
          for (final month in sowingMonths) {
            if (!validMonths.contains(month)) {
              print('❌ [$plantId] sowingMonths invalide : "$month" (attendu: J,F,M,A,M,J,J,A,S,O,N,D)');
              errors++;
              hasError = true;
            }
          }
        }
      }
      
      // Vérifier format harvestMonths
      if (plant.containsKey('harvestMonths')) {
        final harvestMonths = plant['harvestMonths'] as List?;
        if (harvestMonths != null) {
          for (final month in harvestMonths) {
            if (!validMonths.contains(month)) {
              print('❌ [$plantId] harvestMonths invalide : "$month"');
              errors++;
              hasError = true;
            }
          }
        }
      }
      
      // Vérifier daysToMaturity
      if (plant.containsKey('daysToMaturity')) {
        final days = plant['daysToMaturity'];
        if (days is int && (days < 1 || days > 365)) {
          print('⚠️  [$plantId] daysToMaturity hors limites : $days (attendu: 1-365)');
          warnings++;
        }
      }
      
      // Vérifier spacing et depth
      if (plant.containsKey('spacing')) {
        final spacing = plant['spacing'];
        if (spacing is num && spacing < 0) {
          print('❌ [$plantId] spacing négatif : $spacing');
          errors++;
          hasError = true;
        }
      }
      
      if (plant.containsKey('depth')) {
        final depth = plant['depth'];
        if (depth is num && depth < 0) {
          print('❌ [$plantId] depth négatif : $depth');
          errors++;
          hasError = true;
        }
      }
      
      if (hasError) {
        plantsWithErrors++;
      }
    }
    
    // ==================== RÉSUMÉ ====================
    print('\n📊 ========================================');
    print('   Résumé de la validation');
    print('========================================\n');
    
    print('📄 Fichier : $filePath');
    print('📦 Schema : v${data['schema_version']}');
    print('🌱 Plantes : ${plants.length}');
    print('');
    print('🔍 Résultats :');
    print('   - Erreurs  : $errors');
    print('   - Warnings : $warnings');
    print('   - Plantes avec erreurs : $plantsWithErrors');
    if (deprecatedFieldsFound > 0) {
      print('   - Champs dépréciés trouvés : $deprecatedFieldsFound');
    }
    print('');
    
    if (errors == 0 && warnings == 0) {
      print('========================================');
      print('✨ ✅ VALIDATION RÉUSSIE ! ✅ ✨');
      print('========================================');
      print('');
      print('Le fichier respecte parfaitement le schéma v2.1.0');
      print('🌱 Prêt pour la production ! 🌱');
      print('');
      exit(0);
    } else if (errors == 0) {
      print('========================================');
      print('⚠️  VALIDATION RÉUSSIE AVEC WARNINGS');
      print('========================================');
      print('');
      print('Le fichier est valide mais contient des warnings.');
      print('Recommandé de corriger les warnings avant production.');
      print('');
      exit(0);
    } else {
      print('========================================');
      print('❌ VALIDATION ÉCHOUÉE');
      print('========================================');
      print('');
      print('Le fichier contient $errors erreur(s) critique(s).');
      print('Corrigez les erreurs avant d\'utiliser ce fichier.');
      print('');
      exit(1);
    }
    
  } catch (e, stackTrace) {
    print('\n❌ ========================================');
    print('   ERREUR DE VALIDATION');
    print('========================================');
    print('');
    print('Message : $e');
    print('');
    print('Stack trace :');
    print(stackTrace);
    print('');
    print('========================================\n');
    exit(1);
  }
}


