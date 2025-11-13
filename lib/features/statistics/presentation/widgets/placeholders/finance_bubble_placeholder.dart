ï»¿import 'package:flutter/material.dart';

/// Placeholder visuel pour le pilier Finance
///
/// Affiche des bulles de diffÃƒÂ©rentes tailles pour reprÃƒÂ©senter les flux financiers
/// Design neutre avec des cercles gris de tailles variÃƒÂ©es
class FinanceBubblePlaceholder extends StatelessWidget {
  const FinanceBubblePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bulle principale (centre)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
          ),
          // Bulle gauche (plus petite)
          Positioned(
            left: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bulle droite (plus petite)
          Positioned(
            right: 20,
            bottom: 10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



