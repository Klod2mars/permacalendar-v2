import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
        // On garde le style visuel "Bulle" qui est joli
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
            stops: const [0.3, 1.0],
            center: const Alignment(-0.2, -0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: projectedPoint != null
              ? _buildTemperatureContent(projectedPoint.temperatureC)
              : _buildLoading(),
        ),
      );
    });
  }

  Widget _buildTemperatureContent(double? tempC) {
    final tempStr = tempC != null ? '${tempC.toStringAsFixed(0)}°' : '--';

    return AutoSizeText(
      tempStr,
      maxLines: 1,
      minFontSize: 14,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1.0,
        shadows: [
          Shadow(
            color: Colors.black,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
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
