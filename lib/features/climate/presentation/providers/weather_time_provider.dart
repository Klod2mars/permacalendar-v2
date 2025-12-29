import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stocke l'offset temporel (en heures) appliqué par le glisser météo.
/// 0.0 = Temps réel (Présent).
/// > 0.0 = Futur (Projection).
///
/// Cette valeur est pilotée par `WeatherBioContainer` (le "driver")
/// et écoutée par `WeatherSkyBackground` (le "renderer").
///
/// Migration vers Notifier (Riverpod 2.0/3.0) car StateNotifier est deprecated/removed.
class WeatherTimeOffsetNotifier extends Notifier<double> {
  @override
  double build() {
    return 0.0;
  }

  void setOffset(double hours) {
    if (state != hours) {
      state = hours;
    }
  }
}

final weatherTimeOffsetProvider = NotifierProvider<WeatherTimeOffsetNotifier, double>(() {
  return WeatherTimeOffsetNotifier();
});
