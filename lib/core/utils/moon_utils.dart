
class MoonUtils {
  /// Calcule la phase de la lune (0.0 à 1.0) pour une date donnée.
  /// 0.0 = Nouvelle lune
  /// 0.5 = Pleine lune
  /// 1.0 = Nouvelle lune (cycle suivant)
  static double calculateMoonPhase(DateTime date) {
    // Julian Date calculation
    // From: https://www.subsystems.us/uploads/9/8/9/4/98948044/moonphase.pdf
    // or standard algo
    
    // Reference New Moon: 2000-01-06 18:14 UTC (JD 2451550.1)
    // Synodic month: 29.53058867 days
    
    // Simple calc using 1970 epoch
    // Known new moon: 1970-01-07 20:35 UTC
    
    final knownNewMoon = DateTime.utc(1970, 1, 7, 20, 35);
    final cycle = 29.53058867;
    
    final diff = date.difference(knownNewMoon).inSeconds;
    final days = diff / 86400.0;
    
    final cycles = days / cycle;
    final currentCycle = cycles - cycles.floor();
    
    return currentCycle; // 0..1
  }

  /// Retourne le nom de la phase (en français) code correspondant potentiellement à l'affichage
  static String getPhaseLabel(double phase) {
    if (phase < 0.05) return "Nouvelle Lune";
    if (phase < 0.25) return "Premier Croissant";
    if (phase < 0.45) return "Premier Quartier";
    if (phase < 0.55) return "Pleine Lune";
    if (phase < 0.75) return "Dernier Quartier";
    if (phase < 0.95) return "Dernier Croissant";
    return "Nouvelle Lune";
  }
}
