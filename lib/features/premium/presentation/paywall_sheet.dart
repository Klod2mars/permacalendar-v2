import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/features/premium/presentation/unlock_dialog.dart';
import 'package:permacalendar/features/premium/application/purchase_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallSheet extends ConsumerStatefulWidget {
  const PaywallSheet({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaywallSheet(),
    );
  }

  @override
  ConsumerState<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<PaywallSheet> {
  bool _isLoading = true;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    final offerings = await PurchaseService().getOfferings();
    if (mounted) {
      setState(() {
        _offerings = offerings;
        _isLoading = false;
      });
    }
  }

  Future<void> _onPurchase(Package package) async {
    setState(() => _isLoading = true);
    final success = await PurchaseService().purchasePackage(package);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context); // Close paywall on success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bienvenue dans Premium ! 🌿')),
        );
      }
    }
  }

  Future<void> _onRestore() async {
    setState(() => _isLoading = true);
    final success = await PurchaseService().restorePurchases();
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Achats restaurés avec succès ! 🔄')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun achat trouvé à restaurer.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const Text(
            'Débloquez tout le potentiel 🌱',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Déployez votre potager sans contrainte :\n5 jardins, 100 parcelles chacun,\n6 plantes par parcelle\n👉 3 000 cultures suivies simultanément.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),

          // Content
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_offerings == null || _offerings!.current == null)
            const Text("Aucune connection au store. Veuillez réessayer.")
          else ...[
            // Packages
            if (_offerings!.current!.monthly != null)
              _buildPackageButton(_offerings!.current!.monthly!),
            const SizedBox(height: 12),
            if (_offerings!.current!.annual != null)
              _buildPackageButton(_offerings!.current!.annual!, isAnnual: true),
          ],

          const SizedBox(height: 24),
          
          // Restore
          GestureDetector(
            onLongPress: () async {
              if (kDebugMode) {
                final result = await showDialog(
                  context: context,
                  builder: (context) => const UnlockDialog(),
                );
                if (result == true && mounted) {
                  Navigator.pop(context); // Close paywall if unlocked
                }
              }
            },
            child: TextButton(
              onPressed: _onRestore,
              child: const Text("Restaurer les achats"),
            ),
          ),
          
          const SizedBox(height: 24),
          // Legal
          const Text(
            "L'abonnement se renouvelle automatiquement sauf annulation 24h avant la fin. Gérez votre abonnement dans les réglages du Store.",
            style: TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageButton(Package package, {bool isAnnual = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isAnnual ? const Color(0xFF4CAF50) : Colors.white,
          foregroundColor: isAnnual ? Colors.white : Colors.black,
          side: isAnnual ? null : const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _onPurchase(package),
        child: Column(
          children: [
            Text(
              isAnnual ? "Annuel (Meilleure offre)" : "Mensuel",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              package.storeProduct.priceString,
              style: TextStyle(
                fontSize: 12,
                color: isAnnual ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
