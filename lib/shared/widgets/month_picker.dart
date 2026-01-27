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
  // Canonic tokens (3 letters) to remove ambiguity
  static const List<String> _monthTokens = [
    'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
    'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
  ];
  
  // Display names (same as tokens for now, but keeping clean separation concept)
  static const List<String> _monthNamesFr = [
    'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin',
    'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
  ];

  late Set<int> _selectedIndices;

  @override
  void initState() {
    super.initState();
    _selectedIndices = <int>{};
    
    // Initialize selection with support for legacy ambiguous tokens
    for (final token in widget.initialSelected) {
      if (token.length >= 3) {
        // Canonical token
        final idx = _monthTokens.indexOf(token);
        if (idx != -1) _selectedIndices.add(idx);
      } else {
        // Legacy single-letter fallback (Heuristic expansion)
        // 'J' -> Jan, Juin, Juil
        // 'F' -> Fév
        // 'M' -> Mar, Mai
        // 'A' -> Avr, Aoû
        // 'S' -> Sep
        // 'O' -> Oct
        // 'N' -> Nov
        // 'D' -> Déc
        switch (token) {
          case 'J':
            _selectedIndices.addAll([0, 5, 6]); // Jan, Juin, Juil
            break;
          case 'F':
            _selectedIndices.add(1); // Fév
            break;
          case 'M':
            _selectedIndices.addAll([2, 4]); // Mar, Mai
            break;
          case 'A':
            _selectedIndices.addAll([3, 7]); // Avr, Aoû
            break;
          case 'S':
            _selectedIndices.add(8); // Sep
            break;
          case 'O':
            _selectedIndices.add(9); // Oct
            break;
          case 'N':
            _selectedIndices.add(10); // Nov
            break;
          case 'D':
            _selectedIndices.add(11); // Déc
            break;
        }
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
    // Emit canonical tokens
    widget.onChanged?.call(_selectedIndices.map((i) => _monthTokens[i]).toList());
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
