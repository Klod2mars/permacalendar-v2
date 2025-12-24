import 'package:flutter/material.dart';
import '../../widgets/custom_input.dart';

class GardenCreationDialog extends StatefulWidget {
  const GardenCreationDialog({super.key});

  @override
  State<GardenCreationDialog> createState() => _GardenCreationDialogState();
}

class _GardenCreationDialogState extends State<GardenCreationDialog> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Créer votre premier jardin'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Donnez un nom à votre espace de permaculture pour commencer.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: _nameController,
              label: 'Nom du jardin',
              hint: 'Ex: Mon Potager',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_nameController.text.trim());
            }
          },
          child: const Text('Créer'),
        ),
      ],
    );
  }
}
