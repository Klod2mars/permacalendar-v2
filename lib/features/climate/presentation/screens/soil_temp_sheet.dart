import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/soil_temp_provider.dart';
import '../../../../core/providers/active_garden_provider.dart';

/// Soil Temperature Input Sheet
///
/// Bottom sheet for manual soil temperature input.
/// Features slider and manual input field.
///
/// Design specs:
/// - Frost glass bottom sheet
/// - Temperature slider (0-40°C)
/// - Manual input field
/// - Save/Cancel actions
class SoilTempSheet extends ConsumerStatefulWidget {
  const SoilTempSheet({super.key});

  @override
  ConsumerState<SoilTempSheet> createState() => _SoilTempSheetState();
}

class _SoilTempSheetState extends ConsumerState<SoilTempSheet> {
  double _temperature = 0.0;
  final TextEditingController _controller = TextEditingController();
  late String _scopeKey;

  @override
  void initState() {
    super.initState();
    _controller.text = _temperature.toStringAsFixed(1);
    // Scope key resolution moved to didChangeDependencies/later or defaulted here safely
    // We can't access ref here safely for read
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Resolve scope key from active garden
    final activeId = ref.read(activeGardenIdProvider);
    _scopeKey = activeId ?? "garden:demo";

    // Load current soil temperature from provider
    // We use ref.read because we are in a lifecycle method and want to fetch once
    final soilTempAsync = ref.read(soilTempProviderByScope(_scopeKey));
    if (soilTempAsync.hasValue && soilTempAsync.value != null) {
      if (mounted) {
        setState(() {
          _temperature = soilTempAsync.value!;
          _controller.text = _temperature.toStringAsFixed(1);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _temperature = 0.0;
          _controller.text = _temperature.toStringAsFixed(1);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
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
                        Icons.thermostat,
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
                            'Température du sol',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Ajustez la température mesurée',
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

                // Temperature display
                Center(
                  child: Text(
                    '${_temperature.toStringAsFixed(1)}°C',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.amber,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.amber,
                    overlayColor: Colors.amber.withOpacity(0.2),
                    valueIndicatorColor: Colors.amber,
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Slider(
                    value: _temperature,
                    min: -50.0,
                    max: 60.0,
                    divisions: 110,
                    label: '${_temperature.toStringAsFixed(1)}°C',
                    onChanged: (value) {
                      setState(() {
                        _temperature = value;
                        _controller.text = value.toStringAsFixed(1);
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Manual input
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Température (°C)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: '0.0',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.amber, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed != null && parsed >= -50.0 && parsed <= 60.0) {
                      setState(() {
                        _temperature = parsed;
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
                          // Save to provider with soft recalibration
                          ref
                              .read(soilTempProvider.notifier)
                              .setManual(_scopeKey, _temperature);
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
}
