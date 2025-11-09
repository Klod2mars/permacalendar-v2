
import '../../../../test_setup_stub.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/features/climate/presentation/utils/day_phase_blend.dart';
import 'package:permacalendar/features/climate/presentation/providers/hourly_weather_provider.dart';

void main() {
  group('DayPhaseBlend', () {
    group('isDawn', () {
      test('returns true for dawn hours with fixed times', () {
        expect(DayPhaseBlend.isDawn(DateTime(2024, 1, 1, 6)), isTrue);
        expect(DayPhaseBlend.isDawn(DateTime(2024, 1, 1, 7)), isTrue);
        expect(DayPhaseBlend.isDawn(DateTime(2024, 1, 1, 8)), isTrue);
      });

      test('returns false for non-dawn hours', () {
        expect(DayPhaseBlend.isDawn(DateTime(2024, 1, 1, 12)), isFalse);
        expect(DayPhaseBlend.isDawn(DateTime(2024, 1, 1, 2)), isFalse);
      });

      test('returns true for dawn hours with sun times', () {
        final sunrise = DateTime(2024, 1, 1, 7);
        final sunset = DateTime(2024, 1, 1, 19);

        expect(
          DayPhaseBlend.isDawn(
            DateTime(2024, 1, 1, 7), // Sunrise
            sunrise: sunrise,
            sunset: sunset,
          ),
          isTrue,
        );
      });
    });

    group('isDay', () {
      test('returns true for day hours with fixed times', () {
        expect(DayPhaseBlend.isDay(DateTime(2024, 1, 1, 9)), isTrue);
        expect(DayPhaseBlend.isDay(DateTime(2024, 1, 1, 12)), isTrue);
        expect(DayPhaseBlend.isDay(DateTime(2024, 1, 1, 16)), isTrue);
      });

      test('returns false for non-day hours', () {
        expect(DayPhaseBlend.isDay(DateTime(2024, 1, 1, 6)), isFalse);
        expect(DayPhaseBlend.isDay(DateTime(2024, 1, 1, 20)), isFalse);
      });
    });

    group('isDusk', () {
      test('returns true for dusk hours with fixed times', () {
        expect(DayPhaseBlend.isDusk(DateTime(2024, 1, 1, 17)), isTrue);
        expect(DayPhaseBlend.isDusk(DateTime(2024, 1, 1, 19)), isTrue);
        expect(DayPhaseBlend.isDusk(DateTime(2024, 1, 1, 20)), isTrue);
      });

      test('returns false for non-dusk hours', () {
        expect(DayPhaseBlend.isDusk(DateTime(2024, 1, 1, 12)), isFalse);
        expect(DayPhaseBlend.isDusk(DateTime(2024, 1, 1, 2)), isFalse);
      });
    });

    group('isNight', () {
      test('returns true for night hours with fixed times', () {
        expect(DayPhaseBlend.isNight(DateTime(2024, 1, 1, 21)), isTrue);
        expect(DayPhaseBlend.isNight(DateTime(2024, 1, 1, 23)), isTrue);
        expect(DayPhaseBlend.isNight(DateTime(2024, 1, 1, 2)), isTrue);
        expect(DayPhaseBlend.isNight(DateTime(2024, 1, 1, 5)), isTrue);
      });

      test('returns false for non-night hours', () {
        expect(DayPhaseBlend.isNight(DateTime(2024, 1, 1, 12)), isFalse);
        expect(DayPhaseBlend.isNight(DateTime(2024, 1, 1, 7)), isFalse);
      });
    });

    group('getCurrentPhase', () {
      test('returns correct phases for different hours', () {
        expect(
          DayPhaseBlend.getCurrentPhase(DateTime(2024, 1, 1, 6)),
          equals(DayPhase.dawn),
        );
        expect(
          DayPhaseBlend.getCurrentPhase(DateTime(2024, 1, 1, 12)),
          equals(DayPhase.day),
        );
        expect(
          DayPhaseBlend.getCurrentPhase(DateTime(2024, 1, 1, 18)),
          equals(DayPhase.dusk),
        );
        expect(
          DayPhaseBlend.getCurrentPhase(DateTime(2024, 1, 1, 23)),
          equals(DayPhase.night),
        );
      });
    });

    group('getPhaseProgress', () {
      test('returns progress within dawn phase', () {
        final progress =
            DayPhaseBlend.getPhaseProgress(DateTime(2024, 1, 1, 6, 30));

        expect(progress, greaterThan(0.0));
        expect(progress, lessThan(1.0));
      });

      test('returns mid-day progress', () {
        final progress =
            DayPhaseBlend.getPhaseProgress(DateTime(2024, 1, 1, 12));

        // Day phase is 9-17 (8 hours), so 12 PM is 3 hours in = 3/8 = 0.375
        expect(progress, equals(0.375));
      });

      test('returns 0.0 for night phase', () {
        final progress =
            DayPhaseBlend.getPhaseProgress(DateTime(2024, 1, 1, 2));

        expect(progress, equals(0.0));
      });
    });

    group('applyEasing', () {
      test('applies easing curve correctly', () {
        final eased = DayPhaseBlend.applyEasing(0.5, Curves.easeInOut);

        expect(eased, greaterThan(0.0));
        expect(eased, lessThan(1.0));
      });

      test('clamps values to 0.0-1.0 range', () {
        expect(DayPhaseBlend.applyEasing(-0.5, Curves.easeInOut), equals(0.0));
        expect(DayPhaseBlend.applyEasing(1.5, Curves.easeInOut), equals(1.0));
      });
    });

    group('lerpWithPhase', () {
      test('interpolates between values based on phase progress', () {
        final result = DayPhaseBlend.lerpWithPhase(
          0.0,
          1.0,
          DateTime(2024, 1, 1, 12), // Mid-day
        );

        expect(result, greaterThan(0.0));
        expect(result, lessThan(1.0));
      });

      test('uses custom curve when provided', () {
        final result = DayPhaseBlend.lerpWithPhase(
          0.0,
          1.0,
          DateTime(2024, 1, 1, 12),
          curve: Curves.linear,
        );

        expect(result, greaterThan(0.0));
        expect(result, lessThan(1.0));
      });
    });

    group('lerpColorWithPhase', () {
      test('interpolates between colors based on phase progress', () {
        const startColor = Colors.red;
        const endColor = Colors.blue;

        final result = DayPhaseBlend.lerpColorWithPhase(
          startColor,
          endColor,
          DateTime(2024, 1, 1, 12), // Mid-day
        );

        expect(result, isA<Color>());
        expect(result, isNot(equals(startColor)));
        expect(result, isNot(equals(endColor)));
      });
    });

    group('getPhaseDescription', () {
      test('returns descriptive string for current phase', () {
        final description =
            DayPhaseBlend.getPhaseDescription(DateTime(2024, 1, 1, 12));

        expect(description, contains('day'));
        expect(description, contains('%'));
      });
    });

    group('getTimeToNextPhase', () {
      test('returns positive duration for time to next phase', () {
        final duration =
            DayPhaseBlend.getTimeToNextPhase(DateTime(2024, 1, 1, 12));

        expect(duration, isA<Duration>());
        expect(duration.inMinutes, greaterThan(0));
      });

      test('handles day phase transitions correctly', () {
        // Dawn to day transition
        final dawnDuration =
            DayPhaseBlend.getTimeToNextPhase(DateTime(2024, 1, 1, 7));
        expect(dawnDuration.inHours, equals(2)); // 7 AM to 9 AM

        // Day to dusk transition
        final dayDuration =
            DayPhaseBlend.getTimeToNextPhase(DateTime(2024, 1, 1, 12));
        expect(dayDuration.inHours, equals(5)); // 12 PM to 5 PM
      });
    });
  });
}

