// test/core/services/recurrence_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:permacalendar/core/services/recurrence_service.dart';

void main() {
  group('RecurrenceService', () {
    test('interval recurrence calculates correct next date', () {
      final fromDate = DateTime.utc(2025, 1, 1);
      final recurrence = {'type': 'interval', 'every': 3}; // Every 3 days

      final next = RecurrenceService.computeNextRunDate(recurrence, fromDate);
      expect(next, DateTime.utc(2025, 1, 4));
    });

    test('weekly recurrence - next occurrence in same week', () {
      final fromDate = DateTime.utc(2025, 1, 1); // Wednesday
      // Recurrence: Monday (1) and Friday (5)
      final recurrence = {'type': 'weekly', 'days': [1, 5]};

      // Expect Friday (Jan 3rd)
      final next = RecurrenceService.computeNextRunDate(recurrence, fromDate);
      expect(next, DateTime.utc(2025, 1, 3));
    });

    test('weekly recurrence - next occurrence in next week', () {
      final fromDate = DateTime.utc(2025, 1, 3); // Friday
      // Recurrence: Monday (1) and Friday (5)
      final recurrence = {'type': 'weekly', 'days': [1, 5]};

      // Expect Monday next week (Jan 6th)
      final next = RecurrenceService.computeNextRunDate(recurrence, fromDate);
      expect(next, DateTime.utc(2025, 1, 6));
    });

    test('monthlyByDay recurrence - simple case', () {
      final fromDate = DateTime.utc(2025, 1, 15);
      final recurrence = {'type': 'monthlyByDay', 'day': 15};

      final next = RecurrenceService.computeNextRunDate(recurrence, fromDate);
      expect(next, DateTime.utc(2025, 2, 15));
    });

    test('monthlyByDay recurrence - clamping (Feb 31 -> Feb 28)', () {
      final fromDate = DateTime.utc(2025, 1, 31);
      final recurrence = {'type': 'monthlyByDay', 'day': 31};

      final next = RecurrenceService.computeNextRunDate(recurrence, fromDate);
      expect(next, DateTime.utc(2025, 2, 28)); // 2025 is not leap year
    });
    
    test('monthlyByDay recurrence - year wrap', () {
      final fromDate = DateTime.utc(2025, 12, 15);
      final recurrence = {'type': 'monthlyByDay', 'day': 15};

      final next = RecurrenceService.computeNextRunDate(recurrence, fromDate);
      expect(next, DateTime.utc(2026, 1, 15));
    });

    test('computeOccurrences generates list', () {
      final fromDate = DateTime.utc(2025, 1, 1);
      final recurrence = {'type': 'interval', 'every': 1};

      final dates = RecurrenceService.computeOccurrences(recurrence, fromDate, 3);
      expect(dates.length, 3);
      expect(dates[0], DateTime.utc(2025, 1, 2));
      expect(dates[1], DateTime.utc(2025, 1, 3));
      expect(dates[2], DateTime.utc(2025, 1, 4));
    });
  });
}
