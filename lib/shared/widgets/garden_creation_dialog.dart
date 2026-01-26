import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';


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
      title: Text(AppLocalizations.of(context)!.garden_creation_dialog_title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.garden_creation_dialog_description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.garden_creation_name_label,
                hintText: AppLocalizations.of(context)!.garden_creation_name_hint,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? AppLocalizations.of(context)!.garden_creation_name_required
                      : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.dialog_cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_nameController.text.trim());
            }
          },
          child: Text(AppLocalizations.of(context)!.garden_creation_create_button),
        ),
      ],
    );
  }
}
