
class NutritionNormalizer {
  // Facteur de conversion pour normaliser
  static const double _mgToG = 0.001;
  static const double _mcgToG = 0.000001;
  static const double _mcgToMg = 0.001;

  /// Mappe les clés brutes vers des clés canoniques
  static const Map<String, String> _keyMapping = {
    // Macros
    'calories': 'calories_kcal',
    'kcal': 'calories_kcal',
    'protein': 'protein_g',
    'proteines': 'protein_g',
    'carbohydrates': 'carbs_g',
    'glucides': 'carbs_g',
    'fat': 'fat_g',
    'lipides': 'fat_g',
    'fiber': 'fiber_g',
    'fibres': 'fiber_g',
    
    // Vitamins
    'vitaminc': 'vitamin_c_mg',
    'vitaminec': 'vitamin_c_mg',
    'vitamina': 'vitamin_a_mcg', // Souvent en IU ou mcg
    'vitaminea': 'vitamin_a_mcg', 
    'vitamink': 'vitamin_k_mcg',
    'vitaminek': 'vitamin_k_mcg',
    'vitamine': 'vitamin_e_mg',
    'vitaminee': 'vitamin_e_mg',
    'vitaminb6': 'vitamin_b6_mg',
    'folate': 'vitamin_b9_mcg', // B9
    'vitaminb9': 'vitamin_b9_mcg',

    // Minerals
    'iron': 'iron_mg',
    'fer': 'iron_mg',
    'calcium': 'calcium_mg',
    'magnesium': 'magnesium_mg',
    'potassium': 'potassium_mg',
    'zinc': 'zinc_mg',
    'manganese': 'manganese_mg',
    
    // Autres
    'sugar': 'sugar_g',
    'sucre': 'sugar_g',
  };

  /// Calcule le snapshot nutritionnel pour une quantité donnée (en kg).
  /// [nutritionPer100g] : Map brute venant du JSON de la plante.
  /// [quantityKg] : Poids de la récolte en kg.
  static Map<String, double> computeSnapshot(Map<String, dynamic>? nutritionPer100g, double quantityKg) {
    if (nutritionPer100g == null || nutritionPer100g.isEmpty || quantityKg <= 0) {
      return {};
    }

    final double ratio = quantityKg * 10.0; // 1 kg = 10 * 100g
    final Map<String, double> snapshot = {};

    nutritionPer100g.forEach((key, value) {
      if (value is num) {
        final String lowerKey = key.toString().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        
        // Tentative de mapping direct ou partiel
        String? canonicalKey;
        
        // 1. Exact match après nettoyage
        if (_keyMapping.containsKey(lowerKey)) {
          canonicalKey = _keyMapping[lowerKey];
        } 
        // 2. Heuristique pour clés complexes (ex: "Vitamin C (mg)")
        else {
           // Recherche inverse naïve ou regex si besoin, pour l'instant on reste sur le mapping strict
           // pour éviter les faux positifs. On peut itérer sur les clés du mapping.
           for (var entry in _keyMapping.entries) {
             if (lowerKey.contains(entry.key)) {
               canonicalKey = entry.value;
               break;
             }
           }
        }

        if (canonicalKey != null) {
          double val = value.toDouble();
          
          // Conversion d'unité si nécessaire (simplifiée ici, suppose que l'input suit +/- les conventions standards du JSON)
          // Si le JSON source est très hétérogène (mg vs g mélangés pour la même clé), il faudra une logique plus robuste ici.
          // Pour l'instant on assume que nutritionPer100g respecte les unités implicites du mapping (g pour macros, mg/mcg pour micros).
          
          // Gestion spécifique des doublons/variantes pourrait aller ici
          
          snapshot[canonicalKey!] = (snapshot[canonicalKey] ?? 0.0) + (val * ratio);
        }
      }
    });

    return snapshot;
  }
}
