import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import '../providers/soil_temp_provider.dart';
import 'soil_temp_sheet.dart';
import '../../../plant_catalog/providers/plant_catalog_provider.dart';

class SoilTempPage extends ConsumerWidget {
  final String scopeKey;

  const SoilTempPage({super.key, this.scopeKey = "garden:demo"});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final forecastAsync = ref.watch(soilTempForecastProvider(scopeKey));
    final adviceAsync = ref.watch(sowingAdviceProvider(scopeKey));

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Use a gradient container for the background
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
          // Use CustomScrollView to allow the whole page to scroll if content expands
          child: CustomScrollView(
            slivers: [
              // 1. TOP SECTION (Header, Chart, Info, Measure)
              SliverToBoxAdapter(
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
                          Text(l10n.soil_temp_title,
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
                        data: (data) => _buildChart(data, theme, locale),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Center(
                            child: Text(l10n.soil_temp_chart_error(e),
                                style: const TextStyle(color: Colors.white))),
                      ),
                    ),

                    // --- Info Section (Collapsed by default, now scrollable if expanded) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: const Icon(Icons.info_outline,
                              color: Colors.white70, size: 20),
                          title: Text(
                            l10n.soil_temp_about_title,
                            style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          childrenPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: [
                            Text(
                              l10n.soil_temp_about_content,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.soil_temp_formula_label,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.soil_temp_formula_content,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // --- Measure / Measure Button ---
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(l10n.soil_temp_current_label,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(color: Colors.white)),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${displayedTemp.toStringAsFixed(1)}°C',
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: ElevatedButton.icon(
                                      onPressed: () => showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => const SoilTempSheet(),
                                      ),
                                      icon: const Icon(Icons.thermostat),
                                      label: Text(l10n.soil_temp_action_measure),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.soil_temp_measure_hint,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white54, fontSize: 11),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // 2. ADVICE LIST SECTION
              adviceAsync.when(
                data: (adviceList) {
                  // Check for catalog error
                  final catalogError = ref.watch(plantCatalogErrorProvider);
                  if (catalogError != null) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(l10n.soil_temp_catalog_error(catalogError),
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center),
                      ),
                    );
                  }

                  final allPlants = ref.watch(plantsListProvider);
                  final isLoading = ref.watch(plantCatalogLoadingProvider);

                  // Empty DB check
                  if (allPlants.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.inventory_2_outlined,
                              color: Colors.white24, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            l10n.soil_temp_db_empty,
                            style: const TextStyle(color: Colors.white70),
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
                                  label: Text(l10n.soil_temp_reload_plants),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                    );
                  }

                  // Empty advice check
                  if (adviceList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          l10n.soil_temp_no_advice,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                    );
                  }

                  // Valid list
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = adviceList[index];
                          return _buildAdviceCard(item, theme, l10n);
                        },
                        childCount: adviceList.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(l10n.soil_temp_advice_error(e),
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(List<SoilTempForecastPoint> data, ThemeData theme, String locale) {
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
              interval: 1, // Fix: Avoid duplicate labels (e.g. dim, dim)
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox();
                final date = data[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('E', locale).format(date), // Day name
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

  Widget _buildAdviceCard(SowingAdvice item, ThemeData theme, AppLocalizations l10n) {
    Color color;
    IconData icon;
    String statusText;

    switch (item.status) {
      case SowingStatus.ideal:
        color = Colors.green;
        icon = Icons.star;
        statusText = l10n.soil_advice_status_ideal;
        break;
      case SowingStatus.sowNow:
        color = Colors.lightGreen;
        icon = Icons.check_circle;
        statusText = l10n.soil_advice_status_sow_now;
        break;
      case SowingStatus.sowSoon:
        color = Colors.orangeAccent;
        icon = Icons.access_time;
        statusText = l10n.soil_advice_status_sow_soon;
        break;
      case SowingStatus.wait:
        color = Colors.redAccent;
        icon = Icons.do_not_disturb;
        statusText = l10n.soil_advice_status_wait;
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
