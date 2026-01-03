import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/soil_temp_provider.dart';
import 'soil_temp_sheet.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';

class SoilTempPage extends ConsumerWidget {
  final String scopeKey;

  const SoilTempPage({super.key, this.scopeKey = "garden:demo"});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final forecastAsync = ref.watch(soilTempForecastProvider(scopeKey));
    final adviceAsync = ref.watch(sowingAdviceProvider(scopeKey));

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Background handled by parent/stack usually?
      // If used as full page, we might need a background. Assuming standard app background.
      // Let's use a dark nice background if running standalone, but usually this app has a global background.
      // I'll put a container with gradient just in case.
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A2F),
              Color(0xFF0F1E19)
            ], // Deep organic green
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
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.white)),
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(
                      child: Text("Erreur chart: $e",
                          style: const TextStyle(color: Colors.white))),
                ),
              ),

              // --- Info Section (Collapsed by default) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: const Icon(Icons.info_outline, color: Colors.white70, size: 20),
                    title: Text(
                      "À propos de la température du sol",
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                       Text(
                        "La température du sol affichée ici est estimée par l’application à partir de données climatiques et saisonnières, selon une formule de calcul intégrée.\n\nCette estimation permet de donner une tendance réaliste de la température du sol lorsque aucune mesure directe n’est disponible.",
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Formule de calcul utilisée :",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Température du sol = f(température de l’air, saison, inertie du sol)\n(Formule exacte définie dans le code de l’application)",
                         style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // --- Mesure du sol (affichage & bouton) ---
              Consumer(
                builder: (context, ref, child) {
                  final soilTempAsync =
                      ref.watch(soilTempProviderByScope(scopeKey));
                  final double displayedTemp = soilTempAsync.value ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Température actuelle',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${displayedTemp.toStringAsFixed(1)}°C',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 240),
                              child: ElevatedButton.icon(
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const SoilTempSheet(),
                                ),
                                icon: const Icon(Icons.thermostat),
                                label: const Text('Modifier / Mesurer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Concise instruction
                         Text(
                          "Vous pouvez renseigner manuellement la température du sol dans l’onglet “Modifier / Mesurer”.",
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),


              // Advice List
              Expanded(
                child: adviceAsync.when(
                  data: (adviceList) {
                    // 1. Vérifier si erreurs dans catalogue
                    final catalogError = ref.watch(plantCatalogErrorProvider);
                    if (catalogError != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Erreur catalogue: $catalogError",
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center),
                        ),
                      );
                    }

                    // 2. Vérifier si DB vide
                    final allPlants = ref.watch(plantsListProvider);
                    final isLoading = ref.watch(plantCatalogLoadingProvider);

                    if (allPlants.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inventory_2_outlined,
                                color: Colors.white24, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              "Base de données de plantes vide.",
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 16),
                            isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.amber)
                                : ElevatedButton.icon(
                                    onPressed: () {
                                      ref
                                          .read(plantCatalogProvider.notifier)
                                          .seedDefaultPlants();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text("Recharger les plantes"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    }

                    // 3. Si liste conseils vide mais plantes existent -> Aucune correspondance
                    if (adviceList.isEmpty) {
                      return const Center(
                        child:Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            "Aucune plante avec données de germination trouvée.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: adviceList.length,
                      itemBuilder: (context, index) {
                        final item = adviceList[index];
                        return _buildAdviceCard(item, theme);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(
                      child: Text("Erreur conseils: $e",
                          style: const TextStyle(color: Colors.white))),
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

    final maxY = (points.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5)
        .roundToDouble();
    final minY = (points.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5)
        .roundToDouble();

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
                    return Text("${value.toInt()}°",
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 10));
                  })),
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
        title: Text(item.plant.commonName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(item.reason,
            style:
                TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(statusText,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }
}
