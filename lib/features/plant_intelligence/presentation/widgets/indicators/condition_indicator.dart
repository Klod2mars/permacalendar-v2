import 'package:flutter/material.dart';

/// Indicateur pour une condition spécifique (température, humidité, etc.)
class ConditionIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final IconData icon;
  final Color? color;
  final bool showValue;
  final bool showProgress;
  final VoidCallback? onTap;

  const ConditionIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.icon,
    this.color,
    this.showValue = true,
    this.showProgress = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? _getConditionColor(theme, value, maxValue);
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: indicatorColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, indicatorColor),
            if (showProgress) ...[
              const SizedBox(height: 8),
              _buildProgressBar(theme, indicatorColor, percentage),
            ],
            if (showValue) ...[
              const SizedBox(height: 4),
              _buildValue(theme, indicatorColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color indicatorColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: indicatorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 16,
            color: indicatorColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
      ThemeData theme, Color indicatorColor, double percentage) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: Container(
          decoration: BoxDecoration(
            color: indicatorColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildValue(ThemeData theme, Color indicatorColor) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${value.toStringAsFixed(1)} $unit',
          style: theme.textTheme.labelSmall?.copyWith(
            color: indicatorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getConditionColor(ThemeData theme, double value, double maxValue) {
    final percentage = value / maxValue;

    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.lightGreen;
    if (percentage >= 0.4) return Colors.orange;
    if (percentage >= 0.2) return Colors.red;
    return Colors.grey;
  }
}

/// Indicateur de condition compact pour les listes
class CompactConditionIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const CompactConditionIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? _getConditionColor(theme, value, maxValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: indicatorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: indicatorColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: indicatorColor,
            ),
            const SizedBox(width: 4),
            Text(
              '${value.toStringAsFixed(1)}$unit',
              style: theme.textTheme.labelSmall?.copyWith(
                color: indicatorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConditionColor(ThemeData theme, double value, double maxValue) {
    final percentage = value / maxValue;

    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.lightGreen;
    if (percentage >= 0.4) return Colors.orange;
    if (percentage >= 0.2) return Colors.red;
    return Colors.grey;
  }
}

/// Widget pour afficher plusieurs conditions dans une grille
class ConditionIndicatorsGrid extends StatelessWidget {
  final List<ConditionData> conditions;
  final int crossAxisCount;
  final VoidCallback? onConditionTap;

  const ConditionIndicatorsGrid({
    super.key,
    required this.conditions,
    this.crossAxisCount = 2,
    this.onConditionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: conditions.length,
      itemBuilder: (context, index) {
        final condition = conditions[index];
        return ConditionIndicator(
          label: condition.label,
          value: condition.value,
          maxValue: condition.maxValue,
          unit: condition.unit,
          icon: condition.icon,
          color: condition.color,
          onTap: onConditionTap,
        );
      },
    );
  }
}

/// Widget pour afficher les conditions dans une liste horizontale
class ConditionIndicatorsList extends StatelessWidget {
  final List<ConditionData> conditions;
  final double height;
  final VoidCallback? onConditionTap;

  const ConditionIndicatorsList({
    super.key,
    required this.conditions,
    this.height = 60,
    this.onConditionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: conditions.length,
        itemBuilder: (context, index) {
          final condition = conditions[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 8),
            child: ConditionIndicator(
              label: condition.label,
              value: condition.value,
              maxValue: condition.maxValue,
              unit: condition.unit,
              icon: condition.icon,
              color: condition.color,
              onTap: onConditionTap,
            ),
          );
        },
      ),
    );
  }
}

/// Widget pour afficher une condition avec un graphique en barre
class BarConditionIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final IconData icon;
  final Color? color;
  final bool showValue;
  final VoidCallback? onTap;

  const BarConditionIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.icon,
    this.color,
    this.showValue = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? _getConditionColor(theme, value, maxValue);
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: indicatorColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: indicatorColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showValue)
                  Text(
                    '${value.toStringAsFixed(1)} $unit',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: indicatorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        indicatorColor.withValues(alpha: 0.8),
                        indicatorColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConditionColor(ThemeData theme, double value, double maxValue) {
    final percentage = value / maxValue;

    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.lightGreen;
    if (percentage >= 0.4) return Colors.orange;
    if (percentage >= 0.2) return Colors.red;
    return Colors.grey;
  }
}

/// Données d'une condition
class ConditionData {
  final String label;
  final double value;
  final double maxValue;
  final String unit;
  final IconData icon;
  final Color? color;

  const ConditionData({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.icon,
    this.color,
  });
}
