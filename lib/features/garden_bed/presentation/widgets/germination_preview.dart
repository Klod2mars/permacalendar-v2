// lib/features/garden_bed/presentation/widgets/germination_preview.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';

import '../../../../core/models/planting.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/core/services/plant_progress_service.dart';

/// Widget utilitaire réutilisable pour afficher un aperçu des plantations
/// Version Simplifiée : une ligne par planting -> "[Badge Statut] Nom [Badge %]"
class GerminationPreview extends ConsumerWidget {
  final dynamic gardenBed; // accepte GardenBedFreezed ou modèle équivalent
  final String? gardenBedId; // permet de passer directement l'ID si disponible
  final List<Planting>? allPlantings; // optionnel si parent fournit déjà
  final List<PlantFreezed>? plants; // optionnel si parent fournit déjà
  final bool forceRefresh; // Ajout pour forcer le rechargement

  const GerminationPreview({
    super.key,
    required this.gardenBed,
    this.gardenBedId,
    this.allPlantings,
    this.plants,
    this.forceRefresh = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bedId = gardenBedId ?? (gardenBed?.id ?? '');
    final List<Planting> allPlantingsList =
        allPlantings ?? ref.watch(plantingsListProvider);
    final List<PlantFreezed> plantsList =
        plants ?? ref.watch(plantsListProvider);

    // Recharger si nécessaire et demandé
    if (forceRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final isLoading = ref.read(plantingLoadingProvider);
        if (!isLoading) {
          ref.read(plantingProvider.notifier).loadAllPlantings();
        }
      });
    }

    final activePlantings = allPlantingsList
        .where((p) => p.isActive && p.gardenBedId == bedId)
        .toList();

    // SI AUCUNE DONNÉE, RETOURNER UN WIDGET VIDE
    if (activePlantings.isEmpty) {
      return const SizedBox.shrink();
    }

    // Vue synthétique : [Statut] Nom %
    // On retourne une Column (sans Card) pour l'intégrer proprement dans la carte parente
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...activePlantings.map((planting) {
          PlantFreezed? plant;
          try {
            plant = plantsList.firstWhere((p) => p.id == planting.plantId);
          } catch (_) {
            plant = null;
          }

          // Utilise le service centralisé pour obtenir le % de progression
          final double computed =
              PlantProgressService.computeProgress(planting, plant);
          final int percent = (computed * 100).toInt();

          final planted = planting.plantedDate;
          // Format: dd/MM
          final dateStr =
              '${planted.day.toString().padLeft(2, '0')}/${planted.month.toString().padLeft(2, '0')}';

          final theme = Theme.of(context);
          final statusColor = _getStatusColor(planting.status);
          final statusTextColor = _getStatusTextColor(planting.status, theme);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Badge Statut (ex: Planté)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    planting.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Nom de la plante + Date
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: plant?.commonName ?? planting.plantName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        // Date discrète
                        TextSpan(
                          text: '  $dateStr',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Badge Pourcentage
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: percent > 0
                        ? Colors.green.withOpacity(0.12)
                        : Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$percent%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: percent > 0 ? Colors.green : Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Semé':
        return Colors.orange.withOpacity(0.15); // Plus dynamique
      case 'Planté':
        return Colors.blue.withOpacity(0.15);
      case 'En croissance':
        return Colors.green.withOpacity(0.15);
      case 'Prêt à récolter':
        return Colors.amber.withOpacity(0.15);
      case 'Récolté':
        return Colors.grey.withOpacity(0.15);
      case 'Échoué':
        return Colors.red.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.15);
    }
  }

  Color _getStatusTextColor(String status, ThemeData theme) {
    switch (status) {
      case 'Semé':
        return Colors.deepOrange.shade300; // Plus visible
      case 'Planté':
        return Colors.blue.shade300;
      case 'En croissance':
        return Colors.green.shade300;
      case 'Prêt à récolter':
        return Colors.amber.shade400;
      case 'Récolté':
        return Colors.grey.shade700;
      case 'Échoué':
        return Colors.red.shade700;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
