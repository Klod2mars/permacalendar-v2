import 'package:flutter/material.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/garden_context.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/weather_condition.dart';
import '../cards/alert_banner.dart';

/// Widget pour afficher une vue d'ensemble du jardin
class GardenOverviewWidget extends StatelessWidget {
  final GardenContext gardenContext;
  final WeatherCondition? currentWeather;
  final List<AlertData>? alerts;
  final VoidCallback? onTap;
  final bool showAlerts;
  final bool showWeather;

  const GardenOverviewWidget({
    super.key,
    required this.gardenContext,
    this.currentWeather,
    this.alerts,
    this.onTap,
    this.showAlerts = true,
    this.showWeather = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              _buildGardenStats(theme),
              if (showWeather && currentWeather != null) ...[
                const SizedBox(height: 16),
                _buildWeatherSection(theme),
              ],
              if (showAlerts && alerts != null && alerts!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildAlertsSection(theme),
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
            Icons.local_florist,
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
                gardenContext.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                gardenContext.location.city ??
                    gardenContext.location.address ??
                    'Location non spÃ©cifiÃ©e',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildGardenHealthBadge(theme),
      ],
    );
  }

  Widget _buildGardenHealthBadge(ThemeData theme) {
    final overallHealth = _calculateOverallHealth();
    final color = _getHealthColor(overallHealth);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getHealthIcon(overallHealth),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${overallHealth.toStringAsFixed(1)}/10',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenStats(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            'Plantes',
            gardenContext.stats.totalPlants.toString(),
            Icons.eco,
            Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            theme,
            'Parcelles',
            gardenContext.activePlantIds.length.toString(),
            Icons.grid_view,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            theme,
            'Plantations',
            gardenContext.stats.plantingsThisYear.toString(),
            Icons.agriculture,
            Colors.orange,
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
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherSection(ThemeData theme) {
    final weather = currentWeather!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.wb_sunny,
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Conditions mÃ©tÃ©orologiques',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildWeatherItem(
                  theme,
                  'TempÃ©rature',
                  weather.type == WeatherType.temperature
                      ? '${weather.value.toStringAsFixed(1)}${weather.unit}'
                      : 'N/A',
                  Icons.thermostat,
                  weather.type == WeatherType.temperature
                      ? _getTemperatureColor(weather.value)
                      : Colors.grey,
                ),
              ),
              Expanded(
                child: _buildWeatherItem(
                  theme,
                  'HumiditÃ©',
                  weather.type == WeatherType.humidity
                      ? '${weather.value.toStringAsFixed(0)}${weather.unit}'
                      : 'N/A',
                  Icons.water_drop,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildWeatherItem(
                  theme,
                  'PrÃ©cipitations',
                  weather.type == WeatherType.precipitation
                      ? '${weather.value.toStringAsFixed(1)}${weather.unit}'
                      : 'N/A',
                  Icons.water,
                  Colors.cyan,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
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

  Widget _buildAlertsSection(ThemeData theme) {
    final alerts = this.alerts!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.warning,
              size: 16,
              color: Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              'Alertes actives',
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
                '${alerts.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...alerts.take(2).map(
              (alert) => CompactAlertBanner(
                title: alert.title,
                message: alert.message,
                severity: alert.severity,
                onTap: onTap,
              ),
            ),
        if (alerts.length > 2)
          TextButton(
            onPressed: onTap,
            child: Text(
              'Voir ${alerts.length - 2} autres alertes',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  double _calculateOverallHealth() {
    // Calculer la santÃ© globale basÃ©e sur les plantes du jardin
    // Pour l'instant, on utilise une valeur par dÃ©faut
    return 7.5;
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

  Color _getTemperatureColor(double temperature) {
    if (temperature < 0) return Colors.blue;
    if (temperature < 10) return Colors.lightBlue;
    if (temperature < 20) return Colors.green;
    if (temperature < 30) return Colors.orange;
    return Colors.red;
  }
}

/// Widget compact pour afficher un aperÃ§u du jardin
class CompactGardenOverviewWidget extends StatelessWidget {
  final GardenContext gardenContext;
  final WeatherCondition? currentWeather;
  final int alertCount;
  final VoidCallback? onTap;

  const CompactGardenOverviewWidget({
    super.key,
    required this.gardenContext,
    this.currentWeather,
    this.alertCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  Icons.local_florist,
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
                      gardenContext.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      gardenContext.location.city ??
                          gardenContext.location.address ??
                          'Location non spÃ©cifiÃ©e',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (currentWeather != null &&
                  currentWeather!.type == WeatherType.temperature) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.thermostat,
                        size: 12,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${currentWeather!.value.toStringAsFixed(0)}${currentWeather!.unit}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (alertCount > 0) ...[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.warning,
                    size: 16,
                    color: Colors.orange,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher une liste de jardins
class GardenOverviewList extends StatelessWidget {
  final List<GardenContext> gardens;
  final Map<String, WeatherCondition>? weatherConditions;
  final Map<String, int>? alertCounts;
  final VoidCallback? onGardenTap;

  const GardenOverviewList({
    super.key,
    required this.gardens,
    this.weatherConditions,
    this.alertCounts,
    this.onGardenTap,
  });

  @override
  Widget build(BuildContext context) {
    if (gardens.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: gardens.map((garden) {
        final weather = weatherConditions?[garden.gardenId];
        final alertCount = alertCounts?[garden.gardenId] ?? 0;

        return CompactGardenOverviewWidget(
          gardenContext: garden,
          currentWeather: weather,
          alertCount: alertCount,
          onTap: onGardenTap,
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.local_florist_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            'Aucun jardin',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}



