import 'package:flutter/material.dart';

/// Climate Rosace Petal - V2 Geometric Rounded Design
///
/// Individual petal component for the rosace panel.
/// Features geometric rounded rhombus shape with icon, label, and value.
///
/// Design specs:
/// - Rounded geometric shape (rhombus with rounded corners)
/// - Icon + label + value display
/// - Alert mode support (visual emphasis)
/// - Touch target ≥44dp
class ClimateRosacePetal extends StatelessWidget {
  const ClimateRosacePetal({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.alertMode = false,
    this.weatherIcon,
  });

  final IconData icon;
  final String label;
  final String? value;
  final bool alertMode;
  final String? weatherIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 80,
      height: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Rounded geometric shape
        child: Container(
          decoration: BoxDecoration(
            color: alertMode
                ? Colors.amber.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: alertMode
                  ? Colors.amber.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: alertMode
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: null, // Handled by parent ScaleHaloTap
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon - show weather icon if available, otherwise default icon
                    weatherIcon != null
                        ? Text(
                            weatherIcon!,
                            style: TextStyle(
                              fontSize: 24,
                              color: alertMode
                                  ? Colors.amber.shade200
                                  : Colors.white,
                            ),
                          )
                        : Icon(
                            icon,
                            color: alertMode
                                ? Colors.amber.shade200
                                : Colors.white,
                            size: 24,
                          ),

                    const SizedBox(height: 4),

                    // Label
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color:
                            alertMode ? Colors.amber.shade200 : Colors.white70,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Value (if provided)
                    if (value != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        value!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              alertMode ? Colors.amber.shade100 : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
