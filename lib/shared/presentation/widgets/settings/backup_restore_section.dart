import 'package:flutter/material.dart';
import '../../../../core/services/backup/full_backup_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/custom_card.dart';

class BackupRestoreSection extends StatefulWidget {
  const BackupRestoreSection({super.key});

  @override
  State<BackupRestoreSection> createState() => _BackupRestoreSectionState();
}

class _BackupRestoreSectionState extends State<BackupRestoreSection> {
  bool _isLoading = false;

  Future<void> _createBackup() async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await FullBackupService().createAndShareBackup();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settings_backup_success)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settings_backup_error(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _restoreBackup() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Warning Dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settings_restore_warning_title),
        content: Text(l10n.settings_restore_warning_content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.dialog_cancel),
          ),
          TextButton(
             onPressed: () => Navigator.pop(ctx, true),
             style: TextButton.styleFrom(foregroundColor: Colors.red),
             child: Text(l10n.dialog_confirm),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await FullBackupService().restoreBackup();
      if (mounted) {
        // Show success
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.settings_restore_success)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.settings_restore_error(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          l10n.settings_backup_restore_section,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(children: [
            if (_isLoading)
               const Padding(
                 padding: EdgeInsets.all(16.0),
                 child: Center(child: CircularProgressIndicator()),
               ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: Text(l10n.settings_backup_action),
              subtitle: Text(l10n.settings_backup_restore_subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: _isLoading ? null : _createBackup,
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.settings_backup_restore),
              title: Text(l10n.settings_restore_action),
              subtitle: const Text('Compatible ZIP'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _isLoading ? null : _restoreBackup,
            ),
          ]),
        ),
    ]);
  }
}
