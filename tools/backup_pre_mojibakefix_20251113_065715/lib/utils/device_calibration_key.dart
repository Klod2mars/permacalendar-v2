ï»¿// lib/core/utils/device_calibration_key.dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';

/// Returns a stable key for calibration storage, encoding device model, screen size, DPR and orientation.
Future<String> deviceCalibrationKey(BuildContext context) async {
  final deviceInfo = DeviceInfoPlugin();
  String model = 'unknown_device';
  try {
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      model = (info.model ?? '${info.manufacturer}_${info.product}')!;
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      model = (info.utsname.machine ?? info.name) ?? 'ios_device';
    }
  } catch (_) {
    // fallback to platform
    model = Platform.operatingSystem;
  }
  final size = MediaQuery.of(context).size;
  final ratio = WidgetsBinding.instance.window.devicePixelRatio;
  final orientation = size.width > size.height ? 'landscape' : 'portrait';
  final safeModel = model.replaceAll(RegExp(r'\s+'), '_').toLowerCase();
  return 'calib_${safeModel}_${size.width.toInt()}x${size.height.toInt()}@${ratio}_$orientation';
}


