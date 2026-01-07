import 'package:flutter/material.dart';

typedef MonthsChanged = void Function(List<String> months);

class MonthPicker extends StatefulWidget {
  final List<String> initialSelected; // ex: ['M','A']
  final MonthsChanged? onChanged;
  final String label; // 'Mois de semis' / 'Mois de récolte'

  const MonthPicker({
    Key? key,
    this.initialSelected = const [],
    this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  // Abréviations utilisées dans l'app (ordre Jan..Dec)
  static const List<String> _monthAbbr = ['J','F','M','A','M','J','J','A','S','O','N','D'];
  static const List<String> _monthNamesFr = [
    'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
    'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
  ];

  late Set<int> _selectedIndices;

  @override
  void initState() {
    super.initState();
    _selectedIndices = <int>{};
    // Initialize selection based on provided abbreviations
    // Note: This logic assumes simple matching. Duplicate abbreviations in _monthAbbr (like 'J', 'M', 'A') 
    // might match multiple months. 
    // However, the requirement is to use the specific existing abbreviation list.
    // Let's refine the matching to be index-based if possible, but the input is List<String>.
    // Since the input abbreviations are ambiguous ('J' can be Jan, Juin, Juil), 
    // we should be careful. 
    // BUT the USER provided implementation implies a direct mapping.
    // The user's code:
    // for (int i = 0; i < _monthAbbr.length; i++) {
    //   if (widget.initialSelected.contains(_monthAbbr[i])) {
    //     _selectedIndices.add(i);
    //   }
    // }
    // This logic means if 'J' is in initialSelected, Jan (0), Juin (5), Juil (6) will ALL be selected.
    // This assumes the input list has no distinction.
    // Given the context of the app using these specific single letters, this seems to be the intended behavior 
    // or at least the accepted limitation of the existing data model.
    // I will stick to the user's provided implementation for consistency with their request.
    
    for (int i = 0; i < _monthAbbr.length; i++) {
      if (widget.initialSelected.contains(_monthAbbr[i])) {
        _selectedIndices.add(i);
      }
    }
  }

  void _toggle(int idx) {
    setState(() {
      if (_selectedIndices.contains(idx)) {
        _selectedIndices.remove(idx);
      } else {
        _selectedIndices.add(idx);
      }
    });
    // Map indices back to abbreviations. 
    // Note that this might produce duplicates in the output list (e.g. ['J', 'J']) if Jan and Juin are selected.
    // The backend seems to handle List<String>.
    widget.onChanged?.call(_selectedIndices.map((i) => _monthAbbr[i]).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(12, (i) {
            final selected = _selectedIndices.contains(i);
            return ChoiceChip(
              label: Text(_monthNamesFr[i]),
              selected: selected,
              onSelected: (_) => _toggle(i),
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
              ),
              // Ensure tap target is good
              visualDensity: VisualDensity.compact,
            );
          }),
        ),
      ],
    );
  }
}
