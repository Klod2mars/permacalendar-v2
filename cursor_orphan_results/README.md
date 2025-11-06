# Analyse des Orphelins - PermaCalendar v2

Cette analyse a été générée automatiquement pour détecter les fichiers, providers Riverpod et symboles potentiellement non utilisés dans le projet.

## 📊 Résultats de l'analyse

- **Fichiers analysés**: 334 fichiers Dart
- **Fichiers potentiellement non référencés**: 68
- **Providers Riverpod**: 106 trouvés (54 orphelins, 52 utilisés)
- **Symboles top-level non référencés**: 1032

## 📁 Fichiers générés

1. **`orphan_report.md`** - Rapport consolidé avec résumé et extraits (inclut les marqueurs de citation)
2. **`unreferenced_files.txt`** - Liste complète des fichiers potentiellement non référencés (avec marqueurs)
3. **`orphan_providers.txt`** - Liste des providers Riverpod orphelins et utilisés (avec marqueurs)
4. **`unused_symbols.txt`** - Liste des symboles top-level (classes, fonctions, etc.) non référencés (avec marqueurs)
5. **`issues/`** - Dossier contenant les templates d'issues GitHub prêts à copier-coller

## ⚠️ Important : Faux-positifs possibles

Cette analyse est **statique** et peut produire des faux-positifs. Vérifiez manuellement :

- ✅ **Exports via barrel files** : Les fichiers exportés via `lib/my_package.dart` ou fichiers d'export peuvent sembler non référencés
- ✅ **Références dynamiques** : Code utilisé via reflection, génération de code (`.g.dart`, `.freezed.dart`)
- ✅ **Usage dans tests** : Symboles utilisés uniquement dans `test/` ne sont pas analysés
- ✅ **Providers Riverpod** : Providers utilisés via `.family`, `.notifier`, ou références indirectes
- ✅ **Routes dynamiques** : Widgets référencés via des strings (routes nommées)
- ✅ **Code conditionnel** : Code utilisé via des asserts, code platform-specific

## 🚀 Comment utiliser cette analyse

1. **Examiner le rapport principal** : `orphan_report.md`
2. **Vérifier les fichiers suspects** : Ouvrir `unreferenced_files.txt`
3. **Analyser les providers** : Vérifier `orphan_providers.txt` pour les providers non utilisés
4. **Réviser les symboles** : `unused_symbols.txt` liste les classes/fonctions potentiellement non utilisées

## 🔧 Ré-exécuter l'analyse

Pour relancer l'analyse, exécutez :

```powershell
# Sur Windows (avec Message IDX optionnel)
.\scripts\run_orphan_analysis.ps1 -MessageIdx "12"

# Ou directement avec Dart
dart run tools/orphan_analyzer.dart cursor_orphan_results 12
```

### Paramètres

- `OutputDir` : Dossier de sortie (défaut: `cursor_orphan_results`)
- `MessageIdx` : Identifiant pour les marqueurs de citation `【message_idx†source】` (défaut: `12`)

## 📝 Templates d'issues GitHub

Des templates d'issues prêts à l'emploi sont générés dans le dossier `issues/` :
- `rehydrate_orphan_provider_*.md` : Un template par provider orphelin
- `rehydrate_orphan_file_*.md` : Un template par fichier orphelin

Ces templates incluent :
- Les marqueurs de citation `【message_idx†source】` pour la traçabilité
- Des extraits de code pour faciliter la revue
- Un plan de ré-intégration suggéré

## 📝 Prochaines étapes recommandées

1. **Audit manuel** : Passer en revue chaque item détecté
2. **Vérifier les exports** : S'assurer que les barrel files exportent correctement
3. **Tests** : Vérifier si les symboles sont utilisés dans les tests
4. **Documentation** : Documenter les choix de conservation/suppression
5. **Nettoyage progressif** : Supprimer uniquement après vérification complète

## 🔖 Marqueurs de citation

Chaque item détecté est annoté avec un marqueur de preuve `【message_idx†source】` :

- **`message_idx`** : Identifiant configurable (par défaut: `12`) permettant de grouper les preuves
- **`source`** : Chemin du fichier ou `chemin:ligne` pour la position exacte

**Exemples :**
- `【12†lib/core/models/garden_bed_v2.dart】` - Fichier orphelin
- `【12†core\di\garden_module.dart:126】` - Provider orphelin à la ligne 126

Ces marqueurs permettent :
- ✅ D'agréger automatiquement les preuves dans des systèmes externes (issue tracker, Notion, etc.)
- ✅ De retrouver rapidement la position exacte dans le code source
- ✅ De tracer l'origine de chaque détection pour faciliter la revue manuelle

---

**Note** : Cette analyse est **non-destructive** - elle ne modifie pas le code source. Tous les changements doivent être faits manuellement après validation.


