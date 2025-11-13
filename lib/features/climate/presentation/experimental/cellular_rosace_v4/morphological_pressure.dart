import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'unified_membrane_geometry.dart';

/// V4 Morphological Pressure Algorithm
///
/// Calculates how cells deform each other at contact points, creating:
/// - Natural asymmetry through pressure differentials
/// - Visible shared walls as structural elements
/// - Organic cell shapes that reflect functional importance
/// - Authentic plant tissue appearance
class MorphologicalPressure {
  static const double _pressureThreshold = 0.3;
  static const double _deformationStrength = 0.15;
  static const double _wallVisibilityThreshold = 0.2;

  /// Apply morphological pressure deformation to cells
  static Map<String, Path> applyPressureDeformation(
      Map<String, CellData> cells) {
    final deformedPaths = <String, Path>{};

    // Calculate pressure map for all cells
    final pressureMap = _calculatePressureMap(cells);

    // Apply deformation to each cell
    for (final cellEntry in cells.entries) {
      final cell = cellEntry.value;
      final cellId = cellEntry.key;

      // Get pressure for this cell
      final cellPressure = pressureMap[cellId] ?? 0.0;

      // Calculate deformation based on pressure
      final deformation = _calculateCellDeformation(cell, pressureMap);

      // Apply deformation to cell path
      final deformedPath =
          _deformCellPath(cell.path, deformation, cellPressure);

      deformedPaths[cellId] = deformedPath;
    }

    return deformedPaths;
  }

  /// Calculate pressure map for all cells
  static Map<String, double> _calculatePressureMap(
      Map<String, CellData> cells) {
    final pressureMap = <String, double>{};

    for (final cellEntry in cells.entries) {
      final cell = cellEntry.value;
      final cellId = cellEntry.key;

      double totalPressure = 0.0;

      // Calculate pressure from adjacent cells
      for (final otherCellEntry in cells.entries) {
        if (otherCellEntry.key == cellId) continue;

        final otherCell = otherCellEntry.value;
        final pressure = _calculateCellPairPressure(cell, otherCell);
        totalPressure += pressure;
      }

      // Add functional pressure based on hierarchy
      final functionalPressure = _calculateFunctionalPressure(cell);
      totalPressure += functionalPressure;

      pressureMap[cellId] = totalPressure.clamp(0.0, 1.0);
    }

    return pressureMap;
  }

  /// Calculate pressure between two cells
  static double _calculateCellPairPressure(CellData cellA, CellData cellB) {
    // Calculate distance between cell centers
    final distance = (cellA.center - cellB.center).distance;

    // Calculate minimum distance for contact
    final minDistance = (cellA.size.width + cellB.size.width) * 0.4;

    if (distance > minDistance) return 0.0;

    // Calculate pressure based on proximity and importance
    final proximity = (minDistance - distance) / minDistance;
    final importancePressure = (cellA.importance + cellB.importance) * 0.5;

    // Calculate pressure based on cell types
    final typePressure = _calculateTypePressure(cellA.cellType, cellB.cellType);

    return proximity * importancePressure * typePressure;
  }

  /// Calculate functional pressure based on cell hierarchy
  static double _calculateFunctionalPressure(CellData cell) {
    // V4 hierarchy pressure
    switch (cell.cellType) {
      case CellType.weather:
        return 0.3; // Dominant cell - high functional pressure
      case CellType.soilTemp:
      case CellType.forecast:
        return 0.2; // Strategic cells - medium pressure
      case CellType.alerts:
        return 0.15; // Conditional cell - lower pressure
      case CellType.nucleus:
        return 0.1; // Nucleus - subtle pressure
    }
  }

  /// Calculate pressure based on cell types
  static double _calculateTypePressure(CellType typeA, CellType typeB) {
    // Weather cells create more pressure
    if (typeA == CellType.weather || typeB == CellType.weather) {
      return 1.2;
    }

    // Nucleus creates subtle pressure
    if (typeA == CellType.nucleus || typeB == CellType.nucleus) {
      return 0.8;
    }

    // Alerts create moderate pressure
    if (typeA == CellType.alerts || typeB == CellType.alerts) {
      return 1.1;
    }

    return 1.0; // Default pressure
  }

  /// Calculate cell deformation based on pressure
  static CellDeformation _calculateCellDeformation(
      CellData cell, Map<String, double> pressureMap) {
    final cellPressure = pressureMap[cell.id] ?? 0.0;

    // Calculate deformation vectors from adjacent cells
    final deformationVectors = <Offset>[];

    for (final otherCellEntry in pressureMap.entries) {
      if (otherCellEntry.key == cell.id) continue;

      final otherCellId = otherCellEntry.key;
      final otherPressure = otherCellEntry.value;

      // Find the other cell data
      final otherCell = _findCellById(otherCellId, pressureMap);
      if (otherCell == null) continue;

      // Calculate deformation vector
      final vector =
          _calculateDeformationVector(cell, otherCell, otherPressure);
      if (vector != Offset.zero) {
        deformationVectors.add(vector);
      }
    }

    // Combine deformation vectors
    final totalDeformation = _combineDeformationVectors(deformationVectors);

    return CellDeformation(
      cellId: cell.id,
      pressure: cellPressure,
      deformationVector: totalDeformation,
      deformationStrength: cellPressure * _deformationStrength,
    );
  }

  /// Calculate deformation vector between two cells
  static Offset _calculateDeformationVector(
      CellData cellA, CellData cellB, double pressure) {
    final distance = (cellA.center - cellB.center).distance;
    final minDistance = (cellA.size.width + cellB.size.width) * 0.4;

    if (distance > minDistance) return Offset.zero;

    // Calculate direction from cellB to cellA
    final direction = (cellA.center - cellB.center) / distance;

    // Calculate magnitude based on pressure and proximity
    final proximity = (minDistance - distance) / minDistance;
    final magnitude = pressure * proximity * 10.0;

    return direction * magnitude;
  }

  /// Combine multiple deformation vectors
  static Offset _combineDeformationVectors(List<Offset> vectors) {
    if (vectors.isEmpty) return Offset.zero;

    Offset totalVector = Offset.zero;
    for (final vector in vectors) {
      totalVector += vector;
    }

    // Normalize and limit magnitude
    final magnitude = totalVector.distance;
    if (magnitude > 20.0) {
      totalVector = totalVector / magnitude * 20.0;
    }

    return totalVector;
  }

  /// Deform cell path with morphological pressure
  static Path _deformCellPath(
      Path originalPath, CellDeformation deformation, double pressure) {
    if (pressure < _pressureThreshold) return originalPath;

    // Apply deformation to path points
    final deformedPath = _applyPathDeformation(originalPath, deformation);

    return deformedPath;
  }

  /// Apply deformation to path points
  static Path _applyPathDeformation(
      Path originalPath, CellDeformation deformation) {
    // For now, apply simple scaling and translation
    // More complex path deformation can be added later

    final matrix = Matrix4.identity();

    // Apply deformation vector as translation
    matrix.translate(
        deformation.deformationVector.dx, deformation.deformationVector.dy);

    // Apply pressure-based scaling
    final scale = 1.0 + deformation.deformationStrength * 0.1;
    matrix.scale(scale);

    return originalPath.transform(matrix.storage);
  }

  /// Find cell by ID (helper method)
  static CellData? _findCellById(
      String cellId, Map<String, double> pressureMap) {
    // This is a simplified implementation
    // In a real implementation, you'd have access to the cell data
    return null;
  }

  /// Calculate shared wall visibility based on pressure
  static double calculateWallVisibility(double pressureA, double pressureB) {
    final averagePressure = (pressureA + pressureB) / 2;
    return (averagePressure * 0.5 + 0.3).clamp(0.0, 1.0);
  }

  /// Calculate wall thickness based on pressure
  static double calculateWallThickness(double pressureA, double pressureB) {
    final averagePressure = (pressureA + pressureB) / 2;
    return (0.8 + averagePressure * 0.4).clamp(0.8, 1.2);
  }

  /// Calculate wall luminosity based on pressure
  static double calculateWallLuminosity(double pressureA, double pressureB) {
    final averagePressure = (pressureA + pressureB) / 2;
    return (averagePressure * 0.3).clamp(0.0, 0.3);
  }

  /// Calculate cell interaction forces
  static Map<String, Offset> calculateCellForces(Map<String, CellData> cells) {
    final forces = <String, Offset>{};

    for (final cellEntry in cells.entries) {
      final cell = cellEntry.value;
      final cellId = cellEntry.key;

      Offset totalForce = Offset.zero;

      // Calculate forces from other cells
      for (final otherCellEntry in cells.entries) {
        if (otherCellEntry.key == cellId) continue;

        final otherCell = otherCellEntry.value;
        final force = _calculateCellForce(cell, otherCell);
        totalForce += force;
      }

      // Add organic time-based forces
      final timeForce = _calculateTimeBasedForce(cell);
      totalForce += timeForce;

      forces[cellId] = totalForce;
    }

    return forces;
  }

  /// Calculate force between two cells
  static Offset _calculateCellForce(CellData cellA, CellData cellB) {
    final distance = (cellA.center - cellB.center).distance;
    final minDistance = (cellA.size.width + cellB.size.width) * 0.3;

    if (distance < minDistance) {
      // Repulsion force when too close
      final direction = (cellA.center - cellB.center) / distance;
      final forceMagnitude = (minDistance - distance) / minDistance;
      return direction * forceMagnitude * 15.0;
    }

    return Offset.zero;
  }

  /// Calculate time-based organic force
  static Offset _calculateTimeBasedForce(CellData cell) {
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final timeForce = Offset(
      math.sin(time * 0.5 + cell.center.dx * 0.01) * 2.0,
      math.cos(time * 0.5 + cell.center.dy * 0.01) * 2.0,
    );

    return timeForce;
  }

  /// Calculate pressure gradient for visual effects
  static Map<String, double> calculatePressureGradient(
      Map<String, CellData> cells) {
    final gradient = <String, double>{};

    for (final cellEntry in cells.entries) {
      final cell = cellEntry.value;
      final cellId = cellEntry.key;

      // Calculate pressure gradient based on cell position and importance
      final positionGradient = _calculatePositionGradient(cell);
      final importanceGradient = cell.importance * 0.3;

      gradient[cellId] =
          (positionGradient + importanceGradient).clamp(0.0, 1.0);
    }

    return gradient;
  }

  /// Calculate position-based gradient
  static double _calculatePositionGradient(CellData cell) {
    // Calculate gradient based on cell position
    final centerDistance = cell.center.distance;
    const maxDistance = 150.0; // Approximate maximum distance

    return (1.0 - (centerDistance / maxDistance)).clamp(0.0, 1.0);
  }

  /// Calculate organic pressure variation
  static double calculateOrganicPressureVariation(
      CellData cell, double timePhase) {
    // Add organic variation based on time and position
    final timeVariation = math.sin(timePhase + cell.center.dx * 0.01) * 0.1;
    final positionVariation = math.cos(cell.center.dy * 0.01) * 0.05;

    return (cell.importance + timeVariation + positionVariation)
        .clamp(0.0, 1.0);
  }
}

/// Cell deformation data structure
class CellDeformation {
  final String cellId;
  final double pressure;
  final Offset deformationVector;
  final double deformationStrength;

  const CellDeformation({
    required this.cellId,
    required this.pressure,
    required this.deformationVector,
    required this.deformationStrength,
  });
}

/// Pressure analysis utilities
class PressureAnalysis {
  /// Analyze pressure distribution across cells
  static PressureDistribution analyzePressureDistribution(
      Map<String, double> pressureMap) {
    final pressures = pressureMap.values.toList();
    final averagePressure =
        pressures.fold(0.0, (sum, pressure) => sum + pressure) /
            pressures.length;
    final maxPressure =
        pressures.fold(0.0, (max, pressure) => math.max(max, pressure));
    final minPressure =
        pressures.fold(1.0, (min, pressure) => math.min(min, pressure));

    return PressureDistribution(
      averagePressure: averagePressure,
      maxPressure: maxPressure,
      minPressure: minPressure,
      pressureVariance: _calculateVariance(pressures, averagePressure),
    );
  }

  /// Calculate variance of pressure values
  static double _calculateVariance(List<double> values, double mean) {
    final squaredDifferences =
        values.map((value) => math.pow(value - mean, 2)).toList();
    final sumSquaredDifferences =
        squaredDifferences.fold(0.0, (sum, diff) => sum + diff);
    return sumSquaredDifferences / values.length;
  }

  /// Identify high-pressure zones
  static List<String> identifyHighPressureZones(
      Map<String, double> pressureMap, double threshold) {
    return pressureMap.entries
        .where((entry) => entry.value > threshold)
        .map((entry) => entry.key)
        .toList();
  }

  /// Calculate pressure flow between cells
  static Map<String, List<String>> calculatePressureFlow(
      Map<String, CellData> cells, Map<String, double> pressureMap) {
    final flow = <String, List<String>>{};

    for (final cellEntry in cells.entries) {
      final cellId = cellEntry.key;
      final cell = cellEntry.value;
      final cellPressure = pressureMap[cellId] ?? 0.0;

      final flowTargets = <String>[];

      // Find cells with lower pressure (flow direction)
      for (final otherCellEntry in cells.entries) {
        if (otherCellEntry.key == cellId) continue;

        final otherCellId = otherCellEntry.key;
        final otherCell = otherCellEntry.value;
        final otherPressure = pressureMap[otherCellId] ?? 0.0;

        // Check if pressure flows from this cell to the other
        if (cellPressure > otherPressure) {
          final distance = (cell.center - otherCell.center).distance;
          final maxDistance = (cell.size.width + otherCell.size.width) * 0.5;

          if (distance < maxDistance) {
            flowTargets.add(otherCellId);
          }
        }
      }

      flow[cellId] = flowTargets;
    }

    return flow;
  }
}

/// Pressure distribution data structure
class PressureDistribution {
  final double averagePressure;
  final double maxPressure;
  final double minPressure;
  final double pressureVariance;

  const PressureDistribution({
    required this.averagePressure,
    required this.maxPressure,
    required this.minPressure,
    required this.pressureVariance,
  });
}


