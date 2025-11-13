import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Cellular Geometry Engine for Organic Rosace V3
///
/// Generates Voronoi-like tessellation with organic deformation,
/// creating unified cellular tissue with shared membrane boundaries.
class CellularGeometry {
  static const double _goldenRatio = 1.618033988749895;
  static const double _organicVariation = 0.15; // 15% natural irregularity

  /// Generate organic cellular tessellation based on data hierarchy
  static List<CellPath> generateOrganicCells({
    required Size canvasSize,
    required Map<String, double> dataHierarchy,
  }) {
    final cells = <CellPath>[];
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);

    // Sort data by importance (larger values = more important = larger cells)
    final sortedData = dataHierarchy.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Generate cell centers using organic distribution
    final cellCenters = _generateOrganicCenters(
      canvasSize: canvasSize,
      dataCount: sortedData.length,
    );

    // Create cells with organic boundaries
    for (int i = 0; i < sortedData.length; i++) {
      final dataEntry = sortedData[i];
      final cellCenter = cellCenters[i];
      final importance = dataEntry.value;

      // Calculate cell size based on importance and position
      final baseSize = _calculateCellSize(importance, canvasSize);
      final organicSize = _applyOrganicVariation(baseSize);

      // Generate organic cell path
      final cellPath = _createOrganicCellPath(
        center: cellCenter,
        size: organicSize,
        cellType: _getCellType(dataEntry.key),
        importance: importance,
      );

      cells.add(CellPath(
        id: dataEntry.key,
        path: cellPath,
        center: cellCenter,
        size: organicSize,
        importance: importance,
        cellType: _getCellType(dataEntry.key),
      ));
    }

    return cells;
  }

  /// Calculate shared membrane boundaries between adjacent cells
  static List<SharedWall> calculateSharedWalls(List<CellPath> cells) {
    final walls = <SharedWall>[];

    for (int i = 0; i < cells.length; i++) {
      for (int j = i + 1; j < cells.length; j++) {
        final cellA = cells[i];
        final cellB = cells[j];

        // Check if cells are adjacent (distance-based)
        final distance = (cellA.center - cellB.center).distance;
        final maxDistance =
            (cellA.size.width + cellB.size.width) * 0.6; // Adjacency threshold

        if (distance < maxDistance) {
          final wall = _createSharedWall(cellA, cellB);
          if (wall != null) {
            walls.add(wall);
          }
        }
      }
    }

    return walls;
  }

  /// Apply organic pressure deformation to cell boundaries
  static List<CellPath> applyOrganicPressure(List<CellPath> baseCells) {
    return baseCells.map((cell) {
      final deformedPath = _deformCellPath(cell.path, cell.importance);
      return cell.copyWith(path: deformedPath);
    }).toList();
  }

  /// Generate organic cell centers using golden ratio and natural distribution
  static List<Offset> _generateOrganicCenters({
    required Size canvasSize,
    required int dataCount,
  }) {
    final centers = <Offset>[];
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);

    if (dataCount == 0) return centers;

    // Central nucleus (pH) - always at center
    centers.add(center);

    if (dataCount == 1) return centers;

    // Weather cell - top position
    centers.add(Offset(center.dx, center.dy - canvasSize.height * 0.25));

    if (dataCount == 2) return centers;

    // Soil temp - left position
    centers.add(Offset(center.dx - canvasSize.width * 0.25, center.dy));

    if (dataCount == 3) return centers;

    // Forecast - right position
    centers.add(Offset(center.dx + canvasSize.width * 0.25, center.dy));

    if (dataCount == 4) return centers;

    // Alerts - bottom position
    centers.add(Offset(center.dx, center.dy + canvasSize.height * 0.25));

    // Add organic variation to positions
    return centers
        .map((center) => _addOrganicVariation(center, canvasSize))
        .toList();
  }

  /// Calculate cell size based on importance and canvas size
  static Size _calculateCellSize(double importance, Size canvasSize) {
    final baseSize = math.min(canvasSize.width, canvasSize.height) * 0.3;
    final sizeMultiplier = 0.4 + (importance * 0.6); // 40% to 100% of base size

    return Size(
      baseSize * sizeMultiplier,
      baseSize * sizeMultiplier,
    );
  }

  /// Apply organic size variation
  static Size _applyOrganicVariation(Size baseSize) {
    final variation =
        1.0 + (math.Random().nextDouble() - 0.5) * _organicVariation;
    return Size(
      baseSize.width * variation,
      baseSize.height * variation,
    );
  }

  /// Create organic cell path with natural boundaries
  static Path _createOrganicCellPath({
    required Offset center,
    required Size size,
    required CellType cellType,
    required double importance,
  }) {
    final path = Path();
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;

    // Generate organic control points
    final controlPoints = _generateOrganicControlPoints(
      center: center,
      size: size,
      cellType: cellType,
      importance: importance,
    );

    // Start at top point
    path.moveTo(controlPoints[0].dx, controlPoints[0].dy);

    // Create organic boundary using cubic bezier curves
    for (int i = 0; i < controlPoints.length; i++) {
      final current = controlPoints[i];
      final next = controlPoints[(i + 1) % controlPoints.length];
      final afterNext = controlPoints[(i + 2) % controlPoints.length];

      // Calculate control points for smooth organic curves
      final cp1 = Offset(
        current.dx + (next.dx - current.dx) * 0.3,
        current.dy + (next.dy - current.dy) * 0.3,
      );
      final cp2 = Offset(
        next.dx - (afterNext.dx - next.dx) * 0.3,
        next.dy - (afterNext.dy - next.dy) * 0.3,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, next.dx, next.dy);
    }

    path.close();
    return path;
  }

  /// Generate organic control points for cell boundary
  static List<Offset> _generateOrganicControlPoints({
    required Offset center,
    required Size size,
    required CellType cellType,
    required double importance,
  }) {
    final points = <Offset>[];
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;

    // Base number of points (more points = smoother curves)
    final pointCount = 8 + (importance * 4).round();

    for (int i = 0; i < pointCount; i++) {
      final angle = (i * 2 * math.pi) / pointCount;
      final baseRadius = _getBaseRadius(angle, halfWidth, halfHeight, cellType);

      // Apply organic variation
      final organicRadius = baseRadius *
          (1.0 +
              math.sin(angle * 3) * 0.1 +
              math.cos(angle * 5) * 0.05 +
              (math.Random().nextDouble() - 0.5) * _organicVariation);

      final x = center.dx + math.cos(angle) * organicRadius;
      final y = center.dy + math.sin(angle) * organicRadius;

      points.add(Offset(x, y));
    }

    return points;
  }

  /// Get base radius for different angles and cell types
  static double _getBaseRadius(
      double angle, double halfWidth, double halfHeight, CellType cellType) {
    switch (cellType) {
      case CellType.nucleus:
        // Circular nucleus
        return math.min(halfWidth, halfHeight);
      case CellType.weather:
        // Elongated horizontally
        return halfWidth * (1.0 + math.cos(angle) * 0.3);
      case CellType.soilTemp:
        // Slightly elongated vertically
        return halfHeight * (1.0 + math.sin(angle) * 0.2);
      case CellType.forecast:
        // Organic blob
        return math.min(halfWidth, halfHeight) *
            (1.0 + math.sin(angle * 2) * 0.15);
      case CellType.alerts:
        // Compact, slightly irregular
        return math.min(halfWidth, halfHeight) *
            (1.0 + math.cos(angle * 3) * 0.1);
    }
  }

  /// Create shared wall between two cells
  static SharedWall? _createSharedWall(CellPath cellA, CellPath cellB) {
    // Find intersection points between cell boundaries
    final intersection = _findCellIntersection(cellA, cellB);
    if (intersection == null) return null;

    return SharedWall(
      cellAId: cellA.id,
      cellBId: cellB.id,
      path: intersection,
      thickness: 2.0,
      opacity: 0.6,
    );
  }

  /// Find intersection between two cell paths
  static Path? _findCellIntersection(CellPath cellA, CellPath cellB) {
    // Simplified intersection - create a curved line between centers
    final centerA = cellA.center;
    final centerB = cellB.center;
    final midPoint = Offset(
      (centerA.dx + centerB.dx) / 2,
      (centerA.dy + centerB.dy) / 2,
    );

    final path = Path();
    path.moveTo(centerA.dx, centerA.dy);

    // Create organic curve between cells
    final controlPoint = Offset(
      midPoint.dx + (math.Random().nextDouble() - 0.5) * 20,
      midPoint.dy + (math.Random().nextDouble() - 0.5) * 20,
    );

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, centerB.dx, centerB.dy);

    return path;
  }

  /// Deform cell path with organic pressure
  static Path _deformCellPath(Path originalPath, double importance) {
    // Apply subtle organic deformation based on importance
    final deformationStrength = importance * 0.05;

    // For now, return original path (deformation can be added later)
    return originalPath;
  }

  /// Add organic variation to position
  static Offset _addOrganicVariation(Offset position, Size canvasSize) {
    final maxVariation = math.min(canvasSize.width, canvasSize.height) * 0.02;
    return Offset(
      position.dx + (math.Random().nextDouble() - 0.5) * maxVariation,
      position.dy + (math.Random().nextDouble() - 0.5) * maxVariation,
    );
  }

  /// Get cell type from data key
  static CellType _getCellType(String dataKey) {
    switch (dataKey.toLowerCase()) {
      case 'ph_core':
      case 'ph':
        return CellType.nucleus;
      case 'weather_current':
      case 'weather':
        return CellType.weather;
      case 'soil_temp':
      case 'soil_temperature':
        return CellType.soilTemp;
      case 'weather_forecast':
      case 'forecast':
        return CellType.forecast;
      case 'alerts':
      case 'alert':
        return CellType.alerts;
      default:
        return CellType.weather;
    }
  }
}

/// Cell path data structure
class CellPath {
  final String id;
  final Path path;
  final Offset center;
  final Size size;
  final double importance;
  final CellType cellType;

  const CellPath({
    required this.id,
    required this.path,
    required this.center,
    required this.size,
    required this.importance,
    required this.cellType,
  });

  CellPath copyWith({
    String? id,
    Path? path,
    Offset? center,
    Size? size,
    double? importance,
    CellType? cellType,
  }) {
    return CellPath(
      id: id ?? this.id,
      path: path ?? this.path,
      center: center ?? this.center,
      size: size ?? this.size,
      importance: importance ?? this.importance,
      cellType: cellType ?? this.cellType,
    );
  }
}

/// Shared wall between cells
class SharedWall {
  final String cellAId;
  final String cellBId;
  final Path path;
  final double thickness;
  final double opacity;

  const SharedWall({
    required this.cellAId,
    required this.cellBId,
    required this.path,
    required this.thickness,
    required this.opacity,
  });
}

/// Cell type enumeration
enum CellType {
  nucleus, // Central pH core
  weather, // Weather data
  soilTemp, // Soil temperature
  forecast, // Weather forecast
  alerts, // Climate alerts
}


