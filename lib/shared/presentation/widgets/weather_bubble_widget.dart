import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../features/climate/presentation/providers/weather_providers.dart';

class WeatherBubbleWidget extends ConsumerWidget {
  const WeatherBubbleWidget({super.key});

  String _capFirst(String s) => s.isEmpty ? s : (s[0].toUpperCase() + s.substring(1));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);

    return weatherAsync.when(
      loading: () => const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2),
        ),
      ),
      error: (e, _) => const Center(
        child: _OutlinedText(
          'MÉTÉO INDISPONIBLE',
          fontSize: 13,
          weight: FontWeight.w800,
          align: TextAlign.center,
          maxLines: 2,
        ),
      ),
      data: (weather) {
        final dateFormatter = DateFormat('EEEE d/M/yy', 'fr_FR');
        final date = _capFirst(dateFormatter.format(DateTime.now())); // ex: "Lundi 8/12/25"

        final desc = (weather.description?.trim().isNotEmpty ?? false)
            ? weather.description!.trim().toUpperCase()
            : 'DONNÉES INDISPONIBLES';

        final hasMinMax = weather.minTemp != null && weather.maxTemp != null;
        final tempNow = weather.temperature ?? weather.currentTemperatureC;

        final tempLine = hasMinMax
            ? 'Min ${weather.minTemp!.toStringAsFixed(1)}° / Max ${weather.maxTemp!.toStringAsFixed(1)}°'
            : (tempNow != null ? '${tempNow.toStringAsFixed(1)}°' : '');

        // IMPORTANT : on n'ajoute aucun cadre/rectangle.
        // On joue uniquement avec TYPO + contour + ombres pour rester organique sur ton fond.
        return LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth.isFinite ? c.maxWidth : 9999;
            final h = c.maxHeight.isFinite ? c.maxHeight : 9999;
            final s = (w < h ? w : h).clamp(80.0, 240.0);

            // Ajuste typographie selon la taille réelle de la bulle (anti-overflow).
            final dateSize = (s * 0.10).clamp(10.0, 14.0);
            final iconSize = (s * 0.42).clamp(40.0, 84.0);
            final descSize = (s * 0.14).clamp(12.0, 16.0);
            final tempSize = (s * 0.10).clamp(10.0, 13.5);
            final gap1 = (s * 0.06).clamp(4.0, 10.0);
            final gap2 = (s * 0.04).clamp(3.0, 8.0);

            return Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 220),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ICÔNE (seule information visuelle immédiate)
                      FutureBuilder(
                        future: () async {
                           final path = weather.icon ?? 'assets/weather_icons/sunny.png';
                           try {
                             await rootBundle.load(path);
                             debugPrint('WeatherBubble Asset FOUND: $path');
                           } catch (e) {
                             debugPrint('WeatherBubble Asset MISSING: $path -> $e');
                           }
                           return true;
                        }(),
                        builder: (c, s) => Image.asset(
                          weather.icon ?? 'assets/weather_icons/sunny.png',
                          width: iconSize,
                          height: iconSize,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.wb_cloudy,
                            size: iconSize,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      if (tempLine.isNotEmpty) ...[
                        SizedBox(height: (gap2 * 0.9).clamp(3.0, 7.0)),

                        // Affichage minimaliste : min / max sur deux lignes (ou temp courante si absente)
                        if (hasMinMax) ...[
                          _OutlinedText(
                            '${weather.minTemp!.toStringAsFixed(1)}°',
                            fontSize: tempSize,
                            weight: FontWeight.w700,
                            letterSpacing: 0.2,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          SizedBox(height: 2),
                          _OutlinedText(
                            '${weather.maxTemp!.toStringAsFixed(1)}°',
                            fontSize: tempSize,
                            weight: FontWeight.w700,
                            letterSpacing: 0.2,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ] else if (tempNow != null) ...[
                          _OutlinedText(
                            '${tempNow.toStringAsFixed(1)}°',
                            fontSize: tempSize,
                            weight: FontWeight.w700,
                            letterSpacing: 0.2,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ] else ...[
                          // Fallback conservateur : afficher la chaîne existante
                          _OutlinedText(
                            tempLine,
                            fontSize: tempSize,
                            weight: FontWeight.w700,
                            letterSpacing: 0.2,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Texte très lisible sur n'importe quel fond (sans container).
/// - contour (stroke) + fill
/// - ombres douces pour s'intégrer dans les bulles organiques
class _OutlinedText extends StatelessWidget {
  const _OutlinedText(
    this.text, {
    this.fontSize = 14,
    this.weight = FontWeight.w800,
    this.letterSpacing = 0,
    this.height,
    this.align = TextAlign.center,
    this.maxLines = 2,
    this.softWrap = true,
  });

  final String text;
  final double fontSize;
  final FontWeight weight;
  final double letterSpacing;
  final double? height;
  final TextAlign align;
  final int maxLines;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    // Contour adaptatif : assez fort pour rester lisible,
    // mais pas énorme pour ne pas “casser” l’organique.
    final stroke = (fontSize * 0.12).clamp(0.8, 2.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          textAlign: align,
          maxLines: maxLines,
          softWrap: softWrap,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: weight,
            letterSpacing: letterSpacing,
            height: height,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = stroke
              ..color = Colors.black.withOpacity(0.60),
          ),
        ),
        Text(
          text,
          textAlign: align,
          maxLines: maxLines,
          softWrap: softWrap,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: weight,
            letterSpacing: letterSpacing,
            height: height,
            color: const Color(0xFFF1FFF6),
            shadows: const [
              Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 1)),            
            ],
          ),
        ),
      ],
    );
  }
}
