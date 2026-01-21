// lib/features/plant_catalog/presentation/widgets/sowing_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_catalog/application/sowing_utils.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

class SowingPicker extends ConsumerStatefulWidget {
  final List<PlantFreezed> plants;
  final void Function(PlantFreezed) onPlantSelected;

  const SowingPicker({Key? key, required this.plants, required this.onPlantSelected}) : super(key: key);

  @override
  ConsumerState<SowingPicker> createState() => _SowingPickerState();
}

class _SowingPickerState extends ConsumerState<SowingPicker> {
  ActionType _action = ActionType.sow;
  DateTime _date = DateTime.now();
  int _filterMode = 2; // 0 = verts only, 1 = verts+oranges, 2 = tous

  List<PlantFreezed> _computeResults() {
    final list = List<PlantFreezed>.from(widget.plants);
    list.sort((a,b) {
      final aInfo = computeSeasonInfoForPlant(plant: a, date: _date, action: _action);
      final bInfo = computeSeasonInfoForPlant(plant: b, date: _date, action: _action);
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
    if (_filterMode == 0) {
      return list.where((p) => computeSeasonInfoForPlant(plant: p, date: _date, action: _action).status == SeasonStatus.green).toList();
    } else if (_filterMode == 1) {
      return list.where((p) {
        final s = computeSeasonInfoForPlant(plant: p, date: _date, action: _action).status;
        return s == SeasonStatus.green || s == SeasonStatus.orange;
      }).toList();
    } else {
      return list;
    }
  }

  void _openResults() {
    final results = _computeResults();
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, ctrl) {
          return Column(
            children: [
              ListTile(
                title: Text(_action == ActionType.sow ? 'Semer' : 'Planter'),
                trailing: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ),
              Expanded(
                child: results.isEmpty
                  ? Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Aucune plante recommandée sur la période.'),
                        SizedBox(height: 8),
                        TextButton(onPressed: () {
                          // expand: recompute with larger window - could be parameterized
                          // For prototype: temporarily increase nearThreshold by 1 and show again (not persisted)
                          Navigator.of(context).pop();
                          setState(() {});
                          _openResults();
                        }, child: Text('Élargir (±2 mois)')),
                      ],
                    ))
                  : ListView.separated(
                      controller: ctrl,
                      itemBuilder: (context, index) {
                        final plant = results[index];
                        final info = computeSeasonInfoForPlant(plant: plant, date: _date, action: _action);
                        return ListTile(
                          leading: Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(color: statusToColor(info.status), shape: BoxShape.circle),
                          ),
                          title: Text(plant.commonName),
                          subtitle: Text(_buildSubtitle(plant)),
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

  String _buildSubtitle(PlantFreezed plant) {
    final months = buildEligibleMonthsForAction(plant, _action);
    if (months.isEmpty) return 'Données de période manquantes';
    return 'Périodes: ${months.map((m)=>_monthName(m)).join(', ')}';
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ToggleButtons(
                isSelected: [_action == ActionType.sow, _action == ActionType.plant],
                onPressed: (i) => setState(() => _action = (i==0?ActionType.sow:ActionType.plant)),
                children: [Padding(padding: EdgeInsets.all(8), child: Text('Semer')), Padding(padding: EdgeInsets.all(8), child: Text('Planter'))],
              ),
            ),
            IconButton(icon: Icon(Icons.calendar_today), onPressed: () async {
              final pick = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (pick != null) setState(() => _date = pick);
            }),
            PopupMenuButton<int>(
              onSelected: (v) => setState(() => _filterMode = v),
              itemBuilder: (_) => [
                PopupMenuItem(value: 0, child: Text('Verts seulement')),
                PopupMenuItem(value: 1, child: Text('Verts + Oranges')),
                PopupMenuItem(value: 2, child: Text('Tous')),
              ],
              child: Icon(Icons.filter_list),
            )
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: ElevatedButton(onPressed: _openResults, child: Text('Afficher sélection'))),
            SizedBox(width: 8),
            Text('${_computeResults().length}'),
          ],
        )
      ],
    );
  }
}
