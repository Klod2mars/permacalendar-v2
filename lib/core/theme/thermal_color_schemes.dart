import 'package:flutter/material.dart';

/// Palettes thermiques pour adaptation climatique respectueuse
/// Interface respire avec le climat - Changement complet mais respectueux
class ThermalColorSchemes {
  /// â„ï¸ PALETTE FROID EXTRÃŠME - Bleu glace bioluminescent
  static const ColorScheme freezePalette = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0D47A1), // Bleu profond glacial
    onPrimary: Color(0xFFE3F2FD), // Blanc glacé
    secondary: Color(0xFF1976D2), // Bleu glacier
    onSecondary: Color(0xFFBBDEFB), // Bleu clair cristal
    tertiary: Color(0xFF42A5F5), // Bleu électrique
    onTertiary: Color(0xFF000051), // Bleu nuit
    error: Color(0xFF2196F3), // Erreur en bleu froid
    onError: Color(0xFFFFFFFF), // Texte cristal
    surface: Color(0xFF1A237E), // Surface glace
    onSurface: Color(0xFFE8EAF6), // Texte surface
  );

  /// ðŸŒŠ PALETTE FROID MODÉRÉ - Bleu-vert froid
  static const ColorScheme coldPalette = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF00695C), // Bleu-vert profond
    onPrimary: Color(0xFFE0F2F1), // Blanc aqua
    secondary: Color(0xFF00897B), // Vert émeraude froid
    onSecondary: Color(0xFFB2DFDB), // Vert clair
    tertiary: Color(0xFF26A69A), // Turquoise
    onTertiary: Color(0xFF004D40), // Vert sombre
    error: Color(0xFF00BCD4), // Erreur cyan
    onError: Color(0xFFFFFFFF), // Texte aqua
    surface: Color(0xFF37474F), // Surface ardoise
    onSurface: Color(0xFFE0F2F1), // Texte surface
  );

  /// ðŸŒ¿ PALETTE TEMPÉRÉE - Vert stable (référence actuelle)
  static const ColorScheme moderatePalette = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2E7D32), // Vert permaculture (actuel)
    onPrimary: Color(0xFFE8F5E8), // Blanc végétal
    secondary: Color(0xFF388E3C), // Vert nature
    onSecondary: Color(0xFFC8E6C9), // Vert tendre
    tertiary: Color(0xFF4CAF50), // Vert frais
    onTertiary: Color(0xFF1B5E20), // Vert foncé
    error: Color(0xFF66BB6A), // Erreur verte douce
    onError: Color(0xFFFFFFFF), // Texte végétal
    surface: Color(0xFF2E7D32), // Surface vert stable
    onSurface: Color(0xFFE8F5E8), // Texte surface
  );

  /// ðŸ”¥ PALETTE CHALEUR ÉLEVÉE - Vert chaud cuivré
  static const ColorScheme hotPalette = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF6D4C41), // Brun terre chaude
    onPrimary: Color(0xFFFFF3E0), // Blanc chaud
    secondary: Color(0xFF8D6E63), // Terre cuite
    onSecondary: Color(0xFFD7CCC8), // Beige chaud
    tertiary: Color(0xFF795548), // Cuivre naturel
    onTertiary: Color(0xFF3E2723), // Brun foncé
    error: Color(0xFFFF8A65), // Erreur orange douce
    onError: Color(0xFFFFFFFF), // Texte doré
    surface: Color(0xFF5D4037), // Surface cuivre
    onSurface: Color(0xFFEFEBE9), // Texte surface
  );

  /// ðŸŒ‹ PALETTE CANICULE - Orange/rouge organique
  static const ColorScheme heatwavePalette = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFD84315), // Rouge terre volcanique
    onPrimary: Color(0xFFFFF3E0), // Blanc brûlé
    secondary: Color(0xFFFF5722), // Orange feu
    onSecondary: Color(0xFFFFCCBC), // Orange pâle
    tertiary: Color(0xFFFF7043), // Rouge orangé
    onTertiary: Color(0xFFBF360C), // Rouge sombre
    error: Color(0xFFFF6F00), // Erreur orange vif
    onError: Color(0xFFFFFFFF), // Texte doré chaud
    surface: Color(0xFF5D4037), // Surface terre
    onSurface: Color(0xFFFFE0B2), // Texte ambré
  );

  /// ðŸŒˆ Interpoler entre deux palettes pour transitions fluides
  /// Permet des transitions douces sans flash brutal
  static ColorScheme interpolatePalettes(
      ColorScheme from, ColorScheme to, double progress // 0.0 â†’ 1.0
      ) {
    return ColorScheme(
      brightness: to.brightness,
      primary: Color.lerp(from.primary, to.primary, progress)!,
      onPrimary: Color.lerp(from.onPrimary, to.onPrimary, progress)!,
      secondary: Color.lerp(from.secondary, to.secondary, progress)!,
      onSecondary: Color.lerp(from.onSecondary, to.onSecondary, progress)!,
      tertiary: Color.lerp(from.tertiary, to.tertiary, progress)!,
      onTertiary: Color.lerp(from.onTertiary, to.onTertiary, progress)!,
      error: Color.lerp(from.error, to.error, progress)!,
      onError: Color.lerp(from.onError, to.onError, progress)!,
      surface: Color.lerp(from.surface, to.surface, progress)!,
      onSurface: Color.lerp(from.onSurface, to.onSurface, progress)!,
    );
  }
}


