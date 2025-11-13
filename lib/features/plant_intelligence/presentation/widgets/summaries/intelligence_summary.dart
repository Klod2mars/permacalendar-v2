import 'package:flutter/material.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import '../cards/alert_banner.dart';

/// RÃƒÂ©sumÃƒÂ© de l'intelligence vÃƒÂ©gÃƒÂ©tale pour un jardin
class IntelligenceSummary extends StatelessWidget {
  final List<PlantCondition> plantConditions;
  final List<Recommendation> recommendations;
  final WeatherCondition? currentWeather;
  final List<AlertData>? alerts;
  final String gardenName;
  final VoidCallback? onTap;
  final bool showDetails;

  const IntelligenceSummary({
    super.key,
    required this.plantConditions,
    required this.recommendations,
    this.currentWeather,
    this.alerts,
    required this.gardenName,
    this.onTap,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateStats();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 16),
              _buildOverviewStats(theme, stats),
              if (showDetails) ...[
                const SizedBox(height: 16),
                _buildHealthDistribution(theme, stats),
                const SizedBox(height: 16),
                _buildRecommendationsPreview(theme),
                if (alerts != null && alerts!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAlertsPreview(theme),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.psychology,
            color: theme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Intelligence VÃƒÂ©gÃƒÂ©tale',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                gardenName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildOverallHealthIndicator(theme),
      ],
    );
  }

  Widget _buildOverallHealthIndicator(ThemeData theme) {
    final stats = _calculateStats();
    final overallHealth = stats['averageHealth'] as double;
    final color = _getHealthColor(overallHealth);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            _getHealthIcon(overallHealth),
            color: color,
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            overallHealth.toStringAsFixed(1),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStats(ThemeData theme, Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            'Plantes analysÃƒÂ©es',
            '${stats['totalPlants']}',
            Icons.eco,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            theme,
            'Recommandations',
            '${stats['totalRecommendations']}',
            Icons.lightbulb,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            theme,
            'Alertes',
            '${stats['totalAlerts']}',
            Icons.warning,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDistribution(ThemeData theme, Map<String, dynamic> stats) {
    final distribution = stats['healthDistribution'] as Map<String, int>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribution de santÃƒÂ©',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDistributionBar(
                theme,
                'Excellente',
                distribution['excellent'] ?? 0,
                stats['totalPlants'] as int,
                Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDistributionBar(
                theme,
                'Bonne',
                distribution['good'] ?? 0,
                stats['totalPlants'] as int,
                Colors.lightGreen,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDistributionBar(
                theme,
                'Moyenne',
                distribution['fair'] ?? 0,
                stats['totalPlants'] as int,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildDistributionBar(
                theme,
                'Faible',
                distribution['poor'] ?? 0,
                stats['totalPlants'] as int,
                Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistributionBar(
    ThemeData theme,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? count / total : 0.0;

    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsPreview(ThemeData theme) {
    final priorityRecommendations =
        recommendations.where((r) => r.priority == 'HIGH').take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recommandations prioritaires',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${recommendations.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (priorityRecommendations.isNotEmpty)
          ...priorityRecommendations.map((recommendation) =>
              _buildRecommendationPreview(theme, recommendation))
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aucune recommandation prioritaire',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        if (recommendations.length > 2)
          TextButton(
            onPressed: onTap,
            child: Text(
              'Voir toutes les recommandations',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendationPreview(
      ThemeData theme, Recommendation recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.priority_high,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recommendation.title,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsPreview(ThemeData theme) {
    final alerts = this.alerts!;
    final criticalAlerts = alerts
        .where((a) => a.severity == AlertSeverity.critical)
        .take(2)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Alertes critiques',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${alerts.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (criticalAlerts.isNotEmpty)
          ...criticalAlerts.map(
            (alert) => CompactAlertBanner(
              title: alert.title,
              message: alert.message,
              severity: alert.severity,
              onTap: onTap,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Aucune alerte critique',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        if (alerts.length > 2)
          TextButton(
            onPressed: onTap,
            child: Text(
              'Voir toutes les alertes',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Map<String, dynamic> _calculateStats() {
    final totalPlants = plantConditions.length;
    final totalRecommendations = recommendations.length;
    final totalAlerts = alerts?.length ?? 0;

    // Calculer la santÃƒÂ© moyenne
    double averageHealth = 0.0;
    if (totalPlants > 0) {
      averageHealth = plantConditions
              .map((c) => c.healthScore)
              .reduce((a, b) => (a ?? 0.0) + b) /
          totalPlants;
    }

    // Distribution de santÃƒÂ©
    final healthDistribution = <String, int>{
      'excellent': 0,
      'good': 0,
      'fair': 0,
      'poor': 0,
    };

    for (final condition in plantConditions) {
      final score = condition.healthScore;
      if (score >= 80.0) {
        healthDistribution['excellent'] =
            (healthDistribution['excellent'] ?? 0) + 1;
      } else if (score >= 70.0) {
        healthDistribution['good'] = (healthDistribution['good'] ?? 0) + 1;
      } else if (score >= 60.0) {
        healthDistribution['fair'] = (healthDistribution['fair'] ?? 0) + 1;
      } else {
        healthDistribution['poor'] = (healthDistribution['poor'] ?? 0) + 1;
      }
    }

    return {
      'totalPlants': totalPlants,
      'totalRecommendations': totalRecommendations,
      'totalAlerts': totalAlerts,
      'averageHealth': averageHealth,
      'healthDistribution': healthDistribution,
    };
  }

  Color _getHealthColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    if (score >= 4.0) return Colors.red;
    return Colors.grey;
  }

  IconData _getHealthIcon(double score) {
    if (score >= 8.0) return Icons.health_and_safety;
    if (score >= 6.0) return Icons.eco;
    if (score >= 4.0) return Icons.warning;
    return Icons.error;
  }
}

/// RÃƒÂ©sumÃƒÂ© compact pour les listes
class CompactIntelligenceSummary extends StatelessWidget {
  final String gardenName;
  final int plantCount;
  final int recommendationCount;
  final int alertCount;
  final double averageHealth;
  final VoidCallback? onTap;

  const CompactIntelligenceSummary({
    super.key,
    required this.gardenName,
    required this.plantCount,
    required this.recommendationCount,
    required this.alertCount,
    required this.averageHealth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final healthColor = _getHealthColor(averageHealth);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.psychology,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gardenName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Intelligence VÃƒÂ©gÃƒÂ©tale',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuickStat(
                      theme, plantCount.toString(), Icons.eco, Colors.green),
                  const SizedBox(width: 8),
                  _buildQuickStat(theme, recommendationCount.toString(),
                      Icons.lightbulb, Colors.orange),
                  const SizedBox(width: 8),
                  if (alertCount > 0)
                    _buildQuickStat(theme, alertCount.toString(), Icons.warning,
                        Colors.red),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: healthColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  averageHealth.toStringAsFixed(1),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: healthColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(
      ThemeData theme, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    if (score >= 4.0) return Colors.red;
    return Colors.grey;
  }
}



