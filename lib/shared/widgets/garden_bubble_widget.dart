import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GardenBubbleWidget extends StatelessWidget {
  const GardenBubbleWidget({
    super.key,
    required this.gardenName,
    required this.onTap,
    required this.radius,
    // Asset path hardcoded here but can be injected if needed
    this.assetPath = 'assets/images/dashboard/bubbles/bubble_garden_unit.png',
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

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background: Asset if available, else Fallback
            // Note: Since we know the asset is likely missing, this errorBuilder is efficient.
            Image.asset(
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

            // Content: Garden Name
            Padding(
              padding: EdgeInsets.all(radius * 0.3), // Padding based on size
              child: Center(
                child: AutoSizeText(
                  gardenName,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  minFontSize: 8,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black87,
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
