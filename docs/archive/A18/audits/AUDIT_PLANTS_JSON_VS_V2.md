# 🔍 Audit plants.json vs plants_v2.json

**Date :** 12 octobre 2025  
**Objectif :** Identifier l'origine des conflits liés à la cohabitation de `plants.json` et `plants_v2.json`, et comprendre pourquoi certaines données d'analyse ne remontent pas dans le module Intelligence Végétale.

---

## 📊 Vue d'ensemble

### Fichiers identifiés dans `assets/data/`

| Fichier | Format | Taille | Statut | Utilisé par l'app |
|---------|--------|--------|--------|-------------------|
| `plants.json` | Legacy (array-only) | ~100 KB | ✅ Actif | ✅ **OUI - PRINCIPAL** |
| `plants_v2.json` | v2.1.0 (structured) | ~105 KB | ⚠️ Inutilisé | ❌ **NON** |
| `plants.json.backup` | Legacy (array-only) | ~100 KB | 💾 Backup | ❌ NON |

### Statistiques de référence

- **57 occurrences** de `plants.json` dans le code
- **15 occurrences** de `plants_v2.json` (uniquement dans outils de migration et documentation)
- **0 occurrence** de `plants.json.v2`

---

## 🎯 Diagnostic principal

### ❌ PROBLÈME IDENTIFIÉ : plants_v2.json n'est jamais utilisé

**L'application charge exclusivement `plants.json` (format legacy), alors que `plants_v2.json` (format v2.1.0 amélioré) existe mais reste inutilisé.**

#### Différences critiques entre les formats

| Caractéristique | plants.json (Legacy) | plants_v2.json (v2.1.0) |
|-----------------|---------------------|------------------------|
| **Structure** | Array simple `[{...}, {...}]` | Objet structuré avec metadata |
| **schema_version** | ❌ Absent | ✅ `"2.1.0"` |
| **Metadata globales** | ❌ Aucune | ✅ version, date, total_plants, source |
| **plantingSeason** | ✅ Présent (redondant) | ❌ Supprimé (utilise sowingMonths) |
| **harvestSeason** | ✅ Présent (redondant) | ❌ Supprimé (utilise harvestMonths) |
| **notificationSettings** | ✅ Présent | ❌ Supprimé (logique applicative) |
| **Versioning** | ❌ Non versionné | ✅ Versionné et traçable |

#### Exemple de structure

**plants.json (Legacy):**
```json
[
  {
    "id": "tomato",
    "commonName": "Tomate",
    "scientificName": "Solanum lycopersicum",
    "family": "Solanaceae",
    "plantingSeason": "Printemps",
    "harvestSeason": "Été,Automne",
    "sowingMonths": ["F", "M", "A"],
    "harvestMonths": ["J", "J", "A", "S", "O"],
    ...
  }
]
```

**plants_v2.json (v2.1.0):**
```json
{
  "schema_version": "2.1.0",
  "metadata": {
    "version": "2.1.0",
    "updated_at": "2025-10-08",
    "total_plants": 44,
    "source": "PermaCalendar Team",
    "description": "Base de données des plantes pour permaculture",
    "migration_date": "2025-10-08T19:10:42.252463",
    "migrated_from": "legacy format (array-only)"
  },
  "plants": [
    {
      "id": "tomato",
      "commonName": "Tomate",
      "scientificName": "Solanum lycopersicum",
      "family": "Solanaceae",
      "sowingMonths": ["F", "M", "A"],
      "harvestMonths": ["J", "J", "A", "S", "O"],
      ...
    }
  ]
}
```

---

## 📂 Cartographie des usages dans le code

### 🔴 Services chargant plants.json (Legacy)

#### 1. PlantHiveRepository
**Fichier :** `lib/features/plant_catalog/data/repositories/plant_hive_repository.dart`

```dart
// Ligne 27
static const String _jsonAssetPath = 'assets/data/plants.json';

// Ligne 147
final String jsonString = await rootBundle.loadString(_jsonAssetPath);
```

**Responsabilité :**
- Charge `plants.json` depuis les assets
- Convertit le JSON en objets `PlantHive` et les stocke dans Hive
- Supporte la détection automatique des formats (legacy et v2.1.0)
- **✅ Point positif :** Le code supporte déjà le format v2.1.0, mais ne l'utilise pas !

**Utilisé par :**
- `PlantDataSourceImpl` (Intelligence Végétale)
- `PlantCatalogProvider` (Catalogue)
- `AppInitializer` (Initialisation app)

#### 2. PlantCatalogService
**Fichier :** `lib/core/services/plant_catalog_service.dart`

```dart
// Ligne 7
static const String _plantsAssetPath = 'assets/data/plants.json';

// Ligne 25
final String jsonString = await rootBundle.loadString(_plantsAssetPath);
```

**Responsabilité :**
- Service alternatif pour accéder au catalogue de plantes
- Cache les données en mémoire
- **⚠️ Format supporté :** Uniquement Legacy (array-only)

**Utilisé par :**
- `LegacyDataAdapter` (Garden Aggregation Hub)

#### 3. AppInitializer
**Fichier :** `lib/app_initializer.dart`

```dart
// Ligne 142
// Initialiser le PlantHiveRepository et charger depuis plants.json
await PlantHiveRepository.initialize();
final plantRepository = PlantHiveRepository();
await plantRepository.initializeFromJson();
```

**Responsabilité :**
- Initialise l'application au démarrage
- Charge les données de plantes depuis `plants.json` via `PlantHiveRepository`

---

### 🟢 Outils référençant plants_v2.json (Non utilisés par l'app)

#### 1. migrate_plants_json.dart
**Fichier :** `tools/migrate_plants_json.dart`

**Rôle :**
- Outil de migration du format legacy vers v2.1.0
- Crée `plants_v2.json` à partir de `plants.json`
- Effectue les transformations suivantes :
  - Supprime `plantingSeason` (redondant)
  - Supprime `harvestSeason` (redondant)
  - Supprime `notificationSettings` (logique app)
  - Ajoute `schema_version` et `metadata`

**Status :** ✅ Migration déjà effectuée (plants_v2.json existe)

#### 2. validate_plants_json.dart
**Fichier :** `tools/validate_plants_json.dart`

**Rôle :**
- Valide la structure et le schéma de `plants_v2.json`
- Vérifie la conformité avec le schéma v2.1.0

**Status :** ✅ Outil fonctionnel

---

## 🔗 Flux de données vers l'Intelligence Végétale

### Chaîne de dépendances complète

```
assets/data/plants.json (Legacy)
         ↓
PlantHiveRepository.initializeFromJson()
         ↓
Hive Box: plants_box (stockage local)
         ↓
PlantHiveRepository.getAllPlants() / getPlantById()
         ↓
┌────────────────────────────────┬────────────────────────────────┐
│                                │                                │
PlantDataSourceImpl              PlantCatalogProvider            LegacyDataAdapter
(Intelligence Végétale)          (Catalogue UI)                  (Garden Aggregation)
         ↓                                ↓                               ↓
AnalyzePlantConditionsUseCase    PlantCatalogScreen             GardenAggregationHub
         ↓                                                               ↓
PlantIntelligenceOrchestrator                              IntelligenceDataAdapter
         ↓                                                               ↓
PlantIntelligenceDashboard                                 IntelligenceModule
```

### Points de contact critiques

| Service | Fichier | Méthode | Format attendu |
|---------|---------|---------|----------------|
| **PlantHiveRepository** | `plant_hive_repository.dart:147` | `initializeFromJson()` | Legacy ou v2.1.0 (détection auto) |
| **PlantCatalogService** | `plant_catalog_service.dart:25` | `loadPlants()` | Legacy uniquement |
| **PlantDataSourceImpl** | `plant_datasource_impl.dart:20` | `getPlant()` | Via PlantHiveRepository |
| **LegacyDataAdapter** | `legacy_data_adapter.dart:134` | `getActivePlants()` | Via PlantCatalogService |

---

## 🚨 Impact sur l'Intelligence Végétale

### Pourquoi les données ne remontent pas correctement ?

#### 1. Absence de métadonnées structurées

Le format legacy ne fournit pas :
- ❌ Version du schéma (pas de traçabilité)
- ❌ Date de dernière mise à jour
- ❌ Nombre total de plantes (pas de validation)
- ❌ Source des données

**Conséquence :** Impossible de valider l'intégrité des données ou de détecter des incohérences.

#### 2. Redondance de données (plantingSeason vs sowingMonths)

Le format legacy contient :
```json
{
  "plantingSeason": "Printemps",
  "sowingMonths": ["F", "M", "A"]
}
```

**Problème :** Les algorithmes d'analyse peuvent utiliser `plantingSeason` (texte libre, peu précis) au lieu de `sowingMonths` (mois exacts).

**Impact sur les analyses :**
- Calculs de germination imprécis
- Recommandations de plantation approximatives
- Alertes mal calibrées

#### 3. Format non versionné

Sans `schema_version`, impossible de :
- Détecter les changements de structure
- Appliquer des migrations automatiques
- Garantir la compatibilité future

#### 4. PlantCatalogService limité au format Legacy

```dart
// plant_catalog_service.dart:26
final List<dynamic> jsonList = json.decode(jsonString);
```

Ce code suppose que le JSON est un array, **il échouerait avec plants_v2.json**.

**Utilisé par :**
- `LegacyDataAdapter` → utilisé par le Garden Aggregation Hub
- Potentiellement d'autres services à découvrir

---

## ✅ Recommandations

### 🎯 Action #1 : Activer plants_v2.json comme source principale

**Priorité :** 🔴 CRITIQUE

#### Étapes :

1. **Renommer les fichiers** (backup de sécurité)
   ```bash
   # Backup supplémentaire du legacy
   copy assets/data/plants.json assets/data/plants_legacy.json.backup
   
   # Remplacer plants.json par la version v2.1.0
   copy assets/data/plants_v2.json assets/data/plants.json
   ```

2. **Vérifier la compatibilité**
   - ✅ `PlantHiveRepository` supporte déjà v2.1.0 (détection automatique lignes 155-199)
   - ⚠️ `PlantCatalogService` doit être mis à jour

3. **Tester l'application**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

**Bénéfices attendus :**
- ✅ Métadonnées structurées disponibles
- ✅ Données normalisées (pas de redondance)
- ✅ Versioning activé
- ✅ Analyses d'intelligence végétale plus précises

---

### 🎯 Action #2 : Mettre à jour PlantCatalogService pour supporter v2.1.0

**Priorité :** 🟠 IMPORTANTE

**Fichier :** `lib/core/services/plant_catalog_service.dart`

#### Modification proposée :

```dart
static Future<List<Plant>> loadPlants({bool forceReload = false}) async {
  // ... cache logic ...

  try {
    // Charger le fichier JSON
    final String jsonString = await rootBundle.loadString(_plantsAssetPath);
    
    // ✅ NOUVEAU : Détection automatique du format
    final dynamic jsonData = json.decode(jsonString);
    
    List<dynamic> jsonList;
    
    if (jsonData is List) {
      // Format Legacy (array-only)
      jsonList = jsonData;
    } else if (jsonData is Map<String, dynamic>) {
      // Format v2.1.0+ (structured)
      final schemaVersion = jsonData['schema_version'] as String?;
      if (schemaVersion == null) {
        throw PlantCatalogException('Format JSON invalide');
      }
      
      // Extraire la liste des plantes
      jsonList = jsonData['plants'] as List? ?? [];
    } else {
      throw PlantCatalogException('Format JSON invalide');
    }
    
    // Convertir en objets Plant
    final List<Plant> plants = jsonList
        .map((json) => Plant.fromJson(json as Map<String, dynamic>))
        .toList();
    
    // Mettre en cache
    _cachedPlants = plants;
    _lastLoadTime = DateTime.now();
    
    return plants;
  } catch (e) {
    throw PlantCatalogException('Erreur lors du chargement des plantes: $e');
  }
}
```

**Bénéfices :**
- ✅ Support des deux formats (legacy et v2.1.0)
- ✅ Transition en douceur
- ✅ Pas de breaking changes

---

### 🎯 Action #3 : Nettoyer les fichiers obsolètes

**Priorité :** 🟡 RECOMMANDÉE

Une fois la migration validée et stable :

1. **Supprimer plants_v2.json** (devenu plants.json)
   ```bash
   del assets/data/plants_v2.json
   ```

2. **Conserver plants.json.backup** (sécurité)
   - Garder comme référence historique
   - Utile en cas de régression

3. **Mettre à jour la documentation**
   - README.md
   - ARCHITECTURE.md
   - Diagrammes de flux

---

### 🎯 Action #4 : Ajouter des validations au démarrage

**Priorité :** 🟡 RECOMMANDÉE

**Fichier :** `lib/app_initializer.dart`

#### Ajout suggéré :

```dart
static Future<void> _validatePlantData() async {
  try {
    print('🔍 Validation des données de plantes...');
    
    // Charger le JSON brut
    final jsonString = await rootBundle.loadString('assets/data/plants.json');
    final dynamic jsonData = json.decode(jsonString);
    
    // Vérifier le format
    if (jsonData is Map<String, dynamic>) {
      final schemaVersion = jsonData['schema_version'] as String?;
      final metadata = jsonData['metadata'] as Map<String, dynamic>?;
      final plants = jsonData['plants'] as List?;
      
      if (schemaVersion != null && metadata != null && plants != null) {
        print('✅ Format v$schemaVersion détecté');
        print('   - Total plantes: ${metadata['total_plants']}');
        print('   - Version: ${metadata['version']}');
        print('   - Dernière màj: ${metadata['updated_at']}');
        
        // Validation de cohérence
        if (plants.length != metadata['total_plants']) {
          print('⚠️ Incohérence: ${plants.length} plantes trouvées, ${metadata['total_plants']} attendues');
        }
      }
    } else if (jsonData is List) {
      print('⚠️ Format Legacy détecté (array-only)');
      print('   Recommandation: Migrer vers v2.1.0');
    }
  } catch (e) {
    print('❌ Erreur validation données plantes: $e');
  }
}

// Appeler dans initialize()
static Future<void> initialize() async {
  // ... code existant ...
  
  // Valider les données de plantes
  await _validatePlantData();
  
  // ... reste du code ...
}
```

**Bénéfices :**
- ✅ Détection précoce des problèmes de données
- ✅ Logs informatifs au démarrage
- ✅ Traçabilité de la version des données

---

## 📋 Plan d'action recommandé

### Phase 1 : Migration immédiate (30 min)

| Étape | Action | Commande | Validation |
|-------|--------|----------|------------|
| 1 | Backup legacy | `copy assets/data/plants.json assets/data/plants_legacy.json.backup` | Vérifier que le fichier existe |
| 2 | Activer v2.1.0 | `copy assets/data/plants_v2.json assets/data/plants.json` | Vérifier le contenu |
| 3 | Nettoyer build | `flutter clean && flutter pub get` | Pas d'erreurs |
| 4 | Tester l'app | `flutter run` | L'app démarre sans erreur |

### Phase 2 : Mise à jour du code (1-2h)

| Fichier | Modification | Complexité |
|---------|--------------|------------|
| `plant_catalog_service.dart` | Ajouter détection format v2.1.0 | 🟡 Moyenne |
| `app_initializer.dart` | Ajouter validation au démarrage | 🟢 Facile |

### Phase 3 : Tests et validation (30 min)

- [ ] Catalogue de plantes s'affiche correctement
- [ ] Intelligence Végétale reçoit les données
- [ ] Analyses de conditions fonctionnent
- [ ] Pas d'erreurs dans les logs
- [ ] Tests unitaires passent

### Phase 4 : Nettoyage (15 min)

- [ ] Supprimer `plants_v2.json`
- [ ] Mettre à jour la documentation
- [ ] Commit + Push

---

## 🎓 Conclusion

### Diagnostic final

**Problème racine identifié :**
L'application utilise exclusivement `plants.json` (format legacy non structuré), alors que `plants_v2.json` (format v2.1.0 amélioré et versionné) existe mais n'est jamais activé.

### Impact sur l'Intelligence Végétale

| Problème | Cause | Impact |
|----------|-------|--------|
| Données imprécises | Redondance plantingSeason/sowingMonths | ⚠️ Analyses approximatives |
| Pas de métadonnées | Format legacy sans metadata | ❌ Impossible de valider l'intégrité |
| Pas de versioning | Aucun schema_version | ❌ Pas de traçabilité |
| Service legacy limité | PlantCatalogService ne supporte que array | ⚠️ Bloque la migration |

### Solution recommandée

**✅ Migration vers plants_v2.json (format v2.1.0)**

**Raisons :**
1. ✅ Format déjà prêt et validé
2. ✅ PlantHiveRepository compatible (détection automatique)
3. ✅ Données normalisées et structurées
4. ✅ Versioning activé
5. ✅ Métadonnées complètes

**Risques :** 🟢 FAIBLES
- PlantCatalogService doit être mis à jour (modification mineure)
- Tests de non-régression nécessaires

**Bénéfices attendus :** 🔵 ÉLEVÉS
- Analyses d'intelligence végétale plus précises
- Traçabilité et validation des données
- Évolutivité garantie
- Conformité aux standards de l'architecture

---

## 📎 Annexes

### A. Comparaison détaillée des formats

| Propriété | Legacy | v2.1.0 | Justification suppression |
|-----------|--------|--------|--------------------------|
| schema_version | ❌ | ✅ | - |
| metadata | ❌ | ✅ | - |
| plantingSeason | ✅ | ❌ | Redondant avec sowingMonths |
| harvestSeason | ✅ | ❌ | Redondant avec harvestMonths |
| notificationSettings | ✅ | ❌ | Logique applicative, pas données plante |
| sowingMonths | ✅ | ✅ | Précis et exploitable |
| harvestMonths | ✅ | ✅ | Précis et exploitable |
| germination | ✅ | ✅ | Essentiel pour analyses |
| watering | ✅ | ✅ | Essentiel pour analyses |
| biologicalControl | ✅ | ✅ | Essentiel pour analyses |

### B. Fichiers modifiés nécessaires

**Modifications obligatoires :**
- `assets/data/plants.json` → Remplacer par v2.1.0

**Modifications recommandées :**
- `lib/core/services/plant_catalog_service.dart` → Ajouter support v2.1.0
- `lib/app_initializer.dart` → Ajouter validation

**Pas de modification :**
- `lib/features/plant_catalog/data/repositories/plant_hive_repository.dart` → Déjà compatible ✅

### C. Tests à effectuer

**Tests fonctionnels :**
- [ ] Démarrage de l'application
- [ ] Affichage du catalogue de plantes
- [ ] Affichage des détails d'une plante
- [ ] Analyse d'intelligence végétale
- [ ] Génération de recommandations
- [ ] Affichage des alertes

**Tests techniques :**
- [ ] Chargement depuis assets
- [ ] Conversion JSON → PlantHive
- [ ] Stockage dans Hive
- [ ] Récupération depuis Hive
- [ ] Logs de démarrage

---

**📅 Généré le :** 12 octobre 2025  
**🔧 Outil :** Cursor AI - Audit automatisé  
**✅ Status :** Audit complet - Prêt pour action

