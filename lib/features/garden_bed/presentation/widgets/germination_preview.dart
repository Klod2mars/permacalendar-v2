// lib/features/garden_bed/presentation/widgets/germination_preview.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';

import '../../../../core/models/planting.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/core/services/plant_progress_service.dart';

/// Widget utilitaire réutilisable pour afficher un aperçu de germination
/// Version "Minimal" : une ligne par planting -> "• Nom — dd/MM — XX%"
/// Affiche toujours la ligne (ne dépend plus uniquement de la plage de germination).
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

    // Vue synthétique : nom — date plantation/semi — badge %
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.eco, size: 18),
                const SizedBox(width: 8),
                const Text('Germination',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ...activePlantings.map((planting) {
              PlantFreezed? plant;
              try {
                plant = plantsList.firstWhere((p) => p.id == planting.plantId);
              } catch (_) {
                plant = null;
              }

              final planted = planting.plantedDate;
              final plantedDateStr =
                  '${planted.day.toString().padLeft(2, '0')}/${planted.month.toString().padLeft(2, '0')}';

              // Utilise le service centralisé pour obtenir le % de progression
              final double computed =
                  PlantProgressService.computeProgress(planting, plant);
              final int percent = (computed * 100).toInt();

              // Option : afficher la plage de germination sur une 2e ligne si disponible
              String? germinationRange;
              try {
                final germ = plant?.germination;
                final time = germ is Map<String, dynamic> ? germ['germinationTime'] : null;
                final minDays = (time is Map<String, dynamic>) ? (time['min'] as num?)?.toInt() : null;
                final maxDays = (time is Map<String, dynamic>) ? (time['max'] as num?)?.toInt() : null;
                if (minDays != null && maxDays != null) {
                  final germStart = planted.add(Duration(days: minDays));
                  final germEnd = planted.add(Duration(days: maxDays));
                  germinationRange =
                      '${germStart.day.toString().padLeft(2, '0')}/${germStart.month.toString().padLeft(2, '0')} - ${germEnd.day.toString().padLeft(2, '0')}/${germEnd.month.toString().padLeft(2, '0')}';
                }
              } catch (_) {
                germinationRange = null;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '• ${plant?.commonName ?? planting.plantName} — $plantedDateStr',
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: percent > 0
                                ? Colors.green.withOpacity(0.12)
                                : Colors.grey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$percent%',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: percent > 0 ? Colors.green : Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (germinationRange != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Germination: $germinationRange',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
