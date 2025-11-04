import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permacalendar/features/planting/providers/planting_provider.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';

import '../../../../core/models/planting.dart';
import '../../../plant_catalog/domain/entities/plant_entity.dart';

/// Widget utilitaire réutilisable pour afficher un aperçu de germination
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
      final provider = ref.read(plantingLoadingProvider);
      if (!provider) {
        ref.read(plantingProvider.notifier).loadAllPlantings();
      }
    }

    final activePlantings = allPlantingsList
        .where((p) => p.isActive && p.gardenBedId == bedId)
        .toList();

    // SI AUCUNE DONNÉE, RETOURNER UN WIDGET VIDE
    if (activePlantings.isEmpty) {
      return const SizedBox.shrink();
    }

    // Afficher les données réelles de germination pour chaque plantation active
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌱 Germination',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...activePlantings.map((planting) {
              PlantFreezed? plant;
              try {
                plant = plantsList.firstWhere((p) => p.id == planting.plantId);
              } catch (_) {
                plant = null;
              }

              final germ = plant?.germination;
              final time =
                  germ is Map<String, dynamic> ? germ['germinationTime'] : null;
              final minDays = (time is Map<String, dynamic>)
                  ? (time['min'] as num?)?.toInt()
                  : null;
              final maxDays = (time is Map<String, dynamic>)
                  ? (time['max'] as num?)?.toInt()
                  : null;

              if (minDays != null && maxDays != null) {
                final plantedDate = planting.plantedDate;
                final germStart = plantedDate.add(Duration(days: minDays));
                final germEnd = plantedDate.add(Duration(days: maxDays));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ${plant?.commonName ?? planting.plantName}: ${germStart.day}/${germStart.month} - ${germEnd.day}/${germEnd.month}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      _buildGerminationIndicator(germStart, germEnd),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

Widget _buildGerminationIndicator(DateTime start, DateTime end) {
  final now = DateTime.now();
  final totalDays = end.difference(start).inDays;
  final passedDays = now.difference(start).inDays;
  final safeTotal = totalDays <= 0 ? 1.0 : totalDays.toDouble();
  final progress = (passedDays / safeTotal).clamp(0.0, 1.0);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LinearProgressIndicator(value: progress),
      const SizedBox(height: 4),
      Text(
          '${passedDays.clamp(0, totalDays)} / ${totalDays > 0 ? totalDays : 1} jours',
          style: const TextStyle(fontSize: 11)),
    ],
  );
}
