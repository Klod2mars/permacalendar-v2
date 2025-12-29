import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/climate/presentation/providers/weather_providers.dart';
import 'weather_bio_container.dart';
import 'weather_sky_background.dart';

class WeatherBubbleWidget extends ConsumerWidget {
  const WeatherBubbleWidget({super.key, this.showEffects = true});

  final bool showEffects;

  String _capFirst(String s) => s.isEmpty ? s : (s[0].toUpperCase() + s.substring(1));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le conteneur s'adapte à la taille disponible
    // Tout le rendu interne est géré par WeatherBioContainer
    // [MODIF] On ajoute le Ciel Dynamique en arrière-plan
    // On doit utiliser un Stack et CLIPPER pour que le ciel reste dans la bulle (si la bulle a une forme)
    // Mais WeatherBioContainer est rectangulaire dans l'espace alloué ?
    // Le Dashboard crée des bulles RONDEN via le `GardenBubbleWidget` ou juste des slots ?
    // Dans OrganicDashboard, les slots sont des Rect. S'il n'y a pas de clip, c'est carré.
    // L'image de fond a des "trous" ou c'est juste transparent.
    // WeatherBioContainer est probablement clippé par son parent ou pas.
    // Vérifions OrganicDashboard : "Positioned ... SizedBox ... GestureDetector ... child"
    // Il n'y a pas de ClipOval par défaut sur les slots "Weather".
    // MAIS, l'image de fond a un *dessin* de bulle.
    // Si on met un fond carré coloré, ça va dépasser du dessin de bulle de l'image de fond PNG.
    // IL FAUT UN CLIPPER OVAL/CIRCLE pour que le ciel ne soit que dans "l'ovoïde".
    
    return ClipOval(
      child: Stack(
        fit: StackFit.expand,
        children: [
           // 1. Le Ciel (Fond)
           const WeatherSkyBackground(),
           
           // 2. La Physique (Avant-plan)
           WeatherBioContainer(showEffects: showEffects),
        ],
      ),
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
