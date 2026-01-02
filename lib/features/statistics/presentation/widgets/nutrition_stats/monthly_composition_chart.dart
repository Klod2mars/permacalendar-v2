import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyCompositionChart extends StatefulWidget {
  final Map<String, double> data;
  final bool isMajorMinerals; // True = Ca, K, Mg. False = Fe, Zn, Mn

  const MonthlyCompositionChart({
    super.key,
    required this.data,
    required this.isMajorMinerals,
  });

  @override
  State<MonthlyCompositionChart> createState() =>
      _MonthlyCompositionChartState();
}

class _MonthlyCompositionChartState extends State<MonthlyCompositionChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
            child: Text("Pas de données cette période",
                style: TextStyle(color: Colors.white24))),
      );
    }

    // Filter keys based on mode
    final keys = widget.isMajorMinerals
        ? ['calcium_mg', 'potassium_mg', 'magnesium_mg']
        : ['iron_mg', 'zinc_mg', 'manganese_mg'];

    final filteredData = Map.fromEntries(
      widget.data.entries.where((e) => keys.contains(e.key) && e.value > 0),
    );

    if (filteredData.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
            child: Text(
                widget.isMajorMinerals
                    ? "Aucun minéral majeur"
                    : "Aucun oligo-élément",
                style: const TextStyle(color: Colors.white24))),
      );
    }

    final totalMass = filteredData.values.fold(0.0, (sum, val) => sum + val);

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: _buildSections(filteredData, totalMass),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filteredData.entries.map((e) {
              final color = _getColor(e.key);
              final label = _getLabel(e.key);
              final pct = (e.value / totalMass * 100).toStringAsFixed(1);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: color),
                    const SizedBox(width: 8),
                    Text('$label ($pct%)',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      Map<String, double> data, double total) {
    int i = 0;
    return data.entries.map((e) {
      final isTouched = i == touchedIndex;
      final fontSize =
          isTouched ? 16.0 : 0.0; // Hide labels logic on chart, use legend
      final radius = isTouched ? 60.0 : 50.0;
      final section = PieChartSectionData(
        color: _getColor(e.key),
        value: e.value,
        title: '', // No title on chart
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      i++;
      return section;
    }).toList();
  }

  Color _getColor(String key) {
    switch (key) {
      case 'calcium_mg':
        return Colors.blueAccent;
      case 'potassium_mg':
        return Colors.purpleAccent;
      case 'magnesium_mg':
        return Colors.tealAccent;
      case 'iron_mg':
        return Colors.redAccent;
      case 'zinc_mg':
        return Colors.orangeAccent;
      case 'manganese_mg':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String _getLabel(String key) {
    switch (key) {
      case 'calcium_mg':
        return 'Calcium';
      case 'potassium_mg':
        return 'Potassium';
      case 'magnesium_mg':
        return 'Magnésium';
      case 'iron_mg':
        return 'Fer';
      case 'zinc_mg':
        return 'Zinc';
      case 'manganese_mg':
        return 'Manganèse';
      default:
        return key;
    }
  }
}
