// lib/features/planting/presentation/widgets/planting_steps_widget.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/plant.dart';
import '../../../../core/models/planting.dart';
import '../../../../core/models/activity.dart'; // Added
import '../../../../core/data/hive/garden_boxes.dart'; // Added
import '../../../../core/services/notification_service.dart';
import '../../domain/plant_step.dart';
import '../../domain/plant_steps_generator.dart';
import '../../../../core/models/garden_bed.dart';

typedef OnAddCareAction = Future<void> Function(String action);
typedef OnMarkDone = Future<void> Function(PlantStep step);

/// Widget d'affichage du pas-à-pas (compact / détaillé).
class PlantingStepsWidget extends StatefulWidget {
  final Plant plant;
  final Planting planting;
  final OnAddCareAction? onAddCareAction;
  final OnMarkDone? onMarkDone;

  const PlantingStepsWidget({
    Key? key,
    required this.plant,
    required this.planting,
    this.onAddCareAction,
    this.onMarkDone,
  }) : super(key: key);

  @override
  State<PlantingStepsWidget> createState() => _PlantingStepsWidgetState();
}

class _PlantingStepsWidgetState extends State<PlantingStepsWidget> {
  bool _expanded = false;
  List<PlantStep> _customSteps = [];
  final Uuid _uuid = const Uuid();

  // Local cache of steps marked done in this UI session (instant feedback)
  final Set<String> _locallyCompleted = {};

  List<PlantStep> _getComputedSteps(AppLocalizations l10n) =>
      generateSteps(widget.plant, widget.planting, l10n);

  @override
  void initState() {
    super.initState();
    _loadCustomSteps();
  }

  void _loadCustomSteps() {
    final raw = widget.planting.metadata['customSteps'];
    if (raw is List) {
      _customSteps = raw.map<PlantStep>((e) {
        try {
          // e is expected to be a Map<String,dynamic>
          // Safe cast/map access
          final map = e is Map ? e : {};
          final scheduled = map['scheduledDate'] != null
              ? DateTime.tryParse(map['scheduledDate'].toString())
              : null;
          
          return PlantStep(
            id: map['id']?.toString() ?? _uuid.v4(),
            title: map['title']?.toString() ?? '',
            description: map['description']?.toString() ?? '',
            scheduledDate: scheduled,
            category: map['category']?.toString() ?? 'custom',
            recommended: map['recommended'] == true,
            completed: _isStepMarkedAsDoneByPlanting(map),
            meta: map['meta'] is Map<String, dynamic>
                ? Map<String, dynamic>.from(map['meta'])
                : (map['meta'] != null ? Map<String, dynamic>.from(map['meta']) : {}),
          );
        } catch (_) {
          // ignore malformed entry
          return PlantStep(id: _uuid.v4(), title: '', category: 'custom');
        }
      }).toList();
    } else {
      _customSteps = [];
    }
  }

  bool _isStepMarkedAsDoneByPlanting(Map raw) {
    final title = (raw['title'] ?? '').toString();
    return widget.planting.careActions
        .any((a) => a.toLowerCase().contains(title.toLowerCase()));
  }

  Future<void> _saveCustomSteps() async {
    final raw = _customSteps.map((s) => {
          'id': s.id,
          'title': s.title,
          'description': s.description,
          'scheduledDate': s.scheduledDate?.toIso8601String(),
          'category': s.category,
          'recommended': s.recommended,
          'meta': s.meta ?? {},
        }).toList();
    widget.planting.metadata['customSteps'] = raw;
    widget.planting.markAsUpdated();
    await widget.planting.save(); // Planting extends HiveObject
    if (mounted) setState(() {}); // refresh UI
  }

  List<PlantStep> _mergeGeneratedAndCustomSteps(
      List<PlantStep> generated, List<PlantStep> custom) {
    final result = List<PlantStep>.from(generated);
    for (final cs in custom) {
      // dedupe by id if present
      result.removeWhere((r) => r.id == cs.id);
      
      int insertIndex = result.length;
      // positionIndex stored in meta optional
      final meta = cs.meta ?? {};
      if (meta.containsKey('positionIndex') && meta['positionIndex'] is int) {
        insertIndex = (meta['positionIndex'] as int).clamp(0, result.length);
      } else if (cs.scheduledDate != null) {
        final idx = result.indexWhere((s) =>
            s.scheduledDate != null && s.scheduledDate!.isAfter(cs.scheduledDate!));
        insertIndex = idx == -1 ? result.length : idx;
      }
      result.insert(insertIndex, cs);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final generated = _getComputedSteps(l10n);
    final allSteps = _mergeGeneratedAndCustomSteps(generated, _customSteps);
    final toShow = _expanded ? allSteps : allSteps.take(3).toList();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.planting_steps_title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Reporter les étapes dans votre agenda',
                      icon: Icon(Icons.calendar_month,
                          color: theme.colorScheme.primary),
                      onPressed: () async {
                        await _confirmAndExportStepsToAgenda(context, allSteps);
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () async {
                        final created = await _showAddCustomStepDialog(context);
                        if (created == true) {
                          _loadCustomSteps();
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.add,
                          size: 16, color: theme.colorScheme.primary),
                      label: Text(
                        l10n.common_add,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            if (toShow.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.flag,
                        size: 40,
                        color: theme.colorScheme.onSurfaceVariant
                            .withOpacity(0.6)),
                    const SizedBox(height: 8),
                    Text(l10n.planting_steps_empty,
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              )
            else
              Column(
                children: toShow.map((s) => _buildStepCard(s)).toList(),
              ),
            
            if (allSteps.length > 3) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded
                      ? l10n.planting_steps_see_less
                      : l10n.planting_steps_see_all),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Refactored to Custom Layout to fix wrapping issues
  Widget _buildStepCard(PlantStep step) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final completed = step.completed ||
        widget.planting.careActions
            .any((a) => a.toLowerCase().contains(step.title.toLowerCase())) ||
        _locallyCompleted.contains(step.id);
    
    final isCustom = step.category == 'custom' || (step.meta != null && step.meta!['createdBy'] == 'user');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Check Icon / Status
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: completed ? Colors.green.shade100 : Colors.grey.shade200,
              child: Icon(
                completed ? Icons.check : Icons.arrow_forward,
                size: 18,
                color: completed ? Colors.green.shade700 : Colors.black54,
              ),
            ),
          ),
          
          // 2. Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        step.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.3
                        ),
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                
                // Subtitle Line (Date + Badge + Description)
                 const SizedBox(height: 4),
                 if (step.scheduledDate != null || (step.recommended && !completed))
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (step.scheduledDate != null)
                        Text(
                          l10n.planting_steps_date_prefix(_formatDate(step.scheduledDate!)),
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      if (step.recommended && !completed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(l10n.planting_steps_prediction_badge,
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: Colors.blue.shade700, fontSize: 10)),
                        ),
                    ],
                  ),
                  
                if (step.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      step.description,
                      style: const TextStyle(fontSize: 14, height: 1.35),
                      maxLines: 6,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
              ],
            ),
          ),

          // 3. Action Button (Trailing)
          // Use constrained box or column to separate it from resizing text
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 if (completed)
                  TextButton(
                    onPressed: null, 
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    child: Text(l10n.common_done, style: TextStyle(color: Colors.green.shade700)),
                  )
                else
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _locallyCompleted.add(step.id);
                      });
                      if (widget.onMarkDone != null) {
                        widget.onMarkDone!(step).catchError((e) {
                          // ignore error
                        }).whenComplete(() {
                          if (mounted) setState(() {});
                        });
                      }
                    },
                    child: Text(l10n.planting_steps_mark_done), 
                  ),
                  
                 if (isCustom)
                   PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onSelected: (val) async {
                      if (val == 'delete') {
                        _customSteps.removeWhere((s) => s.id == step.id);
                        await _saveCustomSteps();
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(value: 'delete', child: Text(l10n.common_delete)),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showAddCustomStepDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final _titleCtrl = TextEditingController();
    final _descCtrl = TextEditingController();
    DateTime? chosenDate;
    String category = 'custom';
    
    return await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: Text(l10n.step_add_step_title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(labelText: l10n.step_dialog_title_label),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descCtrl,
                      decoration: InputDecoration(labelText: l10n.step_dialog_desc_label),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(chosenDate == null
                              ? l10n.step_dialog_no_date
                              : _formatDate(chosenDate!)),
                        ),
                        TextButton(
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (d != null) {
                              setStateSB(() {
                                chosenDate = d;
                              });
                            }
                          },
                          child: Text(l10n.step_dialog_pick_date),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.common_cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = _titleCtrl.text.trim();
                    if (title.isEmpty) return;
                    final newStep = PlantStep(
                      id: _uuid.v4(),
                      title: title,
                      description: _descCtrl.text.trim(),
                      scheduledDate: chosenDate,
                      category: category,
                      recommended: false,
                      completed: false,
                      meta: {'createdBy': 'user'},
                    );
                    _customSteps.add(newStep);
                    await _saveCustomSteps();
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(l10n.common_save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmAndExportStepsToAgenda(BuildContext context, List<PlantStep> allSteps) async {
    final stepsWithDate = allSteps.where((s) => s.scheduledDate != null).toList();
    if (stepsWithDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune étape datée à exporter.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exporter vers l\'agenda'),
        content: Text('Voulez-vous envoyer ${stepsWithDate.length} étapes vers votre agenda (app + rappels) ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmer')),
        ],
      ),
    );

    if (confirm == true) {
      int count = 0;
      final List<Map<String, dynamic>> scheduledEvents = [];
      final notifService = NotificationService();
      
      // Ensure local notifications initialized
      await notifService.init();

      // Fetch Garden context for Activities
      String gardenName = '';
      String bedName = '';
      GardenBed? bed;
      try {
        bed = GardenBoxes.getGardenBedById(widget.planting.gardenBedId);
        if (bed != null) {
          bedName = bed.name;
          final garden = GardenBoxes.getGarden(bed.gardenId);
          if (garden != null) {
            gardenName = garden.name;
          }
        }
      } catch (e) {
        // ignore errors
      }

      for (final step in stepsWithDate) {
        // 1. Create Local Notification
        int notifId = 0;
        try {
           notifId = await notifService.scheduleNotification(
             title: 'Jardin: ${widget.plant.commonName}',
             body: step.title,
             scheduledDate: step.scheduledDate!,
           );
        } catch (e) {
          print('Notification error for ${step.title}: $e');
        }

        // 2. Create Agenda Activity (so it appears in Calendar View)
        try {
          // Identify if we already exported this step? (Optional for MVP)
          
          final activity = Activity(
            id: _uuid.v4(),
            type: ActivityType.careActionAdded, // Generic "Care Action"
            title: step.title,
            description: '${widget.plant.commonName}: ${step.description}',
            entityId: widget.planting.id,
            entityType: EntityType.planting,
            timestamp: step.scheduledDate!,
            metadata: {
              'status': 'planned',
              'isCustomTask': true, // CRITICAL: Makes it visible in CalendarViewScreen list
              'taskKind': step.category,
              'stepId': step.id,
              'source': 'steps_export',
              'notifId': notifId,
              'plantName': widget.plant.commonName, // Visual aid for logic
              'gardenName': gardenName,
              'bedName': bedName,
              // Fallback IDs for resolution
              'gardenId': bed?.gardenId, 
              'gardenBedId': widget.planting.gardenBedId,
            }
          );
          
          await GardenBoxes.activities.put(activity.id, activity);
          
          scheduledEvents.add({
             'id': activity.id,
             'stepId': step.id,
             'scheduledDate': step.scheduledDate!.toIso8601String(),
             'notifId': notifId,
             'source': 'local_export',
             'custom': step.category == 'custom'
           });
           
          count++;
        } catch (e) {
          print('Activity creation error: $e');
        }
      }

      // Save metadata
      final existingEvents = widget.planting.metadata['scheduledEvents'];
      List<dynamic> currentList = [];
      if (existingEvents is List) {
        currentList = List.from(existingEvents);
      }
      currentList.addAll(scheduledEvents);
      widget.planting.metadata['scheduledEvents'] = currentList;
      widget.planting.markAsUpdated();
      await widget.planting.save();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count étapes ajoutées à l\'agenda.')),
        );
      }
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
