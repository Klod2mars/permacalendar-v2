
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/climate/domain/models/zone.dart';

class PhaseResolver {
  
  /// Résout les mois actifs pour une phase donnée (semis, plantation, récolte)
  /// en fonction de la plante, de la zone et de la date du dernier gel.
  static List<String> resolvePhases(
    PlantFreezed plant, 
    Zone zone, 
    String phaseType, // 'sowing', 'planting', 'harvest'
    {DateTime? lastFrostDate}
  ) {
    // 1. Chercher un override explicite dans zoneProfiles
    if (plant.zoneProfiles != null && plant.zoneProfiles!.containsKey(zone.id)) {
      final zoneProfile = plant.zoneProfiles![zone.id] as Map<String, dynamic>;
      
      // Check if 'phases' defined
      if (zoneProfile.containsKey('phases')) {
        final phases = zoneProfile['phases'] as Map<String, dynamic>;
        if (phases.containsKey(phaseType)) {
          final rule = phases[phaseType] as Map<String, dynamic>;
          return _applyRule(rule, lastFrostDate);
        }
      }
    }

    // 2. Fallback sur referenceProfile
    List<String> baseMonths = [];
    
    // Si la plante a été migrée, elle a un referenceProfile
    if (plant.referenceProfile != null) {
      final refPhases = plant.referenceProfile!['phases'] as Map<String, dynamic>?;
      if (refPhases != null && refPhases.containsKey(phaseType)) {
        final rule = refPhases[phaseType] as Map<String, dynamic>;
        // Généralement type='months' dans referenceProfile
        baseMonths = _applyRule(rule, lastFrostDate);
      }
    } else {
      // Legacy : si pas encore migré (ou partiellement), utiliser les champs racine
      // Note: le script de migration conserve les champs racine pour compatibilité,
      // donc on peut toujours les lire ici comme source de vérité 'Europe'.
      if (phaseType == 'sowing') baseMonths = plant.sowingMonths;
      else if (phaseType == 'harvest') baseMonths = plant.harvestMonths;
      // plantingMonths n'est pas dans PlantFreezed racine standard (souvent calculé ou confondu)
      // On assume sowing pour simplifier si planting introuvable
    }
    
    // 3. Appliquer le shift de la zone
    if (zone.monthShift != 0 && baseMonths.isNotEmpty) {
      return _shiftMonths(baseMonths, zone.monthShift);
    }
    
    return baseMonths;
  }

  static List<String> _applyRule(Map<String, dynamic> rule, DateTime? lastFrostDate) {
    final type = rule['type'] as String?;
    
    if (type == 'months') {
       final m = rule['months'];
       if (m is List) return m.map((e) => e.toString()).toList();
       return [];
    }
    
    if (type == 'relative' && lastFrostDate != null) {
      // Implementation de la logique relative (Last Frost)
      // Ex: offsetDays = -21 (3 semaines avant), windowDays = 14
      final offset = rule['offsetDays'] as int? ?? 0;
      final window = rule['windowDays'] as int? ?? 14;
      
      final start = lastFrostDate.add(Duration(days: offset));
      final end = start.add(Duration(days: window - 1));
      
      return _datesToMonthCodes(start, end);
    }
    
    // Fallback ou type inconnu (ex: 'afterPlanting' pour harvest - plus complexe car dépend de la date de plantation réelle)
    // Pour l'affichage 'calendrier théorique', afterPlanting est dur à résoudre sans date de semis choisie.
    // On pourrait retourner une estimation basée sur un semis 'moyen'. 
    
    return [];
  }
  
  static List<String> _shiftMonths(List<String> months, int shift) {
    const monthCodes = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    // Map code -> index (0-11)
    // Attention aux codes courts francais vs anglais. Le modèle PlantHive utilise des codes normalisés ?
    // Le script de migration a laissé les codes tels quels.
    // PlantHiveRepository tente de normaliser mais PlantEntity a List<String>.
    // Supposons des codes 3 lettres anglais (Jan, Feb...) comme output du script python.
    
    // Normalisation safe
    List<String> result = [];
    for (var m in months) {
      // Nettoyage et matching
      int idx = -1;
      // Try exact match
      idx = monthCodes.indexOf(m);
      
      if (idx == -1) {
        // Try french short codes mapping if needed
        // Mais restons simple
        continue;
      }
      
      // Shift
      int newIdx = (idx + shift) % 12;
      // Handle negative modulo just in case (dart % is positive for positive divisor but let's be safe)
      if (newIdx < 0) newIdx += 12;
      
      result.add(monthCodes[newIdx]);
    }
    // Sort logic (handling wrap around is tricky for display, usually sort by calendar index)
    result.sort((a,b) => monthCodes.indexOf(a).compareTo(monthCodes.indexOf(b)));
    
    return result;
  }
  
  static List<String> _datesToMonthCodes(DateTime start, DateTime end) {
    const monthCodes = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final Set<String> months = {};
    
    // Iterate limits? Or just start/end months and everything in between?
    // Simple logic:
    DateTime current = start;
    while (!current.isAfter(end)) {
       months.add(monthCodes[current.month - 1]);
       current = current.add(const Duration(days: 1));
       // Safety break
       if (current.difference(start).inDays > 365) break; 
    }
    
    final list = months.toList();
    list.sort((a,b) => monthCodes.indexOf(a).compareTo(monthCodes.indexOf(b)));
    return list;
  }
}
