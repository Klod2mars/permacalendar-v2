import 'dart:math' as math;
import 'package:flutter/material.dart';

/// V4 Unified Membrane Geometry Engine
///
/// Transforms V3's cellular structure into an authentic plant tissue with:
/// - Shared membrane boundaries (not separate touching elements)
/// - Morphological pressure deformation between cells
/// - Natural tessellation with visible membrane subdivisions
/// - Functional hierarchy reflecting biological importance
class UnifiedMembraneGeometry {
  static const double _goldenRatio = 1.618033988749895;
  static const double _membraneThickness = 0.8;
  static const double _pressureVariation =
      0.12; // 12% natural pressure variation

  /// Generate unified membrane tessellation with shared boundaries
  static CellularMembrane generateUnifiedTissue({
    required Size canvasSize,
    required Map<String, double> hierarchy,
  }) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);

    // Sort by V4 hierarchy: weather_current dominant, pH subtle nucleus
    final sortedHierarchy = _sortByV4Hierarchy(hierarchy);

    // Generate cell centers with morphological pressure consideration
    final cellCenters = _generateHierarchicalCenters(
      canvasSize: canvasSize,
      hierarchy: sortedHierarchy,
    );

    // Create cells with shared membrane boundaries
    final cells = <CellData>[];
    for (int i = 0; i < sortedHierarchy.length; i++) {
      final entry = sortedHierarchy[i];
      final cellCenter = cellCenters[i];

      final cellData = _createUnifiedCell(
        id: entry.key,
        center: cellCenter,
        importance: entry.value,
        canvasSize: canvasSize,
        cellType: _getCellType(entry.key),
      );

      cells.add(cellData);
    }

    // Apply morphological pressure deformation
    final cellDataMap = {for (final cell in cells) cell.id: cell};
    final deformedCellPaths = applyMorphologicalPressure(cellDataMap);

    // Extract shared wall boundaries
    final sharedWalls = extractSharedBoundaries(deformedCellPaths);

    return CellularMembrane(
      cells: cells,
      sharedWalls: sharedWalls,
      center: center,
      size: canvasSize,
    );
  }

  /// Apply morphological pressure deformation to create natural cell shapes
  static Map<String, Path> applyMorphologicalPressure(
      Map<String, CellData> baseCells) {
    final deformedPaths = <String, Path>{};

    for (final cellEntry in baseCells.entries) {
      final cell = cellEntry.value;
      final cellId = cellEntry.key;

      // Calculate pressure from adjacent cells
      final pressure = _calculateMorphologicalPressure(cell, baseCells);

      // Deform cell path based on pressure
      final deformedPath =
          _deformCellWithPressure(cell.path, pressure, cell.importance);

      deformedPaths[cellId] = deformedPath;
    }

    return deformedPaths;
  }

  /// Extract shared wall boundaries between adjacent cells
  static List<SharedWall> extractSharedBoundaries(Map<String, Path> cellPaths) {
    final walls = <SharedWall>[];
    final cellEntries = cellPaths.entries.toList();

    for (int i = 0; i < cellEntries.length; i++) {
      for (int j = i + 1; j < cellEntries.length; j++) {
        final cellA = cellEntries[i];
        final cellB = cellEntries[j];

        // Check if cells share a boundary
        final sharedBoundary = _findSharedBoundary(cellA.value, cellB.value);
        if (sharedBoundary != null) {
          // Calculate pressure between cells for wall thickness
          final pressure = _calculateWallPressure(cellA.value, cellB.value);

          walls.add(SharedWall(
            wallPath: sharedBoundary,
            cellA: cellA.key,
            cellB: cellB.key,
            luminosity: pressure * 0.3, // Subtle internal glow
            thickness:
                _membraneThickness + (pressure * 0.5), // Varies with pressure
          ));
        }
      }
    }

    return walls;
  }

  /// Sort hierarchy according to V4 specifications
  static List<MapEntry<String, double>> _sortByV4Hierarchy(
      Map<String, double> hierarchy) {
    // V4 hierarchy: weather_current dominant, pH subtle nucleus
    final v4Hierarchy = <String, double>{
      'weather_current': 1.0, // DOMINANT - daily orientation cell
      'soil_temp': 0.85, // STRATEGIC - frequently consulted
      'weather_forecast': 0.85, // STRATEGIC - planning information
      'alerts': 0.75, // CONDITIONAL - importance varies
      'ph_core': 0.35, // NUCLEUS - small but central presence
    };

    // Apply V4 hierarchy to input data
    final adjustedHierarchy = <String, double>{};
    for (final entry in hierarchy.entries) {
      final v4Weight = v4Hierarchy[entry.key] ?? 0.5;
      adjustedHierarchy[entry.key] = entry.value * v4Weight;
    }

    return adjustedHierarchy.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  /// Generate hierarchical cell centers with morphological pressure consideration
  static List<Offset> _generateHierarchicalCenters({
    required Size canvasSize,
    required List<MapEntry<String, double>> hierarchy,
  }) {
    final centers = <Offset>[];
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);

    if (hierarchy.isEmpty) return centers;

    // V4 Layout: Weather dominant (top-center), pH subtle nucleus (center)
    for (int i = 0; i < hierarchy.length; i++) {
      final entry = hierarchy[i];
      final importance = entry.value;

      Offset cellCenter;

      switch (entry.key) {
        case 'weather_current':
          // DOMINANT: Top-center, largest presence
          cellCenter = Offset(center.dx, center.dy - canvasSize.height * 0.3);
          break;
        case 'ph_core':
          // NUCLEUS: Center, subtle presence
          cellCenter = center;
          break;
        case 'soil_temp':
          // STRATEGIC: Left position
          cellCenter = Offset(center.dx - canvasSize.width * 0.25, center.dy);
          break;
        case 'weather_forecast':
          // STRATEGIC: Right position
          cellCenter = Offset(center.dx + canvasSize.width * 0.25, center.dy);
          break;
        case 'alerts':
          // CONDITIONAL: Bottom position
          cellCenter = Offset(center.dx, center.dy + canvasSize.height * 0.25);
          break;
        default:
          // Default: Circular distribution
          final angle = (i * 2 * math.pi) / hierarchy.length;
          final radius = canvasSize.width * 0.2;
          cellCenter = Offset(
            center.dx + math.cos(angle) * radius,
            center.dy + math.sin(angle) * radius,
          );
      }

      // Apply subtle organic variation
      cellCenter = _addOrganicVariation(cellCenter, canvasSize, importance);
      centers.add(cellCenter);
    }

    return centers;
  }

  /// Create unified cell with shared membrane consideration
  static CellData _createUnifiedCell({
    required String id,
    required Offset center,
    required double importance,
    required Size canvasSize,
    required CellType cellType,
  }) {
    // Calculate cell size based on V4 hierarchy
    final baseSize = _calculateV4CellSize(importance, canvasSize, cellType);

    // Generate organic cell path
    final path = _createOrganicCellPath(
      center: center,
      size: baseSize,
      cellType: cellType,
      importance: importance,
    );

    return CellData(
      id: id,
      path: path,
      center: center,
      size: baseSize,
      importance: importance,
      cellType: cellType,
    );
  }

  /// Calculate V4 cell size with functional hierarchy
  static Size _calculateV4CellSize(
      double importance, Size canvasSize, CellType cellType) {
    final baseSize = math.min(canvasSize.width, canvasSize.height) * 0.25;

    // V4 size multipliers based on functional importance
    double sizeMultiplier;
    switch (cellType) {
      case CellType.weather:
        sizeMultiplier = 1.4; // DOMINANT - 40% larger
        break;
      case CellType.soilTemp:
      case CellType.forecast:
        sizeMultiplier = 1.0; // STRATEGIC - normal size
        break;
      case CellType.alerts:
        sizeMultiplier = 0.8; // CONDITIONAL - smaller
        break;
      case CellType.nucleus:
        sizeMultiplier = 0.6; // NUCLEUS - subtle presence
        break;
    }

    final finalSize = baseSize * sizeMultiplier * (0.5 + importance * 0.5);

    return Size(finalSize, finalSize);
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

    // Generate organic control points based on cell type
    final controlPoints = _generateOrganicControlPoints(
      center: center,
      size: size,
      cellType: cellType,
      importance: importance,
    );

    // Start at first point
    path.moveTo(controlPoints[0].dx, controlPoints[0].dy);

    // Create organic boundary with shared membrane consideration
    for (int i = 0; i < controlPoints.length; i++) {
      final current = controlPoints[i];
      final next = controlPoints[(i + 1) % controlPoints.length];

      // Create smooth organic curves
      final cp1 = Offset(
        current.dx + (next.dx - current.dx) * 0.4,
        current.dy + (next.dy - current.dy) * 0.4,
      );
      final cp2 = Offset(
        next.dx - (next.dx - current.dx) * 0.4,
        next.dy - (next.dy - current.dy) * 0.4,
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

    // Number of points based on importance and cell type
    final pointCount = _getPointCount(cellType, importance);

    for (int i = 0; i < pointCount; i++) {
      final angle = (i * 2 * math.pi) / pointCount;
      final baseRadius = _getBaseRadius(angle, halfWidth, halfHeight, cellType);

      // Apply organic variation for natural boundaries
      final organicRadius = baseRadius *
          (1.0 +
              math.sin(angle * 2) * 0.08 +
              math.cos(angle * 3) * 0.04 +
              (math.Random().nextDouble() - 0.5) * _pressureVariation);

      final x = center.dx + math.cos(angle) * organicRadius;
      final y = center.dy + math.sin(angle) * organicRadius;

      points.add(Offset(x, y));
    }

    return points;
  }

  /// Get point count based on cell type and importance
  static int _getPointCount(CellType cellType, double importance) {
    switch (cellType) {
      case CellType.weather:
        return 12; // More points for dominant cell
      case CellType.soilTemp:
      case CellType.forecast:
        return 10; // Standard points
      case CellType.alerts:
        return 8; // Fewer points for conditional cell
      case CellType.nucleus:
        return 6; // Minimal points for subtle nucleus
    }
  }

  /// Get base radius for different angles and cell types
  static double _getBaseRadius(
      double angle, double halfWidth, double halfHeight, CellType cellType) {
    switch (cellType) {
      case CellType.nucleus:
        // Circular nucleus
        return math.min(halfWidth, halfHeight);
      case CellType.weather:
        // Elongated horizontally for dominance
        return halfWidth * (1.0 + math.cos(angle) * 0.2);
      case CellType.soilTemp:
        // Slightly elongated vertically
        return halfHeight * (1.0 + math.sin(angle) * 0.15);
      case CellType.forecast:
        // Organic blob
        return math.min(halfWidth, halfHeight) *
            (1.0 + math.sin(angle * 2) * 0.1);
      case CellType.alerts:
        // Compact, slightly irregular
        return math.min(halfWidth, halfHeight) *
            (1.0 + math.cos(angle * 3) * 0.08);
    }
  }

  /// Calculate morphological pressure between cells
  static double _calculateMorphologicalPressure(
      CellData cell, Map<String, CellData> allCells) {
    double totalPressure = 0.0;

    for (final otherCell in allCells.values) {
      if (otherCell.id == cell.id) continue;

      final distance = (cell.center - otherCell.center).distance;
      final minDistance = (cell.size.width + otherCell.size.width) * 0.4;

      if (distance < minDistance) {
        // Calculate pressure based on proximity and importance
        final proximity = (minDistance - distance) / minDistance;
        final importancePressure = otherCell.importance * 0.3;
        totalPressure += proximity * importancePressure;
      }
    }

    return totalPressure.clamp(0.0, 1.0);
  }

  /// Deform cell path with morphological pressure
  static Path _deformCellWithPressure(
      Path originalPath, double pressure, double importance) {
    // Apply subtle deformation based on pressure
    final deformationStrength = pressure * importance * 0.1;

    // For now, return original path with slight scaling
    // More complex deformation can be added later
    final scale = 1.0 + deformationStrength;
    final matrix = Matrix4.identity()..scale(scale);

    return originalPath.transform(matrix.storage);
  }

  /// Find shared boundary between two cell paths
  static Path? _findSharedBoundary(Path pathA, Path pathB) {
    // Simplified shared boundary detection
    // In a full implementation, this would use proper path intersection algorithms

    // For now, create a curved line representing the shared boundary
    final boundsA = pathA.getBounds();
    final boundsB = pathB.getBounds();

    final centerA = boundsA.center;
    final centerB = boundsB.center;

    final path = Path();
    path.moveTo(centerA.dx, centerA.dy);

    // Create organic curve between centers
    final midPoint = Offset(
      (centerA.dx + centerB.dx) / 2,
      (centerA.dy + centerB.dy) / 2,
    );

    final controlPoint = Offset(
      midPoint.dx + (math.Random().nextDouble() - 0.5) * 15,
      midPoint.dy + (math.Random().nextDouble() - 0.5) * 15,
    );

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, centerB.dx, centerB.dy);

    return path;
  }

  /// Calculate wall pressure for thickness variation
  static double _calculateWallPressure(Path pathA, Path pathB) {
    // Simplified pressure calculation
    final boundsA = pathA.getBounds();
    final boundsB = pathB.getBounds();

    final distance = (boundsA.center - boundsB.center).distance;
    final maxDistance = math.max(boundsA.width, boundsB.width);

    return (1.0 - (distance / maxDistance)).clamp(0.0, 1.0);
  }

  /// Add organic variation to position
  static Offset _addOrganicVariation(
      Offset position, Size canvasSize, double importance) {
    final maxVariation = math.min(canvasSize.width, canvasSize.height) * 0.015;
    final variation = maxVariation *
        (1.0 - importance * 0.5); // Less variation for important cells

    return Offset(
      position.dx + (math.Random().nextDouble() - 0.5) * variation,
      position.dy + (math.Random().nextDouble() - 0.5) * variation,
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

/// V4 Cellular Membrane data structure
class CellularMembrane {
  final List<CellData> cells;
  final List<SharedWall> sharedWalls;
  final Offset center;
  final Size size;

  const CellularMembrane({
    required this.cells,
    required this.sharedWalls,
    required this.center,
    required this.size,
  });
}

/// V4 Cell data with enhanced properties
class CellData {
  final String id;
  final Path path;
  final Offset center;
  final Size size;
  final double importance;
  final CellType cellType;

  const CellData({
    required this.id,
    required this.path,
    required this.center,
    required this.size,
    required this.importance,
    required this.cellType,
  });
}

/// V4 Shared wall with enhanced properties
class SharedWall {
  final Path wallPath;
  final String cellA;
  final String cellB;
  final double luminosity; // Subtle internal glow
  final double thickness; // Based on cell pressure

  const SharedWall({
    required this.wallPath,
    required this.cellA,
    required this.cellB,
    required this.luminosity,
    required this.thickness,
  });
}

/// V4 Cell type enumeration
enum CellType {
  nucleus, // Central pH core - subtle presence
  weather, // Weather data - dominant cell
  soilTemp, // Soil temperature - strategic cell
  forecast, // Weather forecast - strategic cell
  alerts, // Climate alerts - conditional cell
}


