import 'package:flutter/material.dart';

class GardenAlignmentScreen extends StatelessWidget {
  final String gardenId;
  const GardenAlignmentScreen({super.key, required this.gardenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alignement')),
      body: Center(child: Text('Détails Alignement pour $gardenId')),
    );
  }
}
