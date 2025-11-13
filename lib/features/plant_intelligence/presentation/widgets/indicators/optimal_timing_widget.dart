import 'package:flutter/material.dart';

/// Widget pour afficher le timing optimal pour les actions de jardinage
class OptimalTimingWidget extends StatelessWidget {
  final OptimalTiming timing;
  final VoidCallback? onTap;
  final bool showDetails;

  const OptimalTimingWidget({
    super.key,
    required this.timing,
    this.onTap,
    this.showDetails = true,
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
              const SizedBox(height: 12),
              _buildTimingInfo(theme),
              if (showDetails) ...[
                const SizedBox(height: 12),
                _buildDetails(theme),
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTimingColor(timing.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTimingIcon(timing.status),
            color: _getTimingColor(timing.status),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timing.action,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getTimingStatusText(timing.status),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getTimingColor(timing.status),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(theme),
      ],
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final color = _getTimingColor(timing.status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getTimingStatusBadge(timing.status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimingInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timing optimal',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildTimingGrid(theme),
      ],
    );
  }

  Widget _buildTimingGrid(ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _buildTimingItem(theme, 'DÃƒÂ©but', timing.startDate),
        _buildTimingItem(theme, 'Fin', timing.endDate),
        _buildTimingItem(theme, 'Moment idÃƒÂ©al', timing.optimalDate),
        _buildTimingItem(theme, 'Urgence', _getUrgencyText(timing.urgency)),
      ],
    );
  }

  Widget _buildTimingItem(ThemeData theme, String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.toString(),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DÃƒÂ©tails',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            timing.details,
            style: theme.textTheme.bodySmall,
          ),
        ),
        if (timing.recommendations.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Recommandations',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...timing.recommendations.map((recommendation) =>
              _buildRecommendationItem(theme, recommendation)),
        ],
      ],
    );
  }

  Widget _buildRecommendationItem(ThemeData theme, String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recommendation,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimingColor(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return Colors.green;
      case TimingStatus.good:
        return Colors.lightGreen;
      case TimingStatus.acceptable:
        return Colors.orange;
      case TimingStatus.poor:
        return Colors.red;
      case TimingStatus.expired:
        return Colors.grey;
    }
  }

  IconData _getTimingIcon(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return Icons.schedule;
      case TimingStatus.good:
        return Icons.check_circle;
      case TimingStatus.acceptable:
        return Icons.warning;
      case TimingStatus.poor:
        return Icons.error;
      case TimingStatus.expired:
        return Icons.schedule_send;
    }
  }

  String _getTimingStatusText(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return 'Timing optimal';
      case TimingStatus.good:
        return 'Bon timing';
      case TimingStatus.acceptable:
        return 'Timing acceptable';
      case TimingStatus.poor:
        return 'Timing dÃƒÂ©favorable';
      case TimingStatus.expired:
        return 'Timing expirÃƒÂ©';
    }
  }

  String _getTimingStatusBadge(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return 'OPTIMAL';
      case TimingStatus.good:
        return 'BON';
      case TimingStatus.acceptable:
        return 'ACCEPTABLE';
      case TimingStatus.poor:
        return 'DÃƒâ€°FAVORABLE';
      case TimingStatus.expired:
        return 'EXPIRÃƒâ€°';
    }
  }

  String _getUrgencyText(TimingUrgency urgency) {
    switch (urgency) {
      case TimingUrgency.low:
        return 'Faible';
      case TimingUrgency.medium:
        return 'Moyenne';
      case TimingUrgency.high:
        return 'Ãƒâ€°levÃƒÂ©e';
      case TimingUrgency.critical:
        return 'Critique';
    }
  }
}

/// Widget compact pour afficher le timing optimal
class CompactOptimalTimingWidget extends StatelessWidget {
  final OptimalTiming timing;
  final VoidCallback? onTap;

  const CompactOptimalTimingWidget({
    super.key,
    required this.timing,
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
                  color: _getTimingColor(timing.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTimingIcon(timing.status),
                  color: _getTimingColor(timing.status),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timing.action,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${timing.startDate} - ${timing.endDate}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTimingColor(timing.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTimingStatusBadge(timing.status),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getTimingColor(timing.status),
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

  Color _getTimingColor(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return Colors.green;
      case TimingStatus.good:
        return Colors.lightGreen;
      case TimingStatus.acceptable:
        return Colors.orange;
      case TimingStatus.poor:
        return Colors.red;
      case TimingStatus.expired:
        return Colors.grey;
    }
  }

  IconData _getTimingIcon(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return Icons.schedule;
      case TimingStatus.good:
        return Icons.check_circle;
      case TimingStatus.acceptable:
        return Icons.warning;
      case TimingStatus.poor:
        return Icons.error;
      case TimingStatus.expired:
        return Icons.schedule_send;
    }
  }

  String _getTimingStatusBadge(TimingStatus status) {
    switch (status) {
      case TimingStatus.optimal:
        return 'OPTIMAL';
      case TimingStatus.good:
        return 'BON';
      case TimingStatus.acceptable:
        return 'ACCEPTABLE';
      case TimingStatus.poor:
        return 'DÃƒâ€°FAVORABLE';
      case TimingStatus.expired:
        return 'EXPIRÃƒâ€°';
    }
  }
}

/// Widget pour afficher une liste de timings optimaux
class OptimalTimingList extends StatelessWidget {
  final List<OptimalTiming> timings;
  final VoidCallback? onTimingTap;

  const OptimalTimingList({
    super.key,
    required this.timings,
    this.onTimingTap,
  });

  @override
  Widget build(BuildContext context) {
    if (timings.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: timings
          .map(
            (timing) => CompactOptimalTimingWidget(
              timing: timing,
              onTap: onTimingTap,
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            'Aucun timing optimal',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ãƒâ€°numÃƒÂ©ration des statuts de timing
enum TimingStatus {
  optimal,
  good,
  acceptable,
  poor,
  expired,
}

/// Ãƒâ€°numÃƒÂ©ration des niveaux d'urgence
enum TimingUrgency {
  low,
  medium,
  high,
  critical,
}

/// Classe pour reprÃƒÂ©senter un timing optimal
class OptimalTiming {
  final String action;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime optimalDate;
  final TimingStatus status;
  final TimingUrgency urgency;
  final String details;
  final List<String> recommendations;

  const OptimalTiming({
    required this.action,
    required this.startDate,
    required this.endDate,
    required this.optimalDate,
    required this.status,
    required this.urgency,
    required this.details,
    required this.recommendations,
  });

  factory OptimalTiming.fromMap(Map<String, dynamic> map) {
    return OptimalTiming(
      action: map['action'] ?? '',
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      optimalDate: DateTime.parse(map['optimal_date']),
      status: TimingStatus.values.firstWhere(
        (e) => e.toString() == 'TimingStatus.${map['status']}',
        orElse: () => TimingStatus.acceptable,
      ),
      urgency: TimingUrgency.values.firstWhere(
        (e) => e.toString() == 'TimingUrgency.${map['urgency']}',
        orElse: () => TimingUrgency.medium,
      ),
      details: map['details'] ?? '',
      recommendations: List<String>.from(map['recommendations'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'optimal_date': optimalDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'urgency': urgency.toString().split('.').last,
      'details': details,
      'recommendations': recommendations,
    };
  }
}



