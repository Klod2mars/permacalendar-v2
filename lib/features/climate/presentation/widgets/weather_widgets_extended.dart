
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/models/daily_weather_point.dart';
import '../../../../core/models/hourly_weather_point.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import 'package:intl/intl.dart';

// ---------------------------------------------------------------------------
// 1. HOURLY FORECAST GRAPH (Scrollable + CustomPainter)
// ---------------------------------------------------------------------------
class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyWeatherPoint> hourlyData;

  const HourlyForecastWidget({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    if (hourlyData.isEmpty) return const SizedBox.shrink();

    // Use a subset for display if too many points? Usually generic headers filter this.
    // We assume hourlyData passed here is already filtered (e.g. next 24h).
    
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "PROCHAINES 24H",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                // Width depends on number of points. Say 60px per point.
                width: math.max(MediaQuery.of(context).size.width, hourlyData.length * 70.0),
                child: CustomPaint(
                  painter: _HourlyCurvePainter(hourlyData),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourlyCurvePainter extends CustomPainter {
  final List<HourlyWeatherPoint> data;

  _HourlyCurvePainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final textStyleTime = const TextStyle(color: Colors.white70, fontSize: 12);
    final textStyleTemp = const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);

    // Find min/max for normalization
    double minT = data.map((e) => e.temperatureC).reduce(math.min);
    double maxT = data.map((e) => e.temperatureC).reduce(math.max);
    // Add padding
    minT -= 2; 
    maxT += 2;
    if (maxT == minT) maxT += 1;

    final double stepX = size.width / data.length;
    final double paddingBottom = 40.0;
    final double paddingTop = 40.0;
    final double availHeight = size.height - paddingBottom - paddingTop;

    final path = Path();
    
    // Draw points & Text
    for (int i = 0; i < data.length; i++) {
        final point = data[i];
        final x = i * stepX + stepX / 2;
        
        // Normalize Y
        final tRatio = (point.temperatureC - minT) / (maxT - minT);
        final y = paddingTop + availHeight * (1.0 - tRatio);

        if (i == 0) {
            path.moveTo(x, y);
        } else {
             // Cubic bezier for smooth curve
             final prevX = (i - 1) * stepX + stepX / 2;
             final prevPoint = data[i-1];
             final prevTRatio = (prevPoint.temperatureC - minT) / (maxT - minT);
             final prevY = paddingTop + availHeight * (1.0 - prevTRatio);

             final cp1x = prevX + (x - prevX) / 2;
             final cp1y = prevY;
             final cp2x = prevX + (x - prevX) / 2;
             final cp2y = y;

            path.cubicTo(cp1x, cp1y, cp2x, cp2y, x, y);
        }

        // Draw Time below
        final hourStr = DateFormat('HH:mm').format(point.time);
        final textSpan = TextSpan(text: hourStr, style: textStyleTime);
        final tp = TextPainter(text: textSpan, textDirection: ui.TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(x - tp.width / 2, size.height - 20));

        // Draw icon & precip above curve ? Or just Icon
        // Let's draw the icon at the top or near the point
        // Drawing text temp above point
        final tempStr = '${point.temperatureC.round()}°';
        final tpTemp = TextPainter(text: TextSpan(text: tempStr, style: textStyleTemp), textDirection: ui.TextDirection.ltr);
        tpTemp.layout();
        tpTemp.paint(canvas, Offset(x - tpTemp.width / 2, y - 25));

        // Little dot on the line
        canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.white);
    }

    canvas.drawPath(path, paintLine);
    
    // Fill below curve
    final pathFill = Path.from(path);
    pathFill.lineTo(size.width - stepX/2, size.height); // approximate end
    pathFill.lineTo(stepX/2, size.height);
    pathFill.close();
    
    final gradient = LinearGradient(
      colors: [Colors.yellow.withOpacity(0.3), Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
     // We need to construct a rect for the gradient that covers the path bounds?
     // Actually usually we just set shader on paint.
    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // canvas.drawPath(pathFill, paintFill); // Filling under curve can be tricky with exact Bezier, skipping for simplicity/cleanliness unless requested
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


// ---------------------------------------------------------------------------
// 2. DAILY FORECAST LIST (Vertical with "Green Star" style)
// ---------------------------------------------------------------------------
class DailyForecastListWidget extends StatelessWidget {
  final List<DailyWeatherPoint> dailyData;

  const DailyForecastListWidget({super.key, required this.dailyData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: dailyData.map((day) {
            final isToday = day.date.day == DateTime.now().day;
            final dayName = isToday ? "Aujourd'hui" : DateFormat('EEEE', 'fr_FR').format(day.date);
            // Capitalize
            final dayLabel = dayName.substring(0, 1).toUpperCase() + dayName.substring(1);
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(dayLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  // Rain prob?
                   if (day.precipMm > 0)
                      Row(
                        children: [
                             const Icon(Icons.water_drop, size: 12, color: Colors.blueAccent),
                             const SizedBox(width: 4),
                             Text('${day.precipMm.round()}mm', style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
                        ],
                      )
                    else 
                       const SizedBox(width: 40), // Spacer

                  const Spacer(),
                  // Icon
                  SvgPicture.asset(
                    day.icon ?? 'assets/weather_icons/default.svg',
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    placeholderBuilder: (_) => const Icon(Icons.wb_sunny, color: Colors.white24, size: 32),
                  ),
                  const Spacer(),
                  // Min / Max
                  Text('${day.minTemp?.round() ?? '-'}°', style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(width: 16),
                  Text('${day.maxTemp?.round() ?? '-'}°', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. WIND COMPASS WIDGET
// ---------------------------------------------------------------------------
class WindCompassWidget extends StatelessWidget {
  final double speedKmh;
  final int directionDegrees;
  final double gustsKmh;

  const WindCompassWidget({
    super.key,
    required this.speedKmh,
    required this.directionDegrees,
    this.gustsKmh = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 160, // Square shape for grid
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Row(
             children: [
               Icon(Icons.air, color: Colors.white70, size: 16),
               const SizedBox(width: 8),
               Text("VENT", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
             ],
           ),
           Expanded(
             child: Stack(
               alignment: Alignment.center,
               children: [
                 // Compass Background
                 CustomPaint(
                   size: const Size(100, 100),
                   painter: _CompassPainter(directionDegrees),
                 ),
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text('${speedKmh.round()}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, height: 1)),
                     const Text('km/h', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1)),
                   ],
                 )
               ],
             ),
           ),
           if (gustsKmh > 0)
            Text('Rafales: ${gustsKmh.round()} km/h', style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final int degrees;
  _CompassPainter(this.degrees);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paintCircle = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final paintTicks = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw Circle
    canvas.drawCircle(center, radius, paintCircle);

    // Draw Ticks (N, E, S, W)
    final textStyle = const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold);

    void drawLabel(String text, double angle) {
       final r = radius - 15;
       final x = center.dx + r * math.cos(angle - math.pi / 2); // -pi/2 to start at top
       final y = center.dy + r * math.sin(angle - math.pi / 2);
       
       final tp = TextPainter(text: TextSpan(text: text, style: textStyle), textDirection: ui.TextDirection.ltr);
       tp.layout();
       tp.paint(canvas, Offset(x - tp.width/2, y - tp.height/2));
    }
    
    drawLabel("N", 0);
    drawLabel("E", math.pi / 2);
    drawLabel("S", math.pi);
    drawLabel("O", 3 * math.pi / 2);

    // Draw Arrow
    final angleRad = (degrees - 90) * (math.pi / 180); // Adjust so 0 is North (usual math 0 is East)
    // Wait, usually wind direction 0 is North, 90 East.
    // In math, 0 is Right (East), PI/2 is Down (South).
    // So to map 0(N) -> -PI/2 (Top)
    //  90(E) -> 0 (Right)
    // Formula: (deg - 90) * rad/deg
    
    final arrowLen = radius - 5;
    // Tip of arrow
    final tipX = center.dx + arrowLen * math.cos(angleRad);
    final tipY = center.dy + arrowLen * math.sin(angleRad);
    
    final paintArrow = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
    
    // Draw simple triangle pointer ? Or just a line with a head
    // Let's emulate the design: a white triangle pointer on the circle ring
    final markerRadius = 4.0;
    
    // Actually the design shows the Whole compass rotating or a needle.
    // "Pointer" style
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate((degrees) * math.pi / 180); 
    
    // Draw a small triangle at the top (which corresponds to North relative to rotation)
    // Wait if I rotate canvas by `degrees`, then drawing at Top (0, -radius) will act as the pointer?
    // A wind coming FROM North (0°) -> Arrow points South?
    // Standard meteo: Wind Direction is WHERE IT COMES FROM.
    // So 0° = North Wind. Arrow usually points IN THE DIRECTION OF FLOW (South).
    // BUT compass usually shows the SOURCE.
    // The design shows a little arrow on the circle.
    
    // Let's assume the indicator points to the degree.
    // Draw triangle at (0, -radius)
    final path = Path();
    path.moveTo(0, -radius + 5);
    path.lineTo(-5, -radius + 15);
    path.lineTo(5, -radius + 15);
    path.close();
    canvas.drawPath(path, paintArrow);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// 4. PRESSURE GAUGE WIDGET
// ---------------------------------------------------------------------------
class PressureGaugeWidget extends StatelessWidget {
  final double pressureHPa;

  const PressureGaugeWidget({super.key, required this.pressureHPa});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Row(
             children: [
               Icon(Icons.speed, color: Colors.white70, size: 16),
               const SizedBox(width: 8),
               Expanded(child: Text("PRESSION", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70), overflow: TextOverflow.ellipsis)),
             ],
           ),
           Expanded(
             child: Stack(
               alignment: Alignment.center,
               children: [
                 CustomPaint(
                   size: const Size(100, 80),
                   painter: _GaugePainter(pressureHPa),
                 ),
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     const SizedBox(height: 20), // Offset slightly down
                     Text('${pressureHPa.round()}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1)),
                     const Text('hPa', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1)),
                   ],
                 )
               ],
             ),
           ),
           // Basic interpretation
           Text(pressureHPa > 1013 ? "Haute" : "Basse", style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value; // ~950 to ~1050
  _GaugePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = math.min(size.width, size.height) * 0.9;
    
    final paintTrack = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    // Draw Arc (from -PI to 0) -> 180 degrees
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, math.pi, false, paintTrack);

    // Draw ticks
    // Range 960 -> 1060 (100hPa range)
    // Value mapping
    final minP = 960.0;
    final maxP = 1060.0;
    final clamped = value.clamp(minP, maxP);
    final ratio = (clamped - minP) / (maxP - minP); // 0.0 to 1.0
    
    final angle = math.pi + (ratio * math.pi); // Map to PI -> 2PI range

    final paintActive = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
      
    // Draw active arc? Or just a needle/marker?
    // Design has a star on a gauge.
    // Let's draw active arc up to value
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi, (angle - math.pi), false, paintActive);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ---------------------------------------------------------------------------
// 5. SUN & MOON WIDGETS
// ---------------------------------------------------------------------------
class SunPathWidget extends StatelessWidget {
    final String sunrise;
    final String sunset;
    
    const SunPathWidget({super.key, required this.sunrise, required this.sunset});

    @override
    Widget build(BuildContext context) {
        // Parse times 08:15
        return Container(
          height: 160,
          width: double.infinity,
           padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
                children: [
                     Row(
                        children: [
                        const Icon(Icons.sunny, color: Colors.amber, size: 16),
                        const SizedBox(width: 8),
                         Text("SOLEIL", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
                        ],
                    ),
                    Expanded(
                        child: CustomPaint(
                            size: const Size(double.infinity, 80),
                            painter: _SunPathPainter(),
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text("Lever", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                Text(sunrise, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ]),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                const Text("Coucher", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                Text(sunset, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ]),
                        ],
                    )
                ],
            ),
        );
    }
}

class _SunPathPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
        final paintLine = Paint()
            ..color = Colors.amber.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;
        
        final path = Path();
        // Sine wave or Arc
        path.moveTo(0, size.height);
        path.quadraticBezierTo(size.width / 2, -20, size.width, size.height);
        
        canvas.drawPath(path, paintLine);
        
        // Sun position (approximate, static for now or based on current time?)
        // Let's put it in the middle for aesthetics
        final sunPaint = Paint()..color = Colors.amber;
        canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.3), 8, sunPaint);
        
        // Horizon line
        final horizonPaint = Paint()..color = Colors.white12..strokeWidth=1;
        canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), horizonPaint);
    }
    
    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MoonPhaseWidget extends StatelessWidget {
    final double phase; // 0..1
    final String moonrise;
    final String moonset;

    const MoonPhaseWidget({super.key, required this.phase, required this.moonrise, required this.moonset});
    
    String get phaseLabel {
        if (phase < 0.05) return "Nouvelle Lune";
        if (phase < 0.25) return "Premier Croissant";
        if (phase < 0.45) return "Premier Quartier";
        if (phase < 0.55) return "Pleine Lune";
        if (phase < 0.75) return "Dernier Quartier";
        if (phase < 0.95) return "Dernier Croissant";
        return "Nouvelle Lune";
    }

    @override
    Widget build(BuildContext context) {
         return Container(
          height: 160,
          width: double.infinity,
           padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
                children: [
                    // Visual
                    Expanded(
                        flex: 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Icon(Icons.nightlight_round, size: 48, color: Colors.grey[300]), // Placeholder for true moon phase rendering
                                const SizedBox(height: 8),
                                Text(phaseLabel, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                            ],
                        ),
                    ),
                    // Times
                    Expanded(
                        flex: 1,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                 _timeRow("Coucher", moonset),
                                 const SizedBox(height: 12),
                                 _timeRow("Lever", moonrise),
                            ],
                        ),
                    )
                ],
            ),
        );
    }

    Widget _timeRow(String label, String time) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                Text(time, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
        );
    }
}
