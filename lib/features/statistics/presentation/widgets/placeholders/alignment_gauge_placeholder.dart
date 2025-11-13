ï»¿import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Placeholder visuel pour le pilier Alignement
///
/// Affiche un gauge (jauge) avec un arc fin gris reprÃƒÂ©sentant un cadran neutre
/// PrÃƒÂªt pour l'intÃƒÂ©gration de donnÃƒÂ©es d'alignement en Phase 4
class AlignmentGaugePlaceholder extends StatelessWidget {
  const AlignmentGaugePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 60,
          sections: [
            // Arc principal (gris neutre)
            PieChartSectionData(
              color: Colors.grey.withOpacity(0.3),
              value: 25,
              title: '',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Arc vide (transparent)
            PieChartSectionData(
              color: Colors.transparent,
              value: 75,
              title: '',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



