import 'package:flutter/material.dart';

/// Indicateur de santÃ© visuel pour une plante
class PlantHealthIndicator extends StatefulWidget {
  final double healthScore;
  final String? label;
  final double size;
  final bool showLabel;
  final bool showAnimation;
  final VoidCallback? onTap;

  const PlantHealthIndicator({
    super.key,
    required this.healthScore,
    this.label,
    this.size = 100,
    this.showLabel = true,
    this.showAnimation = true,
    this.onTap,
  });

  @override
  State<PlantHealthIndicator> createState() => _PlantHealthIndicatorState();
}

class _PlantHealthIndicatorState extends State<PlantHealthIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.showAnimation) {
      // DÃ©lai minimal pour Ã©viter le lag Ã  l'ouverture
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
  void didUpdateWidget(PlantHealthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animer seulement si le score change significativement
    if ((widget.healthScore - oldWidget.healthScore).abs() > 0.5) {
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
    final healthLevel = _getHealthLevel(widget.healthScore);
    final color = _getHealthColor(healthLevel);
    final healthText = _getHealthText(healthLevel);

    return Semantics(
      label: widget.label != null
          ? '${widget.label}, Score de santÃ©: ${widget.healthScore.toStringAsFixed(1)} sur 10, Ã‰tat: $healthText'
          : 'Score de santÃ©: ${widget.healthScore.toStringAsFixed(1)} sur 10, Ã‰tat: $healthText',
      button: widget.onTap != null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCircularIndicator(theme, color),
              if (widget.showLabel && widget.label != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.label!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getHealthText(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return 'Excellent';
      case HealthLevel.good:
        return 'Bon';
      case HealthLevel.fair:
        return 'Moyen';
      case HealthLevel.poor:
        return 'Faible';
      case HealthLevel.critical:
        return 'Critique';
    }
  }

  Widget _buildCircularIndicator(ThemeData theme, Color color) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedScore = widget.healthScore * _animation.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Cercle de fond
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            // Cercle de progression
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                value: animatedScore / 10.0,
                strokeWidth: 8,
                backgroundColor:
                    theme.colorScheme.outline.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            // Score et icÃ´ne au centre
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getHealthIcon(_getHealthLevel(animatedScore)),
                  size: widget.size * 0.3,
                  color: color,
                ),
                const SizedBox(height: 4),
                Text(
                  animatedScore.toStringAsFixed(1),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '/10',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  HealthLevel _getHealthLevel(double score) {
    if (score >= 8.0) return HealthLevel.excellent;
    if (score >= 7.0) return HealthLevel.good;
    if (score >= 6.0) return HealthLevel.fair;
    if (score >= 4.0) return HealthLevel.poor;
    return HealthLevel.critical;
  }

  Color _getHealthColor(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return Colors.green;
      case HealthLevel.good:
        return Colors.lightGreen;
      case HealthLevel.fair:
        return Colors.orange;
      case HealthLevel.poor:
        return Colors.red;
      case HealthLevel.critical:
        return Colors.red.shade800;
    }
  }

  IconData _getHealthIcon(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return Icons.health_and_safety;
      case HealthLevel.good:
        return Icons.eco;
      case HealthLevel.fair:
        return Icons.warning;
      case HealthLevel.poor:
        return Icons.error;
      case HealthLevel.critical:
        return Icons.dangerous;
    }
  }
}

/// Indicateur de santÃ© linÃ©aire (barre de progression)
class LinearPlantHealthIndicator extends StatelessWidget {
  final double healthScore;
  final String? label;
  final double height;
  final bool showAnimation;
  final VoidCallback? onTap;

  const LinearPlantHealthIndicator({
    super.key,
    required this.healthScore,
    this.label,
    this.height = 20,
    this.showAnimation = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final healthLevel = _getHealthLevel(healthScore);
    final color = _getHealthColor(healthLevel);
    final healthText = _getHealthText(healthLevel);

    return Semantics(
      label: label != null
          ? '$label: ${healthScore.toStringAsFixed(1)} sur 10, Ã‰tat: $healthText'
          : 'Score de santÃ©: ${healthScore.toStringAsFixed(1)} sur 10, Ã‰tat: $healthText',
      button: onTap != null,
      value: '${(healthScore * 10).toInt()}%',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label!,
                    style: theme.textTheme.labelMedium,
                  ),
                  Text(
                    '${healthScore.toStringAsFixed(1)}/10',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(height / 2),
                child: LinearProgressIndicator(
                  value: healthScore / 10.0,
                  backgroundColor:
                      theme.colorScheme.outline.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  HealthLevel _getHealthLevel(double score) {
    if (score >= 8.0) return HealthLevel.excellent;
    if (score >= 7.0) return HealthLevel.good;
    if (score >= 6.0) return HealthLevel.fair;
    if (score >= 4.0) return HealthLevel.poor;
    return HealthLevel.critical;
  }

  Color _getHealthColor(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return Colors.green;
      case HealthLevel.good:
        return Colors.lightGreen;
      case HealthLevel.fair:
        return Colors.orange;
      case HealthLevel.poor:
        return Colors.red;
      case HealthLevel.critical:
        return Colors.red.shade800;
    }
  }

  String _getHealthText(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return 'Excellent';
      case HealthLevel.good:
        return 'Bon';
      case HealthLevel.fair:
        return 'Moyen';
      case HealthLevel.poor:
        return 'Faible';
      case HealthLevel.critical:
        return 'Critique';
    }
  }
}

/// Indicateur de santÃ© compact (icÃ´ne avec score)
class CompactPlantHealthIndicator extends StatelessWidget {
  final double healthScore;
  final double size;
  final VoidCallback? onTap;

  const CompactPlantHealthIndicator({
    super.key,
    required this.healthScore,
    this.size = 32,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final healthLevel = _getHealthLevel(healthScore);
    final color = _getHealthColor(healthLevel);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size / 4),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              _getHealthIcon(healthLevel),
              size: size * 0.6,
              color: color,
            ),
            Positioned(
              bottom: 2,
              child: Text(
                healthScore.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: size * 0.25,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  HealthLevel _getHealthLevel(double score) {
    if (score >= 8.0) return HealthLevel.excellent;
    if (score >= 7.0) return HealthLevel.good;
    if (score >= 6.0) return HealthLevel.fair;
    if (score >= 4.0) return HealthLevel.poor;
    return HealthLevel.critical;
  }

  Color _getHealthColor(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return Colors.green;
      case HealthLevel.good:
        return Colors.lightGreen;
      case HealthLevel.fair:
        return Colors.orange;
      case HealthLevel.poor:
        return Colors.red;
      case HealthLevel.critical:
        return Colors.red.shade800;
    }
  }

  IconData _getHealthIcon(HealthLevel level) {
    switch (level) {
      case HealthLevel.excellent:
        return Icons.health_and_safety;
      case HealthLevel.good:
        return Icons.eco;
      case HealthLevel.fair:
        return Icons.warning;
      case HealthLevel.poor:
        return Icons.error;
      case HealthLevel.critical:
        return Icons.dangerous;
    }
  }
}

/// Widget pour afficher plusieurs indicateurs de santÃ© cÃ´te Ã  cÃ´te
class PlantHealthIndicatorsRow extends StatelessWidget {
  final Map<String, double> indicators;
  final double height;
  final VoidCallback? onTap;

  const PlantHealthIndicatorsRow({
    super.key,
    required this.indicators,
    this.height = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          children: indicators.entries.map((entry) {
            final label = entry.key;
            final score = entry.value;
            final color = _getScoreColor(score);

            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: score / 10.0,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        label.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: height * 0.4,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    if (score >= 4.0) return Colors.red;
    return Colors.grey;
  }
}

/// Niveaux de santÃ© d'une plante
enum HealthLevel {
  excellent,
  good,
  fair,
  poor,
  critical,
}



