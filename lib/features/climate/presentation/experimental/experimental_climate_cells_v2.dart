import 'package:flutter/material.dart';

/// Experimental Climate Cells V2
///
/// An experimental prototype with organically fused cells inspired by plant tissue.
/// Cells are interconnected blobs with elastic curvature, visually touching each other.
class ExperimentalClimateCellsV2 extends StatefulWidget {
  const ExperimentalClimateCellsV2({super.key});

  @override
  State<ExperimentalClimateCellsV2> createState() =>
      _ExperimentalClimateCellsV2State();
}

class _ExperimentalClimateCellsV2State extends State<ExperimentalClimateCellsV2>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      margin: const EdgeInsets.all(20), // Breathing margin
      child: Stack(
        children: [
          // Organic fused cells background painter
          CustomPaint(
            painter: OrganicCellsPainter(),
            child: Container(),
          ),

          // Positioned content for each cell area

          // Weather cell (top, large)
          _buildCellContent(
            position: const Offset(150, 40),
            child: _buildWeatherContent(),
            cellType: CellType.weather,
          ),

          // Forecast cell (right, medium-large)
          _buildCellContent(
            position: const Offset(180, 150),
            child: _buildForecastContent(),
            cellType: CellType.forecast,
          ),

          // Soil temp cell (left, medium)
          _buildCellContent(
            position: const Offset(40, 120),
            child: _buildSoilTempContent(),
            cellType: CellType.soilTemp,
          ),

          // Alert cell (bottom-left, medium)
          _buildCellContent(
            position: const Offset(60, 230),
            child: _buildAlertContent(),
            cellType: CellType.alert,
          ),

          // pH cell (center, pulsating nucleus)
          _buildCellContent(
            position: const Offset(140, 140),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child!,
                );
              },
              child: _buildPhContent(),
            ),
            cellType: CellType.ph,
          ),
        ],
      ),
    );
  }

  Widget _buildCellContent({
    required Offset position,
    required Widget child,
    required CellType cellType,
  }) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        // TODO: Replace with actual navigation/routing
        onTap: () {
          debugPrint('Tapped ${cellType.name}');
          // Implement navigation to detail screen
        },
        child: child,
      ),
    );
  }

  Widget _buildWeatherContent() {
    return const SizedBox(
      width: 120,
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny, size: 24, color: Colors.white70),
          SizedBox(height: 4),
          Text(
            '14° / 7°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastContent() {
    return const SizedBox(
      width: 100,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📈', style: TextStyle(fontSize: 28)),
          SizedBox(height: 4),
          Text(
            'Prévisions',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTempContent() {
    return const SizedBox(
      width: 75,
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.thermostat, size: 20, color: Colors.white70),
          SizedBox(height: 2),
          Text(
            '10.4°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'sol',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertContent() {
    return const SizedBox(
      width: 60,
      height: 60,
      child: Center(
        child: Text(
          '!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPhContent() {
    return const SizedBox(
      width: 80,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.opacity, size: 24, color: Colors.white),
          SizedBox(height: 4),
          Text(
            'pH 6.8',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

enum CellType { weather, forecast, soilTemp, alert, ph }

/// Custom Painter for organic fused cell shapes
/// Creates interconnected blobs that look like plant tissue under a microscope
class OrganicCellsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cells = _createFusedCells(size);

    for (final cell in cells) {
      // Gradient paint for each cell
      final gradient = RadialGradient(
        colors: cell.colors,
        stops: const [0.0, 1.0],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        )
        ..style = PaintingStyle.fill;

      // Draw the cell path
      canvas.drawPath(cell.path, paint);

      // Optional: subtle border for definition
      final borderPaint = Paint()
        ..color = cell.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..blendMode = BlendMode.overlay;

      canvas.drawPath(cell.path, borderPaint);
    }
  }

  List<_CellShape> _createFusedCells(Size size) {
    final cells = <_CellShape>[];

    // 1. Weather cell (top, large) - teal-blue gradient
    cells.add(_CellShape(
      path: _createOrganicBlob(
        center: Offset(size.width * 0.48, size.height * 0.15),
        width: size.width * 0.40,
        height: size.height * 0.25,
        asymmetry: 0.3,
      ),
      colors: const [
        Color.fromRGBO(135, 206, 235, 0.85), // Sky blue
        Color.fromRGBO(95, 158, 160, 0.75),
      ],
      borderColor: const Color.fromRGBO(135, 206, 235, 0.4),
    ));

    // 2. Forecast cell (right, medium-large) - lavender gradient
    cells.add(_CellShape(
      path: _createOrganicBlob(
        center: Offset(size.width * 0.65, size.height * 0.48),
        width: size.width * 0.30,
        height: size.height * 0.30,
        asymmetry: -0.2,
      ),
      colors: const [
        Color.fromRGBO(221, 192, 222, 0.85), // Lavender
        Color.fromRGBO(186, 164, 206, 0.75),
      ],
      borderColor: const Color.fromRGBO(221, 192, 222, 0.4),
    ));

    // 3. Soil temp cell (left, medium) - soft green gradient
    cells.add(_CellShape(
      path: _createOrganicBlob(
        center: Offset(size.width * 0.20, size.height * 0.40),
        width: size.width * 0.28,
        height: size.height * 0.28,
        asymmetry: 0.25,
      ),
      colors: const [
        Color.fromRGBO(173, 216, 181, 0.85), // Light green
        Color.fromRGBO(144, 190, 154, 0.75),
      ],
      borderColor: const Color.fromRGBO(173, 216, 181, 0.4),
    ));

    // 4. Alert cell (bottom-left, medium) - soft coral gradient
    cells.add(_CellShape(
      path: _createOrganicBlob(
        center: Offset(size.width * 0.30, size.height * 0.75),
        width: size.width * 0.22,
        height: size.height * 0.22,
        asymmetry: -0.15,
      ),
      colors: const [
        Color.fromRGBO(255, 182, 193, 0.85), // Light pink
        Color.fromRGBO(255, 160, 160, 0.75),
      ],
      borderColor: const Color.fromRGBO(255, 182, 193, 0.4),
    ));

    // 5. pH cell (center, small nucleus) - teal-blue gradient
    cells.add(_CellShape(
      path: _createOrganicBlob(
        center: Offset(size.width * 0.45, size.height * 0.45),
        width: size.width * 0.22,
        height: size.height * 0.22,
        asymmetry: 0.1,
      ),
      colors: const [
        Color.fromRGBO(102, 205, 170, 0.90), // Medium turquoise
        Color.fromRGBO(64, 180, 148, 0.80),
      ],
      borderColor: const Color.fromRGBO(102, 205, 170, 0.5),
    ));

    return cells;
  }

  /// Creates an organic blob shape using quadratic and cubic bezier curves
  /// Centers are designed to overlap slightly to create fusion effect
  Path _createOrganicBlob({
    required Offset center,
    required double width,
    required double height,
    double asymmetry = 0.0, // -1 to 1, creates irregularity
  }) {
    final path = Path();
    final halfWidth = width / 2;
    final halfHeight = height / 2;

    final varA = asymmetry * 0.3;
    final varB = asymmetry * 0.2;

    // Start at top
    path.moveTo(center.dx, center.dy - halfHeight);

    // Top curve (irregular)
    path.cubicTo(
      center.dx + halfWidth * (0.6 + varA),
      center.dy - halfHeight * (1.2 + varB),
      center.dx + halfWidth * (0.9 + varA),
      center.dy - halfHeight * (0.4 + varB),
      center.dx + halfWidth * 0.8,
      center.dy + varA * 10,
    );

    // Right curve (bulge outward)
    path.cubicTo(
      center.dx + halfWidth * 1.15,
      center.dy + halfHeight * 0.5,
      center.dx + halfWidth * 0.95,
      center.dy + halfHeight * 1.0,
      center.dx + halfWidth * 0.6,
      center.dy + halfHeight * 0.9,
    );

    // Bottom curve (indentation)
    path.cubicTo(
      center.dx + halfWidth * 0.3,
      center.dy + halfHeight * 1.1,
      center.dx - halfWidth * 0.1,
      center.dy + halfHeight * 1.0,
      center.dx - halfWidth * 0.3,
      center.dy + halfHeight * 0.8,
    );

    // Left curve (return to start)
    path.cubicTo(
      center.dx - halfWidth * 0.6,
      center.dy + halfHeight * 0.3,
      center.dx - halfWidth * 0.9,
      center.dy - halfHeight * 0.2,
      center.dx - halfWidth * 0.7,
      center.dy - halfHeight * 0.6,
    );

    // Top-left closing curve
    path.cubicTo(
      center.dx - halfWidth * 0.5,
      center.dy - halfHeight * 0.9,
      center.dx + halfWidth * 0.1,
      center.dy - halfHeight * 1.1,
      center.dx,
      center.dy - halfHeight,
    );

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _CellShape {
  final Path path;
  final List<Color> colors;
  final Color borderColor;

  _CellShape({
    required this.path,
    required this.colors,
    required this.borderColor,
  });
}

/// Screen wrapper for visual testing
class ExperimentalClimateScreenV2 extends StatelessWidget {
  const ExperimentalClimateScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experimental Climate Cells V2'),
        backgroundColor: const Color(0xFF1B4332), // Deep green app bar
      ),
      backgroundColor: const Color(0xFFE8F5E9), // Very light green background
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'V2: Organic fused cell layout\n(inspired by plant tissue under microscope)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E7D32),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ExperimentalClimateCellsV2(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cell Mapping:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Large (top): Météo du jour - Weather data\n'
                      '• Medium (right): Prévisions - Forecast\n'
                      '• Medium (left): Température du sol - Soil temp\n'
                      '• Medium (bottom-left): Alertes - Alert\n'
                      '• Nucleus (center): pH - Pulsating cell',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF558B2F),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Features:\n'
                      '✓ Fused interconnected cell boundaries\n'
                      '✓ Soft radial gradients per cell\n'
                      '✓ Organic asymmetric blob shapes\n'
                      '✓ Pulsating pH nucleus animation\n'
                      '✓ Touch interaction ready (TODO: connect navigation)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF689F38),
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


