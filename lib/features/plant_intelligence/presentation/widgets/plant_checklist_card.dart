// lib/features/plant_intelligence/presentation/widgets/plant_checklist_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/core/di/intelligence_module.dart';

class PlantChecklistCard extends ConsumerWidget {
  final String plantId;
  final String gardenId;
  final String plantName;
  final String? imageUrl; // nullable

  const PlantChecklistCard({
    super.key,
    required this.plantId,
    required this.gardenId,
    required this.plantName,
    this.imageUrl,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  Future<void> _onTapAnalyze(BuildContext context, WidgetRef ref) async {
    // Feedback immédiat
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Analyse démarrée...')));

    try {
      // Lancer l'analyse via le notifier (mettra à jour l'état global)
      await ref
          .read(intelligenceStateProvider(gardenId).notifier)
          .analyzePlant(plantId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Analyse terminée')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur pendant l\'analyse : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recRepo =
        ref.read(IntelligenceModule.recommendationRepositoryProvider);

    return GestureDetector(
      onTap: () => _onTapAnalyze(context, ref),
      child: FutureBuilder<List<Recommendation>>(
        future: () async {
          try {
            return await recRepo.getActiveRecommendations(
                plantId: plantId, limit: 20);
          } catch (e) {
            rethrow;
          }
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                        width: 52, height: 52, color: Colors.grey.shade800),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 14,
                              color: Colors.grey.shade700),
                          const SizedBox(height: 8),
                          Container(
                              width: 150,
                              height: 12,
                              color: Colors.grey.shade700),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.local_florist, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(plantName,
                                  style:
                                      Theme.of(context).textTheme.titleMedium)),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              ref.invalidate(IntelligenceModule
                                  .recommendationRepositoryProvider);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Erreur lors du chargement des recommandations.',
                          style: Theme.of(context).textTheme.bodySmall),
                    ]),
              ),
            );
          }

          final recs = snapshot.data ?? <Recommendation>[];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_isValidImageUrl(imageUrl))
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl!,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) {
                              return Container(
                                width: 52,
                                height: 52,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                child: const Icon(Icons.local_florist),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_florist),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          plantName,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          // Forcer un reload des recommandations pour cette plante
                          ref.invalidate(IntelligenceModule
                              .recommendationRepositoryProvider);
                          // Lancer une analyse asynchrone (non-bloquante)
                          ref
                              .read(
                                  intelligenceStateProvider(gardenId).notifier)
                              .analyzePlant(plantId);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Rafraîchissement demandé')));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (recs.isNotEmpty)
                    ...recs
                        .map((r) => _buildRecommendationTile(context, ref, r))
                  else
                    Text('Aucune action recommandée pour le moment',
                        style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationTile(
      BuildContext context, WidgetRef ref, Recommendation rec) {
    final repo = ref.read(IntelligenceModule.recommendationRepositoryProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor:
            Color(int.parse(rec.priorityColor.replaceFirst('#', '0xff'))),
        child:
            Text(rec.typeIcon.isNotEmpty ? rec.typeIcon.substring(0, 1) : '?'),
      ),
      title: Text(rec.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(rec.instructions.join(' • '),
          maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: ElevatedButton(
        child: Text(rec.isCompleted ? 'Fait' : 'Action'),
        onPressed: rec.isCompleted
            ? null
            : () async {
                final success = await repo.markRecommendationAsApplied(
                  recommendationId: rec.id,
                  appliedAt: DateTime.now(),
                  notes: 'Marqué depuis checklist',
                );
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marqué fait')));
                  // On peut invalider le provider pour forcer refresh
                  ref.invalidate(
                      IntelligenceModule.recommendationRepositoryProvider);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erreur lors du marquage')));
                }
              },
      ),
    );
  }
}
