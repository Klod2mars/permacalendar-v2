import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditContactScreen extends StatelessWidget {
  const CreditContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sobriety and readability theme
    final theme = Theme.of(context);
    final backgroundColor = const Color(0xFF101412); // Deep organic dark
    final textColor = const Color(0xFFE2E8F0);
    final accentColor = const Color(0xFFA7D1AB); // Soft plant green

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor.withOpacity(0.8)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Crédit & contact',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 48),

              // Brand
              Text(
                'SoWing',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),

              // Credits
              _buildSectionText(
                'Conception et développement : Azaïs Claude',
                textColor,
              ),
              _buildSectionText(
                'Projet indépendant',
                textColor.withOpacity(0.7),
              ),
              const SizedBox(height: 48),

              // Contact Header
              Text(
                'Contact – évolution du programme',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24),

              // Contact Body
              _buildBodyText(
                'Pour toute remarque, suggestion, demande d’évolution ou réclamation concernant l’application, vous pouvez écrire à l’adresse suivante :',
                textColor,
              ),
              const SizedBox(height: 16),
              
              // Email (Static text)
              SelectableText(
                '12sowing21@gmail.com',
                style: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 32),

              // Cadre d'échange
              Text(
                'Cadre d’échange',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              _buildBodyText(
                'Les messages sont lus avec attention et peuvent recevoir une réponse lorsque cela est possible.',
                textColor,
              ),
              const SizedBox(height: 12),
              _buildBodyText(
                'Les évolutions de l’application se font par cycles, selon la cohérence globale du projet, le temps disponible et les usages observés.',
                textColor,
              ),
              const SizedBox(height: 12),
              _buildBodyText(
                'Toutes les demandes ne donnent pas nécessairement lieu à une modification.',
                textColor,
              ),

              const SizedBox(height: 48),

              // About
              Text(
                'À propos',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              _buildBodyText(
                'Ce projet est développé de manière indépendante, avec une approche sobre et progressive, attentive au temps long et à la qualité des usages.',
                textColor,
              ),
              const SizedBox(height: 12),
              _buildBodyText(
                'Aucune donnée personnelle n’est collectée via cette page. Aucun formulaire, aucun système de suivi ou de stockage de messages n’est intégré à l’application.',
                textColor,
              ),
              const SizedBox(height: 12),
              _buildBodyText(
                'Tout échange se fait volontairement, en dehors de l’application, par les coordonnées indiquées ci-dessus.',
                textColor,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionText(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: color,
        height: 1.5,
      ),
    );
  }

  Widget _buildBodyText(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: color.withOpacity(0.85),
        height: 1.6,
      ),
    );
  }
}
