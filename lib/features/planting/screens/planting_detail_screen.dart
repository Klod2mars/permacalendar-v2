ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
            _buildHeader(),

            // Widget principal du cycle de vie
            PlantLifecycleWidget(
              plant: plant,
              plantingDate: planting.plantedDate,
            ),

            // Informations détaillées sur la plante
            _buildPlantDetails(),

            // Conseils de culture
            _buildCulturalTips(),

            // Historique des actions (placeholder)
            _buildActionHistory(),
          ],
        ),
      ),
    );
  }

  /// Construit l'en-tête avec image et informations de base
  Widget _buildHeader() {
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
                            'Nom scientifique non disponible',
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
                          'Planté le ${DateFormat('dd/MM/yyyy').format(planting.plantedDate)}',
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
  Widget _buildPlantDetails() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations de culture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Temps de germination',
              '${plant.averageGerminationDays?.toInt() ?? 'Non spécifié'} jours',
              Icons.schedule,
            ),
            _buildDetailRow(
              'Temps de croissance',
              '${plant.daysToMaturity} jours',
              Icons.trending_up,
            ),
            _buildDetailRow(
              'Temps de récolte',
              '${plant.harvestTime ?? 'Non spécifié'} jours',
              Icons.agriculture,
            ),
            _buildDetailRow(
              'Espacement',
              '${plant.spacing} cm',
              Icons.straighten,
            ),
            _buildDetailRow(
              'Profondeur de semis',
              '${plant.depth} cm',
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
  Widget _buildCulturalTips() {
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
                const Text(
                  'Conseils de culture',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              plant.culturalTips?.join(', ') ?? 'Aucun conseil disponible',
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'historique des actions (placeholder)
  Widget _buildActionHistory() {
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
                const Text(
                  'Historique des actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildHistoryItem(
              'Plantation',
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
                  Text(
                    'L\'historique détaillé sera disponible prochainement',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
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


