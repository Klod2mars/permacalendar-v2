ï»¿import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'cellular_geometry.dart';

/// Cellular Painter for Organic Rosace V3
///
/// Renders the living, breathing cellular tissue with:
/// - Individual cells with internal gradients
/// - Shared membrane boundaries
/// - Breathing outer border
/// - Pulsating nucleus
class CellularPainter extends CustomPainter {
  final List<CellPath> cells;
  final List<SharedWall> sharedWalls;
  final double breathingPhase;
  final double nucleusPulse;
  final double membraneLuminosity;
  final Map<String, Color> cellColors;

  CellularPainter({
    required this.cells,
    required this.sharedWalls,
    this.breathingPhase = 0.0,
    this.nucleusPulse = 0.0,
    this.membraneLuminosity = 0.0,
    this.cellColors = const {},
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw base cellular structure
    _drawCellularBase(canvas, size);

    // 2. Render individual cells with internal gradients
    _drawOrganicCells(canvas, size);

    // 3. Apply shared membrane walls
    _drawSharedMembranes(canvas, size);

    // 4. Add breathing outer border
    _drawBreathingBorder(canvas, size);

    // 5. Render pulsating pH nucleus
    _drawLivingNucleus(canvas, size);
  }

  /// Draw base cellular structure (background)
  void _drawCellularBase(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = const Color(0x10E8F5E8) // Very subtle base
      ..style = PaintingStyle.fill;

    // Draw subtle background circle
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.4;

    canvas.drawCircle(center, radius, basePaint);
  }

  /// Render individual cells with internal gradients
  void _drawOrganicCells(Canvas canvas, Size size) {
    for (final cell in cells) {
      _drawSingleCell(canvas, cell);
    }
  }

  /// Draw a single cell with organic styling
  void _drawSingleCell(Canvas canvas, CellPath cell) {
    // Get cell-specific colors
    final colors = _getCellColors(cell);

    // Create radial gradient for cell interior
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: colors,
      stops: const [0.0, 0.7, 1.0],
    );

    final cellPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCenter(
          center: cell.center,
          width: cell.size.width * 2,
          height: cell.size.height * 2,
        ),
      )
      ..style = PaintingStyle.fill;

    // Apply breathing effect to cell size
    final breathingScale = 1.0 + math.sin(breathingPhase) * 0.02;
    final scaledPath = _scalePath(cell.path, cell.center, breathingScale);

    // Draw cell interior
    canvas.drawPath(scaledPath, cellPaint);

    // Draw subtle cell border
    _drawCellBorder(canvas, scaledPath, cell);
  }

  /// Get colors for specific cell type
  List<Color> _getCellColors(CellPath cell) {
    // Use custom colors if provided
    if (cellColors.containsKey(cell.id)) {
      final baseColor = cellColors[cell.id]!;
      return [
        baseColor.withOpacity(0.8),
        baseColor.withOpacity(0.6),
        baseColor.withOpacity(0.3),
      ];
    }

    // Default colors based on cell type
    switch (cell.cellType) {
      case CellType.nucleus:
        return [
          const Color(0xFFFFE082).withOpacity(0.9), // Warm yellow center
          const Color(0xFFFFF176).withOpacity(0.7), // Lighter yellow
          const Color(0xFFFFECB3).withOpacity(0.4), // Very light yellow
        ];
      case CellType.weather:
        return [
          const Color(0xFF87CEEB).withOpacity(0.8), // Sky blue
          const Color(0xFF5F9EA0).withOpacity(0.6), // Cadet blue
          const Color(0xFF4682B4).withOpacity(0.4), // Steel blue
        ];
      case CellType.soilTemp:
        return [
          const Color(0xFFADF4B0).withOpacity(0.8), // Light green
          const Color(0xFF90BE9A).withOpacity(0.6), // Medium green
          const Color(0xFF6B8E6B).withOpacity(0.4), // Darker green
        ];
      case CellType.forecast:
        return [
          const Color(0xFFDDC0DE).withOpacity(0.8), // Lavender
          const Color(0xFFBAA4CE).withOpacity(0.6), // Medium lavender
          const Color(0xFF9B7FA8).withOpacity(0.4), // Darker lavender
        ];
      case CellType.alerts:
        return [
          const Color(0xFFFFB6C1).withOpacity(0.8), // Light pink
          const Color(0xFFFFA0A0).withOpacity(0.6), // Medium pink
          const Color(0xFFFF8A95).withOpacity(0.4), // Darker pink
        ];
    }
  }

  /// Draw subtle cell border
  void _drawCellBorder(Canvas canvas, Path path, CellPath cell) {
    final borderPaint = Paint()
      ..color = _getCellBorderColor(cell).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..blendMode = BlendMode.overlay;

    canvas.drawPath(path, borderPaint);
  }

  /// Get border color for cell type
  Color _getCellBorderColor(CellPath cell) {
    switch (cell.cellType) {
      case CellType.nucleus:
        return const Color(0xFFFFE082);
      case CellType.weather:
        return const Color(0xFF87CEEB);
      case CellType.soilTemp:
        return const Color(0xFFADF4B0);
      case CellType.forecast:
        return const Color(0xFFDDC0DE);
      case CellType.alerts:
        return const Color(0xFFFFB6C1);
    }
  }

  /// Apply shared membrane walls
  void _drawSharedMembranes(Canvas canvas, Size size) {
    for (final wall in sharedWalls) {
      _drawSharedWall(canvas, wall);
    }
  }

  /// Draw a single shared wall
  void _drawSharedWall(Canvas canvas, SharedWall wall) {
    final wallPaint = Paint()
      ..color = const Color(0x60C8E6C9)
          .withOpacity(wall.opacity) // Shared boundary green
      ..style = PaintingStyle.stroke
      ..strokeWidth = wall.thickness
      ..strokeCap = StrokeCap.round
      ..blendMode = BlendMode.overlay;

    // Apply membrane luminosity effect
    final luminosityEffect = 1.0 + math.sin(membraneLuminosity) * 0.1;
    final effectiveOpacity = wall.opacity * luminosityEffect;
    wallPaint.color = wallPaint.color.withOpacity(effectiveOpacity);

    canvas.drawPath(wall.path, wallPaint);
  }

  /// Add breathing outer border
  void _drawBreathingBorder(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) * 0.45;

    // Breathing effect
    final breathingRadius =
        baseRadius * (1.0 + math.sin(breathingPhase) * 0.05);

    final borderPaint = Paint()
      ..color = const Color(0x30A5D6A7) // Outer breathing edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..blendMode = BlendMode.overlay;

    canvas.drawCircle(center, breathingRadius, borderPaint);

    // Add subtle glow effect
    final glowPaint = Paint()
      ..color = const Color(0x20A5D6A7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    canvas.drawCircle(center, breathingRadius, glowPaint);
  }

  /// Render pulsating pH nucleus
  void _drawLivingNucleus(Canvas canvas, Size size) {
    final nucleusCell = cells.firstWhere(
      (cell) => cell.cellType == CellType.nucleus,
      orElse: () => cells.first,
    );

    final center = nucleusCell.center;
    final baseRadius =
        math.min(nucleusCell.size.width, nucleusCell.size.height) / 2;

    // Pulsation effect
    final pulseRadius = baseRadius * (1.0 + math.sin(nucleusPulse) * 0.15);

    // Nucleus glow
    final glowPaint = Paint()
      ..color = const Color(0x40FFE082)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    canvas.drawCircle(center, pulseRadius * 1.5, glowPaint);

    // Nucleus core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE082).withOpacity(0.9),
          const Color(0xFFFFF176).withOpacity(0.7),
          const Color(0xFFFFECB3).withOpacity(0.4),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: pulseRadius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, pulseRadius, corePaint);

    // Nucleus border
    final borderPaint = Paint()
      ..color = const Color(0x80FFE082)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..blendMode = BlendMode.overlay;

    canvas.drawCircle(center, pulseRadius, borderPaint);
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
  bool shouldRepaint(CellularPainter oldDelegate) {
    return oldDelegate.breathingPhase != breathingPhase ||
        oldDelegate.nucleusPulse != nucleusPulse ||
        oldDelegate.membraneLuminosity != membraneLuminosity ||
        oldDelegate.cells != cells ||
        oldDelegate.sharedWalls != sharedWalls ||
        oldDelegate.cellColors != cellColors;
  }
}

/// Organic Palette for cellular rosace
class OrganicPalette {
  // Base membrane colors
  static const cellWalls = Color(0x40E8F5E8); // Translucent green
  static const sharedMembranes = Color(0x60C8E6C9); // Shared boundary green
  static const breathingBorder = Color(0x30A5D6A7); // Outer breathing edge

  // Internal cell gradients
  static const weatherGradient =
      RadialGradient(colors: [Color(0x80F1F8E9), Color(0x40C8E6C9)]);
  static const nucleusGlow =
      RadialGradient(colors: [Color(0xFFFFE082), Color(0x60FFF176)]);

  // Cell type colors
  static const Map<CellType, List<Color>> cellTypeColors = {
    CellType.nucleus: [
      Color(0xFFFFE082), // Warm yellow
      Color(0xFFFFF176), // Lighter yellow
      Color(0xFFFFECB3), // Very light yellow
    ],
    CellType.weather: [
      Color(0xFF87CEEB), // Sky blue
      Color(0xFF5F9EA0), // Cadet blue
      Color(0xFF4682B4), // Steel blue
    ],
    CellType.soilTemp: [
      Color(0xFFADF4B0), // Light green
      Color(0xFF90BE9A), // Medium green
      Color(0xFF6B8E6B), // Darker green
    ],
    CellType.forecast: [
      Color(0xFFDDC0DE), // Lavender
      Color(0xFFBAA4CE), // Medium lavender
      Color(0xFF9B7FA8), // Darker lavender
    ],
    CellType.alerts: [
      Color(0xFFFFB6C1), // Light pink
      Color(0xFFFFA0A0), // Medium pink
      Color(0xFFFF8A95), // Darker pink
    ],
  };
}


