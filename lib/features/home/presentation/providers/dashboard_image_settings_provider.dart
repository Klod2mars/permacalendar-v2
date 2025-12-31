import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for SharedPreferences
const String _keyAlignX = 'organic_dashboard_image_align_x';
const String _keyAlignY = 'organic_dashboard_image_align_y';
const String _keyZoom = 'organic_dashboard_image_zoom';

// Default values
const double _defaultAlignX = -0.15;
const double _defaultAlignY = -0.03;
const double _defaultZoom = 1.18;

@immutable
class DashboardImageSettings {
  final double alignX;
  final double alignY;
  final double zoom;

  const DashboardImageSettings({
    this.alignX = _defaultAlignX,
    this.alignY = _defaultAlignY,
    this.zoom = _defaultZoom,
  });

  DashboardImageSettings copyWith({
    double? alignX,
    double? alignY,
    double? zoom,
  }) {
    return DashboardImageSettings(
      alignX: alignX ?? this.alignX,
      alignY: alignY ?? this.alignY,
      zoom: zoom ?? this.zoom,
    );
  }
}

class DashboardImageSettingsNotifier extends Notifier<DashboardImageSettings> {
  @override
  DashboardImageSettings build() {
    // Start loading async, but return defaults immediately
    _load();
    return const DashboardImageSettings();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble(_keyAlignX) ?? _defaultAlignX;
    final y = prefs.getDouble(_keyAlignY) ?? _defaultAlignY;
    final z = prefs.getDouble(_keyZoom) ?? _defaultZoom;

    state = DashboardImageSettings(alignX: x, alignY: y, zoom: z);
  }

  Future<void> setAlignX(double value) async {
    state = state.copyWith(alignX: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyAlignX, value);
  }

  Future<void> setAlignY(double value) async {
    state = state.copyWith(alignY: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyAlignY, value);
  }

  Future<void> setZoom(double value) async {
    state = state.copyWith(zoom: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyZoom, value);
  }
  
  /// Reset to defaults
  Future<void> reset() async {
    state = const DashboardImageSettings();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAlignX);
    await prefs.remove(_keyAlignY);
    await prefs.remove(_keyZoom);
  }
}

final dashboardImageSettingsProvider =
    NotifierProvider<DashboardImageSettingsNotifier, DashboardImageSettings>(
        DashboardImageSettingsNotifier.new);
