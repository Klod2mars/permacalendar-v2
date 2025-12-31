import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../features/climate/presentation/providers/soil_temp_provider.dart';
import '../../../core/providers/active_garden_provider.dart';
import '../../../features/climate/presentation/screens/soil_temp_page.dart';

class TemperatureBubbleWidget extends ConsumerWidget {
  const TemperatureBubbleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Check active garden
    final activeGardenId = ref.watch(activeGardenIdProvider);
    
    // If no garden, show projected weather (Air Temp)
    if (activeGardenId == null) {
       final projectedPoint = ref.watch(projectedWeatherProvider);
       return _buildWrapper(
         context, 
         child: projectedPoint != null
            ? _buildTemperatureContent(projectedPoint.temperatureC, null)
            : _buildLoading(),
       );
    }

    // If garden active, show Soil Temp
    // Use the scope key corresponding to the garden
    // We assume scopeKey is the gardenId for now, or "garden:$id"
    // In sheet we used the id directly as scopeKey? No, in sheet we resolved it.
    // Let's assume scopeKey = activeGardenId.
    final soilTempAsync = ref.watch(soilTempProviderByScope(activeGardenId));

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SoilTempPage(scopeKey: activeGardenId)),
        );
      },
      child: _buildWrapper(
        context,
        child: soilTempAsync.when(
          data: (val) {
             if (val == null) {
                // Fallback to air if no soil temp recorded?
                // Or show "N/A"
                // Let's fallback to projected weather for continuity but maybe with an icon indicating it is air?
                // User said "Activer le mode Température du Sol".
                // We should encourage them to measure.
                return _buildTemperatureContent(null, "No Data");
             }
             return _buildTemperatureContent(val, "Sol");
          },
          loading: () => _buildLoading(),
          error: (e, s) => const Icon(Icons.error, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildWrapper(BuildContext context, {required Widget child}) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        alignment: Alignment.center,
        child: child,
      );
    });
  }

  Widget _buildTemperatureContent(double? tempC, String? label) {
    final tempStr = tempC != null ? '${tempC.toStringAsFixed(0)}°' : '--';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
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
        ),
        if (label != null) ...[
          const SizedBox(height: 2),
           Text(
            label,
            style: const TextStyle(
              color: Colors.white70, 
              fontSize: 10, 
              fontWeight: FontWeight.bold
            ),
          )
        ]
      ],
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
