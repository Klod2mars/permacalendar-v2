import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/plant_entity.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../providers/plant_catalog_provider.dart';

class PlantDetailScreen extends ConsumerWidget {
  final String plantId;

  const PlantDetailScreen({
    super.key,
    required this.plantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final plantState = ref.watch(plantCatalogProvider);
    final plant = plantState.plants.where((p) => p.id == plantId).firstOrNull;

    if (plant == null) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Plante introuvable'),
        body: Center(
          child:
              Text('Cette plante n\'existe pas ou n\'a pas pu être chargée.'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: plant.commonName,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add to favorites
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('${plant.commonName} ajouté aux favoris')),
              );
            },
            icon: const Icon(Icons.favorite_border),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  // TODO: Implement share
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Partage à implémenter')),
                  );
                  break;
                case 'add_to_garden':
                  // TODO: Navigate to planting creation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ajout au jardin à implémenter')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_to_garden',
                child: Row(
                  children: [
                    Icon(Icons.add_circle),
                    SizedBox(width: 8),
                    Text('Ajouter au jardin'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Partager'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Header
            _buildPlantHeader(plant, theme),
            const SizedBox(height: 24),

            // Plant Details
            _buildPlantDetails(plant, theme),
            const SizedBox(height: 24),

            // Care Instructions
            _buildCareInstructions(plant, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantHeader(PlantFreezed plant, ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    _getPlantIcon(plant.family),
                    color: theme.colorScheme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.commonName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plant.scientificName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            if (plant.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                plant.description,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlantDetails(PlantFreezed plant, ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de culture',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Famille', plant.family, Icons.category, theme),
            _buildDetailRow('Durée de maturation',
                '${plant.daysToMaturity} jours', Icons.schedule, theme),
            _buildDetailRow(
                'Espacement', '${plant.spacing} cm', Icons.straighten, theme),
            _buildDetailRow(
                'Exposition', plant.sunExposure, Icons.wb_sunny, theme),
            _buildDetailRow(
                'Besoins en eau', plant.waterNeeds, Icons.water_drop, theme),
            _buildDetailRow('Saisons de plantation', plant.plantingSeason,
                Icons.calendar_month, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildCareInstructions(PlantFreezed plant, ThemeData theme) {
    final instructions = [
      'Arroser régulièrement selon les besoins de la plante',
      'Surveiller les signes de maladies ou de parasites',
      'Fertiliser selon les recommandations pour ${plant.family.toLowerCase()}',
      'Récolter au bon moment pour une qualité optimale',
    ];

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions générales',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...instructions.map((instruction) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          instruction,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlantIcon(String category) {
    switch (category) {
      case 'Légumes':
        return Icons.eco;
      case 'Fruits':
        return Icons.apple;
      case 'Aromates':
        return Icons.eco;
      case 'Fleurs':
        return Icons.eco;
      case 'Céréales':
        return Icons.grass;
      case 'Légumineuses':
        return Icons.grain;
      default:
        return Icons.eco;
    }
  }
}
