import 'package:intl/intl.dart';

/// Utilitaires pour la gestion des dates
class AppDateUtils {
  // Formatters de date
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _dayMonthYearTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'fr_FR');
  static final DateFormat _dayMonth = DateFormat('dd MMMM', 'fr_FR');
  static final DateFormat _weekday = DateFormat('EEEE', 'fr_FR');
  static final DateFormat _iso8601 = DateFormat('yyyy-MM-dd');

  /// Formate une date au format jour/mois/année
  static String formatDate(DateTime date) {
    return _dayMonthYear.format(date);
  }

  /// Formate une date avec l'heure
  static String formatDateTime(DateTime date) {
    return _dayMonthYearTime.format(date);
  }

  /// Formate une date au format mois année
  static String formatMonthYear(DateTime date) {
    return _monthYear.format(date);
  }

  /// Formate une date au format jour mois
  static String formatDayMonth(DateTime date) {
    return _dayMonth.format(date);
  }

  /// Retourne le nom du jour de la semaine
  static String formatWeekday(DateTime date) {
    return _weekday.format(date);
  }

  /// Formate une date au format ISO 8601
  static String formatISO8601(DateTime date) {
    return _iso8601.format(date);
  }

  /// Parse une date depuis le format jour/mois/année
  static DateTime? parseDate(String dateString) {
    try {
      return _dayMonthYear.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse une date depuis le format ISO 8601
  static DateTime? parseISO8601(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Retourne le début de la journée (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Retourne la fin de la journée (23:59:59)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  /// Retourne le début de la semaine (lundi)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Retourne la fin de la semaine (dimanche)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Retourne le début du mois
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Retourne la fin du mois
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }

  /// Retourne le début de l'année
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  /// Retourne la fin de l'année
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59);
  }

  /// Vérifie si deux dates sont le même jour
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Vérifie si deux dates sont dans la même semaine
  static bool isSameWeek(DateTime date1, DateTime date2) {
    final startWeek1 = startOfWeek(date1);
    final startWeek2 = startOfWeek(date2);
    return isSameDay(startWeek1, startWeek2);
  }

  /// Vérifie si deux dates sont dans le même mois
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Vérifie si une date est aujourd'hui
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Vérifie si une date est hier
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Vérifie si une date est demain
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Retourne le nombre de jours entre deux dates
  static int daysBetween(DateTime date1, DateTime date2) {
    final start = startOfDay(date1);
    final end = startOfDay(date2);
    return end.difference(start).inDays;
  }

  /// Retourne le nombre de semaines entre deux dates
  static int weeksBetween(DateTime date1, DateTime date2) {
    return (daysBetween(date1, date2) / 7).floor();
  }

  /// Retourne le nombre de mois entre deux dates
  static int monthsBetween(DateTime date1, DateTime date2) {
    return (date2.year - date1.year) * 12 + date2.month - date1.month;
  }

  /// Ajoute des jours ouvrables à une date
  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var remainingDays = days;

    while (remainingDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday <= 5) {
        // Lundi à vendredi
        remainingDays--;
      }
    }

    return result;
  }

  /// Vérifie si une date est un jour ouvrable
  static bool isBusinessDay(DateTime date) {
    return date.weekday <= 5; // Lundi à vendredi
  }

  /// Vérifie si une date est un weekend
  static bool isWeekend(DateTime date) {
    return date.weekday > 5; // Samedi et dimanche
  }

  /// Retourne la saison pour une date donnée (hémisphère nord)
  static Season getSeason(DateTime date) {
    final month = date.month;

    if (month >= 3 && month <= 5) {
      return Season.spring;
    } else if (month >= 6 && month <= 8) {
      return Season.summer;
    } else if (month >= 9 && month <= 11) {
      return Season.autumn;
    } else {
      return Season.winter;
    }
  }

  /// Retourne le nom de la saison en français
  static String getSeasonName(Season season) {
    switch (season) {
      case Season.spring:
        return 'Printemps';
      case Season.summer:
        return 'Été';
      case Season.autumn:
        return 'Automne';
      case Season.winter:
        return 'Hiver';
    }
  }

  /// Retourne les dates de début et fin d'une saison
  static DateRange getSeasonDateRange(int year, Season season) {
    switch (season) {
      case Season.spring:
        return DateRange(
          start: DateTime(year, 3, 20),
          end: DateTime(year, 6, 20),
        );
      case Season.summer:
        return DateRange(
          start: DateTime(year, 6, 21),
          end: DateTime(year, 9, 22),
        );
      case Season.autumn:
        return DateRange(
          start: DateTime(year, 9, 23),
          end: DateTime(year, 12, 20),
        );
      case Season.winter:
        return DateRange(
          start: DateTime(year, 12, 21),
          end: DateTime(year + 1, 3, 19),
        );
    }
  }

  /// Formate une durée en texte lisible
  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '$days jour${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours heure${hours > 1 ? 's' : ''}';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  /// Retourne une description relative de la date (ex: "il y a 2 jours")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Hier';
      } else if (difference.inDays < 7) {
        return 'Il y a ${difference.inDays} jours';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return 'Il y a $weeks semaine${weeks > 1 ? 's' : ''}';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return 'Il y a $months mois';
      } else {
        final years = (difference.inDays / 365).floor();
        return 'Il y a $years an${years > 1 ? 's' : ''}';
      }
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
}

/// Énumération des saisons
enum Season {
  spring,
  summer,
  autumn,
  winter,
}

/// Classe pour représenter une plage de dates
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({
    required this.start,
    required this.end,
  });

  /// Vérifie si une date est dans la plage
  bool contains(DateTime date) {
    return date.isAfter(start) && date.isBefore(end) ||
        AppDateUtils.isSameDay(date, start) ||
        AppDateUtils.isSameDay(date, end);
  }

  /// Retourne la durée de la plage
  Duration get duration => end.difference(start);

  /// Retourne le nombre de jours dans la plage
  int get days => AppDateUtils.daysBetween(start, end) + 1;

  @override
  String toString() {
    return '${AppDateUtils.formatDate(start)} - ${AppDateUtils.formatDate(end)}';
  }
}


