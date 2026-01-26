
import 'dart:core';

class NutritionNormalizer {
  // Facteurs de conversion
  static const double _mgToG = 0.001;
  static const double _mcgToG = 0.000001;
  static const double _mcgToMg = 0.001;
  static const double _gToMg = 1000.0;
  static const double _mgToMcg = 1000.0;
  static const double _gToMcg = 1000000.0;

  /// Mapping des tokens (parties de mot) vers la clé canonique.
  /// La clé canonique inclut l'unité cible (ex: _mg, _mcg, _g).
  static const Map<String, String> _tokenToCanonical = {
    // Énergie
    'calories': 'calories_kcal',
    'kcal': 'calories_kcal',
    'energy': 'calories_kcal',
    'energie': 'calories_kcal',
    'ener': 'calories_kcal',

    // Macros
    'protein': 'protein_g',
    'proteine': 'protein_g',
    'prot': 'protein_g',
    'carbs': 'carbs_g',
    'carbohydrate': 'carbs_g',
    'glucide': 'carbs_g',
    'fat': 'fat_g',
    'lipide': 'fat_g',
    'lipid': 'fat_g',
    'gias': 'fat_g', // 'gras'
    'fiber': 'fiber_g',
    'fibre': 'fiber_g',
    'sugar': 'sugar_g',
    'sucre': 'sugar_g',
    'water': 'water_g',
    'eau': 'water_g',

    // Minéraux
    'calcium': 'calcium_mg',
    'ca': 'calcium_mg',
    'iron': 'iron_mg',
    'fer': 'iron_mg',
    'fe': 'iron_mg',
    'magnesium': 'magnesium_mg',
    'mg': 'magnesium_mg', // Risque de collision avec milligramme, géré par l'algo
    'potassium': 'potassium_mg',
    'k': 'potassium_mg',
    'zinc': 'zinc_mg',
    'zn': 'zinc_mg',
    'manganese': 'manganese_mg',
    'mn': 'manganese_mg',
    'phosphorus': 'phosphorus_mg',
    'phosphore': 'phosphorus_mg',
    'p': 'phosphorus_mg',
    'sodium': 'sodium_mg',
    'na': 'sodium_mg',
    'copper': 'copper_mg',
    'cuivre': 'copper_mg',
    'cu': 'copper_mg',
    'selenium': 'selenium_mcg',
    'se': 'selenium_mcg',
    'iodine': 'iodine_mcg',
    'iode': 'iodine_mcg',

    // Vitamines
    'vitaminc': 'vitamin_c_mg',
    'vitc': 'vitamin_c_mg',
    'ascorbic': 'vitamin_c_mg',
    'vitamina': 'vitamin_a_mcg',
    'vita': 'vitamin_a_mcg',
    'retinol': 'vitamin_a_mcg',
    'vitamine': 'vitamin_e_mg', // Attention ambiguïté "Vitamine", check prioritaire
    'vite': 'vitamin_e_mg',
    'tocopherol': 'vitamin_e_mg',
    'vitamink': 'vitamin_k_mcg',
    'vitk': 'vitamin_k_mcg',
    'phylloquinone': 'vitamin_k_mcg',
    'vitaminb1': 'vitamin_b1_mg',
    'vitb1': 'vitamin_b1_mg',
    'thiamin': 'vitamin_b1_mg',
    'vitaminb2': 'vitamin_b2_mg',
    'vitb2': 'vitamin_b2_mg',
    'riboflavin': 'vitamin_b2_mg',
    'vitaminb3': 'vitamin_b3_mg',
    'vitb3': 'vitamin_b3_mg',
    'niacin': 'vitamin_b3_mg',
    'vitaminb5': 'vitamin_b5_mg',
    'vitb5': 'vitamin_b5_mg',
    'pantothenic': 'vitamin_b5_mg',
    'vitaminb6': 'vitamin_b6_mg',
    'vitb6': 'vitamin_b6_mg',
    'pyridoxine': 'vitamin_b6_mg',
    'vitaminb9': 'vitamin_b9_mcg',
    'vitb9': 'vitamin_b9_mcg',
    'folate': 'vitamin_b9_mcg',
    'folic': 'vitamin_b9_mcg',
    'vitaminb12': 'vitamin_b12_mcg',
    'vitb12': 'vitamin_b12_mcg',
    'cobalamin': 'vitamin_b12_mcg',

    // Phytonutriments spécifiques
    'cynarin': 'cynarin_mg',
    'luteolin': 'luteolin_mg',
    'eugenol': 'eugenol_mg',
    'lutein': 'lutein_zeaxanthin_mcg',
    'zeaxanthin': 'lutein_zeaxanthin_mcg',
    'betaine': 'betaine_mg',
    'nitrate': 'nitrates_mg',
    'asparagine': 'asparagine_mg',
    'glutathione': 'glutathione_mg',
    'silicon': 'silicon_mg',
    'silicium': 'silicon_mg',
  };

  /// Normalise une Map brute issue du JSON.
  /// Renvoie UNE COPIE propre avec clés canoniques et valeurs converties.
  /// Ne remplit PAS les valeurs manquantes par 0.
  static Map<String, double> normalizeMap(Map<String, dynamic> raw) {
    if (raw.isEmpty) return {};

    final Map<String, double> out = {};

    for (final entry in raw.entries) {
      if (entry.value is! num) continue; // Ignore non-numeric
      final double value = (entry.value as num).toDouble();
      
      // Pré-nettoyage de la clé
      final String rawKeyLower = entry.key.toLowerCase().trim();
      String base = rawKeyLower.replaceAll(RegExp(r'[^a-z0-9]'), '');

      // Détection de l'unité source
      bool sourceIsG = false;
      bool sourceIsMg = false;
      bool sourceIsMcg = false;
      bool sourceIsKcal = false;

      // Check suffixes before stripping completely (ex: "calcium_mg")
      if (rawKeyLower.endsWith('mg') || rawKeyLower.contains('(mg)')) {
        sourceIsMg = true;
      } else if (rawKeyLower.endsWith('mcg') || rawKeyLower.endsWith('ug') || rawKeyLower.contains('µg') || rawKeyLower.contains('(ug)')) {
        sourceIsMcg = true;
      } else if (rawKeyLower.endsWith('kcal')) {
        sourceIsKcal = true;
      } else if (rawKeyLower.endsWith('g') && !rawKeyLower.endsWith('mg') && !rawKeyLower.endsWith('ug')) {
        sourceIsG = true; // "protein_g" ou "proteing"
      }

      // Identify canonical key
      String? canonical;

      // 1. Exact match sur clé nettoyée
      if (_tokenToCanonical.containsKey(base)) {
        canonical = _tokenToCanonical[base];
      } 
      // 2. Token match (ex: 'vitaminAmcg' -> contient 'vitamina')
      else {
        // Trier par longueur décroissante pour matcher le plus long token
        // (ex: 'vitaminb12' avant 'vitaminb1')
        // Optim: on pourrait mettre en cache cette liste triée si perf critique
        // Ici on itère sur les entrées _tokenToCanonical
        
        // Simple heuristic: check contains
        // Mais attention aux faux positifs (magnesium contient mg)
        // On préfère splitter si possible ou chercher des correspondances fortes
        
        for (final token in _tokenToCanonical.keys) {
           if (base.contains(token)) {
             // Exception: évite que 'magnesium' soit matché par 'mg' seulement si 'magnesium' est présent
             // Mais 'magnesium_mg' contient 'magnesium' ET 'mg'.
             // On prend le plus long match ? 
             // On va assumer que si ça contient "vitamina", c'est vitamina.
             
             // Cas spécifique mg (magnesium vs unité)
             if (token == 'mg' && base.contains('magnesium')) continue; 
             if (token == 'g' || token == 'k') continue; // trop courts
             
             canonical = _tokenToCanonical[token];
             break; // First match wins (attention ordre insertion map, mieux vaut un ordre explicite si besoin)
           }
        }
      }

      if (canonical == null) {
        // Logger la clé inconnue en dev si besoin
        continue;
      }

      // Conversion vers l'unité canonique
      double converted = value;
      final targetIsMg = canonical.endsWith('_mg');
      final targetIsMcg = canonical.endsWith('_mcg');
      final targetIsG = canonical.endsWith('_g');
      final targetIsKcal = canonical.endsWith('_kcal');

      if (targetIsMg) {
        if (sourceIsG) converted = value * _gToMg;
        else if (sourceIsMcg) converted = value * _mcgToMg;
        // else assume match (mg)
      } else if (targetIsMcg) {
        if (sourceIsG) converted = value * _gToMcg;
        else if (sourceIsMg) converted = value * _mgToMcg;
        // else assume match (mcg)
      } else if (targetIsG) {
        if (sourceIsMg) converted = value * _mgToG;
        else if (sourceIsMcg) converted = value * _mcgToG;
      } else if (targetIsKcal) {
        // No conversion logic for now (kJ ignored)
      }

      // Accumuler (cas ou clé dupliquée ex: "Vit C" et "Vitamin C" dans même JSON - rare mais possible)
      out[canonical] = (out[canonical] ?? 0.0) + converted;
    }

    return out;
  }

  /// Calcule le snapshot absolu (valeurs totales pour la récolte)
  /// [nutritionPer100gCanonical] doit être déjà normalisé.
  static Map<String, double> computeSnapshot(Map<String, dynamic>? nutritionPer100gCanonical, double quantityKg) {
    if (nutritionPer100gCanonical == null || nutritionPer100gCanonical.isEmpty || quantityKg <= 0) {
      return {};
    }
    
    // cast safe
    final Map<String, double> canonicalSafe = {};
    nutritionPer100gCanonical.forEach((k, v) {
      if (v is num) canonicalSafe[k] = v.toDouble();
    });

    final double ratio = quantityKg * 10.0; // 1 kg = 10 * 100g
    final Map<String, double> snapshot = {};

    canonicalSafe.forEach((key, val) {
      snapshot[key] = (snapshot[key] ?? 0.0) + (val * ratio);
    });
    
    return snapshot;
  }
}
