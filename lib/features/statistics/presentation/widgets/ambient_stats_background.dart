import 'dart:math';
import 'package:flutter/material.dart';

/// Un fond vivant et organique pour l'écran de statistiques.
/// Affiche des particules subtiles ("dust motes") qui dérivent lentement.
/// L'animation est optimisée pour ne pas surcharger le GPU/CPU.
class AmbientStatsBackground extends StatefulWidget {
  const AmbientStatsBackground({super.key});

  @override
  State<AmbientStatsBackground> createState() => _AmbientStatsBackgroundState();
}

class _AmbientStatsBackgroundState extends State<AmbientStatsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Mote> _motes = [];
  final Random _random = Random();
  static const int _moteCount = 60; // Nombre modéré pour perf mobile

  @override
  void initState() {
    super.initState();
    // Animation très lente pour un effet 'hypnotique' et non distrayant
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), 
    )..repeat();
    
    _initMotes();
  }

  void _initMotes() {
    for (int i = 0; i < _moteCount; i++) {
      _motes.add(_createMote());
    }
  }

  _Mote _createMote() {
    return _Mote(
      x: _random.nextDouble(), // Position normative 0.0 -> 1.0
      y: _random.nextDouble(),
      speedX: (_random.nextDouble() - 0.5) * 0.05, // Vitesse très lente
      speedY: (_random.nextDouble() - 0.5) * 0.05,
      size: _random.nextDouble() * 2.5 + 0.5, // Taille variable (0.5 - 3.0)
      opacityBase: _random.nextDouble() * 0.3 + 0.1, // Opacité faible (0.1 - 0.4)
      opacityPulseSpeed: _random.nextDouble() * 2 + 0.5,
      phase: _random.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _MotePainter(
              motes: _motes,
              progress: _controller.value,
            ),
            isComplex: false,
            willChange: true,
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _Mote {
  double x;
  double y;
  double speedX;
  double speedY;
  final double size;
  final double opacityBase;
  final double opacityPulseSpeed;
  final double phase;

  _Mote({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.size,
    required this.opacityBase,
    required this.opacityPulseSpeed,
    required this.phase,
  });
}

class _MotePainter extends CustomPainter {
  final List<_Mote> motes;
  final double progress; // Sert juste à ticker, la position est accumulée dans le state?
  // Dans un CustomPainter stateless, on calcule la position based on time.
  // Pour faire simple ici on va simuler le mouvement dans le paint 
  // MAIS pour être pur, on devrait update le state.
  // Pour un effet visuel continu sans logique physique complexe, on peut utiliser le temps 
  // pour décaler les positions (x = x0 + speed * time), avec modulo 1.0.
  
  _MotePainter({required this.motes, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    
    // Gradient de fond "Organique" (Nuances de vert profond)
    // Rétablit l'ambiance forêt/abysses
    final Paint bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
           const Color(0xFF1B5E20).withOpacity(0.25), // Vert forêt sombre central
           const Color(0xFF000000).withOpacity(0.0), // Noir transparent bords
        ],
        center: Alignment.center,
        radius: 1.2, // Grand rayon pour couvrir
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
      
    canvas.drawRect(Rect.fromLTWH(0,0,w,h), bgPaint);

    final Paint motePaint = Paint()
      ..style = PaintingStyle.fill;
    
    // Le 'time' total est infini en théorie, mais controller loop 0->1.
    // Astuce: utiliser DateTime.now() pour la position absolue 
    // ou accumuler dans le state du widget.
    // ICI: Pour éviter de modifier les motes (objets) dans le paint (mauvaise pratique), 
    // on calcule leur position dérivée.
    
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;

    for (var mote in motes) {
      // Déplacement continu
      // On utilise 'time' pour que ça ne saute pas quand le controller loop
      double dx = (mote.x + mote.speedX * (time * 0.2)) % 1.0; 
      double dy = (mote.y + mote.speedY * (time * 0.2)) % 1.0;
      
      // Gestion des bords négatifs (modulo en dart peut retourner négatif selon impl)
      if (dx < 0) dx += 1.0;
      if (dy < 0) dy += 1.0;

      final double px = dx * w;
      final double py = dy * h;

      // Opacité pulsante
      // sin(time * speed + phase) -> -1..1 -> mapping 0..1 -> scale opacity
      final double pulse = sin(time * mote.opacityPulseSpeed + mote.phase); 
      // pulse (-1..1) -> (0.5 .. 1.0) facteur d'opacité
      final double opacityFactor = 0.7 + (pulse * 0.3); 
      
      motePaint.color = Colors.lightGreenAccent.withOpacity(
        (mote.opacityBase * opacityFactor).clamp(0.0, 1.0)
      );

      // Dessin
      canvas.drawCircle(Offset(px, py), mote.size, motePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MotePainter oldDelegate) => true; // Anim constante
}
