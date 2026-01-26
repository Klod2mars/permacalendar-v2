import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_config_provider.dart';
import '../../domain/models/weather_config.dart';
import '../providers/weather_metrics_provider.dart';

import '../../../../shared/presentation/widgets/weather_bio_layer.dart';

class WeatherCalibrationScreen extends ConsumerStatefulWidget {
  const WeatherCalibrationScreen({super.key});

  @override
  ConsumerState<WeatherCalibrationScreen> createState() =>
      _WeatherCalibrationScreenState();
}

class _WeatherCalibrationScreenState
    extends ConsumerState<WeatherCalibrationScreen> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(weatherConfigProvider);
    final calibState = ref.watch(weatherCalibrationStateProvider);
    
    // Calcul pour maintenir l'aspect ratio de l'écran dans la preview
    final size = MediaQuery.sizeOf(context);
    final ratio = size.aspectRatio;
    final previewHeight = 350.0;
    final previewWidth = previewHeight * ratio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo Calibration', style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy JSON to Clipboard',
            onPressed: () {
              final json = config.toPrettyJson();
              Clipboard.setData(ClipboardData(text: json));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Config JSON copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: Icon(_showMetrics ? Icons.analytics : Icons.analytics_outlined),
            tooltip: 'Toggle Instrumentation',
            onPressed: () {
               setState(() {
                 _showMetrics = !_showMetrics;
               });
            },
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset Defaults',
            onPressed: () {
               ref.refresh(weatherConfigProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // PREVIEW ZONE
          Container(
            height: previewHeight,
            width: double.infinity,
            color: Colors.grey[900],
            alignment: Alignment.center,
            child: Container(
              width: previewWidth,
              height: previewHeight,
              decoration: BoxDecoration(
                 border: Border.all(color: Colors.white30),
                 borderRadius: BorderRadius.circular(8),
                 image: const DecorationImage(
                    image: AssetImage('assets/images/backgrounds/pexels-padrinan-3392246 (1).jpg'),
                    fit: BoxFit.cover,
                 ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                   const WeatherBioLayer(),
                   if (_showMetrics)
                     Consumer(
                       builder: (context, ref, _) {
                         final metrics = ref.watch(weatherMetricsProvider);
                         return Positioned(
                           top: 8, left: 8,
                           child: Container(
                             padding: const EdgeInsets.all(8),
                             color: Colors.black54,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                  const Text("INSTRUMENTATION", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 10)),
                                  Text("Particles: ${metrics.particleCount}", style: const TextStyle(color: Colors.white, fontSize: 10)),
                                  Text("SpawnRate: ${metrics.spawnRate.toStringAsFixed(1)} /s", style: const TextStyle(color: Colors.white, fontSize: 10)),
                                  Text("Collisions: ${metrics.collisionRate} /frame", style: const TextStyle(color: Colors.white, fontSize: 10)),
                               ],
                             ),
                           ),
                         );
                       }
                     ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                _buildScenarioSelector(ref, calibState),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("🎨 CREATIVE MODE V2", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                ),
                _buildRainAesthetics(ref, config.aesthetics),
                _buildSnowAesthetics(ref, config.aesthetics),
                const Divider(),
                _buildCloudSection(ref, config.cloud), // Keep clouds technical for now? Or hide? Keeping for now.
                _buildGeneralSection(ref, config.general),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioSelector(WidgetRef ref, WeatherCalibrationState state) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Mode Calibration (Force Weather)'),
            value: state.isCalibrationMode,
            onChanged: (val) {
              ref
                  .read(weatherCalibrationStateProvider.notifier)
                  .update((s) => s.copyWith(isCalibrationMode: val));
            },
          ),
          if (state.isCalibrationMode) ...[
            Row(
              children: [
                const Text('Weather: '),
                DropdownButton<int?>(
                  value: state.forcedWeatherCode,
                  hint: const Text('Auto'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Keep Real Type')),
                    DropdownMenuItem(value: 0, child: Text('Sunny (0)')),
                    DropdownMenuItem(value: 61, child: Text('Light Rain (61)')),
                    DropdownMenuItem(value: 63, child: Text('Heavy Rain (63)')),
                    DropdownMenuItem(value: 71, child: Text('Snow (71)')),
                    DropdownMenuItem(value: 95, child: Text('Storm (95)')),
                  ],
                  onChanged: (val) {
                    ref.read(weatherCalibrationStateProvider.notifier).update(
                        (s) => s.copyWith(forcedWeatherCode: val));
                  },
                ),
              ],
            ),
            _ConfigSlider(
              label: 'Force Precip (mm)',
              value: state.forcedPrecipMm ?? 0.0,
              min: 0.0,
              max: 10.0,
              onChanged: (v) {
                ref
                    .read(weatherCalibrationStateProvider.notifier)
                    .update((s) => s.copyWith(forcedPrecipMm: v));
              },
            ),
            _ConfigSlider(
              label: 'Force Wind (km/h)',
              value: state.forcedWindSpeed ?? 0.0,
              min: 0.0,
              max: 100.0,
              onChanged: (v) {
                ref
                    .read(weatherCalibrationStateProvider.notifier)
                    .update((s) => s.copyWith(forcedWindSpeed: v));
              },
            ),
             _ConfigSlider(
              label: 'Force Clouds (%)',
              value: state.forcedCloudCover ?? 0.0,
              min: 0.0,
              max: 100.0,
              onChanged: (v) {
                ref
                    .read(weatherCalibrationStateProvider.notifier)
                    .update((s) => s.copyWith(forcedCloudCover: v));
              },
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildRainAesthetics(WidgetRef ref, AestheticConfig config) {
    return _buildAestheticPanel(
      title: '💧 Rain Aesthetics (V3)',
      params: config.rain,
      onUpdate: (newParams) {
        _update(ref, (cfg) => cfg.copyWith(aesthetics: config.copyWith(rain: newParams)));
      },
    );
  }

  Widget _buildSnowAesthetics(WidgetRef ref, AestheticConfig config) {
    return _buildAestheticPanel(
        title: '❄️ Snow Aesthetics (V3)',
        params: config.snow,
        onUpdate: (newParams) {
          _update(ref, (cfg) => cfg.copyWith(aesthetics: config.copyWith(snow: newParams)));
        });
  }

  bool _showMetrics = true;

  Widget _buildAestheticPanel({
    required String title,
    required AestheticParams params,
    required ValueChanged<AestheticParams> onUpdate,
  }) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: true,
      children: [
        // PRESET BUTTONS (V5)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
               ActionChip(
                 label: const Text('Light Rain'),
                 onPressed: () => onUpdate(WeatherPresets.lightRain),
               ),
               ActionChip(
                 label: const Text('Heavy Rain'),
                 onPressed: () => onUpdate(WeatherPresets.heavyRain),
               ),
               ActionChip(
                 label: const Text('Storm'),
                 backgroundColor: Colors.orange.withOpacity(0.2),
                 onPressed: () => onUpdate(WeatherPresets.storm),
               ),
               ActionChip(
                 label: const Text('Snow'),
                 onPressed: () => onUpdate(WeatherPresets.snow),
               ),
               ActionChip(
                 label: const Text('Blizzard'),
                 backgroundColor: Colors.blue.withOpacity(0.2),
                 onPressed: () => onUpdate(WeatherPresets.blizzard),
               ),
            ],
          ),
        ),
        const Divider(),
        _ConfigSlider(
            label: 'Quantity (Density)',
            value: params.quantity,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(quantity: v))),
        _ConfigSlider(
            label: 'Area (Spread)',
            value: params.area,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(area: v))),
        _ConfigSlider(
            label: 'Weight (Grav/Speed)',
            value: params.weight,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(weight: v))),
        _ConfigSlider(
            label: 'Size (Scale)',
            value: params.size,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(size: v))),
        _ConfigSlider(
            label: 'Agitation (Chaos/Wind)',
            value: params.agitation,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(agitation: v))),
        // V4.1 Structural
        const Divider(),
        const Padding(padding: EdgeInsets.only(left: 16), child: Text("Structure", style: TextStyle(fontSize: 10, color: Colors.grey))),
        _ConfigSlider(
            label: 'Clumping (Clusters)',
            value: params.clumping,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(clumping: v))),
        _ConfigSlider(
            label: 'Granularity (Bursts)',
            value: params.granularity,
            min: 0.0, max: 1.0,
            onChanged: (v) => onUpdate(params.copyWith(granularity: v))),
      ],
    );
  }

  // ... (inside build method, update Stack)
  // Replaced Preview Zone with Stack

 
  // Legacy or Technical Sections below
  
  Widget _buildCloudSection(WidgetRef ref, CloudConfig c) {
    return ExpansionTile(
      title: const Text('☁️ Cloud (Technical)'),
      children: [
        _ConfigSlider(
            label: 'Spawn Chance',
            value: c.spawnChance,
            min: 0.0,
            max: 0.2, 
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(cloud: c.copyWith(spawnChance: v)))),
         _ConfigSlider(
            label: 'Max Clouds',
            value: c.maxClouds.toDouble(),
            min: 0,
            max: 20,
            divisions: 20,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(cloud: c.copyWith(maxClouds: v.toInt())))),
      ],
    );
  }

  Widget _buildGeneralSection(WidgetRef ref, GeneralConfig c) {
    return ExpansionTile(
       title: const Text('⚙️ General'),
       children: [
         SwitchListTile(title: const Text('Enable Collision'), value: c.enableCollision, onChanged: (v) {
            _update(ref, (cfg) => cfg.copyWith(general: c.copyWith(enableCollision: v)));
         }),
       ],
    );
  }

  void _update(WidgetRef ref, WeatherConfig Function(WeatherConfig) updater) {
    ref.read(weatherConfigProvider.notifier).update((s) => updater(s));
  }
}

class _ConfigSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _ConfigSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(value.toStringAsFixed(3),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
