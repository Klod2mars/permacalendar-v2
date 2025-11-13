import 'package:flutter/material.dart';
import 'package:permacalendar/features/plant_intelligence/domain/entities/recommendation.dart';

/// Widget optimisÃ© pour afficher une carte de recommandation
///
/// Utilise const constructors et optimisations pour minimiser les rebuilds
class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;
  final bool isApplied;
  final bool showPlantInfo;
  final bool compact;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onTap,
    this.onComplete,
    this.onDismiss,
    this.isApplied = false,
    this.showPlantInfo = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      return _buildCompactCard(theme);
    }

    return _buildFullCard(theme);
  }

  Widget _buildFullCard(ThemeData theme) {
    return Semantics(
      label:
          'Recommandation: ${recommendation.title}. ${recommendation.description}. PrioritÃ©: ${recommendation.priority}',
      button: onTap != null,
      child: AnimatedOpacity(
        opacity: isApplied ? 0.6 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isApplied ? 1 : 4,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(theme),
                  const SizedBox(height: 12),
                  _buildContent(theme),
                  if (recommendation.expectedImpact > 0) ...[
                    const SizedBox(height: 12),
                    _buildImpactSection(theme),
                  ],
                  const SizedBox(height: 16),
                  _buildActions(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(ThemeData theme) {
    return Semantics(
      label:
          'Recommandation: ${recommendation.title}. PrioritÃ©: ${recommendation.priority}',
      button: onTap != null,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  _getRecommendationIcon(recommendation.type.name),
                  color: _getPriorityColor(theme, recommendation.priority.name),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration:
                              isApplied ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        recommendation.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildPriorityChip(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getPriorityColor(theme, recommendation.priority.name)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getRecommendationIcon(recommendation.type.name),
            color: _getPriorityColor(theme, recommendation.priority.name),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recommendation.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: isApplied ? TextDecoration.lineThrough : null,
                ),
              ),
              if (showPlantInfo)
                Text(
                  'Plante: ${recommendation.plantId}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        _buildPriorityChip(theme),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Text(
      recommendation.description,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildImpactSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Impact attendu: ${(recommendation.expectedImpact * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme) {
    if (isApplied) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 24,
            semanticLabel: 'Recommandation appliquÃ©e',
          ),
          const SizedBox(width: 8),
          Text(
            'TerminÃ©',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        if (onComplete != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onComplete,
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Fait'),
            ),
          ),
        if (onComplete != null && onDismiss != null) const SizedBox(width: 8),
        if (onDismiss != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Ignorer'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriorityChip(ThemeData theme) {
    final color = _getPriorityColor(theme, recommendation.priority.name);
    final icon = _getPriorityIcon(recommendation.priority.name);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            recommendation.priority.name.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRecommendationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.grass;
      case 'protection':
        return Icons.shield;
      case 'pruning':
        return Icons.content_cut;
      case 'planting':
        return Icons.eco;
      case 'harvesting':
        return Icons.agriculture;
      case 'pest_control':
        return Icons.bug_report;
      case 'disease_prevention':
        return Icons.medical_services;
      default:
        return Icons.lightbulb;
    }
  }

  Color _getPriorityColor(ThemeData theme, String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
      case 'critical':
        return theme.colorScheme.error;
      case 'medium':
      case 'moderate':
        return Colors.orange;
      case 'low':
      case 'optional':
        return theme.colorScheme.secondary;
      default:
        return theme.colorScheme.primary;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
      case 'critical':
        return Icons.priority_high;
      case 'medium':
      case 'moderate':
        return Icons.remove;
      case 'low':
      case 'optional':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.remove;
    }
  }
}

/// Widget pour afficher une liste de recommandations avec animations
class RecommendationsList extends StatefulWidget {
  final List<Recommendation> recommendations;
  final Map<String, bool>? appliedRecommendations;
  final Function(Recommendation)? onTap;
  final Function(Recommendation)? onComplete;
  final Function(Recommendation)? onDismiss;
  final bool showAnimation;
  final bool compact;

  const RecommendationsList({
    super.key,
    required this.recommendations,
    this.appliedRecommendations,
    this.onTap,
    this.onComplete,
    this.onDismiss,
    this.showAnimation = true,
    this.compact = false,
  });

  @override
  State<RecommendationsList> createState() => _RecommendationsListState();
}

class _RecommendationsListState extends State<RecommendationsList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _itemAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _initializeAnimations();

    if (widget.showAnimation) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RecommendationsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recommendations.length != oldWidget.recommendations.length) {
      _initializeAnimations();
      if (widget.showAnimation) {
        _controller.reset();
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _itemAnimations.clear();
    for (int i = 0; i < widget.recommendations.length; i++) {
      final startInterval = (i * 0.1).clamp(0.0, 0.9);
      final endInterval = (startInterval + 0.3).clamp(0.1, 1.0);

      _itemAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(startInterval, endInterval, curve: Curves.easeOut),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recommendations.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.recommendations.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final recommendation = widget.recommendations[index];
        final isApplied =
            widget.appliedRecommendations?[recommendation.id] ?? false;

        if (!widget.showAnimation) {
          return RecommendationCard(
            recommendation: recommendation,
            isApplied: isApplied,
            onTap: widget.onTap != null
                ? () => widget.onTap!(recommendation)
                : null,
            onComplete: widget.onComplete != null
                ? () => widget.onComplete!(recommendation)
                : null,
            onDismiss: widget.onDismiss != null
                ? () => widget.onDismiss!(recommendation)
                : null,
            compact: widget.compact,
          );
        }

        return AnimatedBuilder(
          animation: _itemAnimations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - _itemAnimations[index].value) * 30),
              child: Opacity(
                opacity: _itemAnimations[index].value,
                child: child,
              ),
            );
          },
          child: RecommendationCard(
            recommendation: recommendation,
            isApplied: isApplied,
            onTap: widget.onTap != null
                ? () => widget.onTap!(recommendation)
                : null,
            onComplete: widget.onComplete != null
                ? () => widget.onComplete!(recommendation)
                : null,
            onDismiss: widget.onDismiss != null
                ? () => widget.onDismiss!(recommendation)
                : null,
            compact: widget.compact,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune recommandation',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vos plantes sont en excellente santÃ© !',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



