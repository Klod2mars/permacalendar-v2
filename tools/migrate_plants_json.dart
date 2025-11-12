import 'dart:convert';
import 'dart:io';

/// 🌱 Script de migration de plants.json vers le format v2.1.0
/// 
/// **Changements apportés :**
/// 1. ✅ Ajout de `schema_version` : "2.1.0"
/// 2. ✅ Ajout de `metadata` globales (version, date, total, source)
/// 3. ✅ Suppression de `plantingSeason` (redondant avec sowingMonths)
/// 4. ✅ Suppression de `harvestSeason` (redondant avec harvestMonths)
/// 5. ✅ Suppression de `notificationSettings` (logique applicative)
/// 6. ✅ Structure : { schema_version, metadata, plants: [] }
/// 
/// **Usage :**
/// ```bash
/// dart tools/migrate_plants_json.dart
/// ```
/// 
/// **Résultat :**
/// - Crée `assets/data/plants_v2.json` (nouveau format)
/// - Backup `assets/data/plants.json.backup` (sauvegarde)
/// - Affiche statistiques de migration
void main() async {
  print('🌱 ========================================');
  print('   Migration plants.json → v2.1.0');
  print('========================================\n');

  try {
    // ==================== ÉTAPE 1 : LECTURE ====================
    print('📖 Étape 1/5 : Lecture de l\'ancien fichier...');
    
    final oldFile = File('assets/data/plants.json');
    if (!await oldFile.exists()) {
      print('❌ Erreur : Le fichier assets/data/plants.json n\'existe pas !');
      exit(1);
    }
    
    final oldContent = await oldFile.readAsString();
    final List<dynamic> oldPlants = json.decode(oldContent);
    
    print('✅ ${oldPlants.length} plantes chargées depuis l\'ancien format');
    
    // ==================== ÉTAPE 2 : BACKUP ====================
    print('\n💾 Étape 2/5 : Création du backup...');
    
    final backupFile = File('assets/data/plants.json.backup');
    await backupFile.writeAsString(oldContent);
    
    print('✅ Backup créé : ${backupFile.path}');
    
    // ==================== ÉTAPE 3 : TRANSFORMATION ====================
    print('\n🔄 Étape 3/5 : Transformation des plantes...');
    
    int plantingSeasonRemoved = 0;
    int harvestSeasonRemoved = 0;
    int notificationSettingsRemoved = 0;
    
    final transformedPlants = oldPlants.map((plant) {
      // Créer une copie modifiable
      final Map<String, dynamic> newPlant = Map<String, dynamic>.from(plant);
      
      // Supprimer plantingSeason (redondant avec sowingMonths)
      if (newPlant.containsKey('plantingSeason')) {
        newPlant.remove('plantingSeason');
        plantingSeasonRemoved++;
      }
      
      // Supprimer harvestSeason (redondant avec harvestMonths)
      if (newPlant.containsKey('harvestSeason')) {
        newPlant.remove('harvestSeason');
        harvestSeasonRemoved++;
      }
      
      // Supprimer notificationSettings (logique applicative)
      if (newPlant.containsKey('notificationSettings')) {
        newPlant.remove('notificationSettings');
        notificationSettingsRemoved++;
      }
      
      return newPlant;
    }).toList();
    
    print('✅ Transformation terminée :');
    print('   - plantingSeason supprimés : $plantingSeasonRemoved');
    print('   - harvestSeason supprimés : $harvestSeasonRemoved');
    if (notificationSettingsRemoved > 0) {
      print('   - notificationSettings supprimés : $notificationSettingsRemoved');
    }
    
    // ==================== ÉTAPE 4 : CRÉATION STRUCTURE V2 ====================
    print('\n📝 Étape 4/5 : Création de la structure v2.1.0...');
    
    final now = DateTime.now();
    final newStructure = {
      'schema_version': '2.1.0',
      'metadata': {
        'version': '2.1.0',
        'updated_at': now.toIso8601String().split('T')[0], // Format : YYYY-MM-DD
        'total_plants': transformedPlants.length,
        'source': 'PermaCalendar Team',
        'description': 'Base de données des plantes pour permaculture',
        'migration_date': now.toIso8601String(),
        'migrated_from': 'legacy format (array-only)',
      },
      'plants': transformedPlants,
    };
    
    print('✅ Structure v2.1.0 créée avec métadonnées');
    
    // ==================== ÉTAPE 5 : ÉCRITURE ====================
    print('\n💾 Étape 5/5 : Écriture du nouveau fichier...');
    
    final newFile = File('assets/data/plants_v2.json');
    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(newStructure);
    
    await newFile.writeAsString(prettyJson);
    
    print('✅ Nouveau fichier créé : ${newFile.path}');
    
    // ==================== STATISTIQUES FINALES ====================
    print('\n📊 ========================================');
    print('   Statistiques de migration');
    print('========================================');
    print('');
    print('📁 Fichiers :');
    print('   - Source     : assets/data/plants.json');
    print('   - Backup     : assets/data/plants.json.backup');
    print('   - Destination: assets/data/plants_v2.json');
    print('');
    print('🌱 Plantes :');
    print('   - Total migrées      : ${transformedPlants.length}');
    print('   - Plantées           : $plantingSeasonRemoved');
    print('   - Récoltées          : $harvestSeasonRemoved');
    if (notificationSettingsRemoved > 0) {
      print('   - Notifications nett.: $notificationSettingsRemoved');
    }
    print('');
    print('📦 Structure :');
    print('   - Format      : v2.1.0');
    print('   - Schema      : ✅ Ajouté');
    print('   - Metadata    : ✅ Ajouté');
    print('   - Versioning  : ✅ Activé');
    print('');
    print('📈 Taille :');
    final oldSize = (await oldFile.length()) / 1024;
    final newSize = (await newFile.length()) / 1024;
    final reduction = ((oldSize - newSize) / oldSize * 100).toStringAsFixed(1);
    print('   - Ancien : ${oldSize.toStringAsFixed(1)} KB');
    print('   - Nouveau: ${newSize.toStringAsFixed(1)} KB');
    if (newSize < oldSize) {
      print('   - Réduction: $reduction%');
    } else {
      final increase = ((newSize - oldSize) / oldSize * 100).toStringAsFixed(1);
      print('   - Augmentation: $increase% (métadonnées)');
    }
    print('');
    print('========================================');
    print('✨ Migration terminée avec succès ! ✨');
    print('========================================\n');
    
    // ==================== INSTRUCTIONS ====================
    print('📋 Prochaines étapes :');
    print('');
    print('1. Vérifier le fichier généré :');
    print('   - Ouvrir assets/data/plants_v2.json');
    print('   - Vérifier la structure et les données');
    print('');
    print('2. Tester avec l\'application :');
    print('   - Mettre à jour PlantHiveRepository');
    print('   - Tester le chargement des plantes');
    print('');
    print('3. Si tout fonctionne :');
    print('   - Renommer plants_v2.json → plants.json');
    print('   - Garder plants.json.backup par sécurité');
    print('');
    print('4. En cas de problème :');
    print('   - Restaurer depuis plants.json.backup');
    print('   - Vérifier les logs');
    print('');
    
  } catch (e, stackTrace) {
    print('\n❌ ========================================');
    print('   ERREUR DE MIGRATION');
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

