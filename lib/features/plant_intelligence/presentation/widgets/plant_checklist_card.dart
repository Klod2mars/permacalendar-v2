// Exemple : lib/features/plant_intelligence/presentation/widgets/plant_checklist_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/core/di/intelligence_module.dart';

class PlantChecklistCard extends ConsumerWidget {
  final String plantId;
  final String gardenId;
  final String plantName;
  final String imageUrl;

  const PlantChecklistCard({
    super.key,
    required this.plantId,
    required this.gardenId,
    required this.plantName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recRepo =
        ref.read(IntelligenceModule.recommendationRepositoryProvider);

    // Ici, on devrait utiliser un FutureProvider mais pour simplicité je fais fetch direct:
    return FutureBuilder<List<Recommendation>>(
      future: recRepo.getActiveRecommendations(plantId: plantId, limit: 20),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator()));
        }
        final recs = snapshot.data ?? [];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(imageUrl,
                            width: 52, height: 52, fit: BoxFit.cover),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(plantName,
                            style: Theme.of(context).textTheme.titleMedium)),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        // Invalide le cache ou re-génère
                        // ref.refresh(...);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...recs.map((r) => _buildRecommendationTile(context, ref, r)),
                if (recs.isEmpty)
                  Text('Aucune action recommandée pour le moment',
                      style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationTile(
      BuildContext context, WidgetRef ref, Recommendation rec) {
    final repo = ref.read(IntelligenceModule.recommendationRepositoryProvider);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            Color(int.parse(rec.priorityColor.replaceFirst('#', '0xff'))),
        child: Text(rec.typeIcon.substring(0, 1)),
      ),
      title: Text(rec.title),
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
                  // mise à jour minimaliste de l'UI : rebuild parent (ou utiliser provider)
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marqué fait')));
                  // Optionnel : régénérer la prochaine étape
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Erreur lors du marquage')));
                }
              },
      ),
    );
  }
}
