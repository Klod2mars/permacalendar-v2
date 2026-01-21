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
    'energy': 'calories_kcal',
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
  static Map<String, double> computeSnapshot(
      Map<String, dynamic>? nutritionPer100g, double quantityKg) {
    if (nutritionPer100g == null ||
        nutritionPer100g.isEmpty ||
        quantityKg <= 0) {
      return {};
    }

    final double ratio = quantityKg * 10.0; // 1 kg = 10 * 100g
    final Map<String, double> snapshot = {};

    nutritionPer100g.forEach((key, value) {
      if (value is num) {
        final String rawKeyLower = key.toString().toLowerCase();
        final String cleanKey = rawKeyLower.replaceAll(RegExp(r'[^a-z0-9]'), '');

        // Tentative de mapping direct ou partiel
        String? canonicalKey;

        // Détection d'unité explicite dans la clé (ex: "calcium_mg", "iron_g")
        if (rawKeyLower.endsWith('mg') || rawKeyLower.contains('(mg)')) {
          // Déjà en mg
        } else if (rawKeyLower.endsWith('mcg') ||
            rawKeyLower.endsWith('ug') ||
            rawKeyLower.contains('µg')) {
          // Si on mappe vers du mg mais que c'est du mcg -> * 0.001
        } else if (rawKeyLower.endsWith('g') &&
            !rawKeyLower.endsWith('mg') &&
            !rawKeyLower.endsWith('mcg')) {
          // Probablement en grammes
        }

        // 1. Exact match après nettoyage
        if (_keyMapping.containsKey(cleanKey)) {
          canonicalKey = _keyMapping[cleanKey];
        }
        // 2. Heuristique pour clés complexes (ex: "Vitamin C (mg)", "vitaminCmg")
        else {
          for (var entry in _keyMapping.entries) {
            // Si la clé nettoyée contient la clé de map (ex: "vitamincmg" contient "vitaminc")
            if (cleanKey.contains(entry.key)) {
              canonicalKey = entry.value;
              break;
            }
          }
        }

        if (canonicalKey != null) {
          double val = value.toDouble();

          // Ajustement d'unité basique si conflit détecté
          // Si la clé canonique est en 'mg' et que la clé source disait 'g', on multiplie par 1000

          // Is target mg?
          bool targetIsMg = canonicalKey.contains('_mg');
          bool targetIsMcg = canonicalKey.contains('_mcg');

          // Is source g?
          bool sourceIsG = (rawKeyLower.endsWith('g') &&
              !rawKeyLower.endsWith('mg') &&
              !rawKeyLower.endsWith('ug'));
          // Is source mg?
          bool sourceIsMg = rawKeyLower.contains('mg');
          // Is source mcg?
          bool sourceIsMcg = rawKeyLower.contains('mcg') ||
              rawKeyLower.contains('ug') ||
              rawKeyLower.contains('µg');

          if (targetIsMg) {
            if (sourceIsG)
              val *= 1000.0;
            else if (sourceIsMcg) val *= 0.001;
          } else if (targetIsMcg) {
            if (sourceIsG)
              val *= 1000000.0;
            else if (sourceIsMg) val *= 1000.0;
          }

          snapshot[canonicalKey] =
              (snapshot[canonicalKey] ?? 0.0) + (val * ratio);
        }
      }
    });

    return snapshot;
  }
}
