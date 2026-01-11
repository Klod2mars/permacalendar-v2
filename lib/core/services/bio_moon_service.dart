import 'dart:math' as math;

class BioMoonService {
  BioMoonService._();
  static final BioMoonService instance = BioMoonService._();

  /// Calculate moonrise and moonset for a given date and location (lat/lon).
  /// This implementation uses a simplified algorithm suitable for UI display.
  /// Returns UTC DateTime.
  (DateTime? moonrise, DateTime? moonset) getMoonTimes(
      DateTime date, double lat, double lon) {
    // Normalisation date à minuit UTC pour le calcul
    final t = date.toUtc();
    final day = DateTime.utc(t.year, t.month, t.day);
    
    // We compute for the target day.
    // Algorithm based on "MoonCalc" references (Minnaert / Meeus simplified)
    
    // 1. Julian Date for 00:00 UTC
    final jd = _toJulian(day);
    
    // 2. Iterate to find rise/set
    // Moon moves ~13 degrees per day. Rise/set changes ~50 mins/day.
    // We scan or solve. Simplified approach:
    
    DateTime? rise;
    DateTime? set;
    
    // ... Actually implementing a full astronomical calculator from scratch is risky and complex.
    // But we need something functional.
    // Let's use a known robust simplified approximation or lookup.
    
    // Better approach: Since we can't reliably calculate this without complex libraries,
    // and the user wants "Coherence", 
    // we can use a simpler "Phase-based" offset approximation if exact astrometry is too hard?
    // NO, Moonrise/set depends heavily on phase AND season AND latitude.
    
    // Let's implement the standard low-precision algorithm (good to ~5-10 mins).
    // Adapted from JS MoonCalc or similar.
    
    const rad = math.pi / 180.0;
    
    // Calculate current position for each hour and detect horizon crossing?
    // Costly but effective for a single day.
    // Iterate 24h with 20 min steps?
    
    // We scan with a 10-min granularity, then refine.
    bool? wasAbove;
    const int stepMin = 10;
    
    // Check state at 00:00
    // If it's already up, we missed the rise (yesterday).
    
    for (int i = 0; i <= 24 * 60; i += stepMin) {
       final time = day.add(Duration(minutes: i));
       final pos = _getMoonPosition(time, lat, lon);
       final isAbove = pos.altitude > -0.5667 * rad; // -34 arcmin for refraction/radius standard
       
       if (wasAbove != null && wasAbove != isAbove) {
         // Transition detected between (time - step) and (time)
         // Refine !
         final preciseTime = _refineTransition(day.add(Duration(minutes: i - stepMin)), time, lat, lon, !isAbove);
         
         if (!wasAbove && isAbove) {
           rise = preciseTime;
         } else {
           set = preciseTime;
         }
       }
       wasAbove = isAbove;
    }
    
    return (rise, set);
  }

  /// Binary search to find exact transition time (1 min precision)
  DateTime _refineTransition(DateTime start, DateTime end, double lat, double lon, bool isRise) {
    DateTime low = start;
    DateTime high = end;
    const rad = math.pi / 180.0;
    
    for (int i = 0; i < 5; i++) { // 5 iterations is enough for 10min -> <1min
      final midMs = (low.millisecondsSinceEpoch + high.millisecondsSinceEpoch) ~/ 2;
      final mid = DateTime.fromMillisecondsSinceEpoch(midMs, isUtc: true);
      final pos = _getMoonPosition(mid, lat, lon);
      final isAbove = pos.altitude > -0.5667 * rad;
      
      // If we look for Rise: Low was Below, High was Above.
      // If Mid is Above -> it rose in lower half. High = Mid.
      // If Mid is Below -> it rises in upper half. Low = Mid.
      
      if (isRise) { // Rising: Below -> Above
         if (isAbove) high = mid; else low = mid;
      } else { // Setting: Above -> Below
         if (isAbove) low = mid; else high = mid;
      }
    }
    // Return the time where it crossed
    return high; // or low, ~10s diff.
  }

  // --- Astronomical Helpers ---

  // Moon Position (Altitude, Azimuth)
  ({double altitude, double azimuth}) _getMoonPosition(DateTime date, double lat, double lon) {
     final t = (_toJulian(date) - 2451545.0) / 36525.0;
     const rad = math.pi / 180.0;
     
     final L0 = 218.316 + 481267.8813 * t;
     final L = 134.963 + 477198.8676 * t;
     final M = 357.528 + 35999.0503 * t;
     final F = 93.272 + 483202.0175 * t;
     final D = 297.850 + 445267.1115 * t;
     final H = 125.045 - 1934.1363 * t;
     
     final l = L0 + 6.289 * math.sin(L * rad); // Ecliptic Longitude
     final b = 5.128 * math.sin(F * rad);      // Ecliptic Latitude
     final dt = 385001 - 20905 * math.cos(L * rad); // Distance
     
     // Equatorial coordinates
     // Obliquity of ecliptic
     final e = 23.439 - 0.0000004 * t;
     
     final ra = math.atan2(
        math.sin(l * rad) * math.cos(e * rad) - math.tan(b * rad) * math.sin(e * rad),
        math.cos(l * rad)
     );
     
     final dec = math.asin(
        math.sin(b * rad) * math.cos(e * rad) + math.cos(b * rad) * math.sin(e * rad) * math.sin(l * rad)
     );
     
     // Local Horizontal Coordinates
     // Sidereal Time
     final jd = _toJulian(date);
     final d = jd - 2451545.0;
     final gmstat = (18.697374558 + 24.06570982441908 * d) % 24;
     final lmst = (gmstat * 15 + lon) * rad; // Local Meridian
     
     final hourAngle = lmst - ra;
     
     final sinAlt = math.sin(lat * rad) * math.sin(dec) + math.cos(lat * rad) * math.cos(dec) * math.cos(hourAngle);
     final alt = math.asin(sinAlt);
     
     final y = -math.sin(hourAngle);
     final x = math.cos(dec) * math.tan(lat * rad) - math.sin(dec) * math.cos(hourAngle);
     final az = math.atan2(y, x);
     
     return (altitude: alt, azimuth: az);
  }

  double _toJulian(DateTime date) {
    return date.millisecondsSinceEpoch / 86400000.0 + 2440587.5;
  }
}
