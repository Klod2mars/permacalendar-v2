import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../core/models/activity.dart';

/// Widget rÃƒÂ©utilisable pour afficher une activitÃƒÂ© de maniÃƒÂ¨re uniforme

class ActivityItem extends StatelessWidget {
  final Activity activity;

  final VoidCallback? onTap;

  final bool showDate;

  final bool compact;

  const ActivityItem({
    super.key,
    required this.activity,
    this.onTap,
    this.showDate = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = _getActivityIcon(activity.type);

    final color = _getActivityColor(activity.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.all(compact ? 8.0 : 12.0),
        child: Row(
          children: [
            // IcÃƒÂ´ne avec couleur de fond

            Container(
              padding: EdgeInsets.all(compact ? 6 : 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: compact ? 16 : 20,
              ),
            ),

            SizedBox(width: compact ? 8 : 12),

            // Contenu de l'activitÃƒÂ©

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: (compact
                            ? theme.textTheme.bodySmall
                            : theme.textTheme.bodyMedium)
                        ?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!compact || activity.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      _buildSubtitle(),
                      style: (compact
                              ? theme.textTheme.bodySmall
                              : theme.textTheme.bodySmall)
                          ?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: compact ? 11 : null,
                      ),
                      maxLines: compact ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Timestamp (si demandÃƒÂ©)

            if (showDate && !compact) ...[
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(activity.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Construit le sous-titre en combinant description et mÃƒÂ©tadonnÃƒÂ©es

  String _buildSubtitle() {
    final parts = <String>[];

    // Ajouter des informations contextuelles selon le type d'activitÃƒÂ©

    if (activity.metadata.containsKey('gardenName')) {
      parts.add(activity.metadata['gardenName'] as String);
    }

    if (activity.metadata.containsKey('bedName')) {
      parts.add(activity.metadata['bedName'] as String);
    }

    if (activity.metadata.containsKey('plantName')) {
      parts.add(activity.metadata['plantName'] as String);
    }

    // Ajouter la description si elle n'est pas redondante avec le titre

    if (activity.description.isNotEmpty &&
        !activity.description
            .toLowerCase()
            .contains(activity.title.toLowerCase())) {
      parts.add(activity.description);
    }

    // Ajouter le timestamp si compact

    if (compact && showDate) {
      parts.add(_formatTimestamp(activity.timestamp));
    }

    return parts.join(' ââ‚¬Â¢ ');
  }

  /// Formate le timestamp de maniÃƒÂ¨re relative

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();

    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ãƒâ‚¬ l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  /// Retourne l'icÃƒÂ´ne appropriÃƒÂ©e pour le type d'activitÃƒÂ©

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.gardenCreated:
      case ActivityType.gardenUpdated:
        return Icons.eco;

      case ActivityType.gardenDeleted:
        return Icons.delete_outline;

      case ActivityType.bedCreated:
      case ActivityType.bedUpdated:
        return Icons.grid_view;

      case ActivityType.bedDeleted:
        return Icons.delete_outline;

      case ActivityType.plantingCreated:
        return Icons.eco;

      case ActivityType.plantingUpdated:
        return Icons.edit;

      case ActivityType.plantingHarvested:
        return Icons.agriculture;

      case ActivityType.plantingDeleted:
        return Icons.delete_outline;

      case ActivityType.careActionAdded:
        return Icons.flag;

      case ActivityType.germinationConfirmed:
        return Icons.eco;

      case ActivityType.plantCreated:
      case ActivityType.plantUpdated:
        return Icons.local_florist;

      case ActivityType.plantDeleted:
        return Icons.delete_outline;

      case ActivityType.weatherDataFetched:
        return Icons.wb_sunny;

      case ActivityType.weatherAlertTriggered:
        return Icons.warning;
    }
  }

  /// Retourne la couleur appropriÃƒÂ©e pour le type d'activitÃƒÂ©

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.gardenCreated:
      case ActivityType.bedCreated:
      case ActivityType.plantingCreated:
      case ActivityType.plantCreated:
      case ActivityType.germinationConfirmed:
        return Colors.green;

      case ActivityType.gardenUpdated:
      case ActivityType.bedUpdated:
      case ActivityType.plantingUpdated:
      case ActivityType.plantUpdated:
        return Colors.blue;

      case ActivityType.gardenDeleted:
      case ActivityType.bedDeleted:
      case ActivityType.plantingDeleted:
      case ActivityType.plantDeleted:
        return Colors.red;

      case ActivityType.plantingHarvested:
        return Colors.orange;

      case ActivityType.careActionAdded:
        return Colors.purple;

      case ActivityType.weatherDataFetched:
        return Colors.lightBlue;

      case ActivityType.weatherAlertTriggered:
        return Colors.amber;
    }
  }
}

/// Widget pour afficher une liste d'activitÃƒÂ©s avec un ÃƒÂ©tat vide

class ActivityList extends StatefulWidget {
  final List<Activity> activities;

  final bool isLoading;

  final String? error;

  final VoidCallback? onRetry;

  final void Function(Activity)? onActivityTap;

  final bool compact;

  final int? maxItems;

  final String emptyMessage;

  final IconData emptyIcon;

  final bool enablePagination;

  final int itemsPerPage;

  const ActivityList({
    super.key,
    required this.activities,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.onActivityTap,
    this.compact = false,
    this.maxItems,
    this.emptyMessage = 'Aucune activitÃƒÂ© rÃƒÂ©cente',
    this.emptyIcon = Icons.history,
    this.enablePagination = false,
    this.itemsPerPage = 20,
  });

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  late ScrollController _scrollController;

  int _currentPage = 1;

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    if (widget.enablePagination) {
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (!_isLoadingMore && _hasMoreItems()) {
      setState(() {
        _isLoadingMore = true;

        _currentPage++;
      });

      // Simuler un dÃƒÂ©lai de chargement

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      });
    }
  }

  bool _hasMoreItems() {
    final totalItems = widget.activities.length;

    final displayedItems = _currentPage * widget.itemsPerPage;

    return displayedItems < totalItems;
  }

  List<Activity> _getDisplayActivities() {
    if (widget.maxItems != null) {
      return widget.activities.take(widget.maxItems!).toList();
    }

    if (widget.enablePagination) {
      final endIndex = _currentPage * widget.itemsPerPage;

      return widget.activities.take(endIndex).toList();
    }

    return widget.activities;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    if (widget.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.onRetry != null) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('RÃƒÂ©essayer'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (widget.activities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.emptyIcon,
                size: 48,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                widget.emptyMessage,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Commencez par crÃƒÂ©er votre premier jardin !',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final displayActivities = _getDisplayActivities();

    if (widget.compact) {
      return ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayActivities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final activity = displayActivities[index];

          return ActivityItem(
            activity: activity,
            onTap: widget.onActivityTap != null
                ? () => widget.onActivityTap!(activity)
                : null,
            compact: true,
          );
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: displayActivities.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1, indent: 52),
            itemBuilder: (context, index) {
              final activity = displayActivities[index];

              return ActivityItem(
                activity: activity,
                onTap: widget.onActivityTap != null
                    ? () => widget.onActivityTap!(activity)
                    : null,
                compact: false,
              );
            },
          ),
        ),
        if (widget.enablePagination && _isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        if (widget.enablePagination && _hasMoreItems() && !_isLoadingMore)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton.icon(
              onPressed: _loadMoreItems,
              icon: const Icon(Icons.expand_more),
              label: const Text('Charger plus d\'activitÃƒÂ©s'),
            ),
          ),
      ],
    );
  }
}
