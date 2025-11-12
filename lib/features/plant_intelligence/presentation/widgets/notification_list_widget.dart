import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_alert.dart';
import '../providers/notification_providers.dart';

/// Widget pour afficher la liste des notifications
class NotificationListWidget extends ConsumerWidget {
  final bool showOnlyUnread;
  final NotificationType? filterByType;
  final NotificationPriority? filterByPriority;

  const NotificationListWidget({
    super.key,
    this.showOnlyUnread = false,
    this.filterByType,
    this.filterByPriority,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = showOnlyUnread
        ? ref.watch(unreadNotificationsProvider)
        : ref.watch(activeNotificationsProvider);

    final notifier = ref.watch(notificationListNotifierProvider.notifier);

    return notificationsAsync.when(
      data: (notifications) {
        // Appliquer les filtres
        var filteredNotifications = notifications;

        if (filterByType != null) {
          filteredNotifications = filteredNotifications
              .where((n) => n.type == filterByType)
              .toList();
        }

        if (filterByPriority != null) {
          filteredNotifications = filteredNotifications
              .where((n) => n.priority == filterByPriority)
              .toList();
        }

        if (filteredNotifications.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: () async {
            await notifier.refresh();
          },
          child: ListView.separated(
            itemCount: filteredNotifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = filteredNotifications[index];
              return NotificationListTile(
                notification: notification,
                onTap: () => _onNotificationTap(context, ref, notification),
                onDismiss: () => notifier.dismiss(notification.id),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => notifier.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showOnlyUnread
                ? Icons.check_circle_outline
                : Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            showOnlyUnread
                ? 'Aucune notification non lue'
                : 'Aucune notification',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            showOnlyUnread
                ? 'Toutes les notifications ont été lues'
                : 'Vous n\'avez pas encore de notifications',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  void _onNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationAlert notification,
  ) {
    // Marquer comme lue
    if (notification.isUnread) {
      ref
          .read(notificationListNotifierProvider.notifier)
          .markAsRead(notification.id);
    }

    // TODO: Naviguer vers l'écran approprié selon le type de notification
    // Par exemple, si c'est une notification de plante, aller vers l'écran de cette plante
  }
}

/// Tuile de notification dans la liste
class NotificationListTile extends StatelessWidget {
  final NotificationAlert notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationListTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildPriorityChip(),
                const SizedBox(width: 8),
                Text(
                  notification.ageText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ],
        ),
        trailing: notification.isUnread
            ? Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getPriorityColor(),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    return CircleAvatar(
      backgroundColor: _getPriorityColor().withOpacity(0.2),
      child: Icon(
        _getTypeIcon(),
        color: _getPriorityColor(),
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getPriorityColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        notification.priority.displayName,
        style: TextStyle(
          fontSize: 11,
          color: _getPriorityColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.weatherAlert:
        return Icons.wb_sunny;
      case NotificationType.plantCondition:
        return Icons.spa;
      case NotificationType.recommendation:
        return Icons.lightbulb;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.criticalCondition:
        return Icons.warning;
      case NotificationType.optimalCondition:
        return Icons.wb_sunny_outlined;
    }
  }

  Color _getPriorityColor() {
    switch (notification.priority) {
      case NotificationPriority.low:
        return Colors.green;
      case NotificationPriority.medium:
        return Colors.orange;
      case NotificationPriority.high:
        return Colors.deepOrange;
      case NotificationPriority.critical:
        return Colors.red;
    }
  }
}

/// Badge de notification avec le nombre non lu
class NotificationBadge extends ConsumerWidget {
  final Widget child;

  const NotificationBadge({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return unreadCountAsync.when(
      data: (count) {
        if (count == 0) {
          return child;
        }

        return Badge(
          label: Text(count > 99 ? '99+' : count.toString()),
          backgroundColor: Colors.red,
          child: child,
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

