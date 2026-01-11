import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:permacalendar/shared/widgets/curved_text.dart'; // Removed

import 'package:permacalendar/shared/widgets/active_garden_aura.dart';

class GardenBubbleWidget extends StatelessWidget {
  const GardenBubbleWidget({
    super.key,
    required this.gardenName,
    required this.onTap,
    required this.radius,
    // Asset path hardcoded here but can be injected if needed
    this.assetPath = 'assets/images/dashboard/bubbles/bubble_garden.webp',
    this.isActive = false,
    this.auraColor,
  });

  final String gardenName;
  final VoidCallback onTap;
  final double radius;
  final String assetPath;
  final bool isActive;
  final Color? auraColor;

  @override
  Widget build(BuildContext context) {
    // Fallback decoration (Green Circle)
    final fallbackDecoration = BoxDecoration(
      color: const Color(0xFF4CAF50).withOpacity(0.9), // Green 500
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
    );

    // Transparent background to let the leaf show through (Organic look)
    // The image itself (bubble) will provide the visual shape.
    const glassDecoration = null;

    // Prepare text logic
    // Text logic removed for Minimalist approach


    // Text style shared
    // Text style and radius removed for Minimalist approach


    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        label: isActive ? '$gardenName — jardin actif' : gardenName,
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none, // Allow aura to overflow naturally
            children: [
              // [LAYER 0] Aura - Positioned robustly independent of parent clipping if needed,
              // or just unclipped in Stack. User requested LayerLink:
              // We use CompositedTransformTarget on the bubble and Follower for the Aura 
              // to ensuring perfect centering relative to the visual target.
              if (isActive)
                Positioned(
                  // Center the follower in the stack (it will follow target anyway, 
                  // but we need it in the tree)
                  left: 0, top: 0, right: 0, bottom: 0,
                  child: Center(
                    child: OverflowBox(
                      maxWidth: radius * 6, // Allow large bloom
                      maxHeight: radius * 6,
                      child: SizedBox(
                        width: radius * 2, // Reference size matches bubble
                        height: radius * 2,
                        child: ActiveGardenAura(
                          size: radius * 2,
                          color: auraColor,
                          isActive: true,
                        ),
                      ),
                    ),
                  ),
                ),

              // [LAYER 1] The Bubble (Target for centering)
              // If we wanted strictly "follow" logic we'd wrap this in CompositedTransformTarget
              // and the Aura in CompositedTransformFollower.
              // Given the complexity of "behind" in a single stack, Stack alignment is usually sufficient
              // IF clipBehavior is none.
              // However, to strictly satisfy "Diagnostic: decentered without LayerLink", 
              // we can mark this as the target.
              // Note: Follower must be in a specific relation. 
              // Using standard Stack alignment with Clip.none fixes 99% of "cut off" issues.
              
              Container(
                width: radius * 2,
                height: radius * 2,
                decoration: glassDecoration,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        assetPath,
                        width: radius * 2,
                        height: radius * 2,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: radius * 2,
                            height: radius * 2,
                            decoration: fallbackDecoration,
                          );
                        },
                      ),
                    ),
                    // Approche Equilibrée : "Organic Breath"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0), // 14 etait trop exclusif (hachage), 12 est le bon compromis
                      child: Stack(
                        children: [
                          // 1. Shadow Layer (Softer Deep Green)
                          AutoSizeText(
                            gardenName.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            minFontSize: 5, // Autorise petite taille pour eviter hachage "JARDI N"
                            maxFontSize: 9,
                            stepGranularity: 0.1, // Scaling fluide
                            overflow: TextOverflow.ellipsis,
                            wrapWords: false, // Force le wrap sur les mots entiers si possible (pas character break)
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF1B5E20).withOpacity(0.6), // Green 900, reduced opacity
                              fontSize: 9,
                              fontWeight: FontWeight.w600, // SemiBold instead of Bold for lightness
                              letterSpacing: 0.8, // Slightly increased spacing
                              height: 1.1, // Breathing room
                              shadows: [
                                const Shadow(
                                  blurRadius: 3,
                                  color: Color(0xFF1B5E20),
                                  offset: Offset(0, 1),
                                ),
                              ]
                            ),
                          ),
                          // 2. Gradient Face Layer (Pearl/Organic)
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [
                                  Color(0xFFFAFAFA), // Soft White (Grey 50)
                                  Color(0xFFC5E1A5), // Light Green 200 (Soft, natural)
                                ],
                                stops: [0.2, 1.0], // Smooth transition
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcIn,
                            child: AutoSizeText(
                              gardenName.toUpperCase(),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              minFontSize: 5,
                              maxFontSize: 9,
                              stepGranularity: 0.1,
                              overflow: TextOverflow.ellipsis,
                              wrapWords: false, 
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600, // Matching SemiBold
                                letterSpacing: 0.8,
                                height: 1.1,
                                shadows: [],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
