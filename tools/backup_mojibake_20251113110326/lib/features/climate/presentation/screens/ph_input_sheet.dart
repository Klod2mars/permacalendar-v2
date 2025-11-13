import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/soil_ph_provider.dart';

/// pH Input Sheet
///
/// Bottom sheet for pH value adjustment.
/// Features quick adjustment buttons and manual input.
///
/// Design specs:
/// - Frost glass bottom sheet
/// - Quick adjustment buttons (+1, +0.5, -0.5, -1)
/// - Manual input field
/// - pH range validation (4.0-9.0)
class PHInputSheet extends ConsumerStatefulWidget {
  const PHInputSheet({super.key});

  @override
  ConsumerState<PHInputSheet> createState() => _PHInputSheetState();
}

class _PHInputSheetState extends ConsumerState<PHInputSheet> {
  double _phValue = 6.8;
  final TextEditingController _controller = TextEditingController();
  final String _scopeKey =
      "garden:demo"; // TODO: Get from current garden selection

  @override
  void initState() {
    super.initState();
    _controller.text = _phValue.toStringAsFixed(1);

    // Load current soil pH from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soilPHAsync = ref.read(soilPHProviderByScope(_scopeKey));
      if (soilPHAsync.hasValue && soilPHAsync.value != null) {
        setState(() {
          _phValue = soilPHAsync.value!;
          _controller.text = _phValue.toStringAsFixed(1);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _adjustPH(double adjustment) {
    setState(() {
      _phValue = (_phValue + adjustment).clamp(4.0, 9.0);
      _controller.text = _phValue.toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.science,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'pH du sol',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Ajustez le niveau d\'aciditÃ©',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // pH display
                Center(
                  child: Column(
                    children: [
                      Text(
                        'pH',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _phValue.toStringAsFixed(1),
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getPHDescription(_phValue),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Quick adjustment buttons
                Text(
                  'Ajustement rapide',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildAdjustmentButton('-1.0', -1.0, Colors.red),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                          _buildAdjustmentButton('-0.5', -0.5, Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAdjustmentButton('+0.5', 0.5, Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAdjustmentButton('+1.0', 1.0, Colors.green),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Manual input
                TextField(
                  controller: _controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'pH (4.0 - 9.0)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: '6.8',
                    hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.amber, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null && parsed >= 4.0 && parsed <= 9.0) {
                      setState(() {
                        _phValue = parsed;
                      });
                    }
                  },
                ),

                const Spacer(),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Phase 2: Save to provider
                          ref
                              .read(soilPHProvider.notifier)
                              .setPH(_scopeKey, _phValue);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sauvegarder'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentButton(String label, double adjustment, Color color) {
    return ElevatedButton(
      onPressed: () => _adjustPH(adjustment),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  String _getPHDescription(double ph) {
    if (ph < 5.5) return 'TrÃ¨s acide';
    if (ph < 6.5) return 'Acide';
    if (ph < 7.5) return 'Neutre';
    if (ph < 8.5) return 'Alcalin';
    return 'TrÃ¨s alcalin';
  }
}



