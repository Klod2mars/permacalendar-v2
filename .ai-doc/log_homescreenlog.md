==========================================
🟡 PermaCalendar - CLEAN + RUN
==========================================

🔹 Étape 1 : Nettoyage Flutter...
Deleting build...                                                  717ms
Deleting .dart_tool...                                              34ms
Deleting ephemeral...                                                0ms
Deleting Generated.xcconfig...                                       0ms
Deleting flutter_export_environment.sh...                            0ms
Deleting ephemeral...                                                2ms
Deleting ephemeral...                                                1ms
Deleting .flutter-plugins-dependencies...                            0ms

🔹 Étape 2 : Récupération des dépendances...
Resolving dependencies...
Downloading packages...
  _fe_analyzer_shared 67.0.0 (92.0.0 available)
  analyzer 6.4.1 (9.0.0 available)
  analyzer_plugin 0.11.3 (0.13.11 available)
  build 2.4.1 (4.0.2 available)
  build_config 1.1.2 (1.2.0 available)
  build_resolvers 2.4.2 (3.0.4 available)
  build_runner 2.4.13 (2.10.1 available)
  build_runner_core 7.3.2 (9.3.2 available)
  characters 1.4.0 (1.4.1 available)
  crypto 3.0.6 (3.0.7 available)
  custom_lint 0.5.11 (0.8.1 available)
  custom_lint_core 0.5.14 (0.8.1 available)
  dart_style 2.3.6 (3.1.2 available)
  flutter_lints 3.0.2 (6.0.0 available)
  flutter_svg 2.2.1 (2.2.2 available)
  freezed 2.5.2 (3.2.3 available)
  freezed_annotation 2.4.4 (3.1.0 available)
  go_router 16.3.0 (17.0.0 available)
  json_serializable 6.8.0 (6.11.1 available)
  lints 3.0.0 (6.0.0 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
  mockito 5.4.4 (5.5.1 available)
  package_info_plus 8.3.1 (9.0.0 available)
  riverpod_analyzer_utils 1.0.0-dev.1 (1.0.0-dev.7 available)
  riverpod_generator 3.0.0-dev.11 (3.0.3 available)
  rxdart 0.27.7 (0.28.0 available)
  shelf_web_socket 2.0.1 (3.0.0 available)
  source_gen 1.5.0 (4.0.2 available)
  source_helper 1.3.5 (1.3.8 available)
  test 1.26.2 (1.26.3 available)
  test_api 0.7.6 (0.7.7 available)
  test_core 0.6.11 (0.6.12 available)
  uuid 4.5.1 (4.5.2 available)
Got dependencies!
34 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.

🔹 Étape 3 : Construction des fichiers générés (build_runner)...
Deprecated. Use `dart run` instead.
Building package executable... (8.8s)
Built build_runner:build_runner.
[INFO] Generating build script completed, took 189ms
[INFO] Precompiling build script... completed, took 3.5s
[INFO] Building new asset graph completed, took 1.6s
[INFO] Checking for unexpected pre-existing outputs. completed, took 5ms
[WARNING] riverpod_generator on lib/app_initializer.dart:
Your current `analyzer` version may not fully support your current SDK version.

Analyzer language version: 3.4.0
SDK language version: 3.9.0

Please update to the latest `analyzer` version (9.0.0) by running
`flutter packages upgrade`.

If you are not getting the latest version by running the above command, you
can try adding a constraint like the following to your pubspec to start
diagnosing why you can't get the latest version:

dev_dependencies:
  analyzer: ^9.0.0

[INFO] Generating SDK summary completed, took 3.5s
[SEVERE] riverpod_generator on lib/shared/presentation/screens/home_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/shared/presentation/screens/home_screen.dart (or an existing part) contains the following errors.
home_screen.dart:424:30: Named parameters must be enclosed in curly braces ('{' and '}').
home_screen.dart:424:35: A function body must be provided.
home_screen.dart:424:9: Getters, setters and methods can't be declared to be 'const'.
And 10 more...

Try fixing the errors and re-running the build.

[SEVERE] freezed on lib/shared/presentation/screens/home_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/shared/presentation/screens/home_screen.dart (or an existing part) contains the following errors.
home_screen.dart:424:30: Named parameters must be enclosed in curly braces ('{' and '}').
home_screen.dart:424:35: A function body must be provided.
home_screen.dart:424:9: Getters, setters and methods can't be declared to be 'const'.
And 10 more...

Try fixing the errors and re-running the build.

[SEVERE] json_serializable on lib/shared/presentation/screens/home_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/shared/presentation/screens/home_screen.dart (or an existing part) contains the following errors.
home_screen.dart:424:30: Named parameters must be enclosed in curly braces ('{' and '}').
home_screen.dart:424:35: A function body must be provided.
home_screen.dart:424:9: Getters, setters and methods can't be declared to be 'const'.
And 10 more...

Try fixing the errors and re-running the build.

[SEVERE] hive_generator on lib/shared/presentation/screens/home_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/shared/presentation/screens/home_screen.dart (or an existing part) contains the following errors.
home_screen.dart:424:30: Named parameters must be enclosed in curly braces ('{' and '}').
home_screen.dart:424:35: A function body must be provided.
home_screen.dart:424:9: Getters, setters and methods can't be declared to be 'const'.
And 10 more...

Try fixing the errors and re-running the build.

[INFO] Running build completed, took 19.5s
[INFO] Caching finalized dependency graph completed, took 63ms
[SEVERE] Failed after 19.5s
Failed to update packages.
⚠️ Avertissement : problème de génération, mais on tente quand même le lancement.

🚀 Étape 4 : Lancement de l'application sur ton téléphone...
Resolving dependencies...
Downloading packages...
  _fe_analyzer_shared 67.0.0 (92.0.0 available)
  analyzer 6.4.1 (9.0.0 available)
  analyzer_plugin 0.11.3 (0.13.11 available)
  build 2.4.1 (4.0.2 available)
  build_config 1.1.2 (1.2.0 available)
  build_resolvers 2.4.2 (3.0.4 available)
  build_runner 2.4.13 (2.10.1 available)
  build_runner_core 7.3.2 (9.3.2 available)
  characters 1.4.0 (1.4.1 available)
  crypto 3.0.6 (3.0.7 available)
  custom_lint 0.5.11 (0.8.1 available)
  custom_lint_core 0.5.14 (0.8.1 available)
  dart_style 2.3.6 (3.1.2 available)
  flutter_lints 3.0.2 (6.0.0 available)
  flutter_svg 2.2.1 (2.2.2 available)
  freezed 2.5.2 (3.2.3 available)
  freezed_annotation 2.4.4 (3.1.0 available)
  go_router 16.3.0 (17.0.0 available)
  json_serializable 6.8.0 (6.11.1 available)
  lints 3.0.0 (6.0.0 available)
  material_color_utilities 0.11.1 (0.13.0 available)
  meta 1.16.0 (1.17.0 available)
  mockito 5.4.4 (5.5.1 available)
  package_info_plus 8.3.1 (9.0.0 available)
  riverpod_analyzer_utils 1.0.0-dev.1 (1.0.0-dev.7 available)
  riverpod_generator 3.0.0-dev.11 (3.0.3 available)
  rxdart 0.27.7 (0.28.0 available)
  shelf_web_socket 2.0.1 (3.0.0 available)
  source_gen 1.5.0 (4.0.2 available)
  source_helper 1.3.5 (1.3.8 available)
  test 1.26.2 (1.26.3 available)
  test_api 0.7.6 (0.7.7 available)
  test_core 0.6.11 (0.6.12 available)
  uuid 4.5.1 (4.5.2 available)
Got dependencies!
34 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Launching lib\main.dart on SM A356B in debug mode...
lib/shared/presentation/screens/home_screen.dart:424:30: Error: Non-optional parameters can't have a default value.
Try removing the default value or making the parameter optional.
        const SizedBox(height: 12),
                             ^
lib/shared/presentation/screens/home_screen.dart:424:35: Error: Expected '{' before this.
        const SizedBox(height: 12),
                                  ^
lib/shared/presentation/screens/home_screen.dart:424:9: Error: Getters, setters and methods can't be declared to be 'const'.
Try removing the 'const' keyword.
        const SizedBox(height: 12),
        ^^^^^
lib/shared/presentation/screens/home_screen.dart:424:35: Error: Expected a class member, but got ','.
        const SizedBox(height: 12),
                                  ^
lib/shared/presentation/screens/home_screen.dart:427:29: Error: Non-optional parameters can't have a default value.
Try removing the default value or making the parameter optional.
          crossAxisAlignment: CrossAxisAlignment.stretch,
                            ^
lib/shared/presentation/screens/home_screen.dart:428:19: Error: Non-optional parameters can't have a default value.
Try removing the default value or making the parameter optional.
          children: [
                  ^
lib/shared/presentation/screens/home_screen.dart:462:10: Error: Expected '{' before this.
        ),
         ^
lib/shared/presentation/screens/home_screen.dart:462:10: Error: Expected a class member, but got ','.
        ),
         ^
lib/shared/presentation/screens/home_screen.dart:463:7: Error: Expected a class member, but got ']'.
      ],
      ^
lib/shared/presentation/screens/home_screen.dart:463:8: Error: Expected a class member, but got ','.
      ],
       ^
lib/shared/presentation/screens/home_screen.dart:464:5: Error: Expected a class member, but got ')'.
    );
    ^
lib/shared/presentation/screens/home_screen.dart:464:6: Error: Expected a class member, but got ';'.
    );
     ^
lib/shared/presentation/screens/home_screen.dart:713:1: Error: Expected a declaration, but got '}'.
}
^
lib/shared/presentation/screens/home_screen.dart:430:32: Error: Undefined name 'context'.
              onPressed: () => context.push(AppRoutes.recommendations),
                               ^^^^^^^
lib/shared/presentation/screens/home_screen.dart:430:40: Error: Method invocation is not a constant expression.
              onPressed: () => context.push(AppRoutes.recommendations),
                                       ^^^^
lib/shared/presentation/screens/home_screen.dart:430:26: Error: Not a constant expression.
              onPressed: () => context.push(AppRoutes.recommendations),
                         ^^
lib/shared/presentation/screens/home_screen.dart:433:37: Error: Method invocation is not a constant expression.
              style: OutlinedButton.styleFrom(
                                    ^^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:429:28: Error: Constant expression expected.
Try inserting 'const'.
            OutlinedButton.icon(
                           ^^^^
lib/shared/presentation/screens/home_screen.dart:429:28: Error: Cannot invoke a non-'const' factory where a const expression is expected.
Try using a constructor or factory that is 'const'.
            OutlinedButton.icon(
                           ^^^^
lib/shared/presentation/screens/home_screen.dart:439:19: Error: Not a constant expression.
            const SizedBox(height: 12),
                  ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:441:32: Error: Undefined name 'context'.
              onPressed: () => context.push(AppRoutes.notifications),
                               ^^^^^^^
lib/shared/presentation/screens/home_screen.dart:441:40: Error: Method invocation is not a constant expression.
              onPressed: () => context.push(AppRoutes.notifications),
                                       ^^^^
lib/shared/presentation/screens/home_screen.dart:441:26: Error: Not a constant expression.
              onPressed: () => context.push(AppRoutes.notifications),
                         ^^
lib/shared/presentation/screens/home_screen.dart:444:37: Error: Method invocation is not a constant expression.
              style: OutlinedButton.styleFrom(
                                    ^^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:440:28: Error: Constant expression expected.
Try inserting 'const'.
            OutlinedButton.icon(
                           ^^^^
lib/shared/presentation/screens/home_screen.dart:440:28: Error: Cannot invoke a non-'const' factory where a const expression is expected.
Try using a constructor or factory that is 'const'.
            OutlinedButton.icon(
                           ^^^^
lib/shared/presentation/screens/home_screen.dart:450:19: Error: Not a constant expression.
            const SizedBox(height: 12),
                  ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:452:32: Error: Undefined name 'context'.
              onPressed: () => context.push(AppRoutes.intelligenceSettings),
                               ^^^^^^^
lib/shared/presentation/screens/home_screen.dart:452:40: Error: Method invocation is not a constant expression.
              onPressed: () => context.push(AppRoutes.intelligenceSettings),
                                       ^^^^
lib/shared/presentation/screens/home_screen.dart:452:26: Error: Not a constant expression.
              onPressed: () => context.push(AppRoutes.intelligenceSettings),
                         ^^
lib/shared/presentation/screens/home_screen.dart:455:37: Error: Method invocation is not a constant expression.
              style: OutlinedButton.styleFrom(
                                    ^^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:451:28: Error: Constant expression expected.
Try inserting 'const'.
            OutlinedButton.icon(
                           ^^^^
lib/shared/presentation/screens/home_screen.dart:451:28: Error: Cannot invoke a non-'const' factory where a const expression is expected.
Try using a constructor or factory that is 'const'.
            OutlinedButton.icon(
                           ^^^^
lib/shared/presentation/screens/home_screen.dart:428:21: Error: Constant expression expected.
Try inserting 'const'.
          children: [
                    ^
lib/shared/presentation/screens/home_screen.dart:51:21: Error: Not a constant expression.
              const SizedBox(height: 24),
                    ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:55:21: Error: Not a constant expression.
              const SizedBox(height: 24),
                    ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:59:21: Error: Not a constant expression.
              const SizedBox(height: 24),
                    ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:46:24: Error: Too few positional arguments: 2 required, 0 given.
          child: Column(
                       ^
lib/shared/presentation/screens/home_screen.dart:105:29: Error: Not a constant expression.
                      const SizedBox(height: 4),
                            ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:118:23: Error: Not a constant expression.
                const SizedBox(height: 12),
                      ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:122:23: Error: Not a constant expression.
                const SizedBox(height: 12),
                      ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:126:23: Error: Not a constant expression.
                const SizedBox(height: 12),
                      ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:129:23: Error: Not a constant expression.
                const SizedBox(height: 12),
                      ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:131:23: Error: Not a constant expression.
                const SizedBox(height: 16),
                      ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:96:25: Error: Too few positional arguments: 2 required, 0 given.
                  Column(
                        ^
lib/shared/presentation/screens/home_screen.dart:158:15: Error: Not a constant expression.
        const SizedBox(height: 8),
              ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:150:18: Error: Too few positional arguments: 2 required, 0 given.
    return Column(
                 ^
lib/shared/presentation/screens/home_screen.dart:187:15: Error: Not a constant expression.
        const SizedBox(height: 8),
              ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:188:15: Error: Too few positional arguments: 2 required, 0 given.
        Column(
              ^
lib/shared/presentation/screens/home_screen.dart:179:18: Error: Too few positional arguments: 2 required, 0 given.
    return Column(
                 ^
lib/shared/presentation/screens/home_screen.dart:234:15: Error: Not a constant expression.
        const SizedBox(height: 16),
              ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:256:29: Error: Not a constant expression.
                      const SizedBox(width: 8),
                            ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:266:25: Error: Not a constant expression.
                  const SizedBox(height: 12),
                        ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:271:25: Error: Not a constant expression.
                  const SizedBox(height: 12),
                        ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:279:29: Error: Not a constant expression.
                      const SizedBox(width: 12),
                            ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:335:21: Error: Not a constant expression.
              const SizedBox(height: 12),
                    ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:250:28: Error: Too few positional arguments: 2 required, 0 given.
              child: Column(
                           ^
lib/shared/presentation/screens/home_screen.dart:292:17: Error: Too few positional arguments: 2 required, 0 given.
          Column(
                ^
lib/shared/presentation/screens/home_screen.dart:225:18: Error: Too few positional arguments: 2 required, 0 given.
    return Column(
                 ^
lib/shared/presentation/screens/home_screen.dart:360:13: Error: Not a constant expression.
      const SizedBox(height: 16),
            ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:373:13: Error: Not a constant expression.
      const SizedBox(height: 12),
            ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:388:17: Error: Not a constant expression.
          const SizedBox(height: 12),
                ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:398:17: Error: Not a constant expression.
          const SizedBox(height: 12),
                ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:408:17: Error: Not a constant expression.
          const SizedBox(height: 12),
                ^^^^^^^^
lib/shared/presentation/screens/home_screen.dart:376:13: Error: Too few positional arguments: 2 required, 0 given.
      Column(
            ^
lib/shared/presentation/screens/home_screen.dart:351:16: Error: Too few positional arguments: 2 required, 0 given.
  return Column(
               ^
lib/shared/presentation/screens/home_screen.dart:428:21: Error: Non-constant list literal is not a constant expression.
          children: [
                    ^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'C:\src\flutter\bin\flutter.bat'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 35s
Running Gradle task 'assembleDebug'...                             35,5s
Error: Gradle task assembleDebug failed with exit code 1

==========================================
✅ Fin du script CLEAN + RUN
==========================================
Appuyez sur une touche pour continuer...