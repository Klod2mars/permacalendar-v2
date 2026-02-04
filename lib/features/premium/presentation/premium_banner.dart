import 'package:flutter/material.dart';

import 'package:permacalendar/features/premium/presentation/paywall_sheet.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';

class PremiumBanner extends StatelessWidget {
  final int remaining;
  final int limit;
  final String message;
  final String subMessage;
  
  const PremiumBanner({
    super.key, 
    required this.remaining,
    required this.limit,
    required this.message,
    this.subMessage = 'Go Premium for unlimited',
  });

  @override
  Widget build(BuildContext context) {
    if (EntitlementRepository().getCurrentEntitlement().isActive) {
      return const SizedBox.shrink(); 
    }

    // Safety check just in case
    final safeLimit = limit > 0 ? limit : 1;
    final currentCount = limit - remaining;
    // Cap progress at 1.0
    final progress = (currentCount / safeLimit).clamp(0.0, 1.0);

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
                    message,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  Text(
                    subMessage,
                    style: const TextStyle(fontSize: 12, color: Colors.brown),
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
