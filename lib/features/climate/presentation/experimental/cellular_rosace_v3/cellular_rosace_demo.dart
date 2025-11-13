import 'package:flutter/material.dart';
import 'cellular_rosace_widget.dart';

/// Demo screen for Cellular Rosace V3
///
/// This demo showcases the living cellular tissue with different
/// data hierarchies and custom color schemes.
class CellularRosaceDemo extends StatefulWidget {
  const CellularRosaceDemo({super.key});

  @override
  State<CellularRosaceDemo> createState() => _CellularRosaceDemoState();
}

class _CellularRosaceDemoState extends State<CellularRosaceDemo> {
  int _currentDemo = 0;

  final List<DemoConfiguration> _demos = [
    const DemoConfiguration(
      title: 'Default Configuration',
      description: 'Standard cellular layout with balanced importance',
      dataHierarchy: {
        'ph_core': 1.0,
        'weather_current': 0.9,
        'soil_temp': 0.7,
        'weather_forecast': 0.6,
        'alerts': 0.5,
      },
    ),
    const DemoConfiguration(
      title: 'Weather Focused',
      description: 'Emphasizes weather data with larger cells',
      dataHierarchy: {
        'weather_current': 1.0,
        'ph_core': 0.8,
        'weather_forecast': 0.7,
        'soil_temp': 0.5,
        'alerts': 0.4,
      },
    ),
    const DemoConfiguration(
      title: 'Soil Monitoring',
      description: 'Focuses on soil conditions and pH',
      dataHierarchy: {
        'ph_core': 1.0,
        'soil_temp': 0.9,
        'weather_current': 0.6,
        'alerts': 0.5,
        'weather_forecast': 0.4,
      },
    ),
    const DemoConfiguration(
      title: 'Alert Priority',
      description: 'Highlights alerts and monitoring',
      dataHierarchy: {
        'alerts': 1.0,
        'ph_core': 0.8,
        'weather_current': 0.6,
        'soil_temp': 0.5,
        'weather_forecast': 0.4,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentDemo = _demos[_currentDemo];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cellular Rosace V3 Demo'),
        backgroundColor: const Color(0xFF1B4332),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFE8F5E9),
      body: SafeArea(
        child: Column(
          children: [
            // Demo selector
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentDemo.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentDemo.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF558B2F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentDemo > 0 ? _previousDemo : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentDemo < _demos.length - 1
                              ? _nextDemo
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Cellular rosace
            Expanded(
              child: Center(
                child: CellularRosaceWidget(
                  dataHierarchy: currentDemo.dataHierarchy,
                  customColors: currentDemo.customColors,
                  onCellTap: _handleCellTap,
                  height: 280.0,
                  margin: const EdgeInsets.all(20.0),
                ),
              ),
            ),

            // Data hierarchy display
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Hierarchy:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...currentDemo.dataHierarchy.entries.map((entry) {
                    final importance = entry.value;
                    final barWidth = importance * 200.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF558B2F),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: barWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getImportanceColor(importance),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            importance.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF689F38),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previousDemo() {
    if (_currentDemo > 0) {
      setState(() {
        _currentDemo--;
      });
    }
  }

  void _nextDemo() {
    if (_currentDemo < _demos.length - 1) {
      setState(() {
        _currentDemo++;
      });
    }
  }

  void _handleCellTap(String cellId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped: $cellId'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cellular Rosace V3'),
        content: const Text(
          'This experimental prototype demonstrates a living, breathing cellular tissue '
          'inspired by plant epidermis under a microscope.\n\n'
          'Features:\n'
          '• Unified cellular structure with shared membranes\n'
          '• Organic pressure variations\n'
          '• Living animations (breathing, pulsation)\n'
          '• Organic touch responses\n'
          '• Irregular cell shapes with natural boundaries\n\n'
          'Tap cells to see touch responses and try different configurations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getImportanceColor(double importance) {
    if (importance >= 0.8) return const Color(0xFF4CAF50);
    if (importance >= 0.6) return const Color(0xFF8BC34A);
    if (importance >= 0.4) return const Color(0xFFCDDC39);
    return const Color(0xFFFFEB3B);
  }
}

/// Demo configuration data
class DemoConfiguration {
  final String title;
  final String description;
  final Map<String, double> dataHierarchy;
  final Map<String, Color>? customColors;

  const DemoConfiguration({
    required this.title,
    required this.description,
    required this.dataHierarchy,
    this.customColors,
  });
}


