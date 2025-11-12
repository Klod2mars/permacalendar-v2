// lib/shared/widgets/size_slider_picker.dart
import 'package:flutter/material.dart';

/// SizeSliderPicker
/// - currentSize: normalized 0..1
/// - onChanged: callback(double size)
/// - onSave: optional callback to persist changes
class SizeSliderPicker extends StatefulWidget {
  final double currentSize;
  final ValueChanged<double> onChanged;
  final VoidCallback? onSave;
  final String label;

  const SizeSliderPicker({
    super.key,
    required this.currentSize,
    required this.onChanged,
    this.onSave,
    this.label = 'Taille METEO',
  });

  @override
  State<SizeSliderPicker> createState() => _SizeSliderPickerState();
}

class _SizeSliderPickerState extends State<SizeSliderPicker> {
  late double _size;

  @override
  void initState() {
    super.initState();
    _size = widget.currentSize.clamp(0.05, 0.6);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              '${(_size * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Slider(
          min: 0.08, // reasonable minimum
          max: 0.45, // reasonable maximum
          divisions: 37,
          value: _size,
          onChanged: (v) {
            setState(() => _size = v);
            widget.onChanged(v);
          },
          onChangeEnd: (_) {
            if (widget.onSave != null) widget.onSave!();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (widget.onSave != null) widget.onSave!();
              },
              child: const Text('Sauver'),
            ),
          ],
        ),
      ],
    );
  }
}

