import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'cellular_geometry.dart';

/// Cellular Interactions for Organic Rosace V3
///
/// Handles touch detection and organic responses for irregular cell shapes.
/// Maps touch coordinates to specific cells in the tessellation.
class CellularInteractions {
  /// Detect which cell was touched based on touch coordinates
  static String? detectCellFromTouch(
    Offset touchPoint,
    Map<String, Path> cellPaths,
  ) {
    for (final entry in cellPaths.entries) {
      if (_isPointInPath(touchPoint, entry.value)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Check if a point is inside a path (simplified hit testing)
  static bool _isPointInPath(Offset point, Path path) {
    // Use Flutter's built-in path hit testing
    return path.contains(point);
  }

  /// Create organic touch response animation
  static Animation<double> createOrganicTouchResponse({
    required AnimationController controller,
    double scaleAmount = 0.1,
  }) {
    return Tween<double>(
      begin: 1.0,
      end: 1.0 + scaleAmount,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  /// Create ripple effect animation for touch
  static Animation<double> createRippleEffect({
    required AnimationController controller,
    double maxRadius = 50.0,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: maxRadius,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
  }

  /// Create glow effect animation for touched cell
  static Animation<double> createGlowEffect({
    required AnimationController controller,
    double maxIntensity = 0.5,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: maxIntensity,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Calculate touch response based on cell type and importance
  static TouchResponse calculateTouchResponse({
    required String cellId,
    required CellType cellType,
    required double importance,
    required Offset touchPoint,
  }) {
    // Base response intensity based on importance
    final baseIntensity = 0.3 + (importance * 0.4);

    // Cell type specific responses
    final typeMultiplier = _getCellTypeResponseMultiplier(cellType);

    // Calculate final response parameters
    final scaleAmount = baseIntensity * typeMultiplier * 0.15;
    final glowIntensity = baseIntensity * typeMultiplier * 0.6;
    final rippleRadius = 30.0 + (importance * 20.0);

    return TouchResponse(
      cellId: cellId,
      cellType: cellType,
      scaleAmount: scaleAmount,
      glowIntensity: glowIntensity,
      rippleRadius: rippleRadius,
      touchPoint: touchPoint,
      duration: Duration(milliseconds: 300 + (importance * 200).round()),
    );
  }

  /// Get response multiplier based on cell type
  static double _getCellTypeResponseMultiplier(CellType cellType) {
    switch (cellType) {
      case CellType.nucleus:
        return 1.5; // Strongest response for nucleus
      case CellType.weather:
        return 1.2; // Strong response for weather
      case CellType.soilTemp:
        return 1.0; // Normal response
      case CellType.forecast:
        return 0.9; // Slightly weaker response
      case CellType.alerts:
        return 1.3; // Strong response for alerts
    }
  }

  /// Create organic breathing animation
  static Animation<double> createBreathingAnimation({
    required AnimationController controller,
    double breathingIntensity = 0.02,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Create nucleus pulsation animation
  static Animation<double> createNucleusPulsation({
    required AnimationController controller,
    double pulseIntensity = 0.15,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Create membrane luminosity wave animation
  static Animation<double> createMembraneLuminosity({
    required AnimationController controller,
    double waveSpeed = 1.0,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 2 * math.pi * waveSpeed,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
  }

  /// Calculate organic pressure variation for cells
  static Map<String, double> calculateOrganicPressure({
    required List<CellPath> cells,
    required double timePhase,
  }) {
    final pressureMap = <String, double>{};

    for (final cell in cells) {
      // Base pressure from importance
      final basePressure = cell.importance;

      // Organic variation based on time and position
      final timeVariation = math.sin(timePhase + cell.center.dx * 0.01) * 0.1;
      final positionVariation = math.cos(cell.center.dy * 0.01) * 0.05;

      // Cell type specific pressure
      final typePressure = _getCellTypePressure(cell.cellType);

      final finalPressure =
          basePressure + timeVariation + positionVariation + typePressure;
      pressureMap[cell.id] = math.max(0.1, math.min(1.0, finalPressure));
    }

    return pressureMap;
  }

  /// Get pressure modifier based on cell type
  static double _getCellTypePressure(CellType cellType) {
    switch (cellType) {
      case CellType.nucleus:
        return 0.2; // Higher pressure for nucleus
      case CellType.weather:
        return 0.1; // Slightly higher pressure
      case CellType.soilTemp:
        return 0.0; // Normal pressure
      case CellType.forecast:
        return -0.05; // Slightly lower pressure
      case CellType.alerts:
        return 0.15; // Higher pressure for alerts
    }
  }

  /// Create organic deformation for cell boundaries
  static Path applyOrganicDeformation({
    required Path originalPath,
    required double timePhase,
    required double intensity,
  }) {
    // For now, return original path
    // Organic deformation can be implemented later with more complex algorithms
    return originalPath;
  }

  /// Calculate cell interaction forces
  static Map<String, Offset> calculateCellForces({
    required List<CellPath> cells,
    required double timePhase,
  }) {
    final forces = <String, Offset>{};

    for (final cell in cells) {
      Offset totalForce = Offset.zero;

      // Calculate forces from other cells
      for (final otherCell in cells) {
        if (otherCell.id == cell.id) continue;

        final distance = (cell.center - otherCell.center).distance;
        final minDistance = (cell.size.width + otherCell.size.width) * 0.3;

        if (distance < minDistance) {
          // Repulsion force when too close
          final direction = (cell.center - otherCell.center) / distance;
          final forceMagnitude = (minDistance - distance) / minDistance;
          totalForce += direction * forceMagnitude * 10.0;
        }
      }

      // Add organic time-based forces
      final timeForce = Offset(
        math.sin(timePhase + cell.center.dx * 0.01) * 2.0,
        math.cos(timePhase + cell.center.dy * 0.01) * 2.0,
      );
      totalForce += timeForce;

      forces[cell.id] = totalForce;
    }

    return forces;
  }
}

/// Touch response data structure
class TouchResponse {
  final String cellId;
  final CellType cellType;
  final double scaleAmount;
  final double glowIntensity;
  final double rippleRadius;
  final Offset touchPoint;
  final Duration duration;

  const TouchResponse({
    required this.cellId,
    required this.cellType,
    required this.scaleAmount,
    required this.glowIntensity,
    required this.rippleRadius,
    required this.touchPoint,
    required this.duration,
  });
}

/// Organic animation controller for cellular rosace
class OrganicAnimationController {
  late AnimationController _breathingController;
  late AnimationController _nucleusController;
  late AnimationController _membraneController;
  late AnimationController _touchController;

  late Animation<double> _breathingAnimation;
  late Animation<double> _nucleusAnimation;
  late Animation<double> _membraneAnimation;
  late Animation<double> _touchAnimation;

  final TickerProvider vsync;

  OrganicAnimationController({required this.vsync}) {
    _initializeControllers();
  }

  void _initializeControllers() {
    // Breathing animation (slow, continuous)
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: vsync,
    )..repeat();

    _breathingAnimation = CellularInteractions.createBreathingAnimation(
      controller: _breathingController,
    );

    // Nucleus pulsation (medium speed, continuous)
    _nucleusController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    )..repeat();

    _nucleusAnimation = CellularInteractions.createNucleusPulsation(
      controller: _nucleusController,
    );

    // Membrane luminosity (fast, continuous)
    _membraneController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: vsync,
    )..repeat();

    _membraneAnimation = CellularInteractions.createMembraneLuminosity(
      controller: _membraneController,
    );

    // Touch response (triggered on demand)
    _touchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    _touchAnimation = CellularInteractions.createOrganicTouchResponse(
      controller: _touchController,
    );
  }

  // Getters for animations
  Animation<double> get breathingAnimation => _breathingAnimation;
  Animation<double> get nucleusAnimation => _nucleusAnimation;
  Animation<double> get membraneAnimation => _membraneAnimation;
  Animation<double> get touchAnimation => _touchAnimation;

  // Trigger touch response
  void triggerTouchResponse() {
    _touchController.forward().then((_) {
      _touchController.reverse();
    });
  }

  void dispose() {
    _breathingController.dispose();
    _nucleusController.dispose();
    _membraneController.dispose();
    _touchController.dispose();
  }
}
