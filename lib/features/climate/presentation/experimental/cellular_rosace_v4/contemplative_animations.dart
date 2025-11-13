ï»¿import 'dart:math' as math;
import 'package:flutter/material.dart';

/// V4 Contemplative Animations System
///
/// Provides subtle, meditative animations that enhance the contemplative quality:
/// - Nucleus: Subtle breathing (not pulsation)
/// - Membrane luminosity waves (ultra-subtle)
/// - Organic touch response with membrane ripple
/// - Contemplative timing (slow, meditative pace)
class ContemplativeAnimations {
  // ==================== NUCLEUS BREATHING ====================

  /// Create subtle nucleus breathing animation
  static AnimationController createNucleusBreathing({
    required TickerProvider vsync,
    Duration? duration,
  }) {
    return AnimationController(
      duration: duration ?? const Duration(seconds: 5), // Slow, meditative
      vsync: vsync,
    )..repeat();
  }

  /// Create nucleus breathing scale animation
  static Animation<double> createNucleusBreathingScale({
    required AnimationController controller,
    double minScale = 0.98,
    double maxScale = 1.02,
  }) {
    return Tween<double>(
      begin: minScale,
      end: maxScale,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Create nucleus breathing opacity animation
  static Animation<double> createNucleusBreathingOpacity({
    required AnimationController controller,
    double minOpacity = 0.15,
    double maxOpacity = 0.25,
  }) {
    return Tween<double>(
      begin: minOpacity,
      end: maxOpacity,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // ==================== MEMBRANE LUMINOSITY WAVES ====================

  /// Create membrane luminosity wave animation
  static AnimationController createMembraneLuminosity({
    required TickerProvider vsync,
    Duration? duration,
  }) {
    return AnimationController(
      duration: duration ?? const Duration(seconds: 8), // Very slow waves
      vsync: vsync,
    )..repeat();
  }

  /// Create membrane luminosity intensity animation
  static Animation<double> createMembraneLuminosityIntensity({
    required AnimationController controller,
    double minIntensity = 0.1,
    double maxIntensity = 0.3,
  }) {
    return Tween<double>(
      begin: minIntensity,
      end: maxIntensity,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Create membrane wave phase animation
  static Animation<double> createMembraneWavePhase({
    required AnimationController controller,
    double waveSpeed = 0.5,
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

  // ==================== ORGANIC TOUCH RESPONSE ====================

  /// Create organic touch response animation
  static AnimationController createTouchResponse({
    required TickerProvider vsync,
    Duration? duration,
  }) {
    return AnimationController(
      duration: duration ?? const Duration(milliseconds: 400),
      vsync: vsync,
    );
  }

  /// Create membrane ripple animation
  static Animation<double> createMembraneRipple({
    required AnimationController controller,
    double maxRadius = 30.0,
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

  /// Create organic touch scale animation
  static Animation<double> createOrganicTouchScale({
    required AnimationController controller,
    double scaleAmount = 0.05,
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

  /// Create touch glow animation
  static Animation<double> createTouchGlow({
    required AnimationController controller,
    double maxIntensity = 0.4,
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

  // ==================== CONTEMPLATIVE TIMING ====================

  /// Create contemplative breathing animation (very slow)
  static AnimationController createContemplativeBreathing({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(seconds: 6), // Very slow, meditative
      vsync: vsync,
    )..repeat();
  }

  /// Create contemplative breathing scale
  static Animation<double> createContemplativeBreathingScale({
    required AnimationController controller,
  }) {
    return Tween<double>(
      begin: 0.995,
      end: 1.005,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  /// Create contemplative breathing opacity
  static Animation<double> createContemplativeBreathingOpacity({
    required AnimationController controller,
  }) {
    return Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // ==================== SEASONAL RHYTHMS ====================

  /// Create seasonal rhythm animation
  static AnimationController createSeasonalRhythm({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(minutes: 2), // Very slow seasonal rhythm
      vsync: vsync,
    )..repeat();
  }

  /// Create seasonal color variation
  static Animation<double> createSeasonalColorVariation({
    required AnimationController controller,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
  }

  // ==================== PRESSURE WAVES ====================

  /// Create pressure wave animation
  static AnimationController createPressureWave({
    required TickerProvider vsync,
  }) {
    return AnimationController(
      duration: const Duration(seconds: 4),
      vsync: vsync,
    )..repeat();
  }

  /// Create pressure wave intensity
  static Animation<double> createPressureWaveIntensity({
    required AnimationController controller,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }
}

/// V4 Contemplative Animation Controller
///
/// Manages all contemplative animations with organic timing and subtle effects
class ContemplativeAnimationController {
  late AnimationController _nucleusBreathingController;
  late AnimationController _membraneLuminosityController;
  late AnimationController _touchResponseController;
  late AnimationController _contemplativeBreathingController;
  late AnimationController _seasonalRhythmController;
  late AnimationController _pressureWaveController;

  late Animation<double> _nucleusBreathingScale;
  late Animation<double> _nucleusBreathingOpacity;
  late Animation<double> _membraneLuminosityIntensity;
  late Animation<double> _membraneWavePhase;
  late Animation<double> _touchRipple;
  late Animation<double> _touchScale;
  late Animation<double> _touchGlow;
  late Animation<double> _contemplativeBreathingScale;
  late Animation<double> _contemplativeBreathingOpacity;
  late Animation<double> _seasonalColorVariation;
  late Animation<double> _pressureWaveIntensity;

  final TickerProvider vsync;

  ContemplativeAnimationController({required this.vsync}) {
    _initializeControllers();
  }

  void _initializeControllers() {
    // Nucleus breathing (subtle, slow)
    _nucleusBreathingController =
        ContemplativeAnimations.createNucleusBreathing(
      vsync: vsync,
      duration: const Duration(seconds: 5),
    );

    _nucleusBreathingScale =
        ContemplativeAnimations.createNucleusBreathingScale(
      controller: _nucleusBreathingController,
      minScale: 0.98,
      maxScale: 1.02,
    );

    _nucleusBreathingOpacity =
        ContemplativeAnimations.createNucleusBreathingOpacity(
      controller: _nucleusBreathingController,
      minOpacity: 0.15,
      maxOpacity: 0.25,
    );

    // Membrane luminosity (ultra-subtle waves)
    _membraneLuminosityController =
        ContemplativeAnimations.createMembraneLuminosity(
      vsync: vsync,
      duration: const Duration(seconds: 8),
    );

    _membraneLuminosityIntensity =
        ContemplativeAnimations.createMembraneLuminosityIntensity(
      controller: _membraneLuminosityController,
      minIntensity: 0.1,
      maxIntensity: 0.3,
    );

    _membraneWavePhase = ContemplativeAnimations.createMembraneWavePhase(
      controller: _membraneLuminosityController,
      waveSpeed: 0.5,
    );

    // Touch response (organic ripple)
    _touchResponseController = ContemplativeAnimations.createTouchResponse(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );

    _touchRipple = ContemplativeAnimations.createMembraneRipple(
      controller: _touchResponseController,
      maxRadius: 30.0,
    );

    _touchScale = ContemplativeAnimations.createOrganicTouchScale(
      controller: _touchResponseController,
      scaleAmount: 0.05,
    );

    _touchGlow = ContemplativeAnimations.createTouchGlow(
      controller: _touchResponseController,
      maxIntensity: 0.4,
    );

    // Contemplative breathing (very slow)
    _contemplativeBreathingController =
        ContemplativeAnimations.createContemplativeBreathing(
      vsync: vsync,
    );

    _contemplativeBreathingScale =
        ContemplativeAnimations.createContemplativeBreathingScale(
      controller: _contemplativeBreathingController,
    );

    _contemplativeBreathingOpacity =
        ContemplativeAnimations.createContemplativeBreathingOpacity(
      controller: _contemplativeBreathingController,
    );

    // Seasonal rhythm (very slow)
    _seasonalRhythmController = ContemplativeAnimations.createSeasonalRhythm(
      vsync: vsync,
    );

    _seasonalColorVariation =
        ContemplativeAnimations.createSeasonalColorVariation(
      controller: _seasonalRhythmController,
    );

    // Pressure waves
    _pressureWaveController = ContemplativeAnimations.createPressureWave(
      vsync: vsync,
    );

    _pressureWaveIntensity =
        ContemplativeAnimations.createPressureWaveIntensity(
      controller: _pressureWaveController,
    );
  }

  // ==================== GETTERS ====================

  /// Nucleus breathing animations
  Animation<double> get nucleusBreathingScale => _nucleusBreathingScale;
  Animation<double> get nucleusBreathingOpacity => _nucleusBreathingOpacity;

  /// Membrane luminosity animations
  Animation<double> get membraneLuminosityIntensity =>
      _membraneLuminosityIntensity;
  Animation<double> get membraneWavePhase => _membraneWavePhase;

  /// Touch response animations
  Animation<double> get touchRipple => _touchRipple;
  Animation<double> get touchScale => _touchScale;
  Animation<double> get touchGlow => _touchGlow;

  /// Contemplative breathing animations
  Animation<double> get contemplativeBreathingScale =>
      _contemplativeBreathingScale;
  Animation<double> get contemplativeBreathingOpacity =>
      _contemplativeBreathingOpacity;

  /// Seasonal rhythm animations
  Animation<double> get seasonalColorVariation => _seasonalColorVariation;

  /// Pressure wave animations
  Animation<double> get pressureWaveIntensity => _pressureWaveIntensity;

  // ==================== CONTROL METHODS ====================

  /// Trigger organic touch response
  void triggerTouchResponse() {
    _touchResponseController.forward().then((_) {
      _touchResponseController.reverse();
    });
  }

  /// Start all contemplative animations
  void startContemplativeAnimations() {
    _nucleusBreathingController.repeat();
    _membraneLuminosityController.repeat();
    _contemplativeBreathingController.repeat();
    _seasonalRhythmController.repeat();
    _pressureWaveController.repeat();
  }

  /// Stop all contemplative animations
  void stopContemplativeAnimations() {
    _nucleusBreathingController.stop();
    _membraneLuminosityController.stop();
    _contemplativeBreathingController.stop();
    _seasonalRhythmController.stop();
    _pressureWaveController.stop();
  }

  /// Pause all contemplative animations
  void pauseContemplativeAnimations() {
    _nucleusBreathingController.stop();
    _membraneLuminosityController.stop();
    _contemplativeBreathingController.stop();
    _seasonalRhythmController.stop();
    _pressureWaveController.stop();
  }

  /// Resume all contemplative animations
  void resumeContemplativeAnimations() {
    _nucleusBreathingController.repeat();
    _membraneLuminosityController.repeat();
    _contemplativeBreathingController.repeat();
    _seasonalRhythmController.repeat();
    _pressureWaveController.repeat();
  }

  // ==================== DISPOSE ====================

  void dispose() {
    _nucleusBreathingController.dispose();
    _membraneLuminosityController.dispose();
    _touchResponseController.dispose();
    _contemplativeBreathingController.dispose();
    _seasonalRhythmController.dispose();
    _pressureWaveController.dispose();
  }
}

/// V4 Animation Utilities
class ContemplativeAnimationUtils {
  /// Calculate organic animation phase
  static double calculateOrganicPhase(
      double time, double frequency, double phase) {
    return math.sin(time * frequency + phase);
  }

  /// Calculate membrane wave phase
  static double calculateMembraneWavePhase(
      double time, double waveSpeed, Offset position) {
    return math.sin(time * waveSpeed + position.dx * 0.01 + position.dy * 0.01);
  }

  /// Calculate pressure wave phase
  static double calculatePressureWavePhase(
      double time, double pressure, Offset position) {
    return math.sin(time * 2 + pressure * math.pi + position.dx * 0.02);
  }

  /// Calculate contemplative breathing phase
  static double calculateContemplativeBreathingPhase(double time) {
    return math.sin(time * 0.5) * 0.5 + 0.5; // Slow, gentle breathing
  }

  /// Calculate seasonal rhythm phase
  static double calculateSeasonalRhythmPhase(double time) {
    return math.sin(time * 0.1) * 0.3 + 0.7; // Very slow seasonal variation
  }

  /// Calculate organic touch response phase
  static double calculateTouchResponsePhase(double time, double intensity) {
    return math.sin(time * 10) *
        intensity *
        math.exp(-time * 3); // Damped oscillation
  }

  /// Calculate membrane ripple phase
  static double calculateMembraneRipplePhase(
      double time, double radius, double maxRadius) {
    final normalizedRadius = radius / maxRadius;
    return math.sin(time * 8) * (1.0 - normalizedRadius); // Ripple effect
  }
}


