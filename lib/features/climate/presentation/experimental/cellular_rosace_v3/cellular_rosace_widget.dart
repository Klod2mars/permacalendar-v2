import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cellular_geometry.dart';
import 'cellular_painter.dart';
import 'cellular_interactions.dart';

/// Cellular Rosace Widget V3 - Living Organic Tissue
///
/// A unified cellular structure inspired by plant epidermis under microscope.
/// Features shared membrane boundaries, organic pressure variations, and
/// living, breathing animations.
class CellularRosaceWidget extends ConsumerStatefulWidget {
  final Map<String, double> dataHierarchy;
  final Map<String, Color>? customColors;
  final Function(String cellId)? onCellTap;
  final double? height;
  final EdgeInsets? margin;

  const CellularRosaceWidget({
    super.key,
    required this.dataHierarchy,
    this.customColors,
    this.onCellTap,
    this.height,
    this.margin,
  });

  @override
  ConsumerState<CellularRosaceWidget> createState() =>
      _CellularRosaceWidgetState();
}

class _CellularRosaceWidgetState extends ConsumerState<CellularRosaceWidget>
    with TickerProviderStateMixin {
  late OrganicAnimationController _animationController;
  late List<CellPath> _cells;
  late List<SharedWall> _sharedWalls;
  late Map<String, Path> _cellPaths;

  String? _touchedCellId;

  @override
  void initState() {
    super.initState();
    _animationController = OrganicAnimationController(vsync: this);
    _initializeCellularStructure();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeCellularStructure() {
    // Generate cellular geometry
    const canvasSize = Size(300, 300); // Default size, will be updated in build
    _cells = CellularGeometry.generateOrganicCells(
      canvasSize: canvasSize,
      dataHierarchy: widget.dataHierarchy,
    );

    // Apply organic pressure deformation
    _cells = CellularGeometry.applyOrganicPressure(_cells);

    // Calculate shared walls
    _sharedWalls = CellularGeometry.calculateSharedWalls(_cells);

    // Create cell paths map for touch detection
    _cellPaths = {for (final cell in _cells) cell.id: cell.path};
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = widget.height ?? 240.0;
    final effectiveMargin = widget.margin ?? const EdgeInsets.all(16.0);

    return Container(
      height: effectiveHeight,
      margin: effectiveMargin,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _animationController.breathingAnimation,
            _animationController.nucleusAnimation,
            _animationController.membraneAnimation,
            _animationController.touchAnimation,
          ]),
          builder: (context, child) {
            return CustomPaint(
              painter: CellularPainter(
                cells: _cells,
                sharedWalls: _sharedWalls,
                breathingPhase: _animationController.breathingAnimation.value,
                nucleusPulse: _animationController.nucleusAnimation.value,
                membraneLuminosity:
                    _animationController.membraneAnimation.value,
                cellColors: widget.customColors ?? {},
              ),
              child: _buildCellContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCellContent() {
    return Stack(
      children: _cells.map((cell) => _buildCellWidget(cell)).toList(),
    );
  }

  Widget _buildCellWidget(CellPath cell) {
    final isTouched = _touchedCellId == cell.id;
    final touchScale =
        isTouched ? _animationController.touchAnimation.value : 1.0;

    return Positioned(
      left: cell.center.dx - cell.size.width / 2,
      top: cell.center.dy - cell.size.height / 2,
      child: Transform.scale(
        scale: touchScale,
        child: GestureDetector(
          onTap: () => _handleCellTap(cell.id),
          child: SizedBox(
            width: cell.size.width,
            height: cell.size.height,
            child: _buildCellContentWidget(cell),
          ),
        ),
      ),
    );
  }

  Widget _buildCellContentWidget(CellPath cell) {
    switch (cell.cellType) {
      case CellType.nucleus:
        return _buildNucleusContent(cell);
      case CellType.weather:
        return _buildWeatherContent(cell);
      case CellType.soilTemp:
        return _buildSoilTempContent(cell);
      case CellType.forecast:
        return _buildForecastContent(cell);
      case CellType.alerts:
        return _buildAlertsContent(cell);
    }
  }

  Widget _buildNucleusContent(CellPath cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.opacity,
            size: 24,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 4),
          const Text(
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

  Widget _buildWeatherContent(CellPath cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny,
            size: 20,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 4),
          const Text(
            '14Â° / 7Â°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Aujourd\'hui',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTempContent(CellPath cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.thermostat,
            size: 18,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 2),
          const Text(
            '10.4Â°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'sol',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastContent(CellPath cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ðŸ“ˆ',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 2),
          Text(
            'Prévisions',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsContent(CellPath cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 2),
          const Text(
            '2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Alertes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    final touchPoint = details.localPosition;
    final cellId =
        CellularInteractions.detectCellFromTouch(touchPoint, _cellPaths);

    if (cellId != null) {
      setState(() {
        _touchedCellId = cellId;
      });

      // Trigger touch animation
      _animationController.triggerTouchResponse();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _clearTouchState();
  }

  void _handleTapCancel() {
    _clearTouchState();
  }

  void _clearTouchState() {
    setState(() {
      _touchedCellId = null;
    });
  }

  void _handleCellTap(String cellId) {
    if (widget.onCellTap != null) {
      widget.onCellTap!(cellId);
    }
  }
}

/// Default data hierarchy for cellular rosace
class DefaultCellularData {
  static const Map<String, double> hierarchy = {
    'ph_core': 1.0, // Central nucleus - highest importance
    'weather_current': 0.9, // Weather data - high importance
    'soil_temp': 0.7, // Soil temperature - medium-high importance
    'weather_forecast': 0.6, // Forecast - medium importance
    'alerts': 0.5, // Alerts - medium importance
  };
}

/// Cellular Rosace Screen for testing
class CellularRosaceScreen extends StatelessWidget {
  const CellularRosaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cellular Rosace V3'),
        backgroundColor: const Color(0xFF1B4332),
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'V3: Living Cellular Tissue\n(unified membrane structure with shared boundaries)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E7D32),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CellularRosaceWidget(
                dataHierarchy: DefaultCellularData.hierarchy,
                onCellTap: (cellId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tapped: $cellId')),
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cellular Architecture:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Nucleus (center): pH core - pulsating\n'
                      '• Weather (top): Current conditions - largest cell\n'
                      '• Soil (left): Temperature - medium cell\n'
                      '• Forecast (right): Weather forecast - medium cell\n'
                      '• Alerts (bottom): Climate alerts - compact cell',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF558B2F),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Features:\n'
                      'âœ“ Unified cellular tissue (no floating elements)\n'
                      'âœ“ Shared membrane boundaries\n'
                      'âœ“ Organic pressure variations\n'
                      'âœ“ Living breathing animations\n'
                      'âœ“ Pulsating nucleus\n'
                      'âœ“ Organic touch responses\n'
                      'âœ“ Irregular cell shapes with natural boundaries',
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
