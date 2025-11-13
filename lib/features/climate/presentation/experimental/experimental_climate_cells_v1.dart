ï»¿import 'dart:ui';
import 'package:flutter/material.dart';

/// Experimental Climate Cells V1
///
/// A prototype exploring an organic, cellular layout for climate data.
/// Inspired by plant tissue structures with irregular, softly rounded cells.
///
/// This is NOT a replacement for ClimateRosacePanel - it's purely experimental.
class ExperimentalClimateCellsV1 extends StatefulWidget {
  const ExperimentalClimateCellsV1({super.key});

  @override
  State<ExperimentalClimateCellsV1> createState() =>
      _ExperimentalClimateCellsV1State();
}

class _ExperimentalClimateCellsV1State extends State<ExperimentalClimateCellsV1>
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
      height: 280,
      margin: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Organic background cells painter
          CustomPaint(
            painter: CellsBackgroundPainter(),
            child: Container(),
          ),

          // Central pH cell (pulsating nucleus)
          Positioned(
            left: 80,
            top: 80,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: _buildCentralPhCell(),
            ),
          ),

          // Soil temperature cell (top-left)
          Positioned(
            left: 20,
            top: 40,
            child: _buildSoilTempCell(),
          ),

          // Weather cell (top-right)
          Positioned(
            left: 160,
            top: 35,
            child: _buildWeatherCell(),
          ),

          // Alert cell (bottom-left)
          Positioned(
            left: 15,
            top: 180,
            child: _buildAlertCell(),
          ),

          // Forecast cell (bottom-right)
          Positioned(
            left: 145,
            top: 175,
            child: _buildForecastCell(),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralPhCell() {
    return const _CellContainer(
      width: 100,
      height: 100,
      color: Color.fromRGBO(127, 179, 211, 0.75), // Teal-blue nucleus
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.opacity, size: 32, color: Colors.white),
          SizedBox(height: 4),
          Text(
            'pH 6.8',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTempCell() {
    return const _CellContainer(
      width: 85,
      height: 85,
      color: Color.fromRGBO(168, 213, 186, 0.7), // Light green
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.thermostat, size: 28, color: Colors.white70),
          SizedBox(height: 2),
          Text(
            '10.4Â°',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'sol',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCell() {
    return const _CellContainer(
      width: 90,
      height: 85,
      color: Color.fromRGBO(184, 212, 240, 0.7), // Light blue
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wb_sunny, size: 28, color: Colors.white70),
          SizedBox(height: 4),
          Text(
            '14Â° / 7Â°',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCell() {
    return const _CellContainer(
      width: 75,
      height: 75,
      color: Color.fromRGBO(255, 179, 186, 0.7), // Soft pink
      child: Center(
        child: Text(
          '!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildForecastCell() {
    return const _CellContainer(
      width: 80,
      height: 80,
      color: Color.fromRGBO(212, 181, 224, 0.7), // Lavender
      child: Center(
        child: Text(
          'ðŸ“ˆ',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}

/// Individual cell container with organic rounded shape
class _CellContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;

  const _CellContainer({
    required this.width,
    required this.height,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20), // Softly rounded
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(
              (color.r * 255.0).round(),
              (color.g * 255.0).round(),
              (color.b * 255.0).round(),
              0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}

/// Custom painter for organic cellular background shapes
class CellsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(0, 128, 0, 0.05);

    final path1 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.1)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.2, size.width * 0.4,
          size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.35,
          size.width * 0.1, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.15,
          size.width * 0.2, size.height * 0.1)
      ..close();

    final path2 = Path()
      ..moveTo(size.width * 0.7, size.height * 0.15)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.2,
          size.width * 0.85, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.35,
          size.width * 0.65, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.68, size.height * 0.18,
          size.width * 0.7, size.height * 0.15)
      ..close();

    final path3 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.75,
          size.width * 0.3, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.18, size.height * 0.85,
          size.width * 0.05, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.72,
          size.width * 0.1, size.height * 0.7)
      ..close();

    final path4 = Path()
      ..moveTo(size.width * 0.6, size.height * 0.68)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.72,
          size.width * 0.8, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.85,
          size.width * 0.55, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.58, size.height * 0.7,
          size.width * 0.6, size.height * 0.68)
      ..close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Simple screen wrapper for visual testing
class ExperimentalClimateScreen extends StatelessWidget {
  const ExperimentalClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experimental Climate Cells V1'),
        backgroundColor: const Color(0xFF2C5F2D), // Dark green app bar
      ),
      backgroundColor: const Color(0xFFF5F5DC), // Beige background
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Organic cellular layout prototype\n(inspired by plant tissue)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ExperimentalClimateCellsV1(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '• Center: pH value (pulsating nucleus)\n'
                  '• Top-left: Soil temperature\n'
                  '• Top-right: Weather data\n'
                  '• Bottom-left: Alert indicator\n'
                  '• Bottom-right: Forecast indicator',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


