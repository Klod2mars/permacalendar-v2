import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'unified_membrane_geometry.dart';
import 'organic_membrane_palette.dart';

/// V4 Unified Membrane Painter
///
/// Renders the living, unified cellular tissue with:
/// - Unified base membrane (single organic shape)
/// - Internal cell divisions with shared walls
/// - Morphological pressure gradients
/// - Subtle nucleus with minimal presence
/// - Contemplative luminosity (not flashy)
class UnifiedMembranePainter extends CustomPainter {
  final CellularMembrane membrane;
  final double breathingPhase;
  final double nucleusPulse;
  final double membraneLuminosity;
  final double contemplativeBreathing;
  final double seasonalRhythm;
  final Map<String, Color>? customColors;

  UnifiedMembranePainter({
    required this.membrane,
    this.breathingPhase = 0.0,
    this.nucleusPulse = 0.0,
    this.membraneLuminosity = 0.0,
    this.contemplativeBreathing = 0.0,
    this.seasonalRhythm = 0.0,
    this.customColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw unified base membrane
    _drawBaseMembrane(canvas, size);

    // 2. Render internal cell divisions with shared walls
    _drawSharedWallSystem(canvas, size);

    // 3. Apply morphological pressure gradients
    _drawPressureGradients(canvas, size);

    // 4. Render subtle nucleus (pH) with minimal presence
    _drawSubtleNucleus(canvas, size);

    // 5. Add contemplative luminosity (not flashy)
    _drawContemplativeLuminosity(canvas, size);
  }

  /// Draw unified base membrane (single organic shape)
  void _drawBaseMembrane(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) * 0.45;

    // Breathing effect on base membrane
    final breathingRadius =
        baseRadius * (1.0 + math.sin(breathingPhase) * 0.02);

    // Create unified membrane path
    final membranePath = _createUnifiedMembranePath(center, breathingRadius);

    // Base membrane fill
    final basePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          OrganicMembranePalette.baseMembrane,
          OrganicMembranePalette.baseMembrane.withOpacity(0.05),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: breathingRadius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(membranePath, basePaint);

    // Subtle membrane border
    final borderPaint = Paint()
      ..color = OrganicMembranePalette.breathingEdge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..blendMode = BlendMode.overlay;

    canvas.drawPath(membranePath, borderPaint);
  }

  /// Render shared wall system (membrane subdivisions)
  void _drawSharedWallSystem(Canvas canvas, Size size) {
    for (final wall in membrane.sharedWalls) {
      _drawSharedWall(canvas, wall);
    }
  }

  /// Draw a single shared wall with luminosity
  void _drawSharedWall(Canvas canvas, SharedWall wall) {
    // Calculate wall color with luminosity
    final wallColor =
        OrganicMembranePalette.getSharedWallColor(wall.luminosity);
    final wallThickness =
        OrganicMembranePalette.getWallThickness(wall.luminosity);

    final wallPaint = Paint()
      ..color = wallColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = wallThickness
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.overlay;

    // Apply membrane luminosity effect
    final luminosityEffect = 1.0 + math.sin(membraneLuminosity) * 0.1;
    final effectiveOpacity = wallColor.opacity * luminosityEffect;
    wallPaint.color = wallColor.withOpacity(effectiveOpacity);

    canvas.drawPath(wall.wallPath, wallPaint);

    // Optional: Subtle internal glow
    if (wall.luminosity > 0.2) {
      _addSubtleGlow(canvas, wall.wallPath, wall.luminosity);
    }
  }

  /// Apply morphological pressure gradients
  void _drawPressureGradients(Canvas canvas, Size size) {
    for (final cell in membrane.cells) {
      _drawCellWithPressure(canvas, cell);
    }
  }

  /// Draw cell with morphological pressure
  void _drawCellWithPressure(Canvas canvas, CellData cell) {
    // Get cell-specific colors
    final colors = _getCellColors(cell);

    // Create gradient for cell interior
    final gradient = _createCellGradient(cell, colors);

    final cellPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCenter(
          center: cell.center,
          width: cell.size.width * 2,
          height: cell.size.height * 2,
        ),
      )
      ..style = PaintingStyle.fill;

    // Apply contemplative breathing effect
    final breathingScale = 1.0 + math.sin(contemplativeBreathing) * 0.01;
    final scaledPath = _scalePath(cell.path, cell.center, breathingScale);

    // Draw cell interior
    canvas.drawPath(scaledPath, cellPaint);

    // Draw subtle cell border
    _drawCellBorder(canvas, scaledPath, cell);
  }

  /// Render subtle nucleus (pH) with minimal presence
  void _drawSubtleNucleus(Canvas canvas, Size size) {
    final nucleusCell = membrane.cells.firstWhere(
      (cell) => cell.cellType == CellType.nucleus,
      orElse: () => membrane.cells.first,
    );

    final center = nucleusCell.center;
    final baseRadius =
        math.min(nucleusCell.size.width, nucleusCell.size.height) / 2;

    // Subtle breathing effect (not pulsation)
    final breathingRadius = baseRadius * (1.0 + math.sin(nucleusPulse) * 0.02);

    // Nucleus glow (subtle, not flashy)
    final glowPaint = Paint()
      ..shader = OrganicMembranePalette.nucleusGlow.createShader(
        Rect.fromCircle(center: center, radius: breathingRadius * 1.5),
      )
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawCircle(center, breathingRadius * 1.5, glowPaint);

    // Nucleus core (subtle presence)
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0x30FFF176).withOpacity(0.9),
          const Color(0x15FFEB3B).withOpacity(0.7),
          const Color(0x08FFF176).withOpacity(0.4),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: breathingRadius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, breathingRadius, corePaint);

    // Nucleus border (subtle)
    final borderPaint = Paint()
      ..color = const Color(0x20FFF176)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..blendMode = BlendMode.overlay;

    canvas.drawCircle(center, breathingRadius, borderPaint);
  }

  /// Add contemplative luminosity (not flashy)
  void _drawContemplativeLuminosity(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) * 0.5;

    // Contemplative luminosity waves
    final luminosityIntensity =
        (0.1 + math.sin(membraneLuminosity) * 0.05).clamp(0.05, 0.15);

    final luminosityPaint = Paint()
      ..color =
          OrganicMembranePalette.wallLuminosity.withOpacity(luminosityIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    // Draw luminosity waves along membrane
    for (int i = 0; i < 3; i++) {
      final waveRadius = baseRadius * (0.8 + i * 0.1);
      final wavePhase = membraneLuminosity + i * math.pi / 3;
      final waveIntensity = math.sin(wavePhase) * 0.5 + 0.5;

      final wavePaint = Paint()
        ..color = OrganicMembranePalette.wallLuminosity.withOpacity(
          luminosityIntensity * waveIntensity * 0.3,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      canvas.drawCircle(center, waveRadius, wavePaint);
    }
  }

  /// Create unified membrane path
  Path _createUnifiedMembranePath(Offset center, double radius) {
    final path = Path();

    // Create organic membrane shape
    final points = <Offset>[];
    const pointCount = 16;

    for (int i = 0; i < pointCount; i++) {
      final angle = (i * 2 * math.pi) / pointCount;
      final organicRadius = radius *
          (1.0 +
              math.sin(angle * 2) * 0.05 +
              math.cos(angle * 3) * 0.03 +
              (math.Random().nextDouble() - 0.5) * 0.02);

      final x = center.dx + math.cos(angle) * organicRadius;
      final y = center.dy + math.sin(angle) * organicRadius;

      points.add(Offset(x, y));
    }

    // Create smooth organic boundary
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length; i++) {
      final current = points[i];
      final next = points[(i + 1) % points.length];

      final cp1 = Offset(
        current.dx + (next.dx - current.dx) * 0.3,
        current.dy + (next.dy - current.dy) * 0.3,
      );
      final cp2 = Offset(
        next.dx - (next.dx - current.dx) * 0.3,
        next.dy - (next.dy - current.dy) * 0.3,
      );

      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, next.dx, next.dy);
    }

    path.close();
    return path;
  }

  /// Get colors for specific cell type
  List<Color> _getCellColors(CellData cell) {
    // Use custom colors if provided
    if (customColors != null && customColors!.containsKey(cell.id)) {
      final baseColor = customColors![cell.id]!;
      return [
        baseColor.withOpacity(0.8),
        baseColor.withOpacity(0.6),
        baseColor.withOpacity(0.3),
      ];
    }

    // Default colors based on cell type
    switch (cell.cellType) {
      case CellType.weather:
        return [
          const Color(0x60E3F2FD), // Soft sky blue
          const Color(0x40BBDEFB), // Lighter sky blue
          const Color(0x20E3F2FD), // Very light sky blue
        ];
      case CellType.soilTemp:
        return [
          const Color(0x60C8E6C9), // Light earth green
          const Color(0x40A5D6A7), // Medium earth green
          const Color(0x20C8E6C9), // Very light earth green
        ];
      case CellType.forecast:
        return [
          const Color(0x60E1BEE7), // Light lavender
          const Color(0x40CE93D8), // Medium lavender
          const Color(0x20E1BEE7), // Very light lavender
        ];
      case CellType.alerts:
        return [
          const Color(0x60FFCDD2), // Light attention pink
          const Color(0x40F8BBD9), // Medium attention pink
          const Color(0x20FFCDD2), // Very light attention pink
        ];
      case CellType.nucleus:
        return [
          const Color(0x30FFF176), // Gentle yellow
          const Color(0x20FFEB3B), // Lighter yellow
          const Color(0x10FFF176), // Very light yellow
        ];
    }
  }

  /// Create cell gradient
  Gradient _createCellGradient(CellData cell, List<Color> colors) {
    return RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: colors,
      stops: const [0.0, 0.7, 1.0],
    );
  }

  /// Draw subtle cell border
  void _drawCellBorder(Canvas canvas, Path path, CellData cell) {
    final borderPaint = Paint()
      ..color = OrganicMembranePalette.getCellBorderColor(cell.cellType)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..blendMode = BlendMode.overlay;

    canvas.drawPath(path, borderPaint);
  }

  /// Add subtle glow effect
  void _addSubtleGlow(Canvas canvas, Path path, double luminosity) {
    final glowPaint = Paint()
      ..color =
          OrganicMembranePalette.wallLuminosity.withOpacity(luminosity * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    canvas.drawPath(path, glowPaint);
  }

  /// Scale path around center point
  Path _scalePath(Path originalPath, Offset center, double scale) {
    if (scale == 1.0) return originalPath;

    final matrix = Matrix4.identity()
      ..translate(center.dx, center.dy)
      ..scale(scale)
      ..translate(-center.dx, -center.dy);

    return originalPath.transform(matrix.storage);
  }

  @override
  bool shouldRepaint(UnifiedMembranePainter oldDelegate) {
    return oldDelegate.breathingPhase != breathingPhase ||
        oldDelegate.nucleusPulse != nucleusPulse ||
        oldDelegate.membraneLuminosity != membraneLuminosity ||
        oldDelegate.contemplativeBreathing != contemplativeBreathing ||
        oldDelegate.seasonalRhythm != seasonalRhythm ||
        oldDelegate.membrane != membrane ||
        oldDelegate.customColors != customColors;
  }
}

/// V4 Membrane Rendering Utilities
class MembraneRenderingUtils {
  /// Create organic cell path with natural boundaries
  static Path createOrganicCellPath({
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

    // Start at first point
    path.moveTo(controlPoints[0].dx, controlPoints[0].dy);

    // Create organic boundary
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

      // Apply organic variation
      final organicRadius = baseRadius *
          (1.0 +
              math.sin(angle * 2) * 0.08 +
              math.cos(angle * 3) * 0.04 +
              (math.Random().nextDouble() - 0.5) * 0.12);

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
        return math.min(halfWidth, halfHeight);
      case CellType.weather:
        return halfWidth * (1.0 + math.cos(angle) * 0.2);
      case CellType.soilTemp:
        return halfHeight * (1.0 + math.sin(angle) * 0.15);
      case CellType.forecast:
        return math.min(halfWidth, halfHeight) *
            (1.0 + math.sin(angle * 2) * 0.1);
      case CellType.alerts:
        return math.min(halfWidth, halfHeight) *
            (1.0 + math.cos(angle * 3) * 0.08);
    }
  }
}


