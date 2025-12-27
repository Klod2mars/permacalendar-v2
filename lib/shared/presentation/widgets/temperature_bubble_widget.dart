import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';

class TemperatureBubbleWidget extends ConsumerWidget {
  const TemperatureBubbleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return LayoutBuilder(builder: (context, constraints) {
      // Fond transparent pour overlay pur (juste le chiffre)
      // La position est gérée par le dashboard (slot dédié)
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        alignment: Alignment.center,
        child: weatherAsync.when(
            data: (data) {
              final tempVal = data.temperature ?? data.currentTemperatureC;
              final tempStr = tempVal != null ? '${tempVal.toStringAsFixed(0)}°' : '--';

              return AutoSizeText(
                tempStr,
                maxLines: 1,
                minFontSize: 14,
                style: const TextStyle(
                  fontFamily: 'Roboto', // Ou IMPACT si dispo, mais Roboto est sûr
                  fontSize: 40,
                  fontWeight: FontWeight.w900, // Très gras
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
            },
            loading: () => const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
            ),
            error: (_, __) => const Icon(Icons.error_outline, color: Colors.white70),
          ),
      );
    });
  }
}
