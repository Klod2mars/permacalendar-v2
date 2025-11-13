import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_alert.dart';
import '../providers/notification_providers.dart';
import '../widgets/notification_list_widget.dart';
import 'notification_preferences_screen.dart';

/// Écran principal des notifications
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  NotificationType? _filterType;
  NotificationPriority? _filterPriority;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          // Bouton de filtrage
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrer',
            onSelected: (value) {
              _handleFilterSelection(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_filters',
                child: Text('Effacer les filtres'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Par type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuItem(
                value: 'type_weather',
                child: Row(
                  children: [
                    const Icon(Icons.wb_sunny, size: 20),
                    const SizedBox(width: 8),
                    Text(NotificationType.weatherAlert.displayName),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'type_critical',
                child: Row(
                  children: [
                    const Icon(Icons.warning, size: 20),
                    const SizedBox(width: 8),
                    Text(NotificationType.criticalCondition.displayName),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'type_recommendation',
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, size: 20),
                    const SizedBox(width: 8),
                    Text(NotificationType.recommendation.displayName),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Par priorité',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuItem(
                value: 'priority_critical',
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(NotificationPriority.critical.displayName),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'priority_high',
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(NotificationPriority.high.displayName),
                  ],
                ),
              ),
            ],
          ),
          // Bouton pour marquer toutes comme lues
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tout marquer comme lu',
            onPressed: () async {
              await ref
                  .read(notificationListNotifierProvider.notifier)
                  .markAllAsRead();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Toutes les notifications marquées comme lues'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          // Bouton des paramètres
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Préférences',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPreferencesScreen(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Toutes'),
                  const SizedBox(width: 8),
                  unreadCountAsync.when(
                    data: (count) => count > 0
                        ? _buildCountBadge(count)
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const Tab(text: 'Non lues'),
            const Tab(text: 'Critiques'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Afficher les filtres actifs
          if (_filterType != null || _filterPriority != null)
            _buildActiveFiltersBar(),
          // Contenu des onglets
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Toutes les notifications
                NotificationListWidget(
                  showOnlyUnread: false,
                  filterByType: _filterType,
                  filterByPriority: _filterPriority,
                ),
                // Non lues
                NotificationListWidget(
                  showOnlyUnread: true,
                  filterByType: _filterType,
                  filterByPriority: _filterPriority,
                ),
                // Critiques
                _buildCriticalTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActiveFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 18),
          const SizedBox(width: 8),
          const Text('Filtres actifs : '),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                if (_filterType != null)
                  Chip(
                    label: Text(_filterType!.displayName),
                    onDeleted: () {
                      setState(() {
                        _filterType = null;
                      });
                    },
                    deleteIconColor: Theme.of(context).colorScheme.error,
                  ),
                if (_filterPriority != null)
                  Chip(
                    label: Text(_filterPriority!.displayName),
                    onDeleted: () {
                      setState(() {
                        _filterPriority = null;
                      });
                    },
                    deleteIconColor: Theme.of(context).colorScheme.error,
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _filterType = null;
                _filterPriority = null;
              });
            },
            child: const Text('Effacer tout'),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalTab() {
    final criticalNotificationsAsync =
        ref.watch(criticalUnreadNotificationsProvider);

    return criticalNotificationsAsync.when(
      data: (notifications) {
        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucune notification critique',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tout va bien avec vos plantes ! 🌱',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationListTile(
              notification: notification,
              onTap: () {
                // Marquer comme lue
                if (notification.isUnread) {
                  ref
                      .read(notificationListNotifierProvider.notifier)
                      .markAsRead(notification.id);
                }
              },
              onDismiss: () {
                ref
                    .read(notificationListNotifierProvider.notifier)
                    .dismiss(notification.id);
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Erreur: $error'),
      ),
    );
  }

  void _handleFilterSelection(String value) {
    setState(() {
      switch (value) {
        case 'clear_filters':
          _filterType = null;
          _filterPriority = null;
          break;
        case 'type_weather':
          _filterType = NotificationType.weatherAlert;
          break;
        case 'type_critical':
          _filterType = NotificationType.criticalCondition;
          break;
        case 'type_recommendation':
          _filterType = NotificationType.recommendation;
          break;
        case 'priority_critical':
          _filterPriority = NotificationPriority.critical;
          break;
        case 'priority_high':
          _filterPriority = NotificationPriority.high;
          break;
      }
    });
  }
}


