ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_providers.dart';

/// Climate Forecast History Screen
///
/// Placeholder screen for weather forecast and historical data.
/// Will be implemented in Phase 2 with full forecast integration.
class ClimateForecastHistoryScreen extends ConsumerWidget {
  const ClimateForecastHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'PrÃƒÂ©visions & Historique',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/backgrounds/pexels-padrinan-3392246 (1).jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: _TimelineContent(theme: theme),
        ),
      ),
    );
  }
}

class _TimelineContent extends ConsumerWidget {
  const _TimelineContent({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(forecastHistoryProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: timelineAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.amber)),
            error: (e, _) => Center(
              child: Text('MÃƒÂ©tÃƒÂ©o indisponible',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: Colors.white70)),
            ),
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text('Aucune donnÃƒÂ©e',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.white70)),
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.white.withOpacity(0.08)),
                itemBuilder: (_, i) {
                  final d = items[i];
                  final isPast = d.isPast;
                  final dateLabel = _formatDate(d.date);
                  final tempLabel = _formatTemp(d.minTemp, d.maxTemp);
                  final precip = d.precipitation != null
                      ? '${d.precipitation!.toStringAsFixed(1)} mm'
                      : 'ââ‚¬”';
                  return Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (isPast ? Colors.cyan : Colors.amber)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Text(d.icon, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPast
                                  ? 'J- ${_daysAgo(d.date)} Ã‚Â· $dateLabel'
                                  : 'J+ ${_daysAhead(d.date)} Ã‚Â· $dateLabel',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.white60),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              d.description,
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(tempLabel,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(precip,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatTemp(double? min, double? max) {
    if (min != null && max != null) {
      return '${max.toStringAsFixed(0)}Ã‚Â°/${min.toStringAsFixed(0)}Ã‚Â°';
    }
    if (max != null) return '${max.toStringAsFixed(0)}Ã‚Â°';
    if (min != null) return '${min.toStringAsFixed(0)}Ã‚Â°';
    return 'ââ‚¬”';
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }

  int _daysAgo(DateTime d) {
    final now = DateTime.now();
    return now.difference(DateTime(d.year, d.month, d.day)).inDays;
  }

  int _daysAhead(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(d.year, d.month, d.day).difference(today).inDays;
  }
}



