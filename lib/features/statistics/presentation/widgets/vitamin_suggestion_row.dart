import 'package:flutter/material.dart';
import '../../domain/models/vitamin_suggestion.dart';

/// Widget pour afficher une ligne de suggestions de plantes vitaminiques
///
/// Affiche les 3 plantes recommandÃ©es sous forme de bulles colorÃ©es
/// similaires au style du Top 3 Ã‰conomie
class VitaminSuggestionRow extends StatelessWidget {
  final List<VitaminSuggestion> suggestions;

  const VitaminSuggestionRow({
    super.key,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return _buildNoRecommendations(context);
    }

    return Column(
      children: [
        Text(
          'Suggestions pour rÃ©Ã©quilibrer :',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        _buildSuggestionsBubbles(context),
      ],
    );
  }

  /// Construit les bulles de suggestions
  Widget _buildSuggestionsBubbles(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions.take(3).map((suggestion) {
        return _buildSuggestionBubble(context, suggestion);
      }).toList(),
    );
  }

  /// Construit une bulle individuelle pour une suggestion
  Widget _buildSuggestionBubble(
      BuildContext context, VitaminSuggestion suggestion) {
    final vitaminColor = _getVitaminColor(suggestion.vitaminKey);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: vitaminColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: vitaminColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // IcÃ´ne de la vitamine
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: vitaminColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                suggestion.vitaminDisplayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Nom de la plante et vitamine
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                suggestion.plant.commonName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              Text(
                '(${suggestion.vitaminDisplayName})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: vitaminColor,
                      fontSize: 10,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit le message quand aucune recommandation n'est nÃ©cessaire
  Widget _buildNoRecommendations(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Aucune recommandation nÃ©cessaire',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  /// Retourne la couleur associÃ©e Ã  une vitamine
  Color _getVitaminColor(String vitaminKey) {
    switch (vitaminKey) {
      case 'A':
        return const Color(0xFFFF8C42); // Orange
      case 'B':
        return const Color(0xFF4A90E2); // Bleu
      case 'C':
        return const Color(0xFF7ED321); // Vert clair
      case 'E':
        return const Color(0xFF9013FE); // Mauve
      case 'K':
        return const Color(0xFFFFD700); // Jaune pÃ¢le
      default:
        return Colors.grey;
    }
  }
}


