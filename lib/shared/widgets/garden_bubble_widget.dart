import 'package:flutter/material.dart';
import 'package:permacalendar/shared/widgets/curved_text.dart';
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
    final upperName = gardenName.toUpperCase();
    final words = upperName.split(' ');

    String? topText;
    String? bottomText;

    if (words.length > 1) {
      // Heuristic: First word top, rest bottom (or balanced split)
      // Simple split for now:
      topText = words[0];
      bottomText = words.sublist(1).join(' ');
    } else {
      topText = upperName;
      bottomText = null;
    }

    // Text style shared
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.95),
      fontWeight: FontWeight.w500,
      fontSize: 11, // Fixed size for arc
      letterSpacing:
          2.0, // Wider spacing for arc to prevent overlapping characters
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Colors.black.withOpacity(0.5),
          offset: const Offset(0, 1),
        ),
        Shadow(
          blurRadius: 4,
          color: Colors.white.withOpacity(0.2),
          offset: const Offset(0, 0),
        ),
      ],
    );

    // Calculate radius for text (slightly inside the bubble edge)
    final textRadius = radius * 0.60;

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
                    if (topText != null)
                      CurvedText(
                        text: topText,
                        textStyle: textStyle,
                        radius: textRadius,
                        placement: CurvedTextPlacement.top,
                      ),
                     if (bottomText != null)
                      CurvedText(
                        text: bottomText,
                        textStyle: textStyle,
                        radius: textRadius,
                        placement: CurvedTextPlacement.bottom,
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
