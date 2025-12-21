import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/climate/presentation/providers/weather_providers.dart';
import 'weather_bio_container.dart';

class WeatherBubbleWidget extends ConsumerWidget {
  const WeatherBubbleWidget({super.key, this.showEffects = true});

  final bool showEffects;

  String _capFirst(String s) => s.isEmpty ? s : (s[0].toUpperCase() + s.substring(1));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le conteneur s'adapte à la taille disponible
    // Tout le rendu interne est géré par WeatherBioContainer
    return WeatherBioContainer(showEffects: showEffects);
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
