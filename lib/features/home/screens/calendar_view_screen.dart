import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/loading_widgets.dart';
import '../../planting/providers/planting_provider.dart';
import '../../../core/analytics/ui_analytics.dart';
import '../../../core/data/hive/garden_boxes.dart';
import '../../../core/models/activity.dart';
import '../../calendar/presentation/providers/calendar_filter_provider.dart';
import '../../../features/home/providers/calendar_aggregation_provider.dart';
import '../../../core/services/recurrence_service.dart';
import '../../../shared/widgets/create_task_dialog.dart';
import '../../../shared/services/task_document_generator.dart';
import 'dart:developer' as developer;

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
  List<Activity> _activities = [];
  Map<DateTime, List<Activity>> _dailyTasks =
      {}; // Cache pour les tâches du mois

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
        () async {
          await ref.read(plantingProvider.notifier).loadAllPlantings();
          // Load activities
          try {
            _activities =
                GardenBoxes.activities.values.cast<Activity>().toList();
            _updateDailyTasks();
          } catch (e) {
            print('Error loading activities: $e');
            _activities = [];
          }
        },
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

  Future<void> _askToExport(Activity created) async {
    final l10n = AppLocalizations.of(context)!;
    // Ask user if they want to export now
    final want = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.calendar_task_saved_title),
        content: Text(l10n.calendar_ask_export_pdf),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.common_no)),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.common_yes)),
        ],
      ),
    );

    if (want == true) {
      try {
        final file = await TaskDocumentGenerator.generateTaskPdf(created);
        await TaskDocumentGenerator.shareFile(
            file, 'application/pdf', context,
            shareText: 'Tâche PermaCalendar (PDF)');
      } catch (e, s) {
        developer.log('Export after create failed: $e\n$s');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.calendar_export_error(e)),
            backgroundColor: Colors.orange,
          ));
        }
      }
    }
  }

  void _updateDailyTasks() {
    _dailyTasks.clear();

    final startOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final endOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);

    // developer.log('[Calendar] Updating daily tasks. Total activities: ${_activities.length}');

    for (var activity in _activities) {
      // Filter only custom tasks
      final isCustom = activity.metadata['isCustomTask'] == true;
      if (!isCustom) continue; // Or handle other activity types if needed

      // Debug specific activity
      // developer.log('[Calendar] Processing custom task: ${activity.title}, nextRun=${activity.metadata['nextRunDate']}');

      // 1. Check Recurrence
      Map<String, dynamic>? recurrence;
      final rawRecurrence = activity.metadata['recurrence'];
      if (rawRecurrence is Map) {
        recurrence = rawRecurrence.cast<String, dynamic>();
      }

      if (recurrence != null) {
        // Project occurrences for the month
        // Start projection from CreatedAt or NextRunDate?
        // Let's start from a reasonable point relative to the month.
        // We need to find the first occurrence >= startOfMonth.

        // Strategy: Start from activity.createdAt (or metadata['nextRunDate'] if closer?)
        // and project forward until we pass endOfMonth.

        DateTime current = activity.createdAt;
        // Optimization: if createdAt is far in past, we could jump closer?
        // But RecurrenceService doesn't have "jump to".
        // For Phase 1, basic loop is fine as N is small.

        // Safety cap
        int safety = 0;
        while (current.isBefore(endOfMonth) && safety < 1000) {
          safety++;
          // Calc next
          final next =
              RecurrenceService.computeNextRunDate(recurrence, current);
          if (next == null) break;

          current = next;

          if (current.isAfter(endOfMonth)) break;

          if (current.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
              current.isBefore(endOfMonth.add(const Duration(days: 1)))) {
            final k = DateTime(current.year, current.month, current.day);
            _dailyTasks.putIfAbsent(k, () => []).add(activity);
          }
        }
      } else {
        // Single shot: use nextRunDate or timestamp
        String? dateStr = activity.metadata['nextRunDate'];
        DateTime? date;
        if (dateStr != null) {
          date = DateTime.tryParse(dateStr);
        } else {
          // Fallback to timestamp if no nextRunDate
          date = activity.timestamp;
        }

        if (date != null) {
           // Debug date parsing
           // developer.log('[Calendar] Task ${activity.title} date=$date selectedMonth=${_selectedMonth.month}');
        }

        if (date != null &&
            date.year == _selectedMonth.year &&
            date.month == _selectedMonth.month) {
          final k = DateTime(date.year, date.month, date.day);
          _dailyTasks.putIfAbsent(k, () => []).add(activity);
          // developer.log('[Calendar] Added task ${activity.title} to day $k');
        }
      }
    }
  }

  void _showTaskActions(Activity activity) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.send),
                title: Text(l10n.calendar_action_assign),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _assignOrSendActivity(activity);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text(l10n.common_delete),
                onTap: () {
                  Navigator.of(ctx).pop();
                  _confirmAndDeleteActivity(activity);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.common_edit),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _editActivity(activity);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editActivity(Activity activity) async {
    final result = await showDialog(
      context: context,
      builder: (_) => CreateTaskDialog(
        initialDate: activity.timestamp,
        activityToEdit: activity,
      ),
    );

    if (result != null && result is Map && result['task'] != null) {
      final Activity updated = result['task'] as Activity;
      // ExportOption removed
      
      await _loadCalendarData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.calendar_task_modified)));

        // Handle export if option selected or just prompt
          // Handle export if option selected or just prompt
          // Re-prompt always for consistency in this simplified flow
           _askToExport(updated);
        }
    }
  }

  Future<void> _confirmAndDeleteActivity(Activity activity) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.calendar_delete_confirm_title),
        content: Text(l10n.calendar_delete_confirm_content(activity.title)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.common_cancel)),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: Text(l10n.common_delete)),
        ],
      ),
    );

    if (confirmed != true) return;
    await _deleteActivityWithUndo(activity);
  }

  Future<void> _deleteActivityWithUndo(Activity activity) async {
    final l10n = AppLocalizations.of(context)!;
    final Activity deletedCopy = activity;
    try {
      await GardenBoxes.activities.delete(activity.id);
      await _loadCalendarData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.calendar_task_deleted),
          action: SnackBarAction(
            label: l10n.common_undo,
            onPressed: () async {
              try {
                await GardenBoxes.activities.put(deletedCopy.id, deletedCopy);
                await _loadCalendarData();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(l10n.calendar_restore_error(e))));
                }
              }
            },
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.calendar_delete_error(e))));
      }
    }
  }

  Future<void> _assignOrSendActivity(Activity activity) async {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController(
        text: activity.metadata['assignee']?.toString() ?? '');
    final String? recipient = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.calendar_assign_title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${l10n.calendar_assign_hint} :'),
              TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(hintText: l10n.calendar_assign_field)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(null),
                child: Text(l10n.common_cancel)),
            ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: const Text('OK')),
          ],
        );
      },
    );

    if (recipient == null || recipient.isEmpty) return;

    final newMeta = Map<String, dynamic>.from(activity.metadata);
    newMeta['assignee'] = recipient;

    final updated = Activity(
      id: activity.id,
      type: activity.type,
      title: activity.title,
      description: activity.description,
      entityId: activity.entityId,
      entityType: activity.entityType,
      timestamp: activity.timestamp,
      metadata: newMeta,
      createdAt: activity.createdAt,
      updatedAt: DateTime.now(),
      isActive: activity.isActive,
    );

    try {
      await GardenBoxes.activities.put(updated.id, updated);
      await _loadCalendarData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.calendar_task_assigned(recipient))));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.calendar_assign_error(e))));
      }
      return;
    }

    await _sendActivityIfNotSent(updated, recipient);
  }

  Future<void> _sendActivityIfNotSent(Activity activity, String? recipient) async {
    try {
      final file = await TaskDocumentGenerator.generateTaskPdf(activity);
      if (!mounted) return;
      await TaskDocumentGenerator.shareFile(file, 'application/pdf', context, shareText: 'Tâche PermaCalendar (PDF)');
      
      final newMeta = Map<String, dynamic>.from(activity.metadata);
      newMeta['sentAt'] = DateTime.now().toIso8601String();
      if (recipient != null && recipient.isNotEmpty) newMeta['sentTo'] = recipient;
      
      final updated = Activity(
        id: activity.id,
        type: activity.type,
        title: activity.title,
        description: activity.description,
        entityId: activity.entityId,
        entityType: activity.entityType,
        timestamp: activity.timestamp,
        metadata: newMeta,
        createdAt: activity.createdAt,
        updatedAt: DateTime.now(),
        isActive: activity.isActive,
      );
      
      await GardenBoxes.activities.put(updated.id, updated);
      await _loadCalendarData();
      
    } catch (e, s) {
      developer.log('Send task failed: $e\n$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final plantingState = ref.watch(plantingProvider);
    final allPlantings = ref.watch(plantingsListProvider);
    final calendarAggAsync =
        ref.watch(calendarAggregationProvider(_selectedMonth));

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.calendar_title,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              try {
                await _loadCalendarData();
                ref.invalidate(calendarAggregationProvider(_selectedMonth));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.calendar_refreshed),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.common_error_prefix(e)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            tooltip: l10n.common_refresh,
          ),
          IconButton(
            icon: const Icon(Icons.add_task),
            tooltip: l10n.calendar_new_task_tooltip,
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => CreateTaskDialog(initialDate: _selectedDate),
              );

              // Back-compat: if result was previously boolean true, keep behavior
              if (result == true) {
                await _loadCalendarData();
                return;
              }

              if (result != null && result is Map<String, dynamic> && result['task'] != null) {
                final Activity created = result['task'] as Activity;
                // ExportOption removed
                
                // Reload calendar to show new task
                await _loadCalendarData();

                // After the UI has settled, ask user if they want to export
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _askToExport(created);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          _buildFilterBar(theme),
          // Sélecteur de mois
          _buildMonthSelector(theme),

          // Calendrier mensuel
          Expanded(
            child: _errorMessage != null
                ? _buildErrorState(theme)
                : (_isLoading || plantingState.isLoading)
                    ? const Center(child: LoadingWidget())
                    : calendarAggAsync.when(
                        data: (calendarAgg) =>
                            _buildCalendar(theme, allPlantings, calendarAgg),
                        loading: () => const Center(child: LoadingWidget()),
                        error: (err, st) => _buildErrorState(theme),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
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
              l10n.common_error,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? l10n.common_general_error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _loadCalendarData,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector(ThemeData theme) {
    // Limites de navigation: 10 ans dans le passé et 5 ans dans le futur
    final l10n = AppLocalizations.of(context)!;
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
                      _updateDailyTasks();
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
                tooltip: canGoBack
                    ? l10n.calendar_previous_month
                    : l10n.calendar_limit_reached,
          ),
          Column(
            children: [
              Text(
                DateFormat('MMMM yyyy', l10n.localeName).format(_selectedMonth),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.calendar_drag_instruction,
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
                      _updateDailyTasks();
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
            tooltip: canGoForward
                ? l10n.calendar_next_month
                : l10n.calendar_limit_reached,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, List plantings,
      Map<String, Map<String, dynamic>> calendarAgg) {
    // Calculer les dates du mois
    final firstDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Calculer le premier jour de la semaine (lundi = 1)
    final firstWeekday = firstDayOfMonth.weekday;

    final filterState = ref.watch(calendarFilterProvider);

    // Filtrer les plantations pour le mois sélectionné (Detail view only)
    var monthPlantings = plantings.where((p) {
      if (filterState.selectedGardenBedId != null &&
          p.gardenBedId != filterState.selectedGardenBedId) {
        return false;
      }

      final plantedDate = p.plantedDate;
      final harvestStart = p.expectedHarvestStartDate;

      return (plantedDate.year == _selectedMonth.year &&
              plantedDate.month == _selectedMonth.month) ||
          (harvestStart != null &&
              harvestStart.year == _selectedMonth.year &&
              harvestStart.month == _selectedMonth.month);
    }).toList();

    // Filtres avancés
    if (filterState.showHarvestsOnly) {
      monthPlantings = monthPlantings
          .where((p) => p.expectedHarvestStartDate != null)
          .toList();
    }

    if (filterState.showUrgentOnly) {
      final now = DateTime.now();
      monthPlantings = monthPlantings.where((p) {
        final end = p.expectedHarvestEndDate;
        return end != null && end.isBefore(now) && p.status != 'Récolté';
      }).toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-têtes des jours
          _buildWeekdayHeaders(theme),
          const SizedBox(height: 8),

          // Grille du calendrier
          _buildCalendarGrid(
            theme,
            daysInMonth,
            firstWeekday,
            calendarAgg,
          ),

          const SizedBox(height: 24),

          // Liste détaillée du jour sélectionné
          if (_selectedDate != null) _buildDayDetails(theme, monthPlantings),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    // Génère les jours de la semaine (Lun, Mar...) via DateFormat
    // On prend un index de Lundi qui est le 1er jour.
    // Astuce: DateTime(2023, 10, 2) est un Lundi.
    final monday = DateTime(2023, 10, 2);
    final weekdays = List.generate(7, (index) {
      final date = monday.add(Duration(days: index));
      // Substring(0,1) pour avoir L, M, M...
      return DateFormat.E(l10n.localeName).format(date).substring(0, 1).toUpperCase();
    });

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
    Map<String, Map<String, dynamic>> calendarAgg,
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

      dayWidgets.add(
        _buildDayCell(
          date,
          day,
          isToday,
          isSelected,
          theme,
          calendarAgg,
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.75, // Reduced from 0.9 to give more vertical space
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(
    DateTime date,
    int day,
    bool isToday,
    bool isSelected,
    ThemeData theme,
    Map<String, Map<String, dynamic>> calendarAgg,
  ) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    final dayInfo = calendarAgg[key] ??
        {
          'plantingCount': 0,
          'wateringCount': 0,
          'harvestCount': 0,
          'overdueCount': 0,
          'frost': false
        };
    final plantingCount = dayInfo['plantingCount'] as int;
    final wateringCount = dayInfo['wateringCount'] as int;
    final harvestCount = dayInfo['harvestCount'] as int;
    final overdueCount = dayInfo['overdueCount'] as int;
    final frost = dayInfo['frost'] as bool;

    // Tâches personnalisées (filtrage)
    final filterState = ref.watch(calendarFilterProvider);
    final tasksForDay =
        _dailyTasks[DateTime(date.year, date.month, date.day)] ?? [];

    // Si showTasksOnly -> on cache les indicateurs classiques sauf s'ils sont pertinents ?
    // Le prompt dit "ne montrer que tasks".
    final bool showStd =
        !filterState.showTasksOnly && !filterState.showMaintenanceOnly;

    // Filtrer les tâches à afficher (Maintenance vs Generic)
    final visibleTasks = tasksForDay.where((t) {
      if (filterState.showMaintenanceOnly) {
        // maintenance actions
        final k = t.metadata['taskKind'];
        return k != 'generic' && k != 'buy' && k != 'harvest';
      }
      return true;
    }).toList();

    final hasTasks = visibleTasks.isNotEmpty;

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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: Container(
            width: 40, // Constraint width to ensure wrapping happens if needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(height: 2),

                // Indicateurs d'événements
                Column(
                  children: [
                    if (showStd && plantingCount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.eco, size: 12, color: Colors.green),
                          const SizedBox(width: 2),
                          Text('$plantingCount',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 9, color: Colors.green)),
                        ],
                      ),
                    if (showStd && wateringCount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.water_drop,
                              size: 12, color: Colors.blue),
                          const SizedBox(width: 2),
                          Text('$wateringCount',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 9, color: Colors.blue)),
                        ],
                      ),
                    if (showStd && harvestCount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_basket,
                              size: 12, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text('$harvestCount',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontSize: 9, color: Colors.orange)),
                        ],
                      ),
                    if (showStd && frost)
                      const Icon(Icons.ac_unit, size: 12, color: Colors.lightBlue),
                    if (showStd && overdueCount > 0)
                      const Icon(Icons.warning, size: 12, color: Colors.red),

                    // Tâches
                    if (hasTasks)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: visibleTasks.take(3).map((t) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: _buildTaskIcon(t.metadata['taskKind']),
                            );
                          }).toList(),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayDetails(ThemeData theme, List plantings) {
    if (_selectedDate == null) return Container();

    final date = _selectedDate!;

    final dayPlantings = plantings.where((p) {
      final plantedDate = p.plantedDate;
      return plantedDate.year == date.year &&
          plantedDate.month == date.month &&
          plantedDate.day == date.day;
    }).toList();

    final dayHarvests = plantings.where((p) {
      final harvestDate = p.expectedHarvestStartDate;
      return harvestDate != null &&
          harvestDate.year == date.year &&
          harvestDate.month == date.month &&
          harvestDate.day == date.day;
    }).toList();

    // Activities
    // final dayActivities = _activities.where((a) { ... })
    // REMPLACÉ par l'utilisation de _dailyTasks calculé
    final dateKey = DateTime(date.year, date.month, date.day);
    var dayActivities = _dailyTasks[dateKey] ?? [];

    final filterState = ref.watch(calendarFilterProvider);

    // Filtrage contextuel
    if (filterState.showTasksOnly || filterState.showMaintenanceOnly) {
      // Si mode Tâches, on cache les plantings/harvests
      if (filterState.showTasksOnly) {
        // dayPlantings et dayHarvests devraient être vides ou ignorés ici ?
        // Mais _buildDayDetails reçoit `List plantings` déjà filtré dans _buildCalendar.
        // On doit juste s'assurer que si showTasksOnly est actif, plantings est vide.
        // C'est déjà fait dans _buildCalendar (lignes 291+) ?
        // Non, _buildCalendar filtre plantings mais pas ici.
      }
    }

    // Filtrage local des tâches pour MaintenanceOnly
    if (filterState.showMaintenanceOnly) {
      dayActivities = dayActivities.where((t) {
        final k = t.metadata['taskKind'];
        return k != 'generic' && k != 'buy' && k != 'harvest';
      }).toList();
    }

    final l10n = AppLocalizations.of(context)!;
    // ...
    // Note: I can't put l10n here because ... wait, _buildDayDetails is a helper, needs locale passed or accessible.
    // It's in the state, so it has context.
    
    if (dayPlantings.isEmpty && dayHarvests.isEmpty && dayActivities.isEmpty) {
      return CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              l10n.calendar_no_events,
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
          l10n.calendar_events_of(DateFormat('d MMMM yyyy', l10n.localeName).format(date)),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (dayPlantings.isNotEmpty) ...[
          Text(
            l10n.calendar_section_plantings,
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
            l10n.calendar_section_harvests,
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
          const SizedBox(height: 12),
        ],
        if (dayActivities.isNotEmpty) ...[
          Text(
            l10n.calendar_section_tasks,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...dayActivities.map((a) => _buildEventCard(
                a.title,
                a.description ?? 'Pas de description',
                _getIconForKind(a.metadata['taskKind']),
                Colors.blueGrey,
                () {
                  // Behavior on tap (open details/edit not impl, stay same)
                },
                theme,
                onAction: () => _showTaskActions(a),
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
    ThemeData theme, {
    VoidCallback? onAction,
  }) {
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
                onAction != null
                    ? IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        onPressed: onAction,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    : Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskIcon(String? kind) {
    return Icon(_getIconForKind(kind),
        size: 10, color: Colors.blueGrey.shade700);
  }

  IconData _getIconForKind(String? kind) {
    switch (kind) {
      case 'seeding':
        return Icons.eco;
      case 'watering':
        return Icons.water_drop;
      case 'pruning':
        return Icons.content_cut;
      case 'weeding':
        return Icons.grass;
      case 'amendment':
        return Icons.spa;
      case 'treatment':
        return Icons.science;
      case 'harvest':
        return Icons.shopping_basket;
      case 'winter_protection':
        return Icons.ac_unit;
      case 'repair':
        return Icons.build;
      case 'clean':
        return Icons.cleaning_services; // ou Icons.brush
      case 'buy':
        return Icons.shopping_cart;
      default:
        return Icons.task_alt;
    }
  }

  Widget _buildFilterBar(ThemeData theme) {
    final filter = ref.watch(calendarFilterProvider);
    final notifier = ref.read(calendarFilterProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.calendar_filter_tasks),
            selected: filter.showTasksOnly,
            onSelected: (_) => notifier.toggleTasksOnly(),
            avatar: const Icon(Icons.task_alt, size: 16),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(l10n.calendar_filter_maintenance),
            selected: filter.showMaintenanceOnly,
            onSelected: (_) => notifier.toggleMaintenanceOnly(),
            avatar: const Icon(Icons.build, size: 16),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(l10n.calendar_filter_harvests),
            selected: filter.showHarvestsOnly,
            onSelected: (_) => notifier.toggleHarvestsOnly(),
            avatar: const Icon(Icons.shopping_basket, size: 16),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: Text(l10n.calendar_filter_urgent),
            selected: filter.showUrgentOnly,
            onSelected: (_) => notifier.toggleUrgentOnly(),
            backgroundColor:
                filter.showUrgentOnly ? Colors.red.withOpacity(0.2) : null,
            selectedColor: Colors.red.withOpacity(0.4),
            avatar: const Icon(Icons.warning, size: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
