import 'package:flutter/material.dart';

/// Climate Rosace Center PH - V2 Geometric Rounded Design
///
/// Central circular pH display for the rosace panel.
/// Features circular frost-style button with pH value display.
///
/// Design specs:
/// - Circular shape with frost glass effect
/// - pH value display (X.X format)
/// - Alert mode support (pulse effect handled by parent)
/// - Touch target ââ€°Â¥44dp
class ClimateRosaceCenterPH extends StatelessWidget {
  const ClimateRosaceCenterPH({
    super.key,
    required this.phValue,
    this.alertMode = false,
  });

  final double phValue;
  final bool alertMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      height: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40), // Perfect circle
        child: Container(
          decoration: BoxDecoration(
            color: alertMode
                ? Colors.red.withOpacity(0.2)
                : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: alertMode
                  ? Colors.red.withOpacity(0.4)
                  : Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: null, // Handled by parent ScaleHaloTap
              borderRadius: BorderRadius.circular(40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // pH label
                    Text(
                      'pH',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: alertMode ? Colors.red.shade200 : Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // pH value
                    Text(
                      phValue.toStringAsFixed(1),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: alertMode ? Colors.red.shade100 : Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
