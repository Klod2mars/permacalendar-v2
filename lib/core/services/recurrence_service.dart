import 'package:flutter/foundation.dart';

class RecurrenceService {
  /// Calcule la prochaine date d'exécution basée sur la configuration de récurrence.
  /// Retourne null si aucune récurrence n'est configurée.
  /// [recurrence] map contenant: type, every, days, day
  /// [fromDate] date de référence (dernière exécution ou date de création)
  static DateTime? computeNextRunDate(
      Map<String, dynamic>? recurrence, DateTime fromDate) {
    if (recurrence == null || recurrence.isEmpty) {
      return null;
    }

    final type = recurrence['type'] as String?;
    if (type == null) return null;

    final utcFromDate = fromDate.toUtc();
    DateTime nextDate;

    switch (type) {
      case 'interval':
        final every = recurrence['every'] as int? ?? 1;
        nextDate = utcFromDate.add(Duration(days: every));
        break;

      case 'weekly':
        final days = (recurrence['days'] as List<dynamic>?)?.cast<int>() ?? [];
        if (days.isEmpty) return null;
        
        // Trier les jours pour être sûr
        days.sort();
        
        // Chercher le prochain jour dans la semaine en cours
        // 1 = Lundi, 7 = Dimanche
        int currentDay = utcFromDate.weekday;
        
        // Trouver le prochain jour valide dans la liste qui est > currentDay
        // Ou si aucun, prendre le premier de la liste pour la semaine prochaine
        int? nextDay = days.firstWhere((d) => d > currentDay, orElse: () => -1);
        
        if (nextDay != -1) {
          // C'est cette semaine
          final daysToAdd = nextDay - currentDay;
          nextDate = utcFromDate.add(Duration(days: daysToAdd));
        } else {
          // C'est la semaine prochaine, premier jour dispo
          final firstDay = days.first;
          final daysUntilEndOfWeek = 7 - currentDay;
          final daysToAdd = daysUntilEndOfWeek + firstDay;
          nextDate = utcFromDate.add(Duration(days: daysToAdd));
        }
        break;

      case 'monthlyByDay':
        final day = recurrence['day'] as int? ?? 1;
        // Mois suivant
        var nextMonth = utcFromDate.month + 1;
        var nextYear = utcFromDate.year;
        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear++;
        }
        
        // Clamp du jour si le mois suivant a moins de jours
        final daysInNextMonth = _getDaysInMonth(nextYear, nextMonth);
        final actualDay = day > daysInNextMonth ? daysInNextMonth : day;
        
        nextDate = DateTime.utc(nextYear, nextMonth, actualDay);
        
        // Si la date calculée est avant ou égale à fromDate (cas limite ou erreur), on avance d'un mois encore
        if (!nextDate.isAfter(utcFromDate)) {
           nextMonth++;
           if (nextMonth > 12) {
             nextMonth = 1;
             nextYear++;
           }
           final daysInNext2Month = _getDaysInMonth(nextYear, nextMonth);
           final actualDay2 = day > daysInNext2Month ? daysInNext2Month : day;
           nextDate = DateTime.utc(nextYear, nextMonth, actualDay2);
        }
        break;

      default:
        return null;
    }

    // Garder l'heure/minute/seconde de la date originale ou normaliser à minuit ?
    // Spécification: "Accept UTC and robust parsing" -> on préserve l'heure pour l'instant
    // ou on aligne sur le début de journée si souhaité. Pour les tâches, souvent on veut juste "le jour".
    // Mais gardons l'heure de création pour l'instant.
    return nextDate;
  }

  /// Calcule une liste d'occurrences futures (utile pour l'affichage calendrier)
  static List<DateTime> computeOccurrences(
      Map<String, dynamic> recurrence, DateTime fromDate, int count) {
    List<DateTime> occurrences = [];
    DateTime currentDate = fromDate;

    for (int i = 0; i < count; i++) {
      final next = computeNextRunDate(recurrence, currentDate);
      if (next == null) break;
      occurrences.add(next);
      currentDate = next;
    }

    return occurrences;
  }

  static int _getDaysInMonth(int year, int month) {
    if (month == 12) return 31;
    return DateTime(year, month + 1, 0).day;
  }
}
