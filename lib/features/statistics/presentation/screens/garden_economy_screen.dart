import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/statistics_kpi_providers.dart';
import '../../application/providers/economy_trend_provider.dart';
import '../../presentation/providers/statistics_filters_provider.dart';
import '../../presentation/widgets/top_economy_bubble_chart.dart';
import '../../presentation/widgets/economy/economy_top3_table.dart';
import '../../presentation/widgets/economy/economy_trend_chart.dart';
import '../../presentation/widgets/economy/economy_logistics_savings_card.dart';

class GardenEconomyScreen extends ConsumerStatefulWidget {
  final String gardenId;
  const GardenEconomyScreen({super.key, required this.gardenId});

  @override
  ConsumerState<GardenEconomyScreen> createState() => _GardenEconomyScreenState();
}

class _GardenEconomyScreenState extends ConsumerState<GardenEconomyScreen> {
  @override
  void initState() {
    super.initState();
    // Synchronize filter on init (in case we land here directly)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsFiltersProvider.notifier).setGardenId(widget.gardenId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers
    final totalEconomy = ref.watch(totalEconomyKpiProvider);
    final top3Rankings = ref.watch(top3PlantsValueRankingProvider);
    final trendPoints = ref.watch(economyTrendProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            floating: true,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Économie Vivante', style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white70),
                onPressed: () {
                   // TODO: Export PDF/CSV
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Export CSV à venir")));
                },
              )
            ],
          ),
          
          // 1. KPI Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valeur totale produite',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                       Text(
                        '${totalEconomy.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Tendance fictive pour l'instant ou calculée
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                            SizedBox(width: 4),
                            Text('+12%', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Trend Chart
           SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: EconomyTrendChart(
                points: trendPoints,
                height: 180,
                lineColor: const Color(0xFF69F0AE),
                gradientStartColor: const Color(0xFF69F0AE),
                gradientEndColor: Colors.transparent,
              ),
            ),
          ),
          
          // 3. Top 3 Bubbles
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                    'Champions de la rentabilité',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  TopEconomyBubbleChart(rankings: top3Rankings),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // 4. Detail Table
           SliverToBoxAdapter(
            child: EconomyTop3Table(rankings: top3Rankings),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 5. Logistics (Bonus)
          const SliverToBoxAdapter(
            child: EconomyLogisticsSavingsCard(),
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}
