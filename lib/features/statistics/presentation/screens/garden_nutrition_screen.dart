import 'package:flutter/material.dart';

class GardenNutritionScreen extends StatelessWidget {
  final String gardenId;
  const GardenNutritionScreen({super.key, required this.gardenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Santé & Nutrition')),
      body: Center(child: Text('Détails Nutrition pour $gardenId')),
    );
  }
}
