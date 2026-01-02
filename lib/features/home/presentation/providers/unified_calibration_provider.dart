import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CalibrationTool {
  none,   // Mode normal, pas d'outil actif (ou vue d'ensemble)
  image,  // Calibration de l'image de fond (zoom, pan)
  sky,    // Calibration de l'ovoïde ciel (jour/nuit)
  modules // Calibration du placement des modules/hotspots
}

class UnifiedCalibrationState {
  final CalibrationTool activeTool;
  
  const UnifiedCalibrationState({
    this.activeTool = CalibrationTool.image, // Par défaut on commence sur l'image
  });

  UnifiedCalibrationState copyWith({
    CalibrationTool? activeTool,
  }) {
    return UnifiedCalibrationState(
      activeTool: activeTool ?? this.activeTool,
    );
  }
}

class UnifiedCalibrationNotifier extends Notifier<UnifiedCalibrationState> {
  @override
  UnifiedCalibrationState build() {
    return const UnifiedCalibrationState();
  }

  void setTool(CalibrationTool tool) {
    state = state.copyWith(activeTool: tool);
  }
}

final unifiedCalibrationProvider = 
    NotifierProvider<UnifiedCalibrationNotifier, UnifiedCalibrationState>(
        UnifiedCalibrationNotifier.new);
