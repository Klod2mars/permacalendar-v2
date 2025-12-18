import 'package:flutter/material.dart';

class EconomyLogisticsSavingsCard extends StatelessWidget {
  const EconomyLogisticsSavingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder logic for now, could be driven by a provider
    const double fuelSaved = 12.5; // litres
    const double co2Saved = 28.0; // kg
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                'Économies logistiques',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLogisticItem(context, '$fuelSaved L', 'Carburant évité', Icons.oil_barrel, Colors.orangeAccent),
              _buildLogisticItem(context, '$co2Saved kg', 'CO2 épargné', Icons.cloud_off, Colors.tealAccent),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildLogisticItem(BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
