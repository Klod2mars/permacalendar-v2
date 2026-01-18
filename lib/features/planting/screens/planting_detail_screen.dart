import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../core/models/planting.dart';
import '../../../features/plant_catalog/domain/entities/plant_entity.dart';
import '../../../shared/widgets/plant_lifecycle_widget.dart';

/// Écran de détail d'une plantation avec cycle de vie interactif
class PlantingDetailScreen extends ConsumerWidget {
  final Planting planting;
  final PlantFreezed plant;

  const PlantingDetailScreen({
    super.key,
    required this.planting,
    required this.plant,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.commonName),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec image et informations de base
            _buildHeader(context),

            // Widget principal du cycle de vie
            PlantLifecycleWidget(
              plant: plant,
              plantingDate: planting.plantedDate,
              plantingStatus: planting.status,
              initialProgressFromPlanting: (() {
                final dynamic _v = planting.metadata?['initialGrowthPercent'];
                if (_v is num) return _v.toDouble();
                if (_v is String) return double.tryParse(_v);
                return null;
              })(),
            ),

            // Informations détaillées sur la plante
            _buildPlantDetails(context),

            // Conseils de culture
            _buildCulturalTips(context),

            // Historique des actions (placeholder)
            _buildActionHistory(context),
          ],
        ),
      ),
    );
  }

  /// Construit l'en-tête avec image et informations de base
  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Helper to format date consistent with ARB expectation (string)
    String fmtDate(DateTime d) => DateFormat('dd/MM/yyyy').format(d);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade600,
            Colors.green.shade400,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Placeholder pour image de la plante
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 40,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.commonName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        plant.scientificName ??
                            l10n.planting_info_scientific_name_none,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.planting_card_planted_date(fmtDate(planting.plantedDate)),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construit les informations détaillées sur la plante
  Widget _buildPlantDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.planting_info_culture_title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              l10n.planting_info_germination,
              plant.averageGerminationDays != null
                  ? l10n.planting_info_days(plant.averageGerminationDays!.toInt())
                  : l10n.planting_info_none,
              Icons.schedule,
            ),
            _buildDetailRow(
              l10n.planting_info_maturity, // Reuse reusing maturity key for growth time approx
              l10n.planting_info_days(plant.daysToMaturity),
              Icons.trending_up,
            ),
            _buildDetailRow(
              l10n.planting_info_harvest_time,
              plant.harvestTime != null
                  ? l10n.planting_info_days(plant.harvestTime!)
                  : l10n.planting_info_none,
              Icons.agriculture,
            ),
            _buildDetailRow(
              l10n.planting_info_spacing,
              l10n.planting_info_cm(plant.spacing),
              Icons.straighten,
            ),
            _buildDetailRow(
              l10n.planting_info_depth,
              l10n.planting_info_cm(plant.depth),
              Icons.height,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit une ligne de détail
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  /// Construit les conseils de culture
  Widget _buildCulturalTips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (plant.culturalTips == null || plant.culturalTips!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade600),
                const SizedBox(width: 8),
                Text(
                  l10n.planting_info_tips_title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plant.culturalTips?.join(', ') ?? l10n.planting_tips_none,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'historique des actions (placeholder)
  Widget _buildActionHistory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  l10n.planting_history_title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildHistoryItem(
              l10n.planting_history_action_planting,
              DateFormat('dd/MM/yyyy à HH:mm').format(planting.plantedDate),
              Icons.eco,
              Colors.green,
            ),

            // Placeholder pour d'autres actions

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.planting_history_todo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un élément d'historique
  Widget _buildHistoryItem(
    String action,
    String date,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
