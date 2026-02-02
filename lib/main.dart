import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_initializer.dart';
import 'app_router.dart';
import 'core/feature_flags.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_m3.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
    Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 12),
              Text('Erreur interne : ${details.exception}', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  };

  runZonedGuarded<Future<void>>(() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await AppInitializer.initialize();
    await initializeDateFormatting('fr_FR', null);
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) {
    // force le dump complet dans log natif -> visible via adb logcat
    print('UNCAUGHT ERROR (zone): $error\n$stack');
  });
}

/// Widget d'affichage d'erreur minimal/optionnel
class ErrorScreenContent extends StatefulWidget {
  final Object error;
  final StackTrace? stack;
  const ErrorScreenContent(this.error, this.stack, {Key? key}) : super(key: key);

  @override
  State<ErrorScreenContent> createState() => _ErrorScreenContentState();
}

class _ErrorScreenContentState extends State<ErrorScreenContent> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final shortMsg = widget.error.toString();
    final stackStr = widget.stack?.toString() ?? 'No stack available';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.error_outline, size: 72, color: Colors.red),
        const SizedBox(height: 16),
        Text('Une erreur interne est survenue', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(shortMsg, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showDetails = !_showDetails;
            });
          },
          child: Text(_showDetails ? 'Masquer les détails' : 'Afficher les détails'),
        ),
        if (_showDetails) ...[
          const SizedBox(height: 12),
          SelectableText(stackStr, style: const TextStyle(fontSize: 12)),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => SystemNavigator.pop(),
          child: const Text('Quitter'),
        ),
      ],
    );
  }
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
