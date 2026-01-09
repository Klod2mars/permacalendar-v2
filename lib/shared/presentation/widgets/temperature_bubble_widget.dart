import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';

class TemperatureBubbleWidget extends ConsumerWidget {
  const TemperatureBubbleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectedPoint = ref.watch(projectedWeatherProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.10), // highlight atténué
              Colors.white.withOpacity(0.03),
            ],
            stops: const [0.2, 1.0],
            center: const Alignment(-0.25, -0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12), // plus léger
              blurRadius: 6,
              offset: const Offset(1, 2),
              spreadRadius: -1,
            ),
          ],
        ),
        child: ClipOval(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            // éloigne le texte du rim pour éviter la "morsure" autour du °
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: projectedPoint != null
                ? _buildTemperatureContent(context, projectedPoint.temperatureC)
                : _buildLoading(),
          ),
        ),
      );
    });
  }

  Widget _buildTemperatureContent(BuildContext context, double? tempC) {
    // couleur plus douce que le blanc pur, pour intégrer au bubble
    final textColor = Color.lerp(
          Colors.white,
          Theme.of(context).colorScheme.surface,
          0.18,
        ) ??
        const Color(0xFFF2F4F6);

    final numberStr = tempC != null ? tempC.toStringAsFixed(0) : '--';

    // style du chiffre principal (QuickSand, poids 700)
    final baseNumberStyle = GoogleFonts.quicksand(
      textStyle: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.0,
        letterSpacing: -0.4,
        fontFeatures: const [FontFeature.tabularFigures()],
        shadows: const [], // on retire l'ombre lourde
      ),
    );

    // degré - agrandi ~12% par rapport aux 16 précédents => 18
    final degreeStyle = GoogleFonts.quicksand(
      textStyle: TextStyle(
        fontSize: 18, // ~+12% pour le °
        fontWeight: FontWeight.w700,
        color: textColor.withOpacity(0.92),
        letterSpacing: 0.0,
        shadows: const [], // pas d'ombre sur le °
        height: 1.0,
      ),
    );

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: numberStr, style: baseNumberStyle),
              // ° rendu comme WidgetSpan pour pouvoir le remonter proprement
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: Transform.translate(
                  offset: const Offset(4, -10), // ajuster si nécessaire
                  child: Text('°', style: degreeStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
    );
  }
}
