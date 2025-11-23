// lib/features/plant_intelligence/presentation/widgets/plant_checklist_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/di/intelligence_module.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';

import '../providers/intelligence_state_providers.dart';

class PlantChecklistCard extends ConsumerWidget {
  final String plantId;
  final String gardenId;
  final String plantName;
  final String? imageUrl;

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analyse démarrée...')),
    );

    try {
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
    final state = ref.watch(intelligenceStateProvider(gardenId));
    final repo = ref.read(IntelligenceModule.recommendationRepositoryProvider);

    /// 🔥 PRIORITÉ ABSOLUE : recos en mémoire (orchestrateur → notifier → UI)
    final List<Recommendation>? stateRecs = state.plantRecommendations[plantId];

    return GestureDetector(
      onTap: () => _onTapAnalyze(context, ref),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              const SizedBox(height: 8),

              //
              // 🔥 Cas 1 : recommandations disponibles dans l’état
              //
              if (stateRecs != null && stateRecs.isNotEmpty)
                ...stateRecs
                    .map((r) => _buildRecommendationTile(context, ref, r))

              //
              // 🔥 Cas 2 : aucune reco en mémoire => fallback repository
              //
              else
                FutureBuilder<List<Recommendation>>(
                  future: repo.getActiveRecommendations(
                    plantId: plantId,
                    limit: 20,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Chargement des recommandations…',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Erreur lors du chargement des recommandations',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }

                    final recs = snapshot.data ?? <Recommendation>[];

                    if (recs.isEmpty) {
                      return Text(
                        'Aucune action recommandée pour le moment',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    }

                    return Column(
                      children: recs
                          .map((r) => _buildRecommendationTile(context, ref, r))
                          .toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        if (_isValidImageUrl(imageUrl))
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl!,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => _fallbackFlower(context),
            ),
          )
        else
          _fallbackFlower(context),
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
          onPressed: () async {
            ref.invalidate(IntelligenceModule.recommendationRepositoryProvider);
            await ref
                .read(intelligenceStateProvider(gardenId).notifier)
                .analyzePlant(plantId);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rafraîchissement demandé')),
            );
          },
        ),
      ],
    );
  }

  Widget _fallbackFlower(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.local_florist),
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
        child: Text(
          rec.typeIcon.isNotEmpty ? rec.typeIcon.substring(0, 1) : '?',
        ),
      ),
      title: Text(rec.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        rec.instructions.join(' • '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
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
                    const SnackBar(content: Text('Marqué fait')),
                  );
                  ref.invalidate(
                      IntelligenceModule.recommendationRepositoryProvider);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur lors du marquage')),
                  );
                }
              },
      ),
    );
  }
}
