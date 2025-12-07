// lib/shared/widgets/plant_lifecycle_widget.dart
import 'package:flutter/material.dart';

import '../../core/services/plant_lifecycle_service.dart';
import '../../features/plant_catalog/domain/entities/plant_entity.dart';

/// Widget simplifié pour afficher le cycle de vie d'une plante
///
/// Compatible avec la nouvelle architecture PlantLifecycleService
class PlantLifecycleWidget extends StatelessWidget {
  final PlantFreezed plant;
  final DateTime plantingDate;
  final VoidCallback? onUpdateLifecycle;

  // NOUVEAU: champs optionnels pour permettre d'alimenter le calcul
  final double? initialProgressFromPlanting;
  final String? plantingStatus;

  /// NOUVEAU: permet de masquer la "Prochaine action" lorsqu'elle est redondante
  final bool showNextAction;

  const PlantLifecycleWidget({
    super.key,
    required this.plant,
    required this.plantingDate,
    this.onUpdateLifecycle,
    this.initialProgressFromPlanting,
    this.plantingStatus,
    this.showNextAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: PlantLifecycleService.calculateLifecycle(
        plant,
        plantingDate,
        initialProgressFromPlanting: initialProgressFromPlanting,
        plantingStatus: plantingStatus,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Erreur lors du calcul du cycle de vie',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Erreur: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        final lifecycle = snapshot.data!;
        return _buildLifecycleCard(context, lifecycle);
      },
    );
  }

  Widget _buildLifecycleCard(
      BuildContext context, Map<String, dynamic> lifecycle) {
    // Récupérations robustes des valeurs (sécurise les conversions)
    final String currentStage =
        (lifecycle['currentStage'] as String?)?.toString() ?? 'germination';

    final double progress = (() {
      final raw = lifecycle['progress'];
      if (raw is num) return raw.toDouble();
      if (raw is String) return double.tryParse(raw) ?? 0.0;
      return 0.0;
    })();

    final String nextAction =
        (lifecycle['nextAction'] as String?)?.toString() ?? '';

    // germinationDate peut être absent / nullable
    final DateTime? germinationDate = lifecycle['germinationDate'] is DateTime
        ? lifecycle['germinationDate'] as DateTime
        : null;

    final DateTime expectedHarvestDate =
        lifecycle['expectedHarvestDate'] is DateTime
            ? lifecycle['expectedHarvestDate'] as DateTime
            : DateTime.now().add(const Duration(days: 60));

    // initialProgress (0.0 .. 1.0) renvoyé par le service — par défaut 0.0
    final double initialProgress = (() {
      final raw = lifecycle['initialProgress'];
      if (raw is num) return (raw).toDouble().clamp(0.0, 1.0);
      if (raw is String) return (double.tryParse(raw) ?? 0.0).clamp(0.0, 1.0);
      return 0.0;
    })();

    // Décision d'affichage : ne montrer la germination que si initialProgress == 0
    final DateTime? germinationToShow =
        (initialProgress <= 0.0) ? germinationDate : null;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entête avec icône + progression
            _buildHeader(context, currentStage, progress),

            const SizedBox(height: 16),

            // Bloc dates (germination optionnelle + récolte)
            _buildDateInfo(context, germinationToShow, expectedHarvestDate),

            const SizedBox(height: 16),

            // Prochaine action (optionnel — peut être caché si showNextAction == false)
            if (showNextAction) _buildNextAction(context, nextAction),

            // Bouton optionnel pour forcer recalcul / mise à jour
            if (onUpdateLifecycle != null) ...[
              const SizedBox(height: 16),
              _buildActionButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, String currentStage, double progress) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _getStageIcon(currentStage),
              color: _getStageColor(currentStage),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _getStageDisplayName(currentStage),
              style: theme.textTheme.titleLarge?.copyWith(
                color: _getStageColor(currentStage),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceVariant,
          valueColor:
              AlwaysStoppedAnimation<Color>(_getStageColor(currentStage)),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}% du cycle complété',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo(BuildContext context, DateTime? germinationDate,
      DateTime expectedHarvestDate) {
    final now = DateTime.now();
    final theme = Theme.of(context);

    final int? daysToGermination =
        germinationDate != null ? germinationDate.difference(now).inDays : null;
    final int daysToHarvest = expectedHarvestDate.difference(now).inDays;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          if (germinationDate != null) ...[
            _buildDateRow(
              context,
              Icons.eco,
              'Germination',
              germinationDate,
              daysToGermination! > 0
                  ? 'Dans $daysToGermination jours'
                  : 'Passée',
              daysToGermination <= 0 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 8),
          ],
          _buildDateRow(
            context,
            Icons.shopping_basket,
            'Récolte prévue',
            expectedHarvestDate,
            daysToHarvest > 0 ? 'Dans $daysToHarvest jours' : 'Maintenant !',
            daysToHarvest <= 0 ? Colors.green : Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, IconData icon, String label,
      DateTime date, String timeText, Color color) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                '${date.day}/${date.month}/${date.year}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            timeText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextAction(BuildContext context, String nextAction) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline,
              color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prochaine action',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nextAction,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onUpdateLifecycle,
        icon: const Icon(Icons.update),
        label: const Text('Mettre à jour le cycle'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  IconData _getStageIcon(String stage) {
    switch (stage.toLowerCase()) {
      case 'germination':
        return Icons.eco;
      case 'croissance':
        return Icons.grass;
      case 'fructification':
        return Icons.local_florist;
      case 'récolte':
        return Icons.shopping_basket;
      default:
        return Icons.eco;
    }
  }

  Color _getStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'germination':
        return Colors.green;
      case 'croissance':
        return Colors.lightGreen;
      case 'fructification':
        return Colors.orange;
      case 'récolte':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  String _getStageDisplayName(String stage) {
    switch (stage.toLowerCase()) {
      case 'germination':
        return 'Germination';
      case 'croissance':
        return 'Croissance';
      case 'fructification':
        return 'Fructification';
      case 'récolte':
        return 'Récolte';
      default:
        return 'Germination';
    }
  }
}
