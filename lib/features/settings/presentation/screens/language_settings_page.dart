import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language_title),
      ),
      body: ListView(
        children: [
          _buildLanguageTile(
            context,
            ref,
            const Locale('fr'),
            l10n.language_french,
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('en'),
            l10n.language_english,
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('es'),
            l10n.language_spanish,
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('pt', 'BR'),
            l10n.language_portuguese_br,
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('de'),
            l10n.language_german,
            currentLocale,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
    String label,
    Locale currentLocale,
  ) {
    final isSelected = currentLocale.languageCode == locale.languageCode &&
        (locale.countryCode == null || currentLocale.countryCode == locale.countryCode);

    return ListTile(
      title: Text(label),
      leading: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        // Handle specifics for Portuguese which has pt_BR in the UI but we might use pt generic or need to be mapped
        // In the provider we use Locale('pt', 'BR') so it should match.
        ref.read(localeProvider.notifier).setLocale(locale);
        
        // Grab new l10n to show snackbar in the NEW language immediately?
        // Actually context might still have old l10n until rebuild.
        // But usually we want feedback in the new language or current?
        // Let's rely on the rebuild if possible, but the snackbar is triggered immediately.
        // It might use the OLD language context.
        // Ideally we wait for rebuild, but for now we essentially use the current context's l10n 
        // which matches the displayed page.
        // However, if we want the snackbar to say "Language changed" in the NEW language, 
        // we'd need to lookup manually or wait. 
        // For simplicity, let's keep using current context (which is still "old" language until next frame/rebuild).
        // User asked "Langue changée : ..." key is `language_changed_snackbar`.
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.language_changed_snackbar(label))),
        );
      },
    );
  }
}
