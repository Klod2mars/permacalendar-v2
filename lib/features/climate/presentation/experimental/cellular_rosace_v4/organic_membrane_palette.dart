import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'unified_membrane_geometry.dart';

/// V4 Organic Membrane Palette
///
/// Provides authentic plant tissue colors with:
/// - Unified tissue base membrane
/// - Shared wall system with subtle luminosity
/// - Cell internal gradients (naturalistic, not flashy)
/// - Subtle nucleus presence (contemplative, not bright)
class OrganicMembranePalette {
  // ==================== UNIFIED TISSUE BASE ====================

  /// Base membrane color for unified tissue
  static const Color baseMembrane = Color(0x15E8F5E8);

  /// Shared wall system colors
  static const Color sharedWalls =
      Color(0x25C8E6C9); // Subtle translucent green
  static const Color wallLuminosity = Color(0x40A5D6A7); // Internal glow

  /// Membrane breathing edge
  static const Color breathingEdge = Color(0x20A5D6A7); // Outer breathing edge

  // ==================== CELL INTERNAL GRADIENTS ====================

  /// Weather cell gradient (soft sky tones)
  static const LinearGradient weatherCell = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x60E3F2FD), // Soft sky blue
      Color(0x40BBDEFB), // Lighter sky blue
    ],
  );

  /// Soil temperature cell gradient (earth-connected greens)
  static const LinearGradient soilCell = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x60C8E6C9), // Light earth green
      Color(0x40A5D6A7), // Medium earth green
    ],
  );

  /// Forecast cell gradient (contemplative purples)
  static const LinearGradient forecastCell = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x60E1BEE7), // Light lavender
      Color(0x40CE93D8), // Medium lavender
    ],
  );

  /// Alerts cell gradient (gentle attention colors)
  static const LinearGradient alertsCell = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x60FFCDD2), // Light attention pink
      Color(0x40F8BBD9), // Medium attention pink
    ],
  );

  // ==================== NUCLEUS: SUBTLE PRESENCE ====================

  /// Nucleus glow (gentle yellow presence, not flashy)
  static const RadialGradient nucleusGlow = RadialGradient(
    center: Alignment.center,
    radius: 1.0,
    colors: [
      Color(0x30FFF176), // Gentle yellow center
      Color(0x15FFEB3B), // Very subtle yellow edge
    ],
  );

  /// Nucleus breathing colors
  static const Color nucleusBreathing =
      Color(0x25FFF176); // Subtle breathing glow

  // ==================== CELL BORDER COLORS ====================

  /// Get border color for cell type
  static Color getCellBorderColor(CellType cellType) {
    switch (cellType) {
      case CellType.weather:
        return const Color(0x40E3F2FD); // Soft sky blue border
      case CellType.soilTemp:
        return const Color(0x40C8E6C9); // Earth green border
      case CellType.forecast:
        return const Color(0x40E1BEE7); // Lavender border
      case CellType.alerts:
        return const Color(0x40FFCDD2); // Attention pink border
      case CellType.nucleus:
        return const Color(0x30FFF176); // Subtle yellow border
    }
  }

  // ==================== MEMBRANE LUMINOSITY SYSTEM ====================

  /// Get membrane luminosity color based on intensity
  static Color getMembraneLuminosity(double intensity) {
    final alpha = (intensity * 0.3).clamp(0.0, 0.3);
    return wallLuminosity.withOpacity(alpha);
  }

  /// Get shared wall color with luminosity
  static Color getSharedWallColor(double luminosity) {
    final alpha = (0.25 + luminosity * 0.15).clamp(0.0, 0.4);
    return sharedWalls.withOpacity(alpha);
  }

  // ==================== CONTEMPLATIVE GRADIENTS ====================

  /// Create contemplative gradient for cell type
  static Gradient getCellGradient(CellType cellType) {
    switch (cellType) {
      case CellType.weather:
        return weatherCell;
      case CellType.soilTemp:
        return soilCell;
      case CellType.forecast:
        return forecastCell;
      case CellType.alerts:
        return alertsCell;
      case CellType.nucleus:
        return nucleusGlow;
    }
  }

  /// Create subtle breathing gradient
  static RadialGradient createBreathingGradient({
    required Color baseColor,
    required double breathingPhase,
  }) {
    final intensity = (0.15 + math.sin(breathingPhase) * 0.05).clamp(0.1, 0.2);

    return RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        baseColor.withOpacity(intensity),
        baseColor.withOpacity(intensity * 0.5),
      ],
    );
  }

  // ==================== PRESSURE-BASED COLORS ====================

  /// Get pressure-based color intensity
  static double getPressureIntensity(double pressure) {
    return (0.3 + pressure * 0.4).clamp(0.3, 0.7);
  }

  /// Get wall thickness based on pressure
  static double getWallThickness(double pressure) {
    return (0.8 + pressure * 0.4).clamp(0.8, 1.2);
  }

  // ==================== HIERARCHY-BASED OPACITY ====================

  /// Get cell opacity based on importance
  static double getCellOpacity(double importance) {
    switch (importance) {
      case >= 0.9:
        return 0.8; // Dominant cells - high opacity
      case >= 0.7:
        return 0.7; // Strategic cells - medium-high opacity
      case >= 0.5:
        return 0.6; // Conditional cells - medium opacity
      default:
        return 0.4; // Nucleus - subtle opacity
    }
  }

  /// Get nucleus breathing opacity
  static double getNucleusBreathingOpacity(double breathingPhase) {
    return (0.15 + math.sin(breathingPhase) * 0.05).clamp(0.1, 0.2);
  }

  // ==================== TOUCH RESPONSE COLORS ====================

  /// Get touch response color for cell type
  static Color getTouchResponseColor(CellType cellType) {
    switch (cellType) {
      case CellType.weather:
        return const Color(0x60E3F2FD); // Soft sky blue
      case CellType.soilTemp:
        return const Color(0x60C8E6C9); // Earth green
      case CellType.forecast:
        return const Color(0x60E1BEE7); // Lavender
      case CellType.alerts:
        return const Color(0x60FFCDD2); // Attention pink
      case CellType.nucleus:
        return const Color(0x40FFF176); // Subtle yellow
    }
  }

  /// Get ripple effect color
  static Color getRippleColor(CellType cellType) {
    return getTouchResponseColor(cellType).withOpacity(0.3);
  }

  // ==================== MEMBRANE WAVE COLORS ====================

  /// Get membrane wave color based on phase
  static Color getMembraneWaveColor(double wavePhase) {
    final intensity = (0.2 + math.sin(wavePhase) * 0.1).clamp(0.1, 0.3);
    return wallLuminosity.withOpacity(intensity);
  }

  /// Get shared wall wave color
  static Color getSharedWallWaveColor(double wavePhase, double baseLuminosity) {
    final waveIntensity = math.sin(wavePhase * 2) * 0.1;
    final totalIntensity = (baseLuminosity + waveIntensity).clamp(0.0, 0.4);
    return sharedWalls.withOpacity(totalIntensity);
  }

  // ==================== CONTEMPLATIVE MOOD COLORS ====================

  /// Get contemplative background color
  static Color getContemplativeBackground() {
    return const Color(0x08E8F5E8); // Very subtle green background
  }

  /// Get contemplative overlay color
  static Color getContemplativeOverlay() {
    return const Color(0x05A5D6A7); // Minimal overlay
  }

  // ==================== SEASONAL ADAPTATION ====================

  /// Get seasonal color modifier
  static Color getSeasonalModifier(Color baseColor, double seasonPhase) {
    // Subtle seasonal variation
    final seasonalIntensity = (math.sin(seasonPhase) * 0.1).clamp(-0.1, 0.1);
    final alpha = (baseColor.opacity + seasonalIntensity).clamp(0.0, 1.0);

    return baseColor.withOpacity(alpha);
  }

  /// Get time-of-day color modifier
  static Color getTimeOfDayModifier(Color baseColor, double timePhase) {
    // Subtle time-of-day variation
    final timeIntensity = (math.cos(timePhase) * 0.05).clamp(-0.05, 0.05);
    final alpha = (baseColor.opacity + timeIntensity).clamp(0.0, 1.0);

    return baseColor.withOpacity(alpha);
  }
}

/// V4 Membrane Color Utilities
class MembraneColorUtils {
  /// Blend two colors with organic variation
  static Color blendColors(Color color1, Color color2, double ratio) {
    final r = (color1.red * (1 - ratio) + color2.red * ratio).round();
    final g = (color1.green * (1 - ratio) + color2.green * ratio).round();
    final b = (color1.blue * (1 - ratio) + color2.blue * ratio).round();
    final a = (color1.alpha * (1 - ratio) + color2.alpha * ratio).round();

    return Color.fromARGB(a, r, g, b);
  }

  /// Create organic color variation
  static Color createOrganicVariation(Color baseColor, double variation) {
    final variationAmount = (variation * 0.1).clamp(-0.1, 0.1);
    final alpha = (baseColor.opacity + variationAmount).clamp(0.0, 1.0);

    return baseColor.withOpacity(alpha);
  }

  /// Apply contemplative dimming
  static Color applyContemplativeDimming(
      Color baseColor, double dimmingFactor) {
    final dimmedAlpha =
        (baseColor.opacity * (1.0 - dimmingFactor)).clamp(0.0, 1.0);
    return baseColor.withOpacity(dimmedAlpha);
  }
}
