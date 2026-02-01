import 'package:flutter/material.dart';
import 'package:permacalendar/features/premium/domain/can_perform_action_checker.dart';
import 'package:permacalendar/features/premium/presentation/paywall_sheet.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';

class PremiumBanner extends StatelessWidget {
  final int currentCount;
  
  const PremiumBanner({super.key, required this.currentCount});

  @override
  Widget build(BuildContext context) {
    if (EntitlementRepository().getCurrentEntitlement().isActive) {
      return const SizedBox.shrink(); // Hide if premium (or show "Premium Active" badge?)
    }

    final limit = CanPerformActionChecker.kFreePlantLimit;
    final remaining = limit - currentCount;
    final progress = currentCount / limit;

    return GestureDetector(
      onTap: () => PaywallSheet.show(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.orange.shade100,
              color: Colors.orange,
              strokeWidth: 4,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    remaining > 0 
                        ? '$remaining plantes gratuites restantes' 
                        : 'Limite gratuite atteinte',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  const Text(
                    'Passez Premium pour illimité',
                    style: TextStyle(fontSize: 12, color: Colors.brown),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
