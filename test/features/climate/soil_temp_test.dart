import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/climate/domain/usecases/compute_soil_temp_next_day_usecase.dart';

void main() {
  group('ComputeSoilTempNextDayUsecase', () {
    final usecase = ComputeSoilTempNextDayUsecase();

    test('should move soil temp towards air temp', () {
      const soil = 10.0;
      const air = 20.0;
      const alpha = 0.15;

      final next = usecase(soilTempC: soil, airTempC: air, alpha: alpha);

      // S(n+1) = 10 + 0.15 * (20 - 10) = 11.5
      expect(next, 11.5);
      expect(next > soil, true); // Warmer
      expect(next < air, true); // But not as hot as air (inertia)
    });

    test('should prevent abrupt changes (inertia)', () {
      const soil = 15.0;
      const air = 30.0; // Sudden heatwave
      const alpha = 0.15;

      final next = usecase(soilTempC: soil, airTempC: air, alpha: alpha);

      // Change = 15 * 0.15 = 2.25 degrees
      final change = next - soil;

      expect(change, 2.25);
      expect(change, lessThan(10.0)); // Much less than the air jump of 15
    });

    test('should simulate 7-day forecast with smoothing', () {
      double currentSoil = 10.0;
      final airTemps = [15.0, 18.0, 20.0, 22.0, 20.0, 18.0, 15.0];

      final soilTemps = <double>[currentSoil];

      for (final air in airTemps) {
        currentSoil =
            usecase(soilTempC: currentSoil, airTempC: air, alpha: 0.15);
        soilTemps.add(currentSoil);
      }

      // Verify it's smoother than air
      // Air range: 15-22 (7 degrees diff)
      // Soil check
      print('Soil Temps: $soilTemps');

      // Expect last temp to be higher than start
      expect(soilTemps.last > 10.0, true);

      // Verify no abrupt jumps > 5 degrees
      for (int i = 0; i < soilTemps.length - 1; i++) {
        final diff = (soilTemps[i + 1] - soilTemps[i]).abs();
        expect(diff, lessThan(3.0));
      }
    });

    test('daysToEquilibrium returns reasonable value', () {
      final days =
          usecase.daysToEquilibrium(soilTempC: 10, airTempC: 20, alpha: 0.15);

      // Should take some days to reach 95% of gap
      expect(days, greaterThan(5));
      expect(days, lessThan(30));
    });
  });
}
