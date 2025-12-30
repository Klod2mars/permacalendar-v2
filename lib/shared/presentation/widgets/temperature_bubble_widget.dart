import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Garder l'import des providers si besoin pour d'autres choses, 
// mais on va importer celui qui nous intéresse.
import '../../../features/climate/presentation/providers/weather_providers.dart'; 

class TemperatureBubbleWidget extends ConsumerWidget {
  const TemperatureBubbleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // CHANGEMENT ICI : On watch le provider 'projeté' au lieu de 'current'
    final projectedPoint = ref.watch(projectedWeatherProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        alignment: Alignment.center,
        child: projectedPoint != null
            ? _buildTemperatureContent(projectedPoint.temperatureC)
            : _buildLoading(), // Affiche le loader si pas de données
      );
    });
  }

  Widget _buildTemperatureContent(double? tempC) {
    // Si la température est null (peut arriver si l'API ne renvoie rien), on affiche --
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
