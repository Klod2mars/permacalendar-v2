import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/locale_provider.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Langue / Language'),
      ),
      body: ListView(
        children: [
          _buildLanguageTile(
            context,
            ref,
            const Locale('fr'),
            'Français',
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('en'),
            'English',
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('es'),
            'Español',
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('pt', 'BR'),
            'Português (Brasil)',
            currentLocale,
          ),
          _buildLanguageTile(
            context,
            ref,
            const Locale('de'),
            'Deutsch',
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
        currentLocale.countryCode == locale.countryCode;

    return ListTile(
      title: Text(label),
      leading: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.circle_outlined),
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Langue changée : $label')),
        );
      },
    );
  }
}
