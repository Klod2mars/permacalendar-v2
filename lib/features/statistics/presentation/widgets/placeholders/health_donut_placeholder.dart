import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Placeholder visuel pour le pilier SantÃ©
///
/// Affiche un donut chart vide avec un seul secteur gris neutre
/// PrÃªt pour l'intÃ©gration de donnÃ©es de santÃ© en Phase 4
class HealthDonutPlaceholder extends StatelessWidget {
  const HealthDonutPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: Colors.grey.withOpacity(0.3),
              value: 100,
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


