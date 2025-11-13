import 'package:flutter/material.dart';

/// Palette de base abstraite pour les jardins organiques
abstract class OrganicPalette {
  Color get jardin1Color;
  Color get jardin2Color;
  Color get jardin3Color;
  Color get jardin4Color;
  Color get jardin5Color;
}

/// Palette 1 : Jardin Méditerranéen - Tonalités Douces et Lumineuses
///
/// Caractéristiques :
/// - Ambiance : Chaleur douce, méditerranéenne, ensoleillée
/// - Contraste : Moyen (lueurs visibles mais apaisantes)
/// - Usage recommandé : Interface zen, repos, contemplation
class MediterraneanPalette implements OrganicPalette {
  @override
  final Color jardin1Color = const Color(0xFFFFF4C4); // Jaune pollen doux
  // HSL: 54°, 100%, 89% - Lumineux sans être agressif
  // RGB: 255, 244, 196
  // Symbolique: Éveil doux du matin, pollen frais

  @override
  final Color jardin2Color = const Color(0xFFD8BFD8); // Mauve lavande
  // HSL: 300°, 24%, 80% - Douceur florale
  // RGB: 216, 191, 216
  // Symbolique: Fleurs de lavande, poésie provençale

  @override
  final Color jardin3Color = const Color(0xFF6B8E23); // Vert olivier
  // HSL: 80°, 60%, 35% - Ancré, mature
  // RGB: 107, 142, 35
  // Symbolique: Olivier centenaire, racines profondes

  @override
  final Color jardin4Color = const Color(0xFF70D7C7); // Turquoise mer
  // HSL: 170°, 55%, 65% - Fluide, rafraîchissant
  // RGB: 112, 215, 199
  // Symbolique: Eau de mer méditerranéenne, circulation vitale

  @override
  final Color jardin5Color = const Color(0xFFA8E4A0); // Vert menthe
  // HSL: 113°, 54%, 77% - Léger, frais
  // RGB: 168, 228, 160
  // Symbolique: Feuille de menthe jeune, légèreté
}

/// Palette 2 : Forêt Enchantée - Tonalités Saturées et Vibrantes
///
/// Caractéristiques :
/// - Ambiance : Vitalité, énergie, nature sauvage
/// - Contraste : Élevé (lueurs très visibles, présence forte)
/// - Usage recommandé : Interface dynamique, action, engagement
class EnchantedForestPalette implements OrganicPalette {
  @override
  final Color jardin1Color = const Color(0xFFFFD700); // Or solaire
  // HSL: 51°, 100%, 50% - Éclat maximal
  // RGB: 255, 215, 0
  // Symbolique: Soleil levant, réveil de la nature

  @override
  final Color jardin2Color = const Color(0xFFDA70D6); // Violet orchidée
  // HSL: 302°, 59%, 65% - Floraison intense
  // RGB: 218, 112, 214
  // Symbolique: Orchidée sauvage, mystère floral

  @override
  final Color jardin3Color = const Color(0xFF228B22); // Vert forêt
  // HSL: 120°, 61%, 34% - Force, enracinement
  // RGB: 34, 139, 34
  // Symbolique: Cœur de la forêt, maturité puissante

  @override
  final Color jardin4Color = const Color(0xFF00CED1); // Cyan aqua
  // HSL: 181°, 100%, 41% - Énergie fluide
  // RGB: 0, 206, 209
  // Symbolique: Cascade vive, sève en mouvement

  @override
  final Color jardin5Color = const Color(0xFF7FFF00); // Lime électrique
  // HSL: 90°, 100%, 50% - Jeunesse vibrante
  // RGB: 127, 255, 0
  // Symbolique: Pousse printanière, croissance explosive
}

/// Configuration des styles de texte pour les jardins
class GardenLabelStyle {
  // État DISCRET (jardin non actif)
  static const double discreetOpacity = 0.55; // Semi-transparent
  static const double discreetFontSize = 10.0; // Petit
  static const FontWeight discreetWeight = FontWeight.w400; // Normal

  // État INTENSIFIÉ (jardin actif)
  static const double activeOpacity = 0.95; // Presque opaque
  static const double activeFontSize = 11.0; // Légèrement plus grand
  static const FontWeight activeWeight = FontWeight.w600; // Semi-bold

  // Transition
  static const Duration transitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  // Ombre pour lisibilité
  static const Shadow textShadow = Shadow(
    color: Colors.black38, // 38% opacité
    blurRadius: 4.0,
    offset: Offset(0, 1),
  );
}

/// Configuration de l'animation de respiration organique
class OrganicBreathAnimation {
  static const Duration cycleDuration =
      Duration(milliseconds: 2750); // 2.75 sec
  static const Curve curve = Curves.easeInOut; // Fluidité organique

  // Paramètres de variation (respiration)
  static const double minOpacity = 0.30; // Opacité minimale
  static const double maxOpacity = 0.60; // Opacité maximale
  static const double opacityAmplitude = 0.30; // Variation: 30%

  static const double minBlurRadius = 20.0; // Diffusion minimale
  static const double maxBlurRadius = 35.0; // Diffusion maximale
  static const double blurAmplitude = 15.0; // Variation: 15px

  static const double minSpreadRadius = 8.0; // Expansion minimale
  static const double maxSpreadRadius = 13.0; // Expansion maximale
  static const double spreadAmplitude = 5.0; // Variation: 5px
}


