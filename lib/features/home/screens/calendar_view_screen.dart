ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/loading_widgets.dart';
import '../../planting/providers/planting_provider.dart';
import '../../../core/analytics/ui_analytics.dart';

/// Vue calendrier simplifiée des plantations et récoltes prévues
class CalendarViewScreen extends ConsumerStatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  ConsumerState<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends ConsumerState<CalendarViewScreen> {
  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Log analytics
    UIAnalytics.calendarOpened(
      month: _selectedMonth.month,
      year: _selectedMonth.year,
    );

    // Use post-frame callback to avoid modifying provider during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCalendarData();
    });
  }

  Future<void> _loadCalendarData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await UIAnalytics.measureOperation(
        'calendar_load',
        () => ref.read(plantingProvider.notifier).loadAllPlantings(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur de chargement: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final plantingState = ref.watch(plantingProvider);
    final allPlantings = ref.watch(plantingsListProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calendrier de culture',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await _loadCalendarData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calendrier actualisé'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sélecteur de mois
          _buildMonthSelector(theme),

          // Calendrier mensuel
          Expanded(
            child: _errorMessage != null
                ? _buildErrorState(theme)
                : (_isLoading || plantingState.isLoading)
                    ? const Center(child: LoadingWidget())
                    : _buildCalendar(theme, allPlantings),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadCalendarData,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(ThemeData theme) {
    // Limites de navigation: 10 ans dans le passé et 5 ans dans le futur
    final now = DateTime.now();
    final minDate = DateTime(now.year - 10, 1, 1);
    final maxDate = DateTime(now.year + 5, 12, 31);
    final canGoBack = _selectedMonth.isAfter(minDate);
    final canGoForward = _selectedMonth.isBefore(maxDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: canGoBack
                ? () {
                    final oldMonth = _selectedMonth;
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month - 1,
                      );
                    });

                    // Log analytics
                    UIAnalytics.calendarMonthChanged(
                      fromMonth: oldMonth.month,
                      fromYear: oldMonth.year,
                      toMonth: _selectedMonth.month,
                      toYear: _selectedMonth.year,
                    );
                  }
                : null,
            tooltip: canGoBack ? 'Mois précédent' : 'Limite atteinte',
          ),
          Column(
            children: [
              Text(
                DateFormat('MMMM yyyy', 'fr_FR').format(_selectedMonth),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Glisser pour naviguer',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: canGoForward
                ? () {
                    final oldMonth = _selectedMonth;
                    setState(() {
                      _selectedMonth = DateTime(
                        _selectedMonth.year,
                        _selectedMonth.month + 1,
                      );
                    });

                    // Log analytics
                    UIAnalytics.calendarMonthChanged(
                      fromMonth: oldMonth.month,
                      fromYear: oldMonth.year,
                      toMonth: _selectedMonth.month,
                      toYear: _selectedMonth.year,
                    );
                  }
                : null,
            tooltip: canGoForward ? 'Mois suivant' : 'Limite atteinte',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, List plantings) {
    // Calculer les dates du mois
    final firstDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Calculer le premier jour de la semaine (lundi = 1)
    final firstWeekday = firstDayOfMonth.weekday;

    // Filtrer les plantations pour le mois sélectionné
    final monthPlantings = plantings.where((p) {
      final plantedDate = p.plantedDate;
      final harvestStart = p.expectedHarvestStartDate;

      return (plantedDate.year == _selectedMonth.year &&
              plantedDate.month == _selectedMonth.month) ||
          (harvestStart != null &&
              harvestStart.year == _selectedMonth.year &&
              harvestStart.month == _selectedMonth.month);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Légende
          _buildLegend(theme),
          const SizedBox(height: 16),

          // En-têtes des jours
          _buildWeekdayHeaders(theme),
          const SizedBox(height: 8),

          // Grille du calendrier
          _buildCalendarGrid(
            theme,
            daysInMonth,
            firstWeekday,
            monthPlantings,
          ),

          const SizedBox(height: 24),

          // Liste détaillée du jour sélectionné
          if (_selectedDate != null) _buildDayDetails(theme, monthPlantings),
        ],
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem(
              'Plantation',
              Colors.green,
              Icons.eco,
              theme,
            ),
            _buildLegendItem(
              'Récolte',
              Colors.orange,
              Icons.agriculture,
              theme,
            ),
            _buildLegendItem(
              'En retard',
              Colors.red,
              Icons.warning,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color,
    IconData icon,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders(ThemeData theme) {
    const weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(
    ThemeData theme,
    int daysInMonth,
    int firstWeekday,
    List plantings,
  ) {
    final now = DateTime.now();
    final List<Widget> dayWidgets = [];

    // Ajouter des espaces vides pour le début du mois
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Ajouter les jours du mois
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final isToday = date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      final isSelected = _selectedDate != null &&
          date.year == _selectedDate!.year &&
          date.month == _selectedDate!.month &&
          date.day == _selectedDate!.day;

      // Compter les événements du jour
      final dayPlantings = plantings.where((p) {
        final plantedDate = p.plantedDate;
        return plantedDate.year == date.year &&
            plantedDate.month == date.month &&
            plantedDate.day == date.day;
      }).length;

      final dayHarvests = plantings.where((p) {
        final harvestDate = p.expectedHarvestStartDate;
        return harvestDate != null &&
            harvestDate.year == date.year &&
            harvestDate.month == date.month &&
            harvestDate.day == date.day;
      }).length;

      final dayOverdue = plantings.where((p) {
        final harvestDate = p.expectedHarvestStartDate;
        return harvestDate != null &&
            p.status != 'Récolté' &&
            harvestDate.isBefore(date) &&
            harvestDate.year == date.year &&
            harvestDate.month == date.month &&
            harvestDate.day == date.day;
      }).length;

      dayWidgets.add(
        _buildDayCell(
          date,
          day,
          isToday,
          isSelected,
          dayPlantings,
          dayHarvests,
          dayOverdue,
          theme,
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.9,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(
    DateTime date,
    int day,
    bool isToday,
    bool isSelected,
    int plantingCount,
    int harvestCount,
    int overdueCount,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });

        // Log analytics
        UIAnalytics.calendarDateSelected(
          date: date,
          plantingCount: plantingCount,
          harvestCount: harvestCount,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : isToday
                  ? theme.colorScheme.secondaryContainer.withOpacity(0.3)
                  : null,
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Numéro du jour
            Text(
              '$day',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),

            // Indicateurs d'événements
            Column(
              children: [
                if (plantingCount > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.eco,
                        size: 12,
                        color: Colors.green,
                      ),
                      Text(
                        '$plantingCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                if (harvestCount > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.agriculture,
                        size: 12,
                        color: Colors.orange,
                      ),
                      Text(
                        '$harvestCount',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                if (overdueCount > 0)
                  const Icon(
                    Icons.warning,
                    size: 12,
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayDetails(ThemeData theme, List plantings) {
    if (_selectedDate == null) return Container();

    final dayPlantings = plantings.where((p) {
      final plantedDate = p.plantedDate;
      return plantedDate.year == _selectedDate!.year &&
          plantedDate.month == _selectedDate!.month &&
          plantedDate.day == _selectedDate!.day;
    }).toList();

    final dayHarvests = plantings.where((p) {
      final harvestDate = p.expectedHarvestStartDate;
      return harvestDate != null &&
          harvestDate.year == _selectedDate!.year &&
          harvestDate.month == _selectedDate!.month &&
          harvestDate.day == _selectedDate!.day;
    }).toList();

    if (dayPlantings.isEmpty && dayHarvests.isEmpty) {
      return CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Aucun événement ce jour',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Événements du ${DateFormat('d MMMM yyyy', 'fr_FR').format(_selectedDate!)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (dayPlantings.isNotEmpty) ...[
          Text(
            'Plantations',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...dayPlantings.map((p) => _buildEventCard(
                p.plantName,
                'Quantité: ${p.quantity}',
                Icons.eco,
                Colors.green,
                () => context.push('/plantings/${p.id}'),
                theme,
              )),
          const SizedBox(height: 12),
        ],
        if (dayHarvests.isNotEmpty) ...[
          Text(
            'Récoltes prévues',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...dayHarvests.map((p) => _buildEventCard(
                p.plantName,
                'Statut: ${p.status}',
                Icons.agriculture,
                Colors.orange,
                () => context.push('/plantings/${p.id}'),
                theme,
              )),
        ],
      ],
    );
  }

  Widget _buildEventCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


