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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final isLoading = ref.read(plantingLoadingProvider);
        if (!isLoading) {
          ref.read(plantingProvider.notifier).loadAllPlantings();
        }
      });
    }

    // Helper local : récupère l'initialGrowthPercent en respectant les priorités
    double _getInitialPercent(Planting planting, PlantFreezed? plant) {
      try {
        final meta = planting.metadata ?? {};
        if (meta.containsKey('initialGrowthPercent')) {
          final v = meta['initialGrowthPercent'];
          if (v is num) return v.toDouble().clamp(0.0, 1.0);
          final parsed = double.tryParse(v?.toString() ?? '');
          return (parsed ?? 0.0).clamp(0.0, 1.0);
        }
      } catch (_) {}
      if (planting.status == 'Planté') {
        try {
          if (plant?.growth != null) {
            final raw = plant!.growth!['transplantInitialPercent'];
            if (raw is num) return raw.toDouble().clamp(0.0, 1.0);
            if (raw is String) {
              final p = double.tryParse(raw);
              if (p != null) return p.clamp(0.0, 1.0);
            }
          }
        } catch (_) {}
        return 0.3; // défaut Planté
      }
      return 0.0; // Semé
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
              final initialPercentDouble = _getInitialPercent(planting, plant);
              final initialPercentInt = (initialPercentDouble * 100).toInt();

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        '• ${plant?.commonName ?? planting.plantName} — $plantedDateStr',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: initialPercentInt > 0
                            ? Colors.green.withOpacity(0.12)
                            : Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$initialPercentInt%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: initialPercentInt > 0
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                      ),
                    ),
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
