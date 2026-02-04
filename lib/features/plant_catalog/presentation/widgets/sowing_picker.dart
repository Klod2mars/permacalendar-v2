// lib/features/plant_catalog/presentation/widgets/sowing_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_catalog/application/sowing_utils.dart';
import 'package:permacalendar/l10n/app_localizations.dart';
import 'package:permacalendar/features/climate/presentation/providers/zone_providers.dart';
import 'package:permacalendar/features/climate/domain/models/zone.dart';

class SowingPicker extends ConsumerStatefulWidget {
  final List<PlantFreezed> plants;
  final void Function(PlantFreezed) onPlantSelected;

  final ActionType initialAction;

  const SowingPicker({
    Key? key,
    required this.plants,
    required this.onPlantSelected,
    this.initialAction = ActionType.sow,
  }) : super(key: key);

  @override
  ConsumerState<SowingPicker> createState() => _SowingPickerState();
}

class _SowingPickerState extends ConsumerState<SowingPicker> {
  late ActionType _action;
  DateTime _date = DateTime.now();
  bool _showAll = true; // false = verts only, true = all

  @override
  void initState() {
    super.initState();
    _action = widget.initialAction;
  }
  
  @override
  void didUpdateWidget(SowingPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAction != widget.initialAction) {
      setState(() {
        _action = widget.initialAction;
      });
    }
  }

  List<PlantFreezed> _computeResults(Zone? zone, DateTime? lastFrost) {
    if (zone == null) return []; // Loading or error
    final list = List<PlantFreezed>.from(widget.plants);
    list.sort((a,b) {
      final aInfo = computeSeasonInfoForPlant(plant: a, date: _date, action: _action, zone: zone, lastFrostDate: lastFrost);
      final bInfo = computeSeasonInfoForPlant(plant: b, date: _date, action: _action, zone: zone, lastFrostDate: lastFrost);
      int rank(SeasonStatus s) {
        switch(s) {
          case SeasonStatus.green: return 0;
          case SeasonStatus.orange: return 1;
          case SeasonStatus.red: return 2;
          case SeasonStatus.unknown: return 3;
        }
      }
      final r = rank(aInfo.status).compareTo(rank(bInfo.status));
      if (r != 0) return r;
      return aInfo.distance.compareTo(bInfo.distance);
    });
    
    if (!_showAll) {
      // Show only Green
      return list.where((p) => computeSeasonInfoForPlant(plant: p, date: _date, action: _action, zone: zone, lastFrostDate: lastFrost).status == SeasonStatus.green).toList();
    } else {
      // Show All
      return list;
    }
  }

  void _openResults(Zone? zone, DateTime? lastFrost) {
    if (zone == null) return;
    final results = _computeResults(zone, lastFrost);
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, ctrl) {
          return Column(
            children: [
              ListTile(
                title: Text(_action == ActionType.sow ? AppLocalizations.of(context)!.plant_catalog_sow : AppLocalizations.of(context)!.plant_catalog_plant),
                trailing: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ),
              Expanded(
                child: results.isEmpty
                  ? Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(AppLocalizations.of(context)!.plant_catalog_no_recommended),
                        SizedBox(height: 8),
                        TextButton(onPressed: () {
                          // expand: recompute with larger window - could be parameterized
                          // For prototype: temporarily increase nearThreshold by 1 and show again (not persisted)
                          Navigator.of(context).pop();
                          setState(() {});
                          _openResults(zone, lastFrost);
                        }, child: Text(AppLocalizations.of(context)!.plant_catalog_expand_window)),
                      ],
                    ))
                  : ListView.separated(
                      controller: ctrl,
                      itemBuilder: (context, index) {
                        final plant = results[index];
                        final info = computeSeasonInfoForPlant(plant: plant, date: _date, action: _action, zone: zone, lastFrostDate: lastFrost);
                        return ListTile(
                          leading: Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: statusToColor(info.status), shape: BoxShape.circle),
                          ),
                          title: Text(plant.commonName),
                          subtitle: Text(_buildSubtitle(plant, zone, lastFrost)),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onPlantSelected(plant);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: results.length,
                    )
              )
            ],
          );
        }
      );
    });
  }

  String _buildSubtitle(PlantFreezed plant, Zone? zone, DateTime? lastFrost) {
    final months = buildEligibleMonthsForAction(plant, _action, zone: zone, lastFrostDate: lastFrost);
    if (months.isEmpty) return AppLocalizations.of(context)!.plant_catalog_missing_period_data;
    return AppLocalizations.of(context)!.plant_catalog_periods_prefix(months.map((m)=>_monthName(m)).join(', '));
  }

  String _monthName(int m) {
    const names = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return names[m-1];
  }

  ActionType get currentAction => _action;

  @override
  Widget build(BuildContext context) {
    // Use AppLocalizations if available in repo (optional)
    final loc = AppLocalizations.of(context);
    final zoneAsync = ref.watch(currentZoneProvider);
    final frostAsync = ref.watch(lastFrostDateProvider);
    
    // Si chargement, on peut afficher un loader ou utiliser une valeur nullable
    // Pour simplifier, on prend valueOrNull
    final zone = zoneAsync.asData?.value;
    final lastFrost = frostAsync.asData?.value;

    if (zone == null) return const SizedBox.shrink(); // Wait for zone

    return Column(
      children: [
        // Filter Chips Row

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Date Picker Button (if needed, keeping it as is but centered)
               OutlinedButton.icon(
                onPressed: () async {
                  final pick = await showDatePicker(
                    context: context, 
                    initialDate: _date, 
                    firstDate: DateTime(2000), 
                    lastDate: DateTime(2100),
                    locale: const Locale('fr'),
                  );
                  if (pick != null) setState(() => _date = pick);
                },
                icon: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                label: Text(
                  '${_date.day}/${_date.month}', 
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  // removed visualDensity compact to enlarge
                ),
              ),
              const SizedBox(width: 12),
              
              // Simplification: Toggle Filter "Adapté à la saison"
              FilterChip(
                label: Text(AppLocalizations.of(context)!.plant_catalog_filter_green_only),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Added padding to enlarge chip
                selected: !_showAll,
                onSelected: (val) {
                  setState(() => _showAll = !val);
                },
                // Avatar always visible to link with green dots in list
                avatar: const CircleAvatar(backgroundColor: Colors.green, radius: 4),
                selectedColor: Colors.green.withOpacity(0.2),
                checkmarkColor: Colors.green,
                showCheckmark: false, // Don't show checkmark, just the green dot state
                // Ensure label is visible in dark mode when unselected
                labelStyle: TextStyle(
                  color: !_showAll 
                      ? Colors.green.shade900 
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: !_showAll ? FontWeight.bold : FontWeight.normal,
                ),
                // Ensure the chip is visible (outlined) when inactive
                backgroundColor: !_showAll ? null : Colors.transparent,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: !_showAll ? Colors.transparent : Theme.of(context).colorScheme.outline
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: () => _openResults(zone, lastFrost), child: Text(AppLocalizations.of(context)!.plant_catalog_show_selection))),
            SizedBox(width: 8),
            Text('${_computeResults(zone, lastFrost).length}'),
          ],
        )
      ],
    );
  }
}
