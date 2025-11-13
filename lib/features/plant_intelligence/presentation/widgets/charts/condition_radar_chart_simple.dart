import 'package:flutter/material.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/plant_condition.dart';

/// Widget simplifiÃ© pour afficher un graphique radar des conditions d'une plante
/// OptimisÃ© pour minimiser les rebuilds avec RepaintBoundary
class ConditionRadarChartSimple extends StatefulWidget {
  final PlantCondition? plantCondition;
  final double size;
  final bool showLabels;
  final bool showAnimation;

  const ConditionRadarChartSimple({
    super.key,
    this.plantCondition,
    this.size = 200,
    this.showLabels = true,
    this.showAnimation = true,
  });

  @override
  State<ConditionRadarChartSimple> createState() =>
      _ConditionRadarChartSimpleState();
}

class _ConditionRadarChartSimpleState extends State<ConditionRadarChartSimple>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    if (widget.showAnimation && widget.plantCondition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ConditionRadarChartSimple oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plantCondition == null && widget.plantCondition != null) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.plantCondition == null) {
      return _buildEmptyChart(theme);
    }

    final typeLabel = _getTypeLabel(widget.plantCondition!.type);
    final semanticLabel =
        '$typeLabel: ${widget.plantCondition!.value.toStringAsFixed(1)} ${widget.plantCondition!.unit}, '
        'Score de santÃ©: ${widget.plantCondition!.healthScore.toStringAsFixed(0)}%, '
        'Ã‰tat: ${widget.plantCondition!.statusName}';

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Semantics(
              label: semanticLabel,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getHealthColor(widget.plantCondition!.healthScore)
                        .withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IcÃ´ne du type de condition
                    Icon(
                      _getTypeIcon(widget.plantCondition!.type),
                      size: widget.size * 0.2,
                      color:
                          _getHealthColor(widget.plantCondition!.healthScore),
                      semanticLabel: typeLabel,
                    ),
                    const SizedBox(height: 8),

                    // Valeur de la condition
                    Text(
                      '${widget.plantCondition!.value.toStringAsFixed(1)} ${widget.plantCondition!.unit}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            _getHealthColor(widget.plantCondition!.healthScore),
                      ),
                    ),

                    // Score de santÃ©
                    Text(
                      '${widget.plantCondition!.healthScore.toStringAsFixed(0)}%',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color:
                            _getHealthColor(widget.plantCondition!.healthScore),
                      ),
                    ),

                    if (widget.showLabels) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.plantCondition!.statusName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTypeLabel(ConditionType type) {
    switch (type) {
      case ConditionType.temperature:
        return 'TempÃ©rature';
      case ConditionType.humidity:
        return 'HumiditÃ©';
      case ConditionType.light:
        return 'LuminositÃ©';
      case ConditionType.soil:
        return 'Sol';
      case ConditionType.wind:
        return 'Vent';
      case ConditionType.water:
        return 'Eau';
    }
  }

  Widget _buildEmptyChart(ThemeData theme) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: widget.size * 0.3,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'Aucune donnÃ©e',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double healthScore) {
    if (healthScore >= 80) return Colors.green;
    if (healthScore >= 60) return Colors.orange;
    if (healthScore >= 40) return Colors.amber;
    return Colors.red;
  }

  IconData _getTypeIcon(ConditionType type) {
    switch (type) {
      case ConditionType.temperature:
        return Icons.thermostat;
      case ConditionType.humidity:
        return Icons.water_drop;
      case ConditionType.light:
        return Icons.light_mode;
      case ConditionType.soil:
        return Icons.terrain;
      case ConditionType.wind:
        return Icons.air;
      case ConditionType.water:
        return Icons.water;
    }
  }
}



