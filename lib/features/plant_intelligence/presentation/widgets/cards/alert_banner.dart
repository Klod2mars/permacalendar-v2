import 'package:flutter/material.dart';

/// Bannière d'alerte intelligente
class AlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final AlertSeverity severity;
  final String? plantName;
  final DateTime? timestamp;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final bool showIcon;

  const AlertBanner({
    super.key,
    required this.title,
    required this.message,
    required this.severity,
    this.plantName,
    this.timestamp,
    this.onTap,
    this.onDismiss,
    this.dismissible = true,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertStyle = _getAlertStyle(theme);

    return Semantics(
      label: 'Alerte ${_getSeverityText(severity)}: $title. $message',
      button: onTap != null,
      child: RepaintBoundary(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: alertStyle.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    alertStyle.color.withValues(alpha: 0.1),
                    alertStyle.color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme, alertStyle),
                    const SizedBox(height: 8),
                    _buildContent(theme),
                    if (timestamp != null) ...[
                      const SizedBox(height: 8),
                      _buildTimestamp(theme),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, AlertStyle alertStyle) {
    return Row(
      children: [
        if (showIcon) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: alertStyle.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              alertStyle.icon,
              color: alertStyle.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: alertStyle.color,
                ),
              ),
              if (plantName != null)
                Text(
                  plantName!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        _buildSeverityBadge(theme, alertStyle),
        if (dismissible && onDismiss != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, size: 18),
            color: theme.colorScheme.onSurfaceVariant,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSeverityBadge(ThemeData theme, AlertStyle alertStyle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: alertStyle.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getSeverityText(severity),
        style: theme.textTheme.labelSmall?.copyWith(
          color: alertStyle.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Text(
      message,
      style: theme.textTheme.bodyMedium,
    );
  }

  Widget _buildTimestamp(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTimestamp(timestamp!),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  AlertStyle _getAlertStyle(ThemeData theme) {
    switch (severity) {
      case AlertSeverity.critical:
        return const AlertStyle(
          color: Colors.red,
          icon: Icons.error,
        );
      case AlertSeverity.high:
        return const AlertStyle(
          color: Colors.orange,
          icon: Icons.warning,
        );
      case AlertSeverity.medium:
        return const AlertStyle(
          color: Colors.blue,
          icon: Icons.info,
        );
      case AlertSeverity.low:
        return const AlertStyle(
          color: Colors.green,
          icon: Icons.check_circle,
        );
      default:
        return AlertStyle(
          color: theme.colorScheme.primary,
          icon: Icons.notification_important,
        );
    }
  }

  String _getSeverityText(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return 'CRITIQUE';
      case AlertSeverity.high:
        return 'ÉLEVÉE';
      case AlertSeverity.medium:
        return 'MOYENNE';
      case AlertSeverity.low:
        return 'FAIBLE';
      default:
        return 'INFO';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

/// Bannière d'alerte compacte pour les notifications
class CompactAlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final AlertSeverity severity;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool dismissible;

  const CompactAlertBanner({
    super.key,
    required this.title,
    required this.message,
    required this.severity,
    this.onTap,
    this.onDismiss,
    this.dismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertStyle = _getAlertStyle(theme);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: alertStyle.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: alertStyle.color.withValues(alpha: 0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(
                  alertStyle.icon,
                  color: alertStyle.color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: alertStyle.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        message,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (dismissible && onDismiss != null)
                  IconButton(
                    onPressed: onDismiss,
                    icon: const Icon(Icons.close, size: 16),
                    color: theme.colorScheme.onSurfaceVariant,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlertStyle _getAlertStyle(ThemeData theme) {
    switch (severity) {
      case AlertSeverity.critical:
        return const AlertStyle(
          color: Colors.red,
          icon: Icons.error,
        );
      case AlertSeverity.high:
        return const AlertStyle(
          color: Colors.orange,
          icon: Icons.warning,
        );
      case AlertSeverity.medium:
        return const AlertStyle(
          color: Colors.blue,
          icon: Icons.info,
        );
      case AlertSeverity.low:
        return const AlertStyle(
          color: Colors.green,
          icon: Icons.check_circle,
        );
      default:
        return AlertStyle(
          color: theme.colorScheme.primary,
          icon: Icons.notification_important,
        );
    }
  }
}

/// Widget pour afficher une liste d'alertes avec animation
class AlertBannerList extends StatefulWidget {
  final List<AlertData> alerts;
  final VoidCallback? onAlertTap;
  final VoidCallback? onAlertDismiss;
  final bool showAnimation;

  const AlertBannerList({
    super.key,
    required this.alerts,
    this.onAlertTap,
    this.onAlertDismiss,
    this.showAnimation = true,
  });

  @override
  State<AlertBannerList> createState() => _AlertBannerListState();
}

class _AlertBannerListState extends State<AlertBannerList>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didUpdateWidget(AlertBannerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.alerts.length != oldWidget.alerts.length) {
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeAnimations() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }

    _animationControllers = widget.alerts.map((_) {
      return AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
    }).toList();

    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ),
      );
    }).toList();

    if (widget.showAnimation) {
      _startAnimations();
    } else {
      // Si pas d'animation, mettre directement à 1.0
      for (final controller in _animationControllers) {
        controller.value = 1.0;
      }
    }
  }

  void _startAnimations() {
    // Utiliser addPostFrameCallback pour éviter les lags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _animationControllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 80), () {
          if (mounted && i < _animationControllers.length) {
            _animationControllers[i].forward();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: widget.alerts.asMap().entries.map((entry) {
        final index = entry.key;
        final alert = entry.value;

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - _animations[index].value) * 20),
              child: Opacity(
                opacity: _animations[index].value,
                child: AlertBanner(
                  title: alert.title,
                  message: alert.message,
                  severity: alert.severity,
                  plantName: alert.plantName,
                  timestamp: alert.timestamp,
                  onTap: widget.onAlertTap,
                  onDismiss: widget.onAlertDismiss,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

/// Énumération des niveaux de sévérité des alertes
enum AlertSeverity {
  critical,
  high,
  medium,
  low,
  info,
}

/// Style d'alerte
class AlertStyle {
  final Color color;
  final IconData icon;

  const AlertStyle({
    required this.color,
    required this.icon,
  });
}

/// Données d'une alerte
class AlertData {
  final String title;
  final String message;
  final AlertSeverity severity;
  final String? plantName;
  final DateTime? timestamp;

  const AlertData({
    required this.title,
    required this.message,
    required this.severity,
    this.plantName,
    this.timestamp,
  });
}
