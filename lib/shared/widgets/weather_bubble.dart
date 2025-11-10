// lib/shared/widgets/weather_bubble.dart
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeatherBubble extends StatelessWidget {
  final String dateLabel;
  final String conditionLabel;
  final double tMin;
  final double tMax;
  final IconData weatherIcon;
  final Color? backgroundColor;

  const WeatherBubble({
    super.key,
    required this.dateLabel,
    required this.conditionLabel,
    required this.tMin,
    required this.tMax,
    required this.weatherIcon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final diameter = constraints.maxWidth;
      final padding = diameter * 0.10;
      final iconSize = diameter * 0.18;
      final maxFont = diameter * 0.09;
      const minFont = 10.0;

      return Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              (backgroundColor ?? Colors.greenAccent).withOpacity(0.18),
              (backgroundColor ?? Colors.greenAccent).withOpacity(0.06),
            ],
            center: const Alignment(-0.2, -0.3),
            radius: 0.9,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                dateLabel,
                maxLines: 1,
                minFontSize: minFont,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.95),
                  fontSize: maxFont,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: diameter * 0.02),
              Icon(weatherIcon,
                  size: iconSize, color: Colors.white.withOpacity(0.98)),
              SizedBox(height: diameter * 0.03),
              AutoSizeText(
                conditionLabel,
                maxLines: 2,
                minFontSize: minFont,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.95),
                  fontSize: maxFont * 0.95,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: diameter * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '${tMin.toStringAsFixed(0)}Â°',
                    maxLines: 1,
                    minFontSize: minFont,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[100],
                      fontSize: maxFont * 1.05,
                    ),
                  ),
                  SizedBox(width: diameter * 0.05),
                  Container(
                    width: 1,
                    height: diameter * 0.06,
                    color: Colors.white24,
                  ),
                  SizedBox(width: diameter * 0.05),
                  AutoSizeText(
                    '${tMax.toStringAsFixed(0)}Â°',
                    maxLines: 1,
                    minFontSize: minFont,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.red[100],
                      fontSize: maxFont * 1.05,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

