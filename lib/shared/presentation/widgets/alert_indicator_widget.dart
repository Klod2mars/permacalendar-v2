import 'package:flutter/material.dart';
import '../../../features/climate/presentation/providers/weather_providers.dart';

/// Widget indicateur d'alerte météo avec animation pulse
class AlertIndicatorWidget extends StatefulWidget {
  final WeatherAlertType type;
  final bool isActive;
  final VoidCallback? onTap;

  const AlertIndicatorWidget({
    super.key,
    required this.type,
    required this.isActive,
    this.onTap,
  });

  @override
  State<AlertIndicatorWidget> createState() => _AlertIndicatorWidgetState();
}

class _AlertIndicatorWidgetState extends State<AlertIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AlertIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isActive ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAlertColor(),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: _getAlertColor().withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _getAlertIcon(),
                size: 12,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getAlertColor() {
    switch (widget.type) {
      case WeatherAlertType.frost:
        return const Color(0xFF1976D2); // Bleu gel
      case WeatherAlertType.heatwave:
        return const Color(0xFFD32F2F); // Rouge chaleur
      case WeatherAlertType.watering:
        return const Color(0xFF0288D1); // Bleu eau
      case WeatherAlertType.protection:
        return const Color(0xFFF57C00); // Orange protection
    }
  }

  IconData _getAlertIcon() {
    switch (widget.type) {
      case WeatherAlertType.frost:
        return Icons.ac_unit; // ❄️
      case WeatherAlertType.heatwave:
        return Icons.whatshot; // 🌡️
      case WeatherAlertType.watering:
        return Icons.water_drop; // 💧
      case WeatherAlertType.protection:
        return Icons.shield; // 🛡️
    }
  }
}

/// Widget pour afficher une liste d'indicateurs d'alertes
class AlertIndicatorsList extends StatelessWidget {
  final List<WeatherAlert> alerts;
  final VoidCallback? onTap;
  final bool showCount;

  const AlertIndicatorsList({
    super.key,
    required this.alerts,
    this.onTap,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white70, size: 20),
          SizedBox(height: 4),
          Text("Aucune alerte",
              style: TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Indicateurs alertes
        Wrap(
          spacing: 4,
          children: alerts
              .map(
                (alert) => AlertIndicatorWidget(
                  type: alert.type,
                  isActive: true,
                  onTap: onTap,
                ),
              )
              .toList(),
        ),
        if (showCount) ...[
          const SizedBox(height: 4),
          Text(
            "${alerts.length} alerte${alerts.length > 1 ? 's' : ''}",
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ],
    );
  }
}

/// Widget pour afficher un indicateur d'alerte avec texte
class AlertIndicatorWithText extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback? onTap;

  const AlertIndicatorWithText({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _getAlertColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getAlertColor().withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertIndicatorWidget(
              type: alert.type,
              isActive: true,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    alert.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getAlertColor(),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAlertColor() {
    switch (alert.type) {
      case WeatherAlertType.frost:
        return const Color(0xFF1976D2); // Bleu gel
      case WeatherAlertType.heatwave:
        return const Color(0xFFD32F2F); // Rouge chaleur
      case WeatherAlertType.watering:
        return const Color(0xFF0288D1); // Bleu eau
      case WeatherAlertType.protection:
        return const Color(0xFFF57C00); // Orange protection
    }
  }
}
