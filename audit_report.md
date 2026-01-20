# Rapport d'Audit : Fichier de Traduction (plants_en.json)

**Fichier audité** : `assets/data/json_multilangue_doc/plants_en.json`
**Fichier de référence** : `assets/data/plants.json`
**Date** : 20/01/2026

## 1. Statut Global : ⛔ À PROSCRIRE EN L'ÉTAT

Le fichier `plants_en.json` contient des **erreurs de syntaxe critique** qui empêchent son parsing (lecture) par l'application. Il ne doit **pas** être intégré sans corrections préalables.

### 🔴 Erreurs Critiques (Bloquantes)
1.  **Structure JSON Invalide** :
    *   La liste `plants` semble mal formée. Le fichier alterne entre des objets fermés et des clés "orphelines".
    *   Exemple (lignes 98-101) :
        ```json
        			]
        		}
        	},
        	"asparagus": {
        ```
        La clé `"asparagus"` se trouve hors de tout objet, ou directement dans un tableau sans accolades englobantes, ce qui est illégal en JSON.
2.  **Syntaxe Manquante (Asparagus)** :
    *   Dans l'objet `asparagus` -> `watering`, il manque les deux-points (`:`) entre les clés et les valeurs.
    *   Exemple (lignes 109-111) :
        ```json
        "frequency" "Every 10 to 14 days in sandy soil",
        "amount" "50–75 mm per watering..."
        ```
        Correction requise : `"frequency": "Every..."`

---

## 2. Audit de Cohérence Sémantique et Structurelle

### Structure
*   **Différence de Modèle** :
    *   **Original** : Liste d'objets plats `[ { "id": "artichoke", ... }, ... ]`
    *   **Traduction** : Liste d'objets ou Map (selon l'intention) sous la forme `[ { "artichoke": { ... } } ]`.
    *   **Impact** : Si l'application attend la structure originale, ce fichier **ne fonctionnera pas** même après correction de la syntaxe. Il faut vérifier si le mécanisme de chargement (i18n) gère ce format spécifique (Clé d'ID comme racine).

### Contenu
*   **Langue** : Le fichier nommé `plants_en.json` (et décrit comme "traduit en français") contient en réalité de l'**ANGLAIS**. (e.g., `"commonName": "Artichoke"`).
*   **Respect des Clés** : Les clés internes (`commonName`, `watering`, `thinning`) semblent respectées pour les sections présentes.

---

## 3. Audit des Unités de Mesure (cm)

**Constat** :
De nombreuses chaînes de caractères contiennent des unités métriques (`cm`, `mm`, `°C`).
*   *Exemples* : `"80 cm between plants"`, `"25–50 mm of water"`, `"(7°C)"`.

**Analyse de Risque : Remplacement cm → inches**

*   **Usage dans le code (UI)** :
    *   L'écran de détail (`PlantDetailScreen.dart`) affiche les valeurs numériques brutes (ex: `spacing` = 80) suivies d'une unité **codée en dur** dans l'interface (`cm`).
    *   Code actuel : `_buildDetailRow('Espacement', '${plant.spacing} cm', ...)`

*   **Risque de Remplacement (⛔ ÉLEVÉ)** :
    *   Si vous remplacez "80 cm" par "31 inches" dans les descriptions textuelles du JSON traduit :
        1.  L'utilisateur lira **"Space 31 inches apart"** dans le texte (description/thinning).
        2.  L'utilisateur verra **"Espacement: 80 cm"** dans le tableau de détails (donnée brute + suffixe hardcodé).
    *   Cela crée une **incohérence majeure** et déroutante pour l'utilisateur (mélange d'unités et de valeurs).

---

## 4. Recommandations et Stratégie

### ✅ Étape 1 : Correction des Erreurs (Priorité Absolue)
Il faut impérativement corriger la syntaxe du fichier `plants_en.json` pour qu'il soit valide.
*   Ajouter les deux-points manquants (`:`).
*   Corriger la structure de la liste `plants` (probablement envelopper chaque plante dans `{}`).

### ⚠️ Étape 2 : Gestion des Unités
**Ne PAS effectuer le remplacement "cm → inches" maintenant.**
*   **Raison** : Tant que l'interface (`PlantDetailScreen.dart`) code en dur "cm", le contenu traduit doit rester en métrique pour maintenir la cohérence.
*   **Solution Long Terme** : Pour passer aux unités impériales (US), il faudra une modification du code (`PlantDetailScreen`) pour convertir dynamiquement les valeurs numériques (`80` -> `31`) et changer le suffixe (`inches`) selon la locale de l'utilisateur.

### Stratégie Minimale (Non-Destructive)
1.  **Corriger uniquement la syntaxe JSON** pour rendre le fichier utilisable.
2.  **Conserver les valeurs en cm** et les textes en anglais dans le fichier traduit (ex: "80 cm").
3.  Utiliser ce fichier pour l'affichage *textuel* en anglais, en acceptant que les unités soient métriques (ce qui est standard scientifique/international, ou au moins cohérent avec l'affichage des données).
