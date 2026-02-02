import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8
import 'package:permacalendar/core/models/entitlement.dart';
import 'package:permacalendar/features/premium/data/entitlement_repository.dart';

class UnlockDialog extends StatefulWidget {
  const UnlockDialog({super.key});

  @override
  State<UnlockDialog> createState() => _UnlockDialogState();
}

class _UnlockDialogState extends State<UnlockDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _obscureText = true;
  String? _errorText;
  bool _isAlreadyPremium = false;

  // Code: "perma2024"
  // python -c "import hashlib; print(hashlib.sha256(b'perma2024').hexdigest())"
  static const String _targetHash = 'd94ff634c718afd85bad52b5995845d436f8020c99c1c9c70de7a8c0230ff7ee';
  
  // Code to modify: "reset_me"
  static const String _resetHash = '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'; 

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() {
    final status = EntitlementRepository().getCurrentEntitlement();
    if (status.isPremium && status.source == 'bypass') {
      setState(() {
        _isAlreadyPremium = true;
      });
    }
  } 

  void _verifyCode() async {
    final input = _controller.text.trim();
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    final hash = digest.toString();

    if (hash == _targetHash) {
      // Grant Premium
      final repo = EntitlementRepository();
      await repo.saveEntitlement(Entitlement.premium(
        productId: 'dev_bypass',
        source: 'bypass',
        expiresAt: null, // Lifetime
      ));
      // Reset limits just in case
      await repo.resetExportQuota();

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔓 Mode Développeur / Premium activé !')),
        );
      }
    } else if (hash == _resetHash) {
      // Revoke
      final repo = EntitlementRepository();
      await repo.clearEntitlement();
       if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔒 Premium révoqué (Reset).')),
        );
      }
    } else {
      setState(() {
        _errorText = 'Code incorrect';
      });
    }
  }

  void _revokePremium() async {
      final repo = EntitlementRepository();
      await repo.clearEntitlement();
       if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🔒 Premium révoqué (Reset).')),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAlreadyPremium) {
      return AlertDialog(
        title: const Text('Mode Développeur Actif'),
        content: const Text('Vous bénéficiez actuellement du statut Premium via le bypass développeur.\n\nVoulez-vous le révoquer pour tester le Paywall ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: _revokePremium,
            child: const Text('RÉVOQUER'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Code Secret'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Entrez le code',
              errorText: _errorText,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
          ),
          const SizedBox(height: 16),
          const Text(
            'Usage réservé aux développeurs et validateurs.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _verifyCode,
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
