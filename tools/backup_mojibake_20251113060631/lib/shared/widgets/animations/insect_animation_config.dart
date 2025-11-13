import 'package:flutter/material.dart';

/// Configuration des paramètres pour l'animation "éveil insecte"
/// Mission A39-2 : Prototype animation insecte avec 12 particules en spirale
class InsectAwakeningConfig {
  // ═══════════════════════════════════════════════════════════════
  // PARAMÈTRES TEMPORELS
  // ═══════════════════════════════════════════════════════════════

  /// Durée totale de l'animation (800ms selon spec A39-2)
  static const Duration totalDuration = Duration(milliseconds: 800);

  /// Phase d'éveil : apparition progressive des particules (0-200ms)
  static const Duration eveilPhase = Duration(milliseconds: 200);

  /// Phase d'expansion : spirale vers l'extérieur (200-500ms)
  static const Duration expansionPhase = Duration(milliseconds: 300);

  /// Phase de pollinisation : pulsation légère (500-650ms)
  static const Duration pollinisationPhase = Duration(milliseconds: 150);

  /// Phase de dissipation : fade out progressif (650-800ms)
  static const Duration dissipationPhase = Duration(milliseconds: 150);

  // ═══════════════════════════════════════════════════════════════
  // PARAMÈTRES VISUELS
  // ═══════════════════════════════════════════════════════════════

  /// Nombre de particules lumineuses (12 selon spec A39-2)
  static const int particleCount = 12;

  /// Taille de base des particules (3px)
  static const double particleSize = 3.0;

  /// Rayon maximum d'expansion de la spirale (60px)
  static const double expansionRadius = 60.0;

  /// Nombre de tours de spirale (1.5 tours)
  static const double spiralTurns = 1.5;

  /// Opacité maximale des particules (0.7 pour subtilité)
  static const double particleOpacity = 0.7;

  /// Intensité du blur pour effet lumineux
  static const double blurIntensity = 2.0;

  // ═══════════════════════════════════════════════════════════════
  // COURBES D'ANIMATION
  // ═══════════════════════════════════════════════════════════════

  /// Courbe pour la phase d'éveil (apparition douce)
  static const Curve eveilCurve = Curves.easeOut;

  /// Courbe pour la phase d'expansion (mouvement fluide)
  static const Curve expansionCurve = Curves.easeInOut;

  /// Courbe pour la phase de pollinisation (pulsation élastique)
  static const Curve pollinisationCurve = Curves.elasticOut;

  /// Courbe pour la phase de dissipation (disparition progressive)
  static const Curve dissipationCurve = Curves.easeIn;

  // ═══════════════════════════════════════════════════════════════
  // PARAMÈTRES AUDIO
  // ═══════════════════════════════════════════════════════════════

  /// Chemin vers le fichier audio de bourdonnement
  static const String soundAsset = 'sfx/insect_wake.mp3';

  /// Volume du son (0.3 pour discrétion)
  static const double soundVolume = 0.3;

  // ═══════════════════════════════════════════════════════════════
  // PARAMÈTRES DE PERFORMANCE
  // ═══════════════════════════════════════════════════════════════

  /// Délai entre l'apparition des particules (effet cascade)
  static const double particleDelayFactor = 0.2;

  /// Facteur de pulsation pendant la pollinisation
  static const double pulsationAmplitude = 0.3;

  /// Fréquence de pulsation (8 cycles par seconde)
  static const double pulsationFrequency = 8.0;

  // ═══════════════════════════════════════════════════════════════
  // PARAMÈTRES HALO PERSISTANT (A39-2.1)
  // ═══════════════════════════════════════════════════════════════

  /// Durée du cycle de pulsation du halo persistant (3s)
  static const Duration persistentHaloDuration = Duration(seconds: 3);

  /// Opacité minimale du halo persistant (0.35 pour subtilité)
  static const double persistentHaloMinOpacity = 0.35;

  /// Opacité maximale du halo persistant (0.55 pour visibilité)
  static const double persistentHaloMaxOpacity = 0.55;

  /// Rayon de flou du halo persistant (25px)
  static const double persistentHaloBlurRadius = 25.0;

  /// Courbe de pulsation du halo persistant
  static const Curve persistentHaloCurve = Curves.easeInOutCubic;

  // ═══════════════════════════════════════════════════════════════
  // PARAMÈTRES TRANSITION FADE OUT (A39-2.1)
  // ═══════════════════════════════════════════════════════════════

  /// Durée de la transition fade out (800ms symétrique)
  static const Duration fadeOutDuration = Duration(milliseconds: 800);

  /// Courbe de la transition fade out
  static const Curve fadeOutCurve = Curves.easeOut;
}

/// Phases de l'animation insecte
/// Utilisé pour contrôler le comportement des particules selon le timing
enum InsectAnimationPhase {
  /// État initial (pas d'animation)
  idle,

  /// Phase d'éveil : 0-200ms (25% de l'animation)
  eveil,

  /// Phase d'expansion : 200-500ms (37.5% de l'animation)
  expansion,

  /// Phase de pollinisation : 500-650ms (18.75% de l'animation)
  pollinisation,

  /// Phase de dissipation : 650-800ms (18.75% de l'animation)
  dissipation,
}

/// États de l'animation insecte avec halo persistant (A39-2.1)
enum InsectAnimationState {
  /// Aucune animation
  idle,

  /// Animation 800ms initiale (particules)
  awakening,

  /// Halo persistant actif (pulsation continue)
  persistent,

  /// Transition sortante (fade out)
  fadingOut,
}

/// Extension pour faciliter la gestion des phases
extension InsectAnimationPhaseExtension on InsectAnimationPhase {
  /// Retourne le pourcentage de progression pour cette phase
  double get startProgress {
    switch (this) {
      case InsectAnimationPhase.idle:
        return 0.0;
      case InsectAnimationPhase.eveil:
        return 0.0;
      case InsectAnimationPhase.expansion:
        return 0.25;
      case InsectAnimationPhase.pollinisation:
        return 0.625;
      case InsectAnimationPhase.dissipation:
        return 0.8125;
    }
  }

  /// Retourne le pourcentage de fin pour cette phase
  double get endProgress {
    switch (this) {
      case InsectAnimationPhase.idle:
        return 0.0;
      case InsectAnimationPhase.eveil:
        return 0.25;
      case InsectAnimationPhase.expansion:
        return 0.625;
      case InsectAnimationPhase.pollinisation:
        return 0.8125;
      case InsectAnimationPhase.dissipation:
        return 1.0;
    }
  }

  /// Calcule le progrès relatif dans cette phase
  double getPhaseProgress(double globalProgress) {
    if (globalProgress < startProgress) return 0.0;
    if (globalProgress > endProgress) return 1.0;

    return (globalProgress - startProgress) / (endProgress - startProgress);
  }
}


