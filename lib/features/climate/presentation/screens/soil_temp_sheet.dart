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
  bool _inputValid = true;
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
      height: MediaQuery.of(context).size.height * 0.8, // More space
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // header row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Température du sol',
                            style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_temperature.toStringAsFixed(1)}°C',
                            style: theme.textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.thermostat,
                        color: Colors.white54, size: 32),
                  ],
                ),
                const SizedBox(height: 16),

                // Slider (allow negative)
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.amber,
                    inactiveTrackColor: Colors.white.withOpacity(0.3),
                    thumbColor: Colors.amber,
                    overlayColor: Colors.amber.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _temperature,
                    min: -50.0,
                    max: 60.0,
                    divisions: 1100, // approx 0.1°C step
                    label: '${_temperature.toStringAsFixed(1)}°C',
                    onChanged: (value) {
                      setState(() {
                        _temperature = value;
                        _controller.text = value.toStringAsFixed(1);
                        _inputValid = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Manual input
                TextField(
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Température (°C)',
                    errorText:
                        _inputValid ? null : 'Valeur invalide (-50.0 à 60.0)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: '0.0',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.06),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed != null && parsed >= -50.0 && parsed <= 60.0) {
                      setState(() {
                        _temperature = parsed;
                        _inputValid = true;
                      });
                    } else {
                      setState(() {
                        _inputValid = false;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Actions row — ensure buttons visible and not overflow
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side:
                              BorderSide(color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_inputValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Valeur invalide. Entrez -50.0 à 60.0')),
                            );
                            return;
                          }
                          // Persist direct value (override)
                          try {
                            await ref
                                .read(soilTempProvider.notifier)
                                .setManual(_scopeKey, _temperature);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Température enregistrée')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur sauvegarde: $e')),
                            );
                          }
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sauvegarder'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
