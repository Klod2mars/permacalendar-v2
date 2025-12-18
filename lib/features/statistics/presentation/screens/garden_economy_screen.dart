import 'package:flutter/material.dart';

class GardenEconomyScreen extends StatelessWidget {
  final String gardenId;
  const GardenEconomyScreen({super.key, required this.gardenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Économie Vivante')),
      body: Center(child: Text('Détails Économie pour $gardenId')),
    );
  }
}
