import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'unified_membrane_geometry.dart';
import 'unified_membrane_painter.dart';
import 'contemplative_animations.dart';
import 'morphological_pressure.dart';

/// V4 Unified Membrane Widget
///
/// The main widget that brings together all V4 components:
/// - Unified membrane geometry with shared walls
/// - Morphological pressure system
/// - Contemplative animations
/// - Organic touch responses
/// - Authentic plant tissue appearance
class UnifiedMembraneWidget extends ConsumerStatefulWidget {
  final Map<String, double> dataHierarchy;
  final Map<String, Color>? customColors;
  final Function(String cellId)? onCellTap;
  final double? height;
  final EdgeInsets? margin;
  final bool enableAnimations;
  final bool enableTouchResponse;

  const UnifiedMembraneWidget({
    super.key,
    required this.dataHierarchy,
    this.customColors,
    this.onCellTap,
    this.height,
    this.margin,
    this.enableAnimations = true,
    this.enableTouchResponse = true,
  });

  @override
  ConsumerState<UnifiedMembraneWidget> createState() =>
      _UnifiedMembraneWidgetState();
}

class _UnifiedMembraneWidgetState extends ConsumerState<UnifiedMembraneWidget>
    with TickerProviderStateMixin {
  late ContemplativeAnimationController _animationController;
  late CellularMembrane _membrane;

  String? _touchedCellId;

  @override
  void initState() {
    super.initState();
    _animationController = ContemplativeAnimationController(vsync: this);
    _initializeMembrane();

    if (widget.enableAnimations) {
      _animationController.startContemplativeAnimations();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeMembrane() {
    // Generate unified membrane with V4 hierarchy
    const canvasSize = Size(300, 300); // Default size, will be updated in build
    _membrane = UnifiedMembraneGeometry.generateUnifiedTissue(
      canvasSize: canvasSize,
      hierarchy: widget.dataHierarchy,
    );

    // Apply morphological pressure deformation
    final cellDataMap = {for (final cell in _membrane.cells) cell.id: cell};
    final deformedCellPaths =
        MorphologicalPressure.applyPressureDeformation(cellDataMap);
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
            _animationController.nucleusBreathingScale,
            _animationController.nucleusBreathingOpacity,
            _animationController.membraneLuminosityIntensity,
            _animationController.membraneWavePhase,
            _animationController.contemplativeBreathingScale,
            _animationController.contemplativeBreathingOpacity,
            _animationController.seasonalColorVariation,
            _animationController.pressureWaveIntensity,
          ]),
          builder: (context, child) {
            return CustomPaint(
              painter: UnifiedMembranePainter(
                membrane: _membrane,
                breathingPhase:
                    _animationController.contemplativeBreathingScale.value,
                nucleusPulse: _animationController.nucleusBreathingScale.value,
                membraneLuminosity:
                    _animationController.membraneLuminosityIntensity.value,
                contemplativeBreathing:
                    _animationController.contemplativeBreathingScale.value,
                seasonalRhythm:
                    _animationController.seasonalColorVariation.value,
                customColors: widget.customColors,
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
      children: _membrane.cells.map((cell) => _buildCellWidget(cell)).toList(),
    );
  }

  Widget _buildCellWidget(CellData cell) {
    final isTouched = _touchedCellId == cell.id;
    final touchScale = isTouched ? _animationController.touchScale.value : 1.0;

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

  Widget _buildCellContentWidget(CellData cell) {
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

  Widget _buildNucleusContent(CellData cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.opacity,
            size: 20,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 2),
          const Text(
            'pH 6.8',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(CellData cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wb_sunny,
            size: 24,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 4),
          const Text(
            '14° / 7°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Aujourd\'hui',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTempContent(CellData cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.thermostat,
            size: 20,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 2),
          const Text(
            '10.4°',
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

  Widget _buildForecastContent(CellData cell) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '📈',
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

  Widget _buildAlertsContent(CellData cell) {
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
    if (!widget.enableTouchResponse) return;

    final touchPoint = details.localPosition;
    final cellId = _detectCellFromTouch(touchPoint);

    if (cellId != null) {
      setState(() {
        _touchedCellId = cellId;
      });

      // Trigger touch response animation
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

  String? _detectCellFromTouch(Offset touchPoint) {
    for (final cell in _membrane.cells) {
      if (cell.path.contains(touchPoint)) {
        return cell.id;
      }
    }
    return null;
  }
}

/// V4 Default Data Hierarchy
class V4DefaultData {
  static const Map<String, double> hierarchy = {
    'weather_current': 1.0, // DOMINANT - daily orientation cell
    'soil_temp': 0.85, // STRATEGIC - frequently consulted
    'weather_forecast': 0.85, // STRATEGIC - planning information
    'alerts': 0.75, // CONDITIONAL - importance varies
    'ph_core': 0.35, // NUCLEUS - small but central presence
  };
}

/// V4 Unified Membrane Screen for testing
class UnifiedMembraneScreen extends StatelessWidget {
  const UnifiedMembraneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('V4 Unified Membrane System'),
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
                  'V4: Unified Cellular Membrane System\n(authentic plant tissue with shared boundaries)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2E7D32),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              UnifiedMembraneWidget(
                dataHierarchy: V4DefaultData.hierarchy,
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
                      'V4 Membrane Architecture:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Weather (top-center): DOMINANT cell - 40% larger\n'
                      '• Soil + Forecast (flanking): STRATEGIC cells - normal size\n'
                      '• Alerts (bottom): CONDITIONAL cell - smaller\n'
                      '• pH (center): NUCLEUS - subtle presence, minimal size',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF558B2F),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'V4 Features:\n'
                      '✓ Unified tissue appearance (no floating elements)\n'
                      '✓ Shared membrane boundaries (visible structural elements)\n'
                      '✓ Morphological pressure (cells deform each other)\n'
                      '✓ Functional hierarchy (weather dominance, pH subtlety)\n'
                      '✓ Contemplative quality (subtle breathing, not flashy)\n'
                      '✓ Organic touch response (membrane ripple)\n'
                      '✓ Authentic plant tissue appearance',
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
