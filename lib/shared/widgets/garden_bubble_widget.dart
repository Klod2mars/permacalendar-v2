import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GardenBubbleWidget extends StatelessWidget {
  const GardenBubbleWidget({
    super.key,
    required this.gardenName,
    required this.onTap,
    required this.radius,
    // Asset path hardcoded here but can be injected if needed
    this.assetPath = 'assets/images/dashboard/bubbles/bubble_garden.png',
  });

  final String gardenName;
  final VoidCallback onTap;
  final double radius;
  final String assetPath;

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: glassDecoration, 
        child: Stack( // No decoration, fully transparent container
          alignment: Alignment.center,
          children: [
            // Background: Asset wrapped in ClipOval
            ClipOval(
              child: Image.asset(
                assetPath,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.contain, // Contain to avoid cropping/zooming on the transparent canvas
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: fallbackDecoration,
                  );
                },
              ),
            ),

            // Content: Garden Name
            Padding(
              padding: EdgeInsets.all(radius * 0.2), // Reduced padding for more space
              child: Center(
                child: AutoSizeText(
                  gardenName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  minFontSize: 10,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
