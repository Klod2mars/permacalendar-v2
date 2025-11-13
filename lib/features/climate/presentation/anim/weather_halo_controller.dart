import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hourly_weather_provider.dart';
import '../providers/narrative_mode_provider.dart';
import '../utils/halo_color_maps.dart';

/// Lightweight controller for weather-driven halo color updates
/// Updates every 5 minutes and on data changes, respecting TickerMode
class WeatherHaloController extends ChangeNotifier {
  WeatherHaloController(this._ref) {
    _initialize();
  }

  final Ref _ref;
  Timer? _updateTimer;
  Color _currentHaloColor = Colors.transparent;
  bool _isDisposed = false;

  /// Current halo color
  Color get currentHaloColor => _currentHaloColor;

  /// Initialize the controller and start periodic updates
  void _initialize() {
    // Initial update
    _updateHaloColor();

    // Start periodic updates every 5 minutes
    _startPeriodicUpdates();

    // Listen to narrative mode changes
    _ref.listen(narrativeModeProvider, (previous, next) {
      if (!_isDisposed) {
        _updateHaloColor();
      }
    });

    // Listen to hourly weather changes
    _ref.listen(hourlyWeatherProvider, (previous, next) {
      if (!_isDisposed) {
        _updateHaloColor();
      }
    });
  }

  /// Start periodic updates with 5-minute intervals
  void _startPeriodicUpdates() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _updateHaloColor(),
    );
  }

  /// Update halo color based on current weather and narrative mode
  void _updateHaloColor() {
    if (_isDisposed) return;

    final narrativeMode = _ref.read(narrativeModeProvider);

    if (!narrativeMode) {
      // Narrative mode OFF - use static halo (Phase 3 fallback)
      _currentHaloColor = Colors.transparent;
      notifyListeners();
      return;
    }

    // Narrative mode ON - use dynamic halo
    final hourlyWeatherAsync = _ref.read(hourlyWeatherProvider);

    hourlyWeatherAsync.when(
      data: (snapshot) {
        final newColor = HaloColorMaps.getHaloColorFromSnapshot(snapshot);
        if (newColor != _currentHaloColor) {
          _currentHaloColor = newColor;
          notifyListeners();
        }
      },
      loading: () {
        // Keep current color while loading
      },
      error: (error, stackTrace) {
        // Fallback to transparent on error
        if (_currentHaloColor != Colors.transparent) {
          _currentHaloColor = Colors.transparent;
          notifyListeners();
        }
      },
    );
  }

  /// Force immediate update (useful for app resume)
  void forceUpdate() {
    _updateHaloColor();
  }

  /// Pause updates (when widget is not visible)
  void pause() {
    _updateTimer?.cancel();
  }

  /// Resume updates (when widget becomes visible)
  void resume() {
    _startPeriodicUpdates();
    _updateHaloColor(); // Immediate update on resume
  }

  @override
  void dispose() {
    _isDisposed = true;
    _updateTimer?.cancel();
    super.dispose();
  }
}

/// Provider for weather halo controller
final weatherHaloControllerProvider = Provider<WeatherHaloController>((ref) {
  return WeatherHaloController(ref);
});

/// Provider for current halo color with automatic updates
final weatherHaloColorProvider = Provider<Color>((ref) {
  final controller = ref.watch(weatherHaloControllerProvider);
  return controller.currentHaloColor;
});

/// Provider for halo color stream (for widgets that need to listen to changes)
final weatherHaloColorStreamProvider = StreamProvider<Color>((ref) {
  final controller = ref.watch(weatherHaloControllerProvider);

  final controllerStream = Stream.periodic(
    const Duration(minutes: 5),
    (_) => controller.currentHaloColor,
  );

  return controllerStream.distinct();
});

/// Widget that automatically manages halo controller lifecycle
class WeatherHaloControllerWidget extends ConsumerStatefulWidget {
  const WeatherHaloControllerWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<WeatherHaloControllerWidget> createState() =>
      _WeatherHaloControllerWidgetState();
}

class _WeatherHaloControllerWidgetState
    extends ConsumerState<WeatherHaloControllerWidget>
    with WidgetsBindingObserver {
  late WeatherHaloController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ref.read(weatherHaloControllerProvider);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _controller.resume();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _controller.pause();
        break;
      case AppLifecycleState.detached:
        _controller.dispose();
        break;
      case AppLifecycleState.hidden:
        // Keep running but reduce frequency
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Mixin for widgets that need to respond to halo color changes
mixin WeatherHaloMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Color? _lastHaloColor;

  /// Called when halo color changes
  void onHaloColorChanged(Color newColor) {
    // Override in implementing classes
  }

  @override
  void initState() {
    super.initState();
    _lastHaloColor = ref.read(weatherHaloColorProvider);
  }

  @override
  Widget build(BuildContext context) {
    final currentHaloColor = ref.watch(weatherHaloColorProvider);

    if (_lastHaloColor != currentHaloColor) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onHaloColorChanged(currentHaloColor);
      });
      _lastHaloColor = currentHaloColor;
    }

    return buildWithHalo(context, currentHaloColor);
  }

  /// Build method that receives current halo color
  Widget buildWithHalo(BuildContext context, Color haloColor);
}

/// Utility class for halo color transitions
class HaloColorTransition {
  HaloColorTransition._(); // Private constructor

  /// Create a smooth transition between two halo colors
  static Color lerpHaloColors(Color from, Color to, double t) {
    return Color.lerp(from, to, t.clamp(0.0, 1.0)) ?? from;
  }

  /// Get transition duration based on color difference
  static Duration getTransitionDuration(Color from, Color to) {
    final difference = _colorDifference(from, to);

    // Longer transitions for more dramatic color changes
    if (difference > 0.5) {
      return const Duration(milliseconds: 500);
    } else if (difference > 0.2) {
      return const Duration(milliseconds: 300);
    } else {
      return const Duration(milliseconds: 200);
    }
  }

  /// Calculate color difference (0.0 to 1.0)
  static double _colorDifference(Color a, Color b) {
    final aHsl = HSLColor.fromColor(a);
    final bHsl = HSLColor.fromColor(b);

    final hueDiff = (aHsl.hue - bHsl.hue).abs() / 360.0;
    final lightnessDiff = (aHsl.lightness - bHsl.lightness).abs();
    final saturationDiff = (aHsl.saturation - bHsl.saturation).abs();

    // Weighted average of differences
    return (hueDiff * 0.5 + lightnessDiff * 0.3 + saturationDiff * 0.2);
  }
}


