import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_config_provider.dart';
import '../../domain/models/weather_config.dart';

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
              print('--- WEATHER CONFIG JSON ---');
              print(json);
              print('---------------------------');
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
              child: const WeatherBioLayer(),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 30),
              children: [
                _buildScenarioSelector(ref, calibState),
                const Divider(),
                _buildRainSection(ref, config.rain),
                _buildSnowSection(ref, config.snow),
                _buildCloudSection(ref, config.cloud),
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

  Widget _buildRainSection(WidgetRef ref, RainConfig c) {
    return ExpansionTile(
      title: const Text('💧 Rain Config'),
      initiallyExpanded: true,
      children: [
        _ConfigSlider(
            label: 'Gravity',
            value: c.gravity,
            min: 0.1,
            max: 2.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(gravity: v)))),
        _ConfigSlider(
            label: 'Velocity Base',
            value: c.velocityBase,
             min: 0.1,
            max: 5.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(velocityBase: v)))),
         _ConfigSlider(
            label: 'Velocity Var',
            value: c.velocityVariance,
            min: 0.0,
            max: 2.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(velocityVariance: v)))),
         _ConfigSlider(
            label: 'Size Base',
            value: c.sizeBase,
            min: 0.5,
            max: 5.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(sizeBase: v)))),
         _ConfigSlider(
            label: 'Size Var',
            value: c.sizeVariance,
            min: 0.0,
            max: 5.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(sizeVariance: v)))),
         _ConfigSlider(
            label: 'Spawn Rate Base',
            value: c.spawnRateBase,
            min: 10.0,
            max: 200.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(spawnRateBase: v)))),
         _ConfigSlider(
            label: 'Horizontal Spread',
            value: c.horizontalSpread,
            min: 1.0,
            max: 10.0, // Allow up to 10x radius
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(rain: c.copyWith(horizontalSpread: v)))),
      ],
    );
  }

   Widget _buildSnowSection(WidgetRef ref, SnowConfig c) {
    return ExpansionTile(
      title: const Text('❄️ Snow Config'),
      children: [
        _ConfigSlider(
            label: 'Gravity',
            value: c.gravity,
            min: 0.01,
            max: 0.5,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(snow: c.copyWith(gravity: v)))),
        _ConfigSlider(
            label: 'Fall Speed Base',
            value: c.fallSpeedBase,
            min: 0.01,
            max: 1.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(snow: c.copyWith(fallSpeedBase: v)))),
           _ConfigSlider(
            label: 'Fall Speed Var',
            value: c.fallSpeedVariance,
            min: 0.0,
            max: 0.5,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(snow: c.copyWith(fallSpeedVariance: v)))),
        _ConfigSlider(
            label: 'Base Multiplier',
            value: c.baseMultiplier,
            min: 1.0,
            max: 50.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(snow: c.copyWith(baseMultiplier: v)))),
         _ConfigSlider(
            label: 'Horizontal Spread',
            value: c.horizontalSpread,
            min: 1.0,
            max: 10.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(snow: c.copyWith(horizontalSpread: v)))),
      ],
    );
  }

  Widget _buildCloudSection(WidgetRef ref, CloudConfig c) {
    return ExpansionTile(
      title: const Text('☁️ Cloud Config'),
      children: [
        _ConfigSlider(
            label: 'Spawn Chance',
            value: c.spawnChance,
            min: 0.0,
            max: 0.2, // 20% per tick is huge
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(cloud: c.copyWith(spawnChance: v)))),
        _ConfigSlider(
            label: 'Size Base',
            value: c.sizeBase,
            min: 10.0,
            max: 100.0,
            onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(cloud: c.copyWith(sizeBase: v)))),
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
         _ConfigSlider(label: 'Precip Threshold (mm)', value: c.precipThresholdMm, min: 0.0, max: 1.0,
         onChanged: (v) => _update(ref, (cfg) => cfg.copyWith(general: c.copyWith(precipThresholdMm: v))))
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
