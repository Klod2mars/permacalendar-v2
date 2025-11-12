import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/weather_alert_provider.dart';
import '../providers/weather_providers.dart';
import '../../../../shared/presentation/widgets/alert_indicator_widget.dart';

/// Écran de détail des alertes météo avec recommandations jardinage
class AlertsDetailScreen extends ConsumerWidget {
  const AlertsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(weatherAlertsProvider('default'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertes Météo"),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF1B5E20),
            ],
          ),
        ),
        child: alertsAsync.when(
          data: (alerts) => _buildAlertsContent(context, alerts),
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          error: (_, __) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.white70),
                SizedBox(height: 16),
                Text(
                  "Erreur de chargement",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                Text(
                  "Vérifiez votre connexion internet",
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsContent(BuildContext context, List<WeatherAlert> alerts) {
    final activeAlerts = alerts
        .where((alert) => DateTime.now().isBefore(alert.validUntil))
        .toList();

    if (activeAlerts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              "Aucune alerte météo",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Text(
              "Tout va bien pour vos plantes !",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    // Trier les alertes par priorité (critique > warning > info)
    activeAlerts.sort((a, b) {
      final severityOrder = {
        AlertSeverity.critical: 0,
        AlertSeverity.warning: 1,
        AlertSeverity.info: 2,
      };
      return severityOrder[a.severity]!.compareTo(severityOrder[b.severity]!);
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeAlerts.length,
      itemBuilder: (context, index) =>
          _buildAlertCard(context, activeAlerts[index]),
    );
  }

  Widget _buildAlertCard(BuildContext context, WeatherAlert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getAlertColor(alert).withOpacity(0.1),
              _getAlertColor(alert).withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de l'alerte
              Row(
                children: [
                  AlertIndicatorWidget(
                    type: alert.type,
                    isActive: true,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _getAlertColor(alert),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert.description,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge de sévérité
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAlertColor(alert),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getSeverityText(alert.severity),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Informations temporelles
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    "Valide jusqu'au ${_formatDateTime(alert.validUntil)}",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              // Température si disponible
              if (alert.temperature != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.thermostat, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      "Température : ${alert.temperature!.round()}°C",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],

              // Plantes concernées si disponibles
              if (alert.affectedPlants.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.local_florist,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Plantes concernées : ${alert.affectedPlants.join(", ")}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Recommandations
              if (alert.recommendations.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb,
                              size: 16, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            "Recommandations :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...alert.recommendations.map(
                        (rec) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• ",
                                  style: TextStyle(color: Colors.green[600])),
                              Expanded(
                                child: Text(
                                  rec,
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getAlertColor(WeatherAlert alert) {
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

  String _getSeverityText(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return "CRITIQUE";
      case AlertSeverity.warning:
        return "ATTENTION";
      case AlertSeverity.info:
        return "INFO";
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final alertDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (alertDate == today) {
      return "aujourd'hui à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (alertDate == today.add(const Duration(days: 1))) {
      return "demain à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else {
      return "${dateTime.day}/${dateTime.month} à ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    }
  }
}

