import 'package:flutter/material.dart';
import '../../core/data/hive/garden_boxes.dart';
import '../../core/models/activity.dart';
import '../../core/models/garden_bed.dart';
import '../../core/services/recurrence_service.dart';

class CreateTaskDialog extends StatefulWidget {
  final DateTime? initialDate;

  const CreateTaskDialog({super.key, this.initialDate});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Fields
  String _title = '';
  String _description = '';
  String _taskKind = 'generic'; // default
  String? _selectedGardenBedId;
  bool _urgent = false;
  late DateTime _selectedDate;
  
  // Recurrence
  String _recurrenceType = 'none'; // none, interval, weekly, monthlyByDay
  int _intervalEvery = 7;
  // For simplicity in Phase 1, weekly defaults to current day of week if not complex UI
  
  // Available Task Kinds (Icons mapped in CalendarViewScreen, here just selection)
  final Map<String, String> _taskKinds = {
    'generic': 'Générique',
    'repair': 'Réparation 🛠️',
    'buy': 'Achat 🛒',
    'clean': 'Nettoyage 🧹',
    'watering': 'Arrosage 💧',
    'seeding': 'Semis 🌱',
    'pruning': 'Taille ✂️',
    'weeding': 'Désherbage 🌿',
    'amendment': 'Amendement 🪵',
    'treatment': 'Traitement 🧪',
    'harvest': 'Récolte 🧺',
    'winter_protection': 'Hivernage ❄️',
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final gardenBeds = GardenBoxes.gardenBeds.values.toList();

    return AlertDialog(
      title: const Text('Nouvelle Tâche'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre *'),
                validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                onSaved: (v) => _title = v!,
              ),
              
              // Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
                onSaved: (v) => _description = v ?? '',
              ),
              const SizedBox(height: 16),
              
              // Date Picker
              InkWell(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    initialDate: _selectedDate,
                  );
                  if (d != null) setState(() => _selectedDate = d);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date de début'),
                  child: Text('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}'),
                ),
              ),
              const SizedBox(height: 16),
              
              // Type / Icon
              DropdownButtonFormField<String>(
                value: _taskKind,
                decoration: const InputDecoration(labelText: 'Type de tâche'),
                items: _taskKinds.entries.map((e) {
                  return DropdownMenuItem(value: e.key, child: Text(e.value));
                }).toList(),
                onChanged: (v) => setState(() => _taskKind = v!),
              ),
              const SizedBox(height: 16),

              // Zone (GardenBed)
              DropdownButtonFormField<String>(
                value: _selectedGardenBedId,
                decoration: const InputDecoration(labelText: 'Zone (Optionnel)'),
                items: [
                  const DropdownMenuItem(value: null, child: Text("Aucune zone spécifique")),
                  ...gardenBeds.map((bed) => DropdownMenuItem(
                        value: bed.id,
                        child: Text(bed.name),
                      ))
                ],
                onChanged: (v) => setState(() => _selectedGardenBedId = v),
              ),
              
              // Urgent Checkbox
              CheckboxListTile(
                title: const Text('Urgent'),
                value: _urgent,
                onChanged: (v) => setState(() => _urgent = v!),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              const Divider(),
              
              // Recurrence
              DropdownButtonFormField<String>(
                value: _recurrenceType,
                decoration: const InputDecoration(labelText: 'Récurrence'),
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('Pas de récurrence')),
                  DropdownMenuItem(value: 'interval', child: Text('Intervalle (jours)')),
                  DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
                  DropdownMenuItem(value: 'monthlyByDay', child: Text('Mensuel (même jour)')),
                ],
                onChanged: (v) => setState(() => _recurrenceType = v!),
              ),
              
              if (_recurrenceType == 'interval')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    initialValue: '7',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Tous les X jours'),
                    onSaved: (v) => _intervalEvery = int.tryParse(v ?? '7') ?? 7,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton.tonal(
          onPressed: _submit,
          child: const Text('Créer'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Build Recurrence Map
      Map<String, dynamic>? recurrenceMap;
      DateTime? nextRunDate;
      
      if (_recurrenceType != 'none') {
        recurrenceMap = {
          'type': _recurrenceType,
        };
        
        if (_recurrenceType == 'interval') {
          recurrenceMap['every'] = _intervalEvery;
        } else if (_recurrenceType == 'weekly') {
          // Default to current weekday
          recurrenceMap['days'] = [_selectedDate.weekday]; 
        } else if (_recurrenceType == 'monthlyByDay') {
          recurrenceMap['day'] = _selectedDate.day;
        }
        
        // Initial nextRunDate is the selected date
        // Logic: The first occurrence is the selected date. 
        // If we want the *next* after that, we use computeNextRunDate.
        // But for "Scheduled Tasks", the selected date IS the first run.
        nextRunDate = _selectedDate; 
      } else {
        // Single shot
        nextRunDate = _selectedDate;
      }
      
      final newTask = Activity.customTask(
        title: _title,
        description: _description,
        taskKind: _taskKind,
        zoneGardenBedId: _selectedGardenBedId,
        urgent: _urgent,
        recurrence: recurrenceMap,
        nextRunDate: nextRunDate,
      );

      // Save via GardenBoxes directly here or pass back? 
      // Prompt says "provide an UI creation (dialog)... Storing these tasks in GardenBoxes.activities".
      // Simplest is to save here.
      GardenBoxes.activities.put(newTask.id, newTask);
      
      Navigator.pop(context, true); // Return true to signal created
    }
  }
}
