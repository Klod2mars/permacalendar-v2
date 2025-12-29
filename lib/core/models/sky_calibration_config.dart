import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sky_calibration_config.freezed.dart';
part 'sky_calibration_config.g.dart';

/// Configuration de l'ovoïde du ciel.
/// Coordonnées normalisées (0.0 -> 1.0) par rapport à la taille du conteneur parent.
@freezed
@HiveType(typeId: 44) // ID unique arbitraire (check conflict)
class SkyCalibrationConfig with _$SkyCalibrationConfig {
  const factory SkyCalibrationConfig({
    @HiveField(0) @Default(0.5) double cx, // Centre X
    @HiveField(1) @Default(0.35) double cy, // Centre Y
    @HiveField(2) @Default(0.4) double rx, // Rayon X
    @HiveField(3) @Default(0.3) double ry, // Rayon Y
    @HiveField(4) @Default(0.0) double rotation, // Rotation en radians
  }) = _SkyCalibrationConfig;

  factory SkyCalibrationConfig.fromJson(Map<String, dynamic> json) =>
      _$SkyCalibrationConfigFromJson(json);
}

class SkyCalibrationRepository {
  static const String _boxName = 'sky_calibration_v1';
  static const String _key = 'current_config';

  static Future<void> init() async {
     // Register adapter handled by source gen usually, but manual check if needed
     // Hive.registerAdapter(SkyCalibrationConfigAdapter()); 
     // We assume generated adapter will be registered in main or we register it here if we can instantiate it.
     // For now, let's assume auto-generated adapter file is included in main setup.
  }
  
  static Future<void> save(SkyCalibrationConfig config) async {
    final box = await Hive.openBox<SkyCalibrationConfig>(_boxName);
    await box.put(_key, config);
  }

  static Future<SkyCalibrationConfig?> load() async {
    if (!Hive.isBoxOpen(_boxName)) {
       await Hive.openBox<SkyCalibrationConfig>(_boxName);
    }
    final box = Hive.box<SkyCalibrationConfig>(_boxName);
    return box.get(_key);
  }
}

class SkyCalibrationNotifier extends Notifier<SkyCalibrationConfig> {
  @override
  SkyCalibrationConfig build() {
    _load();
    return const SkyCalibrationConfig();
  }

  Future<void> _load() async {
    final saved = await SkyCalibrationRepository.load();
    if (saved != null) {
      state = saved;
    }
  }

  void update(SkyCalibrationConfig config) {
    state = config;
    SkyCalibrationRepository.save(config);
  }
  
  void updatePartial({double? cx, double? cy, double? rx, double? ry, double? rotation}) {
     final newState = state.copyWith(
       cx: cx ?? state.cx,
       cy: cy ?? state.cy,
       rx: rx ?? state.rx,
       ry: ry ?? state.ry,
       rotation: rotation ?? state.rotation,
     );
     update(newState);
  }
}

final skyCalibrationProvider = NotifierProvider<SkyCalibrationNotifier, SkyCalibrationConfig>(() {
  return SkyCalibrationNotifier();
});
