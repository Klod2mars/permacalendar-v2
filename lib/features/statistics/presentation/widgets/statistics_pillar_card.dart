import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../enums/pillar_type.dart';
import '../../application/providers/statistics_kpi_providers.dart';
import '../../application/providers/vitamin_distribution_provider.dart';
import '../../application/providers/vitamin_recommendation_provider.dart';
import '../../application/providers/performance/performance_comparison_provider.dart';
import '../../application/providers/alignment/alignment_insight_provider.dart';
import '../../application/providers/nutrition_radar_provider.dart';
import '../../application/providers/intelligence_perma_provider.dart';
import 'placeholders/performance_seasonal_placeholder.dart';
import 'top_economy_bubble_chart.dart';
// 🔄 V4_UNIFIED_MEMBRANE: Import V4 unified membrane system
import '../../../climate/presentation/experimental/cellular_rosace_v4/unified_membrane_widget.dart';
import 'charts/vitamin_pie_chart.dart';
import 'charts/nutrition_radar_chart.dart';
import 'vitamin_suggestion_row.dart';
import 'kpi/alignment_kpi_card.dart';

/// Carte individuelle pour chaque pilier métier
///
/// Refactored for "Conscience du Vivant" - Containment & Polish
/// Responsibilities:
/// - Perfect circular containment (AspectRatio 1:1)
/// - Neon Glow & Glassmorphism aesthetics
/// - Responsive content scaling based on diameter
/// - No overflows
class StatisticsPillarCard extends ConsumerWidget {
  final PillarType type;

  const StatisticsPillarCard({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconAndTitle = switch (type) {
      PillarType.economieVivante => {'icon': '🌾', 'title': 'Économie Vivante'},
      PillarType.sante => {'icon': '🥗', 'title': 'Équilibre Nutritionnel'},
      PillarType.performance => {'icon': '🧠', 'title': 'Intelligence Perma'},
      PillarType.patrimoine => {'icon': '📜', 'title': 'Patrimoine'},
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: AspectRatio(
            aspectRatio: 1.0, // GARANTIT un cercle parfait
            child: LayoutBuilder(
              builder: (context, constraints) {
                final diameter = constraints.maxWidth;
                final innerPadding = diameter * 0.08; // 8% padding relatif
                final contentMaxWidth = diameter - innerPadding * 2;

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black, // Fond opaque pour masquer l'arrière-plan
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00FF88).withOpacity(0.18),
                        blurRadius: 60,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.04),
                        blurRadius: 12,
                        spreadRadius: -6,
                      ),
                    ],
                    border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // glassmorphism fort
                      child: Material(
                        color: Colors.white.withOpacity(0.06),
                        child: InkWell(
                          onTap: () {
                             final routeName = switch (type) {
                                PillarType.economieVivante => 'garden-stats-economie',
                                PillarType.sante => 'garden-stats-sante',
                                PillarType.performance => 'garden-stats-performance',
                                PillarType.patrimoine => 'garden-stats-patrimoine',
                              };

                              final state = GoRouterState.of(context);
                              final gardenId = state.pathParameters['id'];
                              if (gardenId != null) {
                                context.pushNamed(routeName, pathParameters: {'id': gardenId});
                              }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(innerPadding),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Header (icone + titre) — taille relative
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      iconAndTitle['icon']!,
                                      style: TextStyle(fontSize: diameter * 0.10, height: 1.0),
                                    ),
                                    SizedBox(height: diameter * 0.02),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        iconAndTitle['title']!.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          color: Colors.white.withOpacity(0.95),
                                          fontSize: diameter * 0.035, // Responsive generic size
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: diameter * 0.04),

                                // KPI central responsive
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                                    child: _buildKpiValueResponsive(context, ref, diameter),
                                  ),
                                ),

                                SizedBox(height: diameter * 0.02),

                                // Label descriptif
                                Text(
                                  _getKpiLabel(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.greenAccent.withOpacity(0.8),
                                    fontStyle: FontStyle.italic,
                                    fontSize: diameter * 0.03,
                                  ),
                                ),

                                SizedBox(height: diameter * 0.04),

                                // Zone graphique contenue (carrée)
                                SizedBox(
                                  width: contentMaxWidth * 0.6,
                                  height: contentMaxWidth * 0.6,
                                  child: _buildPlaceholderConstrained(type, contentMaxWidth * 0.6),
                                ),

                                SizedBox(height: diameter * 0.03),

                                // Contenu additionnel limité en hauteur
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: diameter * 0.25,
                                    maxWidth: contentMaxWidth,
                                  ),
                                  child: _buildCompactContentForType(type, context, ref, diameter),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a responsive KPI value scaled to the diameter
  Widget _buildKpiValueResponsive(BuildContext context, WidgetRef ref, double diameter) {
    // Existing logic returning Text widgets, we wrap them or style them.
    // Ideally we pass a style, but the existing methods return Text widgets with specific styles.
    // We will rely on the FittedBox parent in the build method to scale them down if they are too big.
    // But we can also return a simplified widget here.
    
    // For now, reuse logic but we might want to override styles if possible. 
    // Since _buildKpiValue logic is simple (returning Text), we can inline or call it.
    // Let's reimplement small parts to ensure style control.

    final style = TextStyle(
      fontSize: diameter * 0.12, // approx 12% of diameter size (e.g. 36px for 300px)
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    switch (type) {
      case PillarType.economieVivante:
        final totalValue = ref.watch(totalEconomyKpiProvider);
        return Text(
           totalValue > 0 ? '${totalValue.toStringAsFixed(0)} €' : '--',
           style: style,
        );
      case PillarType.sante:
        final vitaminDistributionAsync = ref.watch(vitaminDistributionProvider);
         return vitaminDistributionAsync.when(
          data: (distribution) {
            final detectedVitamins = distribution.values.where((value) => value > 0).length;
            return Text('$detectedVitamins/5', style: style);
          },
          loading: () => Text('...', style: style),
          error: (_, __) => Text('--', style: style),
        );
      case PillarType.performance:
        final comparisonAsync = ref.watch(seasonalComparisonProvider);
        return comparisonAsync.when(
          data: (comparison) {
             if (!comparison.hasPreviousSeason) return Text('--', style: style);
             // We can show just the score
             return Text('${comparison.overallScorePercentage}', style: style);
          },
          loading: () => Text('...', style: style),
          error: (_, __) => Text('--', style: style),
        );
      case PillarType.patrimoine:
         return Text('Export', style: style);
    }
  }

  String _getKpiLabel() {
    switch (type) {
      case PillarType.economieVivante:
        return 'Valeur totale des récoltes';
      case PillarType.sante:
        return 'Contribution Nutritionnelle';
      case PillarType.performance:
        return 'Intelligence Végétale';
      case PillarType.patrimoine:
        return 'Héritage & Transmission';
    }
  }

  Widget _buildPlaceholderConstrained(PillarType type, double size) {
    // Enforce square constraints
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: size,
        height: size,
        child: Builder(builder: (_) {
           switch (type) {
            case PillarType.economieVivante:
              return _buildV4UnifiedMembrane(size);
            case PillarType.sante:
              return _buildNutritionRadar(); 
            case PillarType.performance:
              return const PerformanceSeasonalPlaceholder();
            case PillarType.patrimoine:
              return const AlignmentKpiCard();
          }
        }),
      ),
    );
  }

  // --- Content Builders ---

  Widget _buildCompactContentForType(PillarType type, BuildContext context, WidgetRef ref, double diameter) {
     switch (type) {
      case PillarType.economieVivante:
         return _buildTop3PlantsBubblesResponsive(context, ref, diameter);
      case PillarType.sante:
         return _buildVitaminSuggestionsResponsive(context, ref, diameter);
      case PillarType.performance:
         return _buildIntelligenceSuggestionsResponsive(context, ref, diameter);
      case PillarType.patrimoine:
         return _buildPatrimoineActionsResponsive(context, ref, diameter);
    }
  }

  Widget _buildTop3PlantsBubblesResponsive(BuildContext context, WidgetRef ref, double diameter) {
    final top3Plants = ref.watch(top3PlantsValueRankingProvider);
    if (top3Plants.isEmpty) return const SizedBox.shrink();

    // Simplified view: just small bubbles or text
    // Re-using chart if it fits, or a list
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
             Text(
            'Top 3 Rentables',
             style: TextStyle(fontSize: diameter * 0.03, color: Colors.white70),
          ),
          SizedBox(height: diameter * 0.01),
          // We assume TopEconomyBubbleChart can fit or scale. 
          // If it's too big, we might need a simpler list.
          // Let's try scaling it down.
          Transform.scale(
            scale: 0.8,
            child: TopEconomyBubbleChart(rankings: top3Plants),
          ),
        ],
      )
    );
  }

  Widget _buildVitaminSuggestionsResponsive(BuildContext context, WidgetRef ref, double diameter) {
    final suggestionsAsync = ref.watch(vitaminRecommendationProvider);
    return suggestionsAsync.when(
      data: (suggestions) {
         if (suggestions.isEmpty) return const SizedBox.shrink();
         // Just show first suggestion if space is tight
         return SingleChildScrollView(
             physics: const BouncingScrollPhysics(),
             child: VitaminSuggestionRow(suggestions: suggestions)
         );
      },
      loading: () => const SizedBox.shrink(),
      error: (_,__) => const SizedBox.shrink(),
    );
  }

  Widget _buildIntelligenceSuggestionsResponsive(BuildContext context, WidgetRef ref, double diameter) {
    final suggestionsAsync = ref.watch(intelligencePermaProvider);
    return suggestionsAsync.when(
      data: (suggestions) {
        if (suggestions.isEmpty) {
          return Center(
            child: Text(
            'Jardin équilibré',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontStyle: FontStyle.italic, fontSize: diameter * 0.03),
          ));
        }
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
             final s = suggestions[index];
             return Padding(
               padding: const EdgeInsets.only(bottom: 4.0),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                    Text('🌱', style: TextStyle(fontSize: diameter * 0.04)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        s.plant.commonName,
                        style: TextStyle(color: Colors.white, fontSize: diameter * 0.035),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                 ],
               ),
             );
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_,__) => const SizedBox.shrink(),
    );
  }

  Widget _buildPatrimoineActionsResponsive(BuildContext context, WidgetRef ref, double diameter) {
     return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildExportButton(
              context,
              icon: Icons.picture_as_pdf_rounded,
              label: 'PDF',
              diameter: diameter,
              onTap: () {},
            ),
            SizedBox(width: diameter * 0.04),
            _buildExportButton(
              context,
              icon: Icons.table_chart_rounded,
              label: 'CSV',
              diameter: diameter,
              onTap: () {},
            ),
          ],
        );
  }

  Widget _buildExportButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap, required double diameter}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: diameter * 0.03, vertical: diameter * 0.02),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.greenAccent, size: diameter * 0.04),
             SizedBox(width: diameter * 0.02),
            Text(label, style: TextStyle(color: Colors.white, fontSize: diameter * 0.03)),
          ],
        ),
      ),
    );
  }

  // --- Specific Placeholders ---

   Widget _buildV4UnifiedMembrane(double size) {
    // V4 hierarchy: weather_current dominant, pH subtle nucleus
    final v4Hierarchy = {
      'weather_current': 1.0, 
      'soil_temp': 0.85, 
      'weather_forecast': 0.85, 
      'alerts': 0.75, 
      'ph_core': 0.35, 
    };

    // We pass explicit size to conform to container
    return UnifiedMembraneWidget(
      dataHierarchy: v4Hierarchy,
      height: size, 
      margin: EdgeInsets.zero, // No margin, we handle it in container
      onCellTap: (cellId) {
        debugPrint('Statistics cell tapped: $cellId');
      },
    );
  }

  Widget _buildNutritionRadar() {
    return Consumer(
      builder: (context, ref, child) {
        final radarDataAsync = ref.watch(nutritionRadarProvider);
        return radarDataAsync.when(
          data: (data) => NutritionRadarChart(data: data),
          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_,__) => const Icon(Icons.error_outline, color: Colors.white24),
        );
      }
    );
  }
}
