import 'package:flutter/material.dart';

class GardenPerformanceScreen extends StatelessWidget {
  final String gardenId;
  const GardenPerformanceScreen({super.key, required this.gardenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance')),
      body: Center(child: Text('Détails Performance pour $gardenId')),
    );
  }
}
