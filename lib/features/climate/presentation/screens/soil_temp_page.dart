import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/soil_temp_provider.dart';

class SoilTempPage extends ConsumerWidget {
  final String scopeKey;

  const SoilTempPage({super.key, this.scopeKey = "garden:demo"});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final forecastAsync = ref.watch(soilTempForecastProvider(scopeKey));
    final adviceAsync = ref.watch(sowingAdviceProvider(scopeKey));

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by parent/stack usually? 
      // If used as full page, we might need a background. Assuming standard app background.
      // Let's use a dark nice background if running standalone, but usually this app has a global background.
      // I'll put a container with gradient just in case.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A2F), Color(0xFF0F1E19)], // Deep organic green
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white)),
                    const SizedBox(width: 8),
                    Text("Température du Sol",
                        style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              // Chart Section
              Container(
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: forecastAsync.when(
                  data: (data) => _buildChart(data, theme),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text("Erreur chart: $e", style: const TextStyle(color: Colors.white))),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Conseils de Semis",
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),

              // Advice List
              Expanded(
                child: adviceAsync.when(
                  data: (adviceList) {
                    if (adviceList.isEmpty) return const Center(child: Text("Aucune plante chargée", style: TextStyle(color: Colors.white70)));
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: adviceList.length,
                      itemBuilder: (context, index) {
                        final item = adviceList[index];
                        return _buildAdviceCard(item, theme);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text("Erreur conseils: $e", style: const TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(List<SoilTempForecastPoint> data, ThemeData theme) {
    if (data.isEmpty) return const SizedBox();

    final points = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.tempC);
    }).toList();

    final maxY = (points.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5).roundToDouble();
    final minY = (points.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5).roundToDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox();
                final date = data[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('E', 'fr').format(date), // Day name
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
             sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}°", style: const TextStyle(color: Colors.white54, fontSize: 10));
                }
             )
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            color: Colors.amber,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.amber.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(SowingAdvice item, ThemeData theme) {
    Color color;
    IconData icon;
    String statusText;

    switch (item.status) {
      case SowingStatus.ideal:
        color = Colors.green;
        icon = Icons.star;
        statusText = "Optimal";
        break;
      case SowingStatus.sowNow:
        color = Colors.lightGreen;
        icon = Icons.check_circle;
        statusText = "Semer";
        break;
      case SowingStatus.sowSoon:
        color = Colors.orangeAccent;
        icon = Icons.access_time;
        statusText = "Bientôt";
        break;
      case SowingStatus.wait:
        color = Colors.redAccent;
        icon = Icons.do_not_disturb;
        statusText = "Attendre";
        break;
    }

    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(item.plant.commonName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(item.reason, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(statusText, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }
}
