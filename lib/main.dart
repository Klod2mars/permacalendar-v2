import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:path_provider/path_provider.dart';

// âœ… IMPORTS CRITIQUES (mentionnés dans le doc)
import 'app_initializer.dart';
import 'app_router.dart';
import 'core/feature_flags.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_m3.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // âœ… NOUVEAU : Utiliser AppInitializer pour une initialisation complète
  await AppInitializer.initialize();

  // Initialires les données locales pour les dates
  await initializeDateFormatting('fr_FR', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final flags = ref.watch(featureFlagsProvider);

    // Sélection du thème selon le feature flag
    final lightTheme =
        flags.materialDesign3 ? AppThemeM3.lightTheme : AppTheme.lightTheme;
    final darkTheme =
        flags.materialDesign3 ? AppThemeM3.darkTheme : AppTheme.darkTheme;

    return MaterialApp.router(
      title: 'PermaCalendar v2.1',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      locale: ref.watch(localeProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
