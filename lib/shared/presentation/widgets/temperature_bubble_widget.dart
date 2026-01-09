import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/climate/presentation/providers/weather_providers.dart';

class TemperatureBubbleWidget extends ConsumerWidget {
  const TemperatureBubbleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // RÉTABLISSEMENT DU SYSTÈME DRAG :
    // On surveille le provider projeté qui contient la température interpolée
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
              Colors.white.withOpacity(0.10), // plus faible highlight
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
            // IMPORTANT : éloigne le texte du rim pour éviter "morsure"
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
    final textColor = Color.lerp(Colors.white, Theme.of(context).colorScheme.surface, 0.16) ?? const Color(0xFFF2F4F6);
    final number = tempC != null ? tempC.toStringAsFixed(0) : '--';

    final baseNumberStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 44,
      fontWeight: FontWeight.w700,
      color: textColor,
      height: 1.0,
      letterSpacing: -0.4,
      fontFeatures: const [FontFeature.tabularFigures()],
      shadows: const [], // on enlève l'ombre lourde
    );

    final degreeStyle = baseNumberStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: textColor.withOpacity(0.92),
      shadows: const [], // pas d'ombre pour le degré
    );

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: number, style: baseNumberStyle),
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: Transform.translate(
                  offset: const Offset(4, -10), // ajuste la position du °
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
