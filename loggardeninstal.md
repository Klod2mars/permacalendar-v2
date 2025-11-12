PS C:\Users\roman\Documents\apppklod\permacalendarv2> flutter pub get
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
  http 1.5.0 (1.6.0 available)
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
35 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
PS C:\Users\roman\Documents\apppklod\permacalendarv2> # régénère les builders
PS C:\Users\roman\Documents\apppklod\permacalendarv2> flutter pub run build_runner build --delete-conflicting-outputs
Deprecated. Use `dart run` instead.
[INFO] Generating build script completed, took 183ms
[INFO] Reading cached asset graph completed, took 188ms
[INFO] Checking for updates since last build completed, took 873ms
[SEVERE] riverpod_generator on lib/app_router.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/app_router.dart (or an existing part) contains the following errors.
app_router.dart:308:43: Expected to find ','.
app_router.dart:308:50: Expected to find ','.
app_router.dart:308:54: Expected an identifier.
And 6 more...

Try fixing the errors and re-running the build.

[SEVERE] riverpod_generator on lib/features/garden_management/presentation/screens/garden_list_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_list_screen.dart (or an existing part) contains the following errors.
garden_list_screen.dart:119:58: Expected to find ','.
garden_list_screen.dart:119:68: Expected to find ','.
garden_list_screen.dart:119:72: Expected to find ','.
And 8 more...

Try fixing the errors and re-running the build.

[SEVERE] riverpod_generator on lib/features/garden_management/presentation/screens/garden_create_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_create_screen.dart (or an existing part) contains the following errors.
garden_create_screen.dart:95:40: Expected to find ','.
garden_create_screen.dart:95:45: Expected to find ','.
garden_create_screen.dart:96:21: Expected to find ','.
And 5 more...

Try fixing the errors and re-running the build.

[SEVERE] freezed on lib/features/garden_management/presentation/screens/garden_create_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_create_screen.dart (or an existing part) contains the following errors.
garden_create_screen.dart:95:40: Expected to find ','.
garden_create_screen.dart:95:45: Expected to find ','.
garden_create_screen.dart:96:21: Expected to find ','.
And 5 more...

Try fixing the errors and re-running the build.

[SEVERE] freezed on lib/app_router.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/app_router.dart (or an existing part) contains the following errors.
app_router.dart:308:43: Expected to find ','.
app_router.dart:308:50: Expected to find ','.
app_router.dart:308:54: Expected an identifier.
And 6 more...

Try fixing the errors and re-running the build.

[SEVERE] freezed on lib/features/garden_management/presentation/screens/garden_list_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_list_screen.dart (or an existing part) contains the following errors.
garden_list_screen.dart:119:58: Expected to find ','.
garden_list_screen.dart:119:68: Expected to find ','.
garden_list_screen.dart:119:72: Expected to find ','.
And 8 more...

Try fixing the errors and re-running the build.

[WARNING] riverpod_generator on lib/features/garden_management/presentation/screens/garden_create_screen.dart:
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

[SEVERE] json_serializable on lib/app_router.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/app_router.dart (or an existing part) contains the following errors.
app_router.dart:308:43: Expected to find ','.
app_router.dart:308:50: Expected to find ','.
app_router.dart:308:54: Expected an identifier.
And 6 more...

Try fixing the errors and re-running the build.

[SEVERE] json_serializable on lib/features/garden_management/presentation/screens/garden_create_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_create_screen.dart (or an existing part) contains the following errors.
garden_create_screen.dart:95:40: Expected to find ','.
garden_create_screen.dart:95:45: Expected to find ','.
garden_create_screen.dart:96:21: Expected to find ','.
And 5 more...

Try fixing the errors and re-running the build.

[SEVERE] json_serializable on lib/features/garden_management/presentation/screens/garden_list_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_list_screen.dart (or an existing part) contains the following errors.
garden_list_screen.dart:119:58: Expected to find ','.
garden_list_screen.dart:119:68: Expected to find ','.
garden_list_screen.dart:119:72: Expected to find ','.
And 8 more...

Try fixing the errors and re-running the build.

[SEVERE] hive_generator on lib/app_router.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/app_router.dart (or an existing part) contains the following errors.
app_router.dart:308:43: Expected to find ','.
app_router.dart:308:50: Expected to find ','.
app_router.dart:308:54: Expected an identifier.
And 6 more...

Try fixing the errors and re-running the build.

[SEVERE] hive_generator on lib/features/garden_management/presentation/screens/garden_create_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_create_screen.dart (or an existing part) contains the following errors.
garden_create_screen.dart:95:40: Expected to find ','.
garden_create_screen.dart:95:45: Expected to find ','.
garden_create_screen.dart:96:21: Expected to find ','.
And 5 more...

Try fixing the errors and re-running the build.

[SEVERE] hive_generator on lib/features/garden_management/presentation/screens/garden_list_screen.dart:

This builder requires Dart inputs without syntax errors.
However, package:permacalendar/features/garden_management/presentation/screens/garden_list_screen.dart (or an existing part) contains the following errors.
garden_list_screen.dart:119:58: Expected to find ','.
garden_list_screen.dart:119:68: Expected to find ','.
garden_list_screen.dart:119:72: Expected to find ','.
And 8 more...

Try fixing the errors and re-running the build.

[INFO] Running build completed, took 11.5s
[INFO] Caching finalized dependency graph completed, took 130ms
[SEVERE] Failed after 11.6s
Failed to update packages.
PS C:\Users\roman\Documents\apppklod\permacalendarv2> # vérifie l'analyse statique
PS C:\Users\roman\Documents\apppklod\permacalendarv2> flutter analyze
Analyzing permacalendarv2...

   info - Don't invoke 'print' in production code - lib\app_initializer.dart:57:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:59:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:156:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:158:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:159:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:177:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:179:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:193:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:208:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:209:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:211:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:217:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:221:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:223:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:225:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:230:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:232:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:234:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:239:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:241:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:243:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:244:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:249:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:267:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:269:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:270:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:271:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:273:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:274:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:277:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:278:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:279:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:280:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:281:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:282:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:287:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:288:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:289:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:312:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:313:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:314:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:328:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:329:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:330:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:331:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:332:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:333:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:334:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:335:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:338:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:339:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:342:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:343:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:351:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:353:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:354:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:355:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:356:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:360:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:361:13 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:368:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:369:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:370:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:371:15 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:379:17 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:381:17 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:382:40 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:383:39 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:388:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:389:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:390:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:391:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:395:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:396:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:397:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:398:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:400:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:401:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:402:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:405:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:407:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:408:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:409:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_initializer.dart:410:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_router.dart:210:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\app_router.dart:212:11 - avoid_print
  error - Expected to find ',' - lib\app_router.dart:308:43 - expected_token
  error - Too many positional arguments: 1 expected, but 3 found - lib\app_router.dart:308:43 -
         extra_positional_arguments_could_be_named
  error - Undefined name 'existe' - lib\app_router.dart:308:43 - undefined_identifier
  error - Expected to find ',' - lib\app_router.dart:308:50 - expected_token
  error - Undefined name 'pas' - lib\app_router.dart:308:50 - undefined_identifier
  error - Expected an identifier - lib\app_router.dart:308:54 - missing_identifier
  error - Unterminated string literal - lib\app_router.dart:308:55 - unterminated_string_literal
  error - Expected to find ',' - lib\app_router.dart:309:15 - expected_token
  error - Arguments of a constant creation must be constant expressions - lib\app_router.dart:314:47 -
         const_with_non_constant_argument
  error - Expected to find ',' - lib\app_router.dart:314:47 - expected_token
  error - Too many positional arguments: 1 expected, but 3 found - lib\app_router.dart:314:47 -
         extra_positional_arguments_could_be_named
  error - Undefined name 'accueil' - lib\app_router.dart:314:47 - undefined_identifier
  error - Expected to find ',' - lib\app_router.dart:314:54 - expected_token
  error - Unterminated string literal - lib\app_router.dart:314:56 - unterminated_string_literal
  error - Expected to find ')' - lib\app_router.dart:316:11 - expected_token
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:53:42 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:74:17 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:75:19 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:107:34 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:137:13 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:143:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:226:61 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:231:53 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:308:34 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\adapters\garden_migration_adapters.dart:310:26 - deprecated_member_use_from_same_package
warning - The value of the local variable 'timestamp' isn't used - lib\core\analytics\ui_analytics.dart:17:11 -
       unused_local_variable
   info - The constant name 'APP_SETTINGS_BOX_NAME' isn't a lowerCamelCase identifier -
          lib\core\data\hive\constants.dart:3:14 - constant_identifier_names
   info - The constant name 'APP_SETTINGS_LEGACY_BOX_NAME' isn't a lowerCamelCase identifier -
          lib\core\data\hive\constants.dart:4:14 - constant_identifier_names
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:19:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:23:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:26:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:28:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:31:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:40:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:50:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:58:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:63:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:72:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:74:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:90:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:93:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:116:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:118:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:125:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:132:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:135:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:152:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:154:9 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:157:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\data_migration_service.dart:173:7 - avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\hive\garden_boxes.dart:11:14 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\hive\garden_boxes.dart:16:14 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\hive\garden_boxes.dart:40:40 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\data\hive\garden_boxes.dart:44:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\garden_boxes.dart:46:7 - avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\hive\garden_boxes.dart:68:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\hive\garden_boxes.dart:72:10 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\hive\garden_boxes.dart:76:34 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\data\hive\garden_boxes.dart:110:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\garden_boxes.dart:113:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\garden_boxes.dart:169:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\hive_service.dart:25:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\hive_service.dart:77:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\hive_service.dart:79:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\hive_service.dart:83:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\hive_service.dart:85:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\plant_boxes.dart:44:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\data\hive\plant_boxes.dart:46:7 - avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:180:18 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:183:37 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:186:49 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:246:14 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:249:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:252:41 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:461:25 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\data\migration\garden_data_migration.dart:471:28 - deprecated_member_use_from_same_package
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:143:73 - invalid_return_type_for_catch_error
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:144:72 - invalid_return_type_for_catch_error
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:146:64 - invalid_return_type_for_catch_error
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:172:73 - invalid_return_type_for_catch_error
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:173:72 - invalid_return_type_for_catch_error
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:175:64 - invalid_return_type_for_catch_error
warning - A value of type 'Null' can't be returned by the 'onError' handler because it must be assignable to
       'FutureOr<Box<dynamic>>' - lib\core\di\garden_module.dart:177:67 - invalid_return_type_for_catch_error
warning - The left operand can't be null, so the right operand is never executed - lib\core\di\garden_module.dart:179:47
       - dead_null_aware_expression
warning - The left operand can't be null, so the right operand is never executed - lib\core\di\garden_module.dart:180:39
       - dead_null_aware_expression
warning - The left operand can't be null, so the right operand is never executed - lib\core\di\garden_module.dart:181:43
       - dead_null_aware_expression
warning - The left operand can't be null, so the right operand is never executed - lib\core\di\garden_module.dart:182:49
       - dead_null_aware_expression
warning - This default clause is covered by the previous cases - lib\core\models\app_settings.dart:113:7 -
       unreachable_switch_default
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden.g.dart:9:41 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden.g.dart:14:3 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden.g.dart:19:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden.g.dart:34:35 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden_v2.g.dart:9:41 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden_v2.g.dart:14:3 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden_v2.g.dart:19:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\models\garden_v2.g.dart:30:35 - deprecated_member_use_from_same_package
   info - Statements in an if should be enclosed in a block - lib\core\models\planting.dart:187:7 -
          curly_braces_in_flow_control_structures
warning - Unused import: 'package:permacalendar/features/plant_intelligence/domain/entities/intelligence_state.dart' -
       lib\core\providers\intelligence_runtime_providers.dart:5:8 - unused_import
   info - Use 'const' with the constructor to improve performance -
          lib\core\providers\intelligence_runtime_providers.dart:30:37 - prefer_const_constructors
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:9:47 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:21:10 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:21:45 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:24:5 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:40:10 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:40:40 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:54:10 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:54:41 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:67:49 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:81:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:82:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:91:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:91:55 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:100:27 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:101:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:102:28 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:126:58 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:162:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:163:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:173:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:173:51 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:185:42 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:193:15 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:193:53 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:212:42 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:217:58 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:260:9 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:261:9 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_helpers.dart:262:9 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\repositories\garden_hive_repository.dart:25:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\repositories\garden_hive_repository.dart:27:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\repositories\garden_hive_repository.dart:76:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\repositories\garden_hive_repository.dart:109:7 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\repositories\garden_hive_repository.dart:131:7 -
          avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_repository.dart:13:8 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_repository.dart:24:3 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_repository.dart:35:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_repository.dart:78:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_repository.dart:136:8 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_repository.dart:157:8 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_rules.dart:10:32 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_rules.dart:20:45 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_rules.dart:50:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_rules.dart:66:39 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_rules.dart:119:25 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\repositories\garden_rules.dart:158:55 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\services\activity_observer_service.dart:21:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\activity_observer_service.dart:26:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\activity_observer_service.dart:29:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\activity_observer_service.dart:33:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\activity_tracker_v3.dart:42:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\activity_tracker_v3.dart:45:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\activity_tracker_v3.dart:56:7 - avoid_print
   info - 'PlantIntelligenceRepository' is deprecated and shouldn't be used. Utilisez les interfaces spécialisées
          (IPlantConditionRepository, IWeatherRepository, IGardenContextRepository, IRecommendationRepository,
          IAnalyticsRepository) à la place. Sera supprimé dans la v3.0 -
          lib\core\services\aggregation\garden_aggregation_hub.dart:105:14 - deprecated_member_use_from_same_package
   info - 'PlantIntelligenceRepository' is deprecated and shouldn't be used. Utilisez les interfaces spécialisées
          (IPlantConditionRepository, IWeatherRepository, IGardenContextRepository, IRecommendationRepository,
          IAnalyticsRepository) à la place. Sera supprimé dans la v3.0 -
          lib\core\services\aggregation\intelligence_data_adapter.dart:13:9 - deprecated_member_use_from_same_package
   info - 'PlantIntelligenceRepository' is deprecated and shouldn't be used. Utilisez les interfaces spécialisées
          (IPlantConditionRepository, IWeatherRepository, IGardenContextRepository, IRecommendationRepository,
          IAnalyticsRepository) à la place. Sera supprimé dans la v3.0 -
          lib\core\services\aggregation\intelligence_data_adapter.dart:18:14 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\services\environment_service.dart:98:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\environment_service.dart:104:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\environment_service.dart:106:9 - avoid_print
warning - The value of the local variable 'service' isn't used -
       lib\core\services\garden_event_system_validator.dart:94:13 - unused_local_variable
warning - The value of the field '_analyticsService' isn't used -
       lib\core\services\intelligence\intelligent_recommendation_engine.dart:110:37 - unused_field
warning - The value of the local variable 'temp' isn't used -
       lib\core\services\intelligence\intelligent_recommendation_engine.dart:208:11 - unused_local_variable
warning - The value of the local variable 'successRates' isn't used -
       lib\core\services\intelligence\intelligent_recommendation_engine.dart:458:11 - unused_local_variable
warning - The value of the field '_lookbackPeriod' isn't used -
       lib\core\services\intelligence\predictive_analytics_service.dart:126:13 - unused_field
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\data_archival_service.dart:168:30 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\services\migration\data_archival_service.dart:351:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\data_archival_service.dart:362:5 -
          avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\data_integrity_validator.dart:275:39 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\data_integrity_validator.dart:319:24 - deprecated_member_use_from_same_package
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\services\migration\data_integrity_validator.dart:353:62 - dead_null_aware_expression
   info - Don't invoke 'print' in production code - lib\core\services\migration\data_integrity_validator.dart:565:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\data_integrity_validator.dart:576:5 -
          avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\dual_write_service.dart:401:40 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\dual_write_service.dart:413:3 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\dual_write_service.dart:414:12 - deprecated_member_use_from_same_package
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\services\migration\dual_write_service.dart:419:42 - dead_null_aware_expression
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\services\migration\dual_write_service.dart:423:42 - dead_null_aware_expression
   info - Don't invoke 'print' in production code - lib\core\services\migration\dual_write_service.dart:497:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\dual_write_service.dart:508:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\legacy_cleanup_service.dart:331:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\legacy_cleanup_service.dart:342:5 -
          avoid_print
warning - The value of the field '_minAvailabilityRate' isn't used -
       lib\core\services\migration\migration_health_checker.dart:33:23 - unused_field
   info - Don't invoke 'print' in production code - lib\core\services\migration\migration_health_checker.dart:421:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\migration_health_checker.dart:432:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\migration_orchestrator.dart:882:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\migration_orchestrator.dart:894:5 -
          avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          lib\core\services\migration\read_switch_service.dart:333:41 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - lib\core\services\migration\read_switch_service.dart:389:5 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\migration\read_switch_service.dart:400:5 -
          avoid_print
warning - The value of the field '_batchQueue' isn't used -
       lib\core\services\performance\query_optimization_engine.dart:123:44 - unused_field
warning - The value of the field '_batchWindow' isn't used -
       lib\core\services\performance\query_optimization_engine.dart:125:18 - unused_field
   info - Don't invoke 'print' in production code - lib\core\services\plant_catalog_service.dart:55:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\plant_catalog_service.dart:56:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\plant_catalog_service.dart:57:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\plant_catalog_service.dart:58:11 - avoid_print
   info - Don't invoke 'print' in production code - lib\core\services\plant_catalog_service.dart:59:11 - avoid_print
warning - The name SoilInfo is shown, but isn't used - lib\core\services\plant_condition_analyzer.dart:3:25 -
       unused_shown_name
warning - The name GardenLocation is shown, but isn't used - lib\core\services\plant_condition_analyzer.dart:3:35 -
       unused_shown_name
warning - The name ExposureType is shown, but isn't used - lib\core\services\plant_condition_analyzer.dart:8:20 -
       unused_shown_name
   info - Statements in an if should be enclosed in a block - lib\core\services\plant_condition_analyzer.dart:207:9 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block - lib\core\services\plant_condition_analyzer.dart:214:9 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block - lib\core\services\plant_condition_analyzer.dart:255:9 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block - lib\core\services\plant_condition_analyzer.dart:261:9 -
          curly_braces_in_flow_control_structures
warning - The declaration '_getOptimalTemperatureRange' isn't referenced -
       lib\core\services\plant_condition_analyzer.dart:778:23 - unused_element
warning - The declaration '_isFrostSensitive' isn't referenced - lib\core\services\plant_condition_analyzer.dart:865:8 -
       unused_element
   info - Statements in an if should be enclosed in a block - lib\core\services\plant_condition_analyzer.dart:901:9 -
          curly_braces_in_flow_control_structures
   info - Don't invoke 'print' in production code - lib\core\services\plant_condition_analyzer.dart:981:5 - avoid_print
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\services\plant_lifecycle_service.dart:10:50 - dead_null_aware_expression
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\services\thermal_theme_service.dart:129:22 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\services\thermal_theme_service.dart:165:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\services\thermal_theme_service.dart:174:49 - deprecated_member_use
warning - This default clause is covered by the previous cases - lib\core\services\thermal_theme_service.dart:180:7 -
       unreachable_switch_default
   info - The constant name 'FROST_THRESHOLD' isn't a lowerCamelCase identifier -
          lib\core\services\weather_alert_service.dart:8:23 - constant_identifier_names
   info - The constant name 'HEATWAVE_THRESHOLD' isn't a lowerCamelCase identifier -
          lib\core\services\weather_alert_service.dart:9:23 - constant_identifier_names
   info - The constant name 'DROUGHT_DAYS' isn't a lowerCamelCase identifier -
          lib\core\services\weather_alert_service.dart:10:23 - constant_identifier_names
   info - The constant name 'HIGH_HYDRIC_NEED_TEMP' isn't a lowerCamelCase identifier -
          lib\core\services\weather_alert_service.dart:11:23 - constant_identifier_names
warning - The declaration '_getFrostSensitivePlants' isn't referenced -
       lib\core\services\weather_impact_analyzer.dart:704:16 - unused_element
warning - The declaration '_getWaterSensitivePlants' isn't referenced -
       lib\core\services\weather_impact_analyzer.dart:708:16 - unused_element
warning - The declaration '_getWindSensitivePlants' isn't referenced -
       lib\core\services\weather_impact_analyzer.dart:712:16 - unused_element
   info - Don't invoke 'print' in production code - lib\core\services\weather_impact_analyzer.dart:772:5 - avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\theme\app_theme_m3.dart:159:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\theme\app_theme_m3.dart:167:40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\theme\app_theme_m3.dart:232:36 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\theme\app_theme_m3.dart:420:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\theme\app_theme_m3.dart:428:40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\theme\app_theme_m3.dart:493:36 - deprecated_member_use
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\utils\device_calibration_key.dart:13:30 - dead_null_aware_expression
warning - The '!' will have no effect because the receiver can't be null -
       lib\core\utils\device_calibration_key.dart:13:69 - unnecessary_non_null_assertion
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\utils\device_calibration_key.dart:16:40 - dead_null_aware_expression
warning - The left operand can't be null, so the right operand is never executed -
       lib\core\utils\device_calibration_key.dart:16:54 - dead_null_aware_expression
   info - Don't use 'BuildContext's across async gaps - lib\core\utils\device_calibration_key.dart:22:30 -
          use_build_context_synchronously
   info - 'window' is deprecated and shouldn't be used. Look up the current FlutterView from the context via
          View.of(context) or consult the PlatformDispatcher directly instead. Deprecated to prepare for the upcoming
          multi-window support. This feature was deprecated after v3.7.0-32.0.pre -
          lib\core\utils\device_calibration_key.dart:23:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\widgets\thermal_overlay_widget.dart:39:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\widgets\thermal_overlay_widget.dart:40:36 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\widgets\thermal_overlay_widget.dart:42:36 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\core\widgets\thermal_overlay_widget.dart:163:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\activities\presentation\screens\activities_screen.dart:197:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\activities\presentation\screens\activities_screen.dart:209:26 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\activities\presentation\screens\activities_screen.dart:210:29 - deprecated_member_use
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\datasources\soil_metrics_local_ds.dart:133:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\datasources\soil_metrics_local_ds.dart:144:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\datasources\soil_metrics_local_ds.dart:154:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\datasources\soil_metrics_local_ds.dart:163:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\datasources\soil_metrics_local_ds.dart:175:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\datasources\soil_metrics_local_ds.dart:186:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\initialization\soil_metrics_initialization.dart:17:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\initialization\soil_metrics_initialization.dart:26:9 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\initialization\soil_metrics_initialization.dart:29:9 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\initialization\soil_metrics_initialization.dart:34:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\initialization\soil_metrics_initialization.dart:37:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:21:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:33:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:59:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:85:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:96:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:111:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:131:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:162:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:173:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:183:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:194:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:214:7 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\climate\data\repositories\soil_metrics_repository_impl.dart:224:7 - avoid_print
  error - A value of type 'List<DailyWeatherPoint> (where DailyWeatherPoint is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\core\services\open_meteo_service.dart)' can't be returned
         from the function 'dailyWeather' because it has a return type of 'List<DailyWeatherPoint> (where
         DailyWeatherPoint is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\core\models\daily_weather_point.dart)' -
         lib\features\climate\domain\models\weather_view_data.dart:30:47 - return_of_invalid_type
  error - The named parameter 'currentWeatherCode' isn't defined -
         lib\features\climate\domain\models\weather_view_data.dart:84:7 - undefined_named_parameter
  error - The getter 'currentWeatherCode' isn't defined for the type 'OpenMeteoResult' -
         lib\features\climate\domain\models\weather_view_data.dart:119:42 - undefined_getter
warning - The value of the field '_goldenRatio' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_geometry.dart:9:23 - unused_field
warning - The value of the local variable 'center' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_geometry.dart:18:11 -
       unused_local_variable
warning - The value of the local variable 'halfWidth' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_geometry.dart:163:11 -
       unused_local_variable
warning - The value of the local variable 'halfHeight' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_geometry.dart:164:11 -
       unused_local_variable
warning - The value of the local variable 'deformationStrength' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_geometry.dart:301:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:107:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:108:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:109:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:117:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:118:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:119:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:123:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:124:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:125:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:129:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:130:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:131:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:135:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:136:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:137:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:141:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:142:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:143:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:151:43 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:186:12 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:195:39 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:253:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:254:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:255:35 -
          deprecated_member_use
   info - 'translate' is deprecated and shouldn't be used. Use translateByVector3, translateByVector4, or
          translateByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:280:9 -
          deprecated_member_use
   info - 'scale' is deprecated and shouldn't be used. Use scaleByVector3, scaleByVector4, or scaleByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:281:9 -
          deprecated_member_use
   info - 'translate' is deprecated and shouldn't be used. Use translateByVector3, translateByVector4, or
          translateByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_painter.dart:282:9 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:241
          :38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:243
          :39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:245
          :40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:250
          :41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:252
          :40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:254
          :42 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_integration_example.dart:259
          :40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:162:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:186:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:200:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:217:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:231:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:253:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:271:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v3\cellular_rosace_widget.dart:285:35 -
          deprecated_member_use
warning - The value of the field '_wallVisibilityThreshold' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\morphological_pressure.dart:15:23 -
       unused_field
   info - 'translate' is deprecated and shouldn't be used. Use translateByVector3, translateByVector4, or
          translateByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\morphological_pressure.dart:225:12 -
          deprecated_member_use
   info - 'scale' is deprecated and shouldn't be used. Use scaleByVector3, scaleByVector4, or scaleByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\morphological_pressure.dart:230:12 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:107:27 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:113:24 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:145:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:146:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:204:44 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:212:27 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:219:24 -
          deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:240:30 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:242:22 -
          deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:249:30 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:251:22 -
          deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:259:23 -
          deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:259:50 -
          deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:260:23 -
          deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:260:52 -
          deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:261:23 -
          deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:261:51 -
          deprecated_member_use
   info - 'alpha' is deprecated and shouldn't be used. Use (*.a * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:262:23 -
          deprecated_member_use
   info - 'alpha' is deprecated and shouldn't be used. Use (*.a * 255.0).round() & 0xff -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:262:52 -
          deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:270:30 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:272:22 -
          deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:279:20 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\organic_membrane_palette.dart:280:22 -
          deprecated_member_use
warning - The value of the field '_goldenRatio' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_geometry.dart:12:23 -
       unused_field
warning - The value of the local variable 'halfWidth' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_geometry.dart:262:11 -
       unused_local_variable
warning - The value of the local variable 'halfHeight' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_geometry.dart:263:11 -
       unused_local_variable
   info - 'scale' is deprecated and shouldn't be used. Use scaleByVector3, scaleByVector4, or scaleByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_geometry.dart:402:40 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:70:47 -
          deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:113:40 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:114:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:188:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:189:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:190:35 -
          deprecated_member_use
warning - The value of the local variable 'luminosityPaint' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:219:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:221:49 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:233:57 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:295:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:296:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:297:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:361:49 -
          deprecated_member_use
   info - 'translate' is deprecated and shouldn't be used. Use translateByVector3, translateByVector4, or
          translateByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:374:9 -
          deprecated_member_use
   info - 'scale' is deprecated and shouldn't be used. Use scaleByVector3, scaleByVector4, or scaleByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:375:9 -
          deprecated_member_use
   info - 'translate' is deprecated and shouldn't be used. Use translateByVector3, translateByVector4, or
          translateByDouble instead -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:376:9 -
          deprecated_member_use
warning - The value of the local variable 'halfWidth' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:403:11 -
       unused_local_variable
warning - The value of the local variable 'halfHeight' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_painter.dart:404:11 -
       unused_local_variable
warning - The value of the local variable 'deformedCellPaths' isn't used -
       lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:75:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:175:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:199:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:213:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:230:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:244:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:266:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:284:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\experimental\cellular_rosace_v4\unified_membrane_widget.dart:298:35 -
          deprecated_member_use
   info - Don't invoke 'print' in production code -
          lib\features\climate\presentation\providers\daily_update_provider.dart:53:7 - avoid_print
warning - The value of the local variable 'currentHourData' isn't used -
       lib\features\climate\presentation\providers\hourly_weather_provider.dart:117:9 - unused_local_variable
  error - The returned type 'List<WeatherAlert>' isn't returnable from a 'Future<List<WeatherAlert>>' function, as
         required by the closure's context -
         lib\features\climate\presentation\providers\weather_alert_provider.dart:36:12 -
         return_of_invalid_type_from_closure
  error - Target of URI doesn't exist: '../../../../core/providers/app_settings_provider.dart' -
         lib\features\climate\presentation\providers\weather_providers.dart:7:8 - uri_does_not_exist
  error - Undefined name 'appSettingsProvider' -
         lib\features\climate\presentation\providers\weather_providers.dart:19:30 - undefined_identifier
  error - Undefined name 'appSettingsProvider' -
         lib\features\climate\presentation\providers\weather_providers.dart:22:29 - undefined_identifier
  error - The getter 'currentWeatherCode' isn't defined for the type 'OpenMeteoResult' -
         lib\features\climate\presentation\providers\weather_providers.dart:290:39 - undefined_getter
  error - The getter 'weatherCode' isn't defined for the type 'DailyWeatherPoint' -
         lib\features\climate\presentation\providers\weather_providers.dart:398:26 - undefined_getter
  error - The getter 'weatherCode' isn't defined for the type 'DailyWeatherPoint' -
         lib\features\climate\presentation\providers\weather_providers.dart:399:49 - undefined_getter
  error - The getter 'weatherCode' isn't defined for the type 'DailyWeatherPoint' -
         lib\features\climate\presentation\providers\weather_providers.dart:401:33 - undefined_getter
  error - The getter 'weatherCode' isn't defined for the type 'DailyWeatherPoint' -
         lib\features\climate\presentation\providers\weather_providers.dart:402:59 - undefined_getter
  error - The getter 'weatherCode' isn't defined for the type 'DailyWeatherPoint' -
         lib\features\climate\presentation\providers\weather_providers.dart:413:28 - undefined_getter
  error - The argument type 'List<DailyWeatherPoint> (where DailyWeatherPoint is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\core\services\open_meteo_service.dart)' can't be assigned
         to the parameter type 'List<DailyWeatherPoint> (where DailyWeatherPoint is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\core\models\daily_weather_point.dart)'.  -
         lib\features\climate\presentation\providers\weather_providers.dart:468:18 - argument_type_not_assignable
  error - The argument type 'List<DailyWeatherPoint> (where DailyWeatherPoint is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\core\services\open_meteo_service.dart)' can't be assigned
         to the parameter type 'List<DailyWeatherPoint> (where DailyWeatherPoint is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\core\models\daily_weather_point.dart)'.  -
         lib\features\climate\presentation\providers\weather_providers.dart:469:18 - argument_type_not_assignable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\alerts_detail_screen.dart:124:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\alerts_detail_screen.dart:125:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\alerts_detail_screen.dart:247:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\alerts_detail_screen.dart:249:60 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_alerts_screen.dart:42:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_alerts_screen.dart:48:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_alerts_screen.dart:50:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_day_detail_screen.dart:42:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_day_detail_screen.dart:48:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_day_detail_screen.dart:50:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_forecast_history_screen.dart:43:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_forecast_history_screen.dart:63:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_forecast_history_screen.dart:65:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_forecast_history_screen.dart:88:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\climate_forecast_history_screen.dart:105:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:66:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:84:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:199:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:203:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:208:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:216:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:239:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:283:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\ph_input_sheet.dart:285:39 - deprecated_member_use
   info - 'onPopInvoked' is deprecated and shouldn't be used. Use onPopInvokedWithResult instead. This feature was
          deprecated after v3.22.0-12.0.pre - lib\features\climate\presentation\screens\ph_management_screen.dart:15:7 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:59:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:77:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:133:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:135:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:170:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:174:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:179:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:187:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\screens\soil_temp_sheet.dart:210:51 - deprecated_member_use
   info - 'onPopInvoked' is deprecated and shouldn't be used. Use onPopInvokedWithResult instead. This feature was
          deprecated after v3.22.0-12.0.pre -
          lib\features\climate\presentation\screens\soil_temperature_screen.dart:15:7 - deprecated_member_use
   info - 'onPopInvoked' is deprecated and shouldn't be used. Use onPopInvokedWithResult instead. This feature was
          deprecated after v3.22.0-12.0.pre - lib\features\climate\presentation\screens\weather_detail_screen.dart:15:7
          - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\utils\halo_color_maps.dart:126:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\climate_mini_card.dart:50:43 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\climate_mini_card.dart:53:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\climate_mini_card.dart:210:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\climate_mini_card.dart:212:52 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\climate_mini_card.dart:217:43 - deprecated_member_use
  error - Target of URI doesn't exist: '../../../../core/providers/app_settings_provider.dart' -
         lib\features\climate\presentation\widgets\garden_climate_panel.dart:9:8 - uri_does_not_exist
  error - Target of URI doesn't exist: '../../../../core/theme/app_icons.dart' -
         lib\features\climate\presentation\widgets\garden_climate_panel.dart:12:8 - uri_does_not_exist
warning - The value of the local variable 'gardenState' isn't used -
       lib\features\climate\presentation\widgets\garden_climate_panel.dart:25:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:42:37 - deprecated_member_use
warning - The value of the local variable 'weatherCards' isn't used -
       lib\features\climate\presentation\widgets\garden_climate_panel.dart:96:11 - unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:124:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:127:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:182:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:189:41 - deprecated_member_use
  error - All final variables must be initialized, but 'padding' isn't -
         lib\features\climate\presentation\widgets\garden_climate_panel.dart:209:9 - final_not_initialized_constructor
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:238:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\garden_climate_panel.dart:240:52 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\anim\scale_halo_tap.dart:88:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_center_ph.dart:35:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_center_ph.dart:36:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_center_ph.dart:40:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_center_ph.dart:41:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_center_ph.dart:46:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_integration_example.dart:35:31 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_integration_example.dart:68:29 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_integration_example.dart:70:48 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_integration_example.dart:106:29 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_integration_example.dart:108:48 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:365:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:367:52 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:392:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:394:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:396:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:398:40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:400:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_panel.dart:402:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_petal.dart:41:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_petal.dart:42:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_petal.dart:46:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_petal.dart:47:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\climate\presentation\widgets\rosace\climate_rosace_petal.dart:53:43 - deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\export\presentation\screens\export_screen.dart:87:19 - deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre - lib\features\export\presentation\screens\export_screen.dart:88:19 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\export\presentation\screens\export_screen.dart:175:19 - deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre - lib\features\export\presentation\screens\export_screen.dart:176:19 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\export\presentation\screens\export_screen.dart:272:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\export\presentation\screens\export_screen.dart:275:52 - deprecated_member_use
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check -
          lib\features\export\presentation\screens\export_screen.dart:418:30 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check -
          lib\features\export\presentation\screens\export_screen.dart:432:30 - use_build_context_synchronously
warning - The declaration '_buildCompactInfoItem' isn't referenced - lib\features\garden\widgets\garden_card.dart:137:10
       - unused_element
warning - The declaration '_buildInfoItem' isn't referenced - lib\features\garden\widgets\garden_card.dart:166:10 -
       unused_element
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:149:59 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:150:59 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:151:59 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:223:61 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:224:61 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:225:61 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:233:47 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:234:47 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:235:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:258:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:261:44 - deprecated_member_use
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check -
          lib\features\garden_bed\presentation\screens\garden_bed_list_screen.dart:453:34 -
          use_build_context_synchronously
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_bed\presentation\widgets\garden_bed_card.dart:144:22 - deprecated_member_use
   info - Don't invoke 'print' in production code - lib\features\garden_bed\providers\garden_bed_provider.dart:55:7 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\garden_bed\providers\garden_bed_provider.dart:105:9 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\garden_bed\providers\garden_bed_provider.dart:117:7 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\garden_bed\providers\garden_bed_provider.dart:168:9 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\garden_bed\providers\garden_bed_provider.dart:227:9 -
          avoid_print
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:95:40 -
         expected_token
  error - Too many positional arguments: 0 expected, but 2 found -
         lib\features\garden_management\presentation\screens\garden_create_screen.dart:95:40 -
         extra_positional_arguments_could_be_named
  error - Undefined name 'image' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:95:40 -
         undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:95:45 -
         expected_token
  error - Unterminated string literal -
         lib\features\garden_management\presentation\screens\garden_create_screen.dart:95:46 -
         unterminated_string_literal
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:96:21 -
         expected_token
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:165:57 - deprecated_member_use
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:195:46 -
         expected_token
  error - Too many positional arguments: 1 expected, but 3 found -
         lib\features\garden_management\presentation\screens\garden_create_screen.dart:195:46 -
         extra_positional_arguments_could_be_named
  error - Undefined name 'image' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:195:46
         - undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:195:51 -
         expected_token
  error - Unterminated string literal -
         lib\features\garden_management\presentation\screens\garden_create_screen.dart:195:52 -
         unterminated_string_literal
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_create_screen.dart:196:19 -
         expected_token
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:210:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:213:44 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:243:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:250:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:257:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_create_screen.dart:264:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:137:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:212:20 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:230:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:233:48 - deprecated_member_use
warning - The declaration '_buildInfoRow' isn't referenced -
       lib\features\garden_management\presentation\screens\garden_detail_screen.dart:293:10 - unused_element
   info - Don't use 'BuildContext's across async gaps -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:591:40 -
          use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:597:19 -
          use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:599:40 -
          use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\features\garden_management\presentation\screens\garden_detail_screen.dart:607:38 -
          use_build_context_synchronously
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:58 -
         expected_token
  error - Too many positional arguments: 0 expected, but 7 found -
         lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:58 -
         extra_positional_arguments_could_be_named
  error - Undefined name 'affichage' -
         lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:58 - undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:68 -
         expected_token
  error - Undefined name 'des' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:68 -
         undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:72 -
         expected_token
  error - Undefined name 'jardins' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:72
         - undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:80 -
         expected_token
  error - Undefined name 'archivés' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:80
         - undefined_identifier
  error - Illegal character '233' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:86 -
         illegal_character
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:89 -
         expected_token
  error - Undefined name 'pour' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:89 -
         undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:94 -
         expected_token
  error - Undefined name 'les' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:94 -
         undefined_identifier
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:98 -
         expected_token
  error - Undefined name 'voir' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:98 -
         undefined_identifier
  error - Expected an identifier - lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:103 -
         missing_identifier
  error - Unterminated string literal -
         lib\features\garden_management\presentation\screens\garden_list_screen.dart:119:104 -
         unterminated_string_literal
  error - Expected to find ',' - lib\features\garden_management\presentation\screens\garden_list_screen.dart:120:9 -
         expected_token
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\screens\calendar_view_screen.dart:179:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\screens\calendar_view_screen.dart:482:58 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\screens\calendar_view_screen.dart:663:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\widgets\invisible_garden_zone.dart:98:46 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\widgets\invisible_garden_zone.dart:104:37 - deprecated_member_use
  error - Undefined name 'gardenProvider' - lib\features\home\widgets\invisible_garden_zone.dart:142:35 -
         undefined_identifier
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\widgets\invisible_garden_zone.dart:317:41 - deprecated_member_use
   info - Use 'const' with the constructor to improve performance -
          lib\features\home\widgets\invisible_stats_zone.dart:38:30 - prefer_const_constructors
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\widgets\invisible_stats_zone.dart:48:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\home\widgets\invisible_stats_zone.dart:51:53 - deprecated_member_use
   info - 'PlantIntelligenceRepository' is deprecated and shouldn't be used. Utilisez les interfaces spécialisées
          (IPlantConditionRepository, IWeatherRepository, IGardenContextRepository, IRecommendationRepository,
          IAnalyticsRepository) à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\data\repositories\plant_intelligence_repository_impl.dart:52:9 -
          deprecated_member_use_from_same_package
warning - The declaration '_convertUnifiedToGardenContext' isn't referenced -
       lib\features\plant_intelligence\data\repositories\plant_intelligence_repository_impl.dart:1414:17 -
       unused_element
warning - The left operand can't be null, so the right operand is never executed -
       lib\features\plant_intelligence\data\services\flutter_notification_service.dart:401:64 -
       dead_null_aware_expression
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\data\services\flutter_notification_service.dart:431:5 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\data\services\notification_initialization.dart:109:5 - avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\data\services\plant_notification_service.dart:982:5 - avoid_print
warning - The annotation 'JsonKey.new' can only be used on fields or getters -
       lib\features\plant_intelligence\domain\entities\comprehensive_garden_analysis.dart:23:6 -
       invalid_annotation_target
   info - Statements in an if should be enclosed in a block -
          lib\features\plant_intelligence\domain\entities\condition_models.dart:200:7 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block -
          lib\features\plant_intelligence\domain\entities\condition_models.dart:203:7 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block -
          lib\features\plant_intelligence\domain\entities\condition_models.dart:205:7 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block -
          lib\features\plant_intelligence\domain\entities\garden_context.dart:409:50 -
          curly_braces_in_flow_control_structures
   info - Statements in an if should be enclosed in a block -
          lib\features\plant_intelligence\domain\entities\garden_context.dart:414:41 -
          curly_braces_in_flow_control_structures
  error - The argument type 'String' can't be assigned to the parameter type 'GardenLocation'.  -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:38:23 -
         argument_type_not_assignable
  error - The argument type 'String' can't be assigned to the parameter type 'GardenLocation'.  -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:46:23 -
         argument_type_not_assignable
  error - The argument type 'String' can't be assigned to the parameter type 'ClimateConditions'.  -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:47:22 -
         argument_type_not_assignable
  error - The argument type 'String' can't be assigned to the parameter type 'SoilInfo'.  -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:48:19 -
         argument_type_not_assignable
  error - The named parameter 'currentYearYield' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'harvestsThisYear' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'plantingsThisYear' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'successRate' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'totalHarvestValue' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'totalInputCosts' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'totalYield' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:52:17 -
         missing_required_argument
  error - The named parameter 'automaticIrrigation' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'method' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'mulching' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'objectives' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'regularMonitoring' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'useChemicalFertilizers' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'useOrganicFertilizers' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'usePesticides' is required, but there's no corresponding argument -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:59:17 -
         missing_required_argument
  error - The named parameter 'organic' isn't defined -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:60:19 -
         undefined_named_parameter
  error - The argument type 'Garden' can't be assigned to the parameter type 'GardenFreezed'.  -
         lib\features\plant_intelligence\domain\services\garden_context_sync_service.dart:123:60 -
         argument_type_not_assignable
  error - Target of URI doesn't exist: '../../../core/models/garden_freezed.dart' -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:4:8 -
         uri_does_not_exist
  error - Undefined name 'plantIntelligenceLocalDataSourceProvider' -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:9:31 -
         undefined_identifier
  error - The name 'GardenContext' isn't a type, so it can't be used as a type argument -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:15:27 -
         non_type_as_type_argument
  error - Undefined name 'GardenBoxes' -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:17:18 -
         undefined_identifier
  error - The name 'GardenContext' isn't a type, so it can't be used as a type argument -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:28:32 -
         non_type_as_type_argument
  error - The name 'GardenContext' isn't a type, so it can't be used as a type argument -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:39:10 -
         non_type_as_type_argument
  error - Undefined name 'GardenBoxes' -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:42:22 -
         undefined_identifier
  error - The name 'GardenContext' isn't a type, so it can't be used as a type argument -
         lib\features\plant_intelligence\presentation\providers\garden_context_sync_provider.dart:54:22 -
         non_type_as_type_argument
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\intelligence_state_providers.dart:69:17 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\intelligence_state_providers.dart:74:17 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:188:33 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:201:33 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:211:33 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:231:33 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:269:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:278:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:286:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:298:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:306:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:316:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:324:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:336:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:343:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:351:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:363:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:374:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:385:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceRepositoryProvider' is deprecated and shouldn't be used. Utilisez les interfaces
          spécialisées à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:396:31 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:407:33 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:419:33 -
          deprecated_member_use_from_same_package
   info - 'plantIntelligenceOrchestratorProvider' is deprecated and shouldn't be used. Utilisez
          IntelligenceModule.orchestratorProvider à la place. Sera supprimé dans la v3.0 -
          lib\features\plant_intelligence\presentation\providers\plant_intelligence_providers.dart:435:33 -
          deprecated_member_use_from_same_package
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\bio_control_recommendations_screen.dart:261:64 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:19:42 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:20:37 -
         undefined_identifier
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:47:31 -
         undefined_identifier
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:56:31 -
         undefined_identifier
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:65:31 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:81:31 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:90:31 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:99:34 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:107:34 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:115:34 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:375:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:375:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:376:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:379:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:388:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:388:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:389:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:392:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:415:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:415:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:416:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:419:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:428:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:428:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:429:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:432:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:455:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:455:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:456:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:459:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:468:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:468:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:469:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:472:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:481:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:481:36 -
         undefined_identifier
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:482:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:485:29 -
         undefined_identifier
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:508:15 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:509:15 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:514:15 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:515:15 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:520:15 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:521:15 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:526:15 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:527:15 -
          deprecated_member_use
  error - Undefined name 'displayPreferencesProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:712:24 -
         undefined_identifier
  error - Undefined name 'chartSettingsProvider' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:713:24 -
         undefined_identifier
  error - Undefined class 'ChartSettingsNotifier' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:734:45 - undefined_class
  error - Undefined name 'state' -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:736:5 -
         undefined_identifier
  error - The name 'ChartSettings' isn't a class -
         lib\features\plant_intelligence\presentation\screens\intelligence_settings_screen.dart:736:19 -
         creation_with_non_type
warning - Unused import: '../providers/intelligence_state_providers.dart' -
       lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:3:8 - unused_import
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:56:48 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:57:47 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:62:52 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:268:23 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:269:23 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:277:23 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:278:23 -
          deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:286:23 -
          deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:287:23 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\intelligence_settings_simple.dart:449:52 -
          deprecated_member_use
warning - The value of the local variable 'priorities' isn't used -
       lib\features\plant_intelligence\presentation\screens\notification_preferences_screen.dart:72:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_evolution_history_screen.dart:106:56 -
          deprecated_member_use
   info - The import of 'package:flutter/semantics.dart' is unnecessary because all of the used elements are also
          provided by the import of 'package:flutter/material.dart' -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:3:8 -
          unnecessary_import
warning - Unused import: '../widgets/garden_selector_widget.dart' -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:25:8 -
       unused_import
   info - Don't put any logic in 'createState' -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:33:65 -
          no_logic_in_create_state
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:34:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:45:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:52:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:55:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:62:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:67:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:69:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:78:7 -
          avoid_print
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:85:73 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:85:73 -
       invalid_use_of_protected_member
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:87:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:95:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:101:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:103:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:105:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:114:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:118:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:123:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:144:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:146:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:148:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:150:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:180:21 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:207:23 -
          avoid_print
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:231:64 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:231:64 -
       invalid_use_of_protected_member
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:509:30 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:636:36 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:669:48 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:707:49 -
          deprecated_member_use
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:816:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:819:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:823:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:828:15 -
          avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:858:41 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:859:42 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:864:46 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:904:56 -
          deprecated_member_use
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:955:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:956:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:958:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:959:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:960:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:962:5 -
          avoid_print
warning - This default clause is covered by the previous cases -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:1201:7 -
       unreachable_switch_default
warning - This default clause is covered by the previous cases -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:1214:7 -
       unreachable_switch_default
warning - The value of the local variable 'itemsPerRow' isn't used -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:1390:25 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:1652:56 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:1861:50 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2024:26 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2062:26 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2084:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2180:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2205:37 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2593:64 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2640:40 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2641:41 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2711:42 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2712:41 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2784:41 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2785:41 -
          deprecated_member_use
warning - The declaration '_buildQuickActions' isn't referenced -
       lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2838:10 -
       unused_element
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2957:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2961:5 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2964:7 -
          avoid_print
   info - Don't invoke 'print' in production code -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:2976:5 -
          avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_screen.dart:3462:42 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_simple.dart:33:47 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_simple.dart:34:49 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_simple.dart:39:52 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_simple.dart:190:52 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\plant_intelligence_dashboard_simple.dart:240:44 -
          deprecated_member_use
warning - The left operand can't be null, so the right operand is never executed -
       lib\features\plant_intelligence\presentation\screens\recommendations_screen.dart:212:60 -
       dead_null_aware_expression
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\recommendations_simple.dart:32:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\recommendations_simple.dart:33:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\recommendations_simple.dart:38:52 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\recommendations_simple.dart:168:52 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\recommendations_simple.dart:243:42 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\screens\recommendations_simple.dart:272:52 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:43:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:57:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:58:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:91:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:145:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:273:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\alert_banner.dart:283:37 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\recommendation_card.dart:137:18 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\recommendation_card.dart:184:51 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\recommendation_card.dart:264:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\recommendation_card.dart:267:24 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\cards\recommendation_card.dart:504:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\charts\condition_radar_chart_simple.dart:100:26 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\charts\condition_radar_chart_simple.dart:180:44 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_card.dart:132:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_card.dart:151:27 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_card.dart:153:46 -
          deprecated_member_use
warning - The value of the local variable 'theme' isn't used -
       lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:63:11 -
       unused_local_variable
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:74:63 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:74:63 -
       invalid_use_of_protected_member
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:81:63 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:81:63 -
       invalid_use_of_protected_member
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:88:63 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:88:63 -
       invalid_use_of_protected_member
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:95:63 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:95:63 -
       invalid_use_of_protected_member
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:138:59 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:334:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:456:31 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:458:50 -
          deprecated_member_use
warning - The value of the local variable 'theme' isn't used -
       lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:599:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:611:30 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\evolution\plant_evolution_timeline.dart:612:37 -
          deprecated_member_use
warning - Unused import: '../providers/intelligence_state_providers.dart' -
       lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:4:8 - unused_import
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:52:66 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:52:66 -
       invalid_use_of_protected_member
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:62:64 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:62:64 -
       invalid_use_of_protected_member
warning - The member 'state' can only be used within 'package:riverpod/src/core/provider/notifier_provider.dart' or a
       test - lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:292:60 -
       invalid_use_of_visible_for_testing_member
warning - The member 'state' can only be used within instance members of subclasses of 'AnyNotifier' -
       lib\features\plant_intelligence\presentation\widgets\garden_selector_widget.dart:292:60 -
       invalid_use_of_protected_member
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:42:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:70:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:97:42 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:177:33 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:180:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:336:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:373:50 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\condition_indicator.dart:383:40 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\optimal_timing_widget.dart:50:51 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\optimal_timing_widget.dart:91:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\optimal_timing_widget.dart:141:58 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\optimal_timing_widget.dart:181:18 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\optimal_timing_widget.dart:333:57 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\optimal_timing_widget.dart:369:57 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:142:52 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:155:47 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:288:52 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:296:49 -
          deprecated_member_use
warning - The value of the local variable 'theme' isn't used -
       lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:361:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:371:24 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:374:26 -
          deprecated_member_use
warning - The value of the local variable 'theme' isn't used -
       lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:457:11 -
       unused_local_variable
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\indicators\plant_health_indicator.dart:473:32 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\notification_list_widget.dart:222:44 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\notification_list_widget.dart:234:36 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner.dart:287:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner.dart:289:41 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:106:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:176:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:179:24 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:236:18 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:339:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:472:40 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\garden_overview_widget.dart:500:42 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:111:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:180:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:183:24 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:288:46 -
          deprecated_member_use
   info - The type of the right operand ('String') isn't a subtype or a supertype of the left operand
          ('RecommendationPriority') -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:322:49 -
          unrelated_type_equality_checks
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:339:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:361:20 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:401:30 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:404:32 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:450:35 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:478:20 -
          deprecated_member_use
warning - The left operand can't be null, so the right operand is never executed -
       lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:522:39 -
       dead_null_aware_expression
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:655:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\plant_intelligence\presentation\widgets\summaries\intelligence_summary.dart:678:22 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\dialogs\create_planting_dialog.dart:395:51 - deprecated_member_use
warning - The value of 'refresh' should be used -
       lib\features\planting\presentation\dialogs\create_planting_dialog.dart:549:13 - unused_result
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:199:36 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:561:57 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:622:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:623:48 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:740:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:760:60 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:954:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:956:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:963:35 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:974:35 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:974:46 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:974:59 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:984:45 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:985:45 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:986:45 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1062:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1089:64 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1110:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1139:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1164:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1166:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1168:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1170:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1172:27 - deprecated_member_use
   info - 'groupValue' is deprecated and shouldn't be used. Use a RadioGroup ancestor to manage group value instead.
          This feature was deprecated after v3.32.0-0.0.pre -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1298:17 - deprecated_member_use
   info - 'onChanged' is deprecated and shouldn't be used. Use RadioGroup to handle value change instead. This feature
          was deprecated after v3.32.0-0.0.pre -
          lib\features\planting\presentation\screens\planting_detail_screen.dart:1299:17 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_list_screen.dart:129:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_list_screen.dart:147:61 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_list_screen.dart:222:61 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_list_screen.dart:223:61 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_list_screen.dart:224:61 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_list_screen.dart:232:47 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_list_screen.dart:233:47 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\features\planting\presentation\screens\planting_list_screen.dart:234:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_list_screen.dart:257:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\screens\planting_list_screen.dart:260:44 - deprecated_member_use
   info - Don't use 'BuildContext's across async gaps, guarded by an unrelated 'mounted' check -
          lib\features\planting\presentation\screens\planting_list_screen.dart:463:34 - use_build_context_synchronously
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:200:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:315:57 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:343:61 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:370:28 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:372:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:374:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:376:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\presentation\widgets\planting_card.dart:378:27 - deprecated_member_use
   info - Don't invoke 'print' in production code - lib\features\planting\providers\planting_provider.dart:143:9 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\planting\providers\planting_provider.dart:200:9 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\planting\providers\planting_provider.dart:256:9 -
          avoid_print
   info - Don't invoke 'print' in production code - lib\features\planting\providers\planting_provider.dart:389:9 -
          avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\screens\planting_detail_screen.dart:81:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\screens\planting_detail_screen.dart:84:43 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\screens\planting_detail_screen.dart:91:41 - deprecated_member_use
warning - The left operand can't be null, so the right operand is never executed -
       lib\features\planting\screens\planting_detail_screen.dart:109:29 - dead_null_aware_expression
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\screens\planting_detail_screen.dart:113:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\screens\planting_detail_screen.dart:123:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\planting\screens\planting_detail_screen.dart:321:28 - deprecated_member_use
  error - Target of URI doesn't exist: '../../../../harvest/application/harvest_records_provider.dart' -
         lib\features\statistics\application\providers\alignment\alignment_raw_data_provider.dart:3:8 -
         uri_does_not_exist
  error - Target of URI doesn't exist: '../../../../harvest/domain/models/harvest_record.dart' -
         lib\features\statistics\application\providers\alignment\alignment_raw_data_provider.dart:4:8 -
         uri_does_not_exist
  error - Target of URI doesn't exist: '../../../presentation/providers/statistics_filters_provider.dart' -
         lib\features\statistics\application\providers\alignment\alignment_raw_data_provider.dart:8:8 -
         uri_does_not_exist
  error - Undefined name 'harvestRecordsProvider' -
         lib\features\statistics\application\providers\alignment\alignment_raw_data_provider.dart:87:41 -
         undefined_identifier
  error - Undefined name 'statisticsFiltersProvider' -
         lib\features\statistics\application\providers\alignment\alignment_raw_data_provider.dart:88:29 -
         undefined_identifier
  error - Undefined class 'HarvestRecord' -
         lib\features\statistics\application\providers\alignment\alignment_raw_data_provider.dart:236:5 -
         undefined_class
  error - Target of URI doesn't exist: '../../../../harvest/application/harvest_records_provider.dart' -
         lib\features\statistics\application\providers\performance\performance_raw_data_provider.dart:3:8 -
         uri_does_not_exist
  error - Target of URI doesn't exist: '../../../presentation/providers/statistics_filters_provider.dart' -
         lib\features\statistics\application\providers\performance\performance_raw_data_provider.dart:7:8 -
         uri_does_not_exist
  error - Undefined name 'harvestRecordsProvider' -
         lib\features\statistics\application\providers\performance\performance_raw_data_provider.dart:20:41 -
         undefined_identifier
  error - Undefined name 'statisticsFiltersProvider' -
         lib\features\statistics\application\providers\performance\performance_raw_data_provider.dart:21:29 -
         undefined_identifier
  error - Target of URI doesn't exist: '../../../harvest/application/harvest_records_provider.dart' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:2:8 - uri_does_not_exist
  error - Target of URI doesn't exist: '../../presentation/providers/statistics_filters_provider.dart' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:3:8 - uri_does_not_exist
  error - Undefined name 'harvestRecordsProvider' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:14:41 - undefined_identifier
  error - Undefined name 'statisticsFiltersProvider' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:15:29 - undefined_identifier
  error - Undefined name 'harvestRecordsProvider' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:52:41 - undefined_identifier
  error - Undefined name 'statisticsFiltersProvider' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:53:29 - undefined_identifier
  error - Undefined name 'harvestRecordsProvider' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:107:41 - undefined_identifier
  error - Undefined name 'statisticsFiltersProvider' -
         lib\features\statistics\application\providers\statistics_kpi_providers.dart:108:29 - undefined_identifier
  error - Target of URI doesn't exist: '../../../harvest/application/harvest_records_provider.dart' -
         lib\features\statistics\application\providers\vitamin_distribution_provider.dart:2:8 - uri_does_not_exist
  error - Target of URI doesn't exist: '../../presentation/providers/statistics_filters_provider.dart' -
         lib\features\statistics\application\providers\vitamin_distribution_provider.dart:3:8 - uri_does_not_exist
  error - Undefined name 'harvestRecordsProvider' -
         lib\features\statistics\application\providers\vitamin_distribution_provider.dart:19:41 - undefined_identifier
  error - Undefined name 'statisticsFiltersProvider' -
         lib\features\statistics\application\providers\vitamin_distribution_provider.dart:20:29 - undefined_identifier
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\charts\vitamin_pie_chart.dart:61:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:46:18 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:50:57 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:108:18 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:112:20 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:164:20 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:315:14 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:317:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\kpi\alignment_kpi_card.dart:324:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\alignment_gauge_placeholder.dart:22:34 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\finance_bubble_placeholder.dart:22:34 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\finance_bubble_placeholder.dart:33:36 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\finance_bubble_placeholder.dart:46:36 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\health_donut_placeholder.dart:21:34 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_bar_placeholder.dart:46:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_bar_placeholder.dart:60:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_bar_placeholder.dart:74:38 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:53:18 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:57:18 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:62:56 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:150:56 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:222:39 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:310:56 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:326:58 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\placeholders\performance_seasonal_placeholder.dart:329:54 -
          deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\statistics_pillar_card.dart:49:35 - deprecated_member_use
   info - Don't invoke 'print' in production code -
          lib\features\statistics\presentation\widgets\statistics_pillar_card.dart:191:9 - avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\statistics_pillar_card.dart:376:16 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\statistics_pillar_card.dart:379:58 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\statistics_pillar_card.dart:459:16 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\statistics_pillar_card.dart:462:58 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\vitamin_suggestion_row.dart:56:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\vitamin_suggestion_row.dart:59:31 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\vitamin_suggestion_row.dart:117:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\features\statistics\presentation\widgets\vitamin_suggestion_row.dart:120:31 - deprecated_member_use
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:58:28 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:64:26 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:72:28 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:79:46 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:81:28 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:85:28 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:93:26 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:123:28 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps -
          lib\shared\presentation\screens\calibration_settings_screen.dart:130:28 - use_build_context_synchronously
warning - The value of the local variable 'theme' isn't used - lib\shared\presentation\screens\home_screen.dart:15:11 -
       unused_local_variable
   info - Don't use 'BuildContext's across async gaps - lib\shared\presentation\screens\home_screen.dart:57:40 -
          use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps - lib\shared\presentation\screens\home_screen.dart:65:19 -
          use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps - lib\shared\presentation\screens\home_screen.dart:67:40 -
          use_build_context_synchronously
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\alert_indicator_widget.dart:79:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\alert_indicator_widget.dart:198:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\alert_indicator_widget.dart:200:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\settings\calibration_settings_section.dart:78:40 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\settings\calibration_settings_section.dart:80:59 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\settings\calibration_settings_section.dart:121:42 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\settings\calibration_settings_section.dart:124:58 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\settings\calibration_settings_section.dart:133:62 - deprecated_member_use
  error - Target of URI doesn't exist: '../../../../core/providers/app_settings_provider.dart' -
         lib\shared\presentation\widgets\settings\garden_settings_section.dart:3:8 - uri_does_not_exist
  error - Target of URI doesn't exist: 'settings_group.dart' -
         lib\shared\presentation\widgets\settings\garden_settings_section.dart:6:8 - uri_does_not_exist
  error - Target of URI doesn't exist: 'settings_tile.dart' -
         lib\shared\presentation\widgets\settings\garden_settings_section.dart:7:8 - uri_does_not_exist
warning - The value of the local variable 'settings' isn't used -
       lib\shared\presentation\widgets\settings\garden_settings_section.dart:18:11 - unused_local_variable
  error - Undefined name 'appSettingsProvider' -
         lib\shared\presentation\widgets\settings\garden_settings_section.dart:18:32 - undefined_identifier
warning - The value of the local variable 'notifier' isn't used -
       lib\shared\presentation\widgets\settings\garden_settings_section.dart:19:11 - unused_local_variable
  error - Undefined name 'appSettingsProvider' -
         lib\shared\presentation\widgets\settings\garden_settings_section.dart:19:31 - undefined_identifier
  error - The method 'SettingsGroup' isn't defined for the type 'GardenSettingsSection' -
         lib\shared\presentation\widgets\settings\garden_settings_section.dart:21:12 - undefined_method
  error - Undefined name 'SettingsTile' - lib\shared\presentation\widgets\settings\garden_settings_section.dart:25:9 -
         undefined_identifier
  error - Undefined name 'SettingsTile' - lib\shared\presentation\widgets\settings\garden_settings_section.dart:32:9 -
         undefined_identifier
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\thermal_transition_widget.dart:143:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\presentation\widgets\thermal_transition_widget.dart:259:43 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\activity_item.dart:37:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\animations\insect_particles_painter.dart:47:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\animations\insect_persistent_halo_painter.dart:39:27 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\animations\insect_persistent_halo_painter.dart:53:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\animations\insect_persistent_halo_painter.dart:62:29 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\calibration_debug_overlay.dart:40:30 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_app_bar.dart:133:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_app_bar.dart:228:59 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_button.dart:373:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:120:64 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:187:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:212:58 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:272:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:399:38 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:427:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:477:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:482:56 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:493:49 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:503:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_card.dart:504:51 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_input.dart:119:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_input.dart:145:61 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_input.dart:407:50 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_input.dart:433:61 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\custom_input.dart:518:50 - deprecated_member_use
   info - 'WillPopScope' is deprecated and shouldn't be used. Use PopScope instead. The Android predictive back feature
          will not work with WillPopScope. This feature was deprecated after v3.12.0-1.0.pre -
          lib\shared\widgets\dialogs.dart:425:12 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\dialogs.dart:512:50 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\shared\widgets\loading_widgets.dart:40:47 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\shared\widgets\loading_widgets.dart:41:47 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\shared\widgets\loading_widgets.dart:42:47 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\loading_widgets.dart:144:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\loading_widgets.dart:219:54 - deprecated_member_use
   info - 'red' is deprecated and shouldn't be used. Use (*.r * 255.0).round() & 0xff -
          lib\shared\widgets\loading_widgets.dart:331:53 - deprecated_member_use
   info - 'green' is deprecated and shouldn't be used. Use (*.g * 255.0).round() & 0xff -
          lib\shared\widgets\loading_widgets.dart:332:53 - deprecated_member_use
   info - 'blue' is deprecated and shouldn't be used. Use (*.b * 255.0).round() & 0xff -
          lib\shared\widgets\loading_widgets.dart:333:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\loading_widgets.dart:397:32 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\loading_widgets.dart:430:43 - deprecated_member_use
warning - Unused import: '../widgets/calibration_debug_overlay.dart' - lib\shared\widgets\organic_dashboard.dart:11:8 -
       unused_import
warning - The value of the field '_initialSizeForScale' isn't used - lib\shared\widgets\organic_dashboard.dart:47:11 -
       unused_field
   info - The local variable '_routeMap' starts with an underscore - lib\shared\widgets\organic_dashboard.dart:119:33 -
          no_leading_underscores_for_local_identifiers
   info - 'surfaceVariant' is deprecated and shouldn't be used. Use surfaceContainerHighest instead. This feature was
          deprecated after v3.18.0-0.1.pre - lib\shared\widgets\organic_dashboard.dart:139:60 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:229:47 - deprecated_member_use
   info - Use 'const' with the constructor to improve performance - lib\shared\widgets\organic_dashboard.dart:232:32 -
          prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\shared\widgets\organic_dashboard.dart:254:33 -
          prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\shared\widgets\organic_dashboard.dart:254:55 -
          prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\shared\widgets\organic_dashboard.dart:262:33 -
          prefer_const_constructors
   info - Use 'const' with the constructor to improve performance - lib\shared\widgets\organic_dashboard.dart:270:33 -
          prefer_const_constructors
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:277:68 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:277:101 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:362:67 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:373:47 - deprecated_member_use
   info - Parameter 'key' could be a super parameter - lib\shared\widgets\organic_dashboard.dart:393:9 -
          use_super_parameters
warning - The value of the field '_startFocalLocal' isn't used - lib\shared\widgets\organic_dashboard.dart:418:11 -
       unused_field
warning - The value of the field '_startNormalizedPos' isn't used - lib\shared\widgets\organic_dashboard.dart:419:11 -
       unused_field
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:462:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:468:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:482:5 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:488:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:497:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:508:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:523:7 - avoid_print
   info - Don't invoke 'print' in production code - lib\shared\widgets\organic_dashboard.dart:536:5 - avoid_print
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:557:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\organic_dashboard.dart:558:53 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\plant_lifecycle_widget.dart:188:26 - deprecated_member_use
warning - The value of the field '_isInitialized' isn't used - lib\shared\widgets\quick_harvest_widget.dart:20:8 -
       unused_field
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:129:64 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:160:24 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:176:63 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:226:54 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:342:41 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:414:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\quick_harvest_widget.dart:428:57 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\recent_activities_widget.dart:235:34 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\weather_bubble.dart:39:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\weather_bubble.dart:40:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\weather_bubble.dart:47:35 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\weather_bubble.dart:64:39 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\weather_bubble.dart:71:55 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss -
          lib\shared\widgets\weather_bubble.dart:79:39 - deprecated_member_use
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:13:35 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:45:35 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:95:27 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:260:16 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:266:16 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:286:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:287:12 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\adapters\garden_migration_adapters_test.dart:495:31 - deprecated_member_use_from_same_package
   info - The imported package 'hive_test' isn't a dependency of the importing package -
          test\core\data\migration\garden_data_migration_test.dart:3:8 - depend_on_referenced_packages
  error - Target of URI doesn't exist: 'package:hive_test/hive_test.dart' -
         test\core\data\migration\garden_data_migration_test.dart:3:8 - uri_does_not_exist
  error - The function 'setUpTestHive' isn't defined - test\core\data\migration\garden_data_migration_test.dart:14:13 -
         undefined_function
  error - The function 'tearDownTestHive' isn't defined - test\core\data\migration\garden_data_migration_test.dart:18:13
         - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:97:51 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:98:35 - deprecated_member_use_from_same_package
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:126:28 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:131:51 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:134:16 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:144:16 - deprecated_member_use_from_same_package
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:175:28 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:180:43 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:183:12 - deprecated_member_use_from_same_package
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:217:28 - undefined_function
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:275:28 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:281:51 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:284:16 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:293:43 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:296:12 - deprecated_member_use_from_same_package
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:340:28 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:345:33 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromV2() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:346:29 - deprecated_member_use_from_same_package
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:364:28 - undefined_function
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:385:28 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:389:51 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:392:16 - deprecated_member_use_from_same_package
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:418:28 - undefined_function
  error - The function 'GardenFreezedAdapter' isn't defined -
         test\core\data\migration\garden_data_migration_test.dart:436:28 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:440:51 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\data\migration\garden_data_migration_test.dart:443:16 - deprecated_member_use_from_same_package
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:156:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:157:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:158:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:159:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:160:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:161:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:162:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:163:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:164:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:167:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:168:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:173:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:174:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:175:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:176:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:177:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:178:9 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:181:7 -
          avoid_print
   info - Don't invoke 'print' in production code - test\core\data\plants_json_v2_validation_test.dart:182:7 -
          avoid_print
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\services\aggregation\modern_data_adapter_test.dart:77:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\services\aggregation\modern_data_adapter_test.dart:100:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\services\aggregation\modern_data_adapter_test.dart:145:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\services\aggregation\modern_data_adapter_test.dart:226:29 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\services\aggregation\modern_data_adapter_test.dart:298:30 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\core\services\aggregation\modern_data_adapter_test.dart:306:30 - deprecated_member_use_from_same_package
  error - Local variable 'soilTempProvider' can't be referenced before it is declared -
         test\features\climate\integration\climate_rosace_integration_test.dart:25:47 - referenced_before_declaration
  error - Local variable 'soilPHProvider' can't be referenced before it is declared -
         test\features\climate\integration\climate_rosace_integration_test.dart:36:45 - referenced_before_declaration
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:66:41 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:71:36 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:77:43 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:87:41 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:92:36 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:98:44 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:107:42 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:108:42 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:115:37 -
         invocation_of_non_function_expression
  error - The expression doesn't evaluate to a function, so it can't be invoked -
         test\features\climate\integration\climate_rosace_integration_test.dart:116:37 -
         invocation_of_non_function_expression
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:139:27 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:144:25 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:146:22 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:151:26 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:152:26 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:152:53 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:161:32 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:179:26 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:179:58 - deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an
          explicit conversion - test\features\climate\presentation\utils\halo_color_maps_test.dart:194:27 -
          deprecated_member_use
   info - 'value' is deprecated and shouldn't be used. Use component accessors like .r or .g, or toARGB32 for an
          explicit conversion - test\features\climate\presentation\utils\halo_color_maps_test.dart:194:58 -
          deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:203:28 - deprecated_member_use
   info - 'opacity' is deprecated and shouldn't be used. Use .a -
          test\features\climate\presentation\utils\halo_color_maps_test.dart:204:28 - deprecated_member_use
  error - Target of URI doesn't exist: 'package:permacalendar/core/providers/app_settings_provider.dart' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:3:8 - uri_does_not_exist
  error - Undefined name 'appSettingsProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:26:28 - undefined_identifier
  error - Undefined name 'resolvedCoordinatesProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:57:49 - undefined_identifier
  error - Undefined name 'appSettingsProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:71:17 - undefined_identifier
  error - Undefined name 'resolvedCoordinatesProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:78:28 - undefined_identifier
  error - Undefined name 'resolvedCoordinatesProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:79:49 - undefined_identifier
  error - Undefined name 'appSettingsProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:143:28 - undefined_identifier
  error - Undefined name 'resolvedCoordinatesProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:149:28 - undefined_identifier
  error - Undefined name 'resolvedCoordinatesProvider' -
         test\features\climate\presentation\weather_providers_commune_sync_test.dart:150:42 - undefined_identifier
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_simple_test.dart:61:23 -
          deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_simple_test.dart:68:23 -
          deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_simple_test.dart:123:22 -
          deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_simple_test.dart:163:22 -
          deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_test.dart:61:23 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_test.dart:68:23 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_test.dart:142:22 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_test.dart:176:22 - deprecated_member_use_from_same_package
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\garden_bed\garden_bed_scoped_provider_test.dart:216:22 - deprecated_member_use_from_same_package
  error - The named parameter 'priorityActions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:356:15 -
         missing_required_argument
  error - Undefined name 'PlantHealth' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:359:22 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:362:20 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:363:17 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:364:14 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:365:13 - undefined_identifier
  error - The named parameter 'priorityActions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:384:15 -
         missing_required_argument
  error - Undefined name 'PlantHealth' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:387:22 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:390:20 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:391:17 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:392:14 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:393:13 - undefined_identifier
  error - The named parameter 'priorityActions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:415:15 -
         missing_required_argument
  error - Undefined name 'PlantHealth' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:418:22 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:421:20 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:422:17 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:423:14 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:424:13 - undefined_identifier
  error - The named parameter 'effortRequired' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:430:7 -
         missing_required_argument
  error - The named parameter 'estimatedCost' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:430:7 -
         missing_required_argument
  error - The named parameter 'expectedImpact' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:430:7 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:430:7 -
         missing_required_argument
  error - The named parameter 'instructions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:430:7 -
         missing_required_argument
  error - The named parameter 'type' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:430:7 -
         missing_required_argument
  error - The named parameter 'category' isn't defined -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:436:9 -
         undefined_named_parameter
  error - Undefined name 'RecommendationCategory' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:436:19 - undefined_identifier
  error - The named parameter 'effortRequired' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:440:7 -
         missing_required_argument
  error - The named parameter 'estimatedCost' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:440:7 -
         missing_required_argument
  error - The named parameter 'expectedImpact' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:440:7 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:440:7 -
         missing_required_argument
  error - The named parameter 'instructions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:440:7 -
         missing_required_argument
  error - The named parameter 'type' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:440:7 -
         missing_required_argument
  error - The named parameter 'category' isn't defined -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:446:9 -
         undefined_named_parameter
  error - Undefined name 'RecommendationCategory' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:446:19 - undefined_identifier
  error - There's no constant named 'warning' in 'NotificationType' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:464:32 -
         undefined_enum_constant
  error - The named parameter 'priorityActions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:484:15 -
         missing_required_argument
  error - Undefined name 'PlantHealth' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:487:22 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:490:20 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:491:17 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:492:14 - undefined_identifier
  error - Undefined name 'ConditionStatus' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:493:13 - undefined_identifier
  error - The named parameter 'effortRequired' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:500:14 -
         missing_required_argument
  error - The named parameter 'estimatedCost' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:500:14 -
         missing_required_argument
  error - The named parameter 'expectedImpact' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:500:14 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:500:14 -
         missing_required_argument
  error - The named parameter 'instructions' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:500:14 -
         missing_required_argument
  error - The named parameter 'type' is required, but there's no corresponding argument -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:500:14 -
         missing_required_argument
  error - The named parameter 'category' isn't defined -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:506:9 -
         undefined_named_parameter
  error - Undefined name 'RecommendationCategory' -
         test\features\plant_intelligence\data\repositories\analytics_repository_test.dart:506:19 - undefined_identifier
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\entities\analysis_result_test.dart:151:10 - missing_required_argument
  error - The named parameter 'lastUpdatedAt' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:14:23 -
         missing_required_argument
  error - The named parameter 'gardenName' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:16:9 -
         undefined_named_parameter
  error - The argument type 'Map<String, Object>' can't be assigned to the parameter type 'String'.  -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:17:19 -
         argument_type_not_assignable
  error - The argument type 'Map<String, Object>' can't be assigned to the parameter type 'String'.  -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:23:18 -
         argument_type_not_assignable
  error - The named parameter 'soil' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:29:9 -
         undefined_named_parameter
  error - The named parameter 'activePlantIds' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:34:9 -
         undefined_named_parameter
  error - The named parameter 'archivedPlantIds' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:35:9 -
         undefined_named_parameter
  error - The named parameter 'stats' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:36:9 -
         undefined_named_parameter
  error - The named parameter 'preferences' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:41:9 -
         undefined_named_parameter
  error - The named parameter 'collaboratorIds' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:45:9 -
         undefined_named_parameter
  error - The named parameter 'customData' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:46:9 -
         undefined_named_parameter
  error - The named parameter 'createdAt' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:47:9 -
         undefined_named_parameter
  error - The named parameter 'updatedAt' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:48:9 -
         undefined_named_parameter
  error - The named parameter 'lastIntelligenceSync' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:49:9 -
         undefined_named_parameter
  error - The getter 'gardenName' isn't defined for the type 'GardenIntelligenceContext' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:58:30 - undefined_getter
  error - The getter 'activePlantIds' isn't defined for the type 'GardenIntelligenceContext' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:59:30 - undefined_getter
  error - The getter 'archivedPlantIds' isn't defined for the type 'GardenIntelligenceContext' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:60:30 - undefined_getter
  error - The getter 'collaboratorIds' isn't defined for the type 'GardenIntelligenceContext' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:61:30 - undefined_getter
  error - The getter 'customData' isn't defined for the type 'GardenIntelligenceContext' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:62:30 - undefined_getter
  error - The getter 'lastIntelligenceSync' isn't defined for the type 'GardenIntelligenceContext' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:72:27 - undefined_getter
  error - The named parameter 'currentReports' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:79:9 -
         undefined_named_parameter
  error - The named parameter 'reportHistory' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:80:9 -
         undefined_named_parameter
  error - The named parameter 'recentAnalyses' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:81:9 -
         undefined_named_parameter
  error - The named parameter 'activeAlerts' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:82:9 -
         undefined_named_parameter
  error - The named parameter 'activeSuggestions' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:83:9 -
         undefined_named_parameter
  error - The named parameter 'globalIntelligenceScore' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:84:9 -
         undefined_named_parameter
  error - The named parameter 'globalConfidence' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:85:9 -
         undefined_named_parameter
  error - The getter 'currentReports' isn't defined for the type 'GardenIntelligenceMemory' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:99:29 - undefined_getter
  error - The getter 'reportHistory' isn't defined for the type 'GardenIntelligenceMemory' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:100:29 - undefined_getter
  error - The getter 'globalIntelligenceScore' isn't defined for the type 'GardenIntelligenceMemory' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:101:29 - undefined_getter
  error - The getter 'globalConfidence' isn't defined for the type 'GardenIntelligenceMemory' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:102:29 - undefined_getter
  error - The named parameter 'alertLevel' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:111:9 -
         undefined_named_parameter
  error - Undefined name 'NotificationLevel' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:111:21 -
         undefined_identifier
  error - The named parameter 'enableWeatherAlerts' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:112:9 -
         undefined_named_parameter
  error - The named parameter 'enableLunarSuggestions' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:113:9 -
         undefined_named_parameter
  error - The named parameter 'enableSeasonalReminders' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:114:9 -
         undefined_named_parameter
  error - The named parameter 'enablePestWarnings' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:115:9 -
         undefined_named_parameter
  error - The named parameter 'reportFrequency' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:116:9 -
         undefined_named_parameter
  error - Undefined name 'ReportFrequency' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:116:26 -
         undefined_identifier
  error - The named parameter 'showDetailedAnalysis' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:117:9 -
         undefined_named_parameter
  error - The named parameter 'showConfidenceScores' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:118:9 -
         undefined_named_parameter
  error - The named parameter 'showDebugInfo' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:119:9 -
         undefined_named_parameter
  error - The named parameter 'minConfidenceThreshold' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:120:9 -
         undefined_named_parameter
  error - The named parameter 'maxSuggestionsPerDay' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:121:9 -
         undefined_named_parameter
  error - The named parameter 'historyRetentionDays' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:122:9 -
         undefined_named_parameter
  error - The named parameter 'isSharedGarden' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:123:9 -
         undefined_named_parameter
  error - The named parameter 'allowCollaboratorSuggestions' isn't defined -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:124:9 -
         undefined_named_parameter
  error - The getter 'alertLevel' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:135:31 - undefined_getter
  error - Undefined name 'NotificationLevel' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:135:50 -
         undefined_identifier
  error - The getter 'enableWeatherAlerts' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:136:31 - undefined_getter
  error - The getter 'enableLunarSuggestions' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:137:31 - undefined_getter
  error - The getter 'reportFrequency' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:138:31 - undefined_getter
  error - Undefined name 'ReportFrequency' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:138:55 -
         undefined_identifier
  error - The getter 'minConfidenceThreshold' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:139:31 - undefined_getter
  error - The getter 'maxSuggestionsPerDay' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:140:31 - undefined_getter
  error - The getter 'historyRetentionDays' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:141:31 - undefined_getter
  error - The getter 'isSharedGarden' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:142:31 - undefined_getter
  error - The getter 'allowCollaboratorSuggestions' isn't defined for the type 'GardenIntelligenceSettings' -
         test\features\plant_intelligence\domain\entities\garden_intelligence_models_test.dart:143:31 - undefined_getter
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\entities\intelligence_report_test.dart:232:10 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\entities\intelligence_report_test.dart:265:10 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\entities\intelligence_report_test.dart:286:10 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\entities\intelligence_report_test.dart:307:10 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_evolution_tracker_service_test.dart:628:18 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_evolution_tracker_service_test.dart:641:15 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_evolution_tracker_service_test.dart:654:12 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_evolution_tracker_service_test.dart:667:11 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_intelligence_evolution_tracker_test.dart:398:18 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_intelligence_evolution_tracker_test.dart:411:15 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_intelligence_evolution_tracker_test.dart:424:12 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_intelligence_evolution_tracker_test.dart:437:11 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\services\plant_intelligence_evolution_tracker_test.dart:466:10 -
         missing_required_argument
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\analyze_pest_threats_usecase_test.dart:103:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\analyze_pest_threats_usecase_test.dart:152:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\analyze_pest_threats_usecase_test.dart:203:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\analyze_pest_threats_usecase_test.dart:247:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\analyze_pest_threats_usecase_test.dart:304:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\analyze_pest_threats_usecase_test.dart:370:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:115:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:143:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:145:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:179:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:214:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:255:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:288:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:322:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:345:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:391:36
         - return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context -
         test\features\plant_intelligence\domain\usecases\generate_bio_control_recommendations_usecase_test.dart:419:36
         - return_of_invalid_type_from_closure
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\usecases\generate_recommendations_usecase_test.dart:364:5 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\usecases\generate_recommendations_usecase_test.dart:380:5 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\usecases\generate_recommendations_usecase_test.dart:396:5 -
         missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\features\plant_intelligence\domain\usecases\test_helpers.dart:183:10 - missing_required_argument
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:36:22 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:39:22 - undefined_identifier
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:49:7 - avoid_print
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:67:7 - avoid_print
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:87:7 - avoid_print
warning - The value of the local variable 'initialStats' isn't used -
       test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:91:13 - unused_local_variable
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:115:7 - avoid_print
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:116:7 - avoid_print
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:135:7 - avoid_print
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:148:24 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:149:24 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:150:24 - undefined_identifier
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:163:7 - avoid_print
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:164:7 - avoid_print
   info - Don't invoke 'print' in production code -
          test\features\plant_intelligence\integration\garden_switch_benchmark_test.dart:190:7 - avoid_print
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:31:38 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:35:22 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:36:38 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:40:22 - undefined_identifier
  error - Undefined name 'currentIntelligenceGardenIdProvider' -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:41:37 - undefined_identifier
  error - The function 'MigrationReport' isn't defined -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:167:22 - undefined_function
  error - The function 'MigrationReport' isn't defined -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:187:22 - undefined_function
  error - The function 'MigrationReport' isn't defined -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:195:22 - undefined_function
  error - The function 'MigrationReport' isn't defined -
         test\features\plant_intelligence\integration\multi_garden_flow_test.dart:203:22 - undefined_function
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:24:15 -
          deprecated_member_use_from_same_package
  error - Undefined class 'IntelligenceState' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:25:10 -
         undefined_class
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:43:26 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:43:29 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:43:32 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:44:27 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:44:30 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:44:33 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:59:26 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:59:29 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:60:27 -
         list_element_type_not_assignable
  error - The element type 'int' can't be assigned to the list type 'String' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:60:30 -
         list_element_type_not_assignable
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:66:9 -
          deprecated_member_use_from_same_package
  error - The named parameter 'description' is required, but there's no corresponding argument -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:66:9 -
         missing_required_argument
  error - The named parameter 'totalAreaInSquareMeters' is required, but there's no corresponding argument -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:66:9 -
         missing_required_argument
  error - The named parameter 'size' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:70:11 -
         undefined_named_parameter
  error - The name 'IntelligenceState' isn't a class -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:76:37 -
         creation_with_non_type
  error - The argument type 'IntelligenceStateNotifier Function(dynamic)' can't be assigned to the parameter type
         'IntelligenceStateNotifier Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:95:15 -
         argument_type_not_assignable
  error - The returned type 'IntelligenceStateNotifier (where IntelligenceStateNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\test\features\plant_intelligence\presentation\integration\evo
         lution_timeline_integration_test.dart)' isn't returnable from a 'IntelligenceStateNotifier (where
         IntelligenceStateNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\plant_intelligence\presentation\providers\intell
         igence_state_providers.dart)' function, as required by the closure's context -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:96:19 -
         return_of_invalid_type_from_closure
  error - The setter 'state' isn't defined for the type 'IntelligenceStateNotifier' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:96:48 -
         undefined_setter
  error - The argument type 'PlantCatalogNotifier Function(dynamic)' can't be assigned to the parameter type
         'PlantCatalogNotifier Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:99:15 -
         argument_type_not_assignable
  error - Too many positional arguments: 0 expected, but 2 found -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:100:19 -
         extra_positional_arguments
  error - The argument type 'GardenNotifier Function(dynamic)' can't be assigned to the parameter type 'GardenNotifier
         Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:104:15 -
         argument_type_not_assignable
  error - The returned type 'GardenNotifier (where GardenNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\test\features\plant_intelligence\presentation\integration\evo
         lution_timeline_integration_test.dart)' isn't returnable from a 'GardenNotifier (where GardenNotifier is
         defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\garden\providers\garden_provider.dart)'
         function, as required by the closure's context -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:104:24 -
         return_of_invalid_type_from_closure
  error - The setter 'state' isn't defined for the type 'GardenNotifier' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:105:19 -
         undefined_setter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:146:11 -
         undefined_named_parameter
  error - The argument type 'IntelligenceStateNotifier Function(dynamic)' can't be assigned to the parameter type
         'IntelligenceStateNotifier Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:154:15 -
         argument_type_not_assignable
  error - The returned type 'IntelligenceStateNotifier (where IntelligenceStateNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\test\features\plant_intelligence\presentation\integration\evo
         lution_timeline_integration_test.dart)' isn't returnable from a 'IntelligenceStateNotifier (where
         IntelligenceStateNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\plant_intelligence\presentation\providers\intell
         igence_state_providers.dart)' function, as required by the closure's context -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:155:19 -
         return_of_invalid_type_from_closure
  error - The setter 'state' isn't defined for the type 'IntelligenceStateNotifier' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:155:48 -
         undefined_setter
  error - The argument type 'PlantCatalogNotifier Function(dynamic)' can't be assigned to the parameter type
         'PlantCatalogNotifier Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:158:15 -
         argument_type_not_assignable
  error - Too many positional arguments: 0 expected, but 2 found -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:159:19 -
         extra_positional_arguments
  error - The argument type 'GardenNotifier Function(dynamic)' can't be assigned to the parameter type 'GardenNotifier
         Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:163:15 -
         argument_type_not_assignable
  error - The returned type 'GardenNotifier (where GardenNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\test\features\plant_intelligence\presentation\integration\evo
         lution_timeline_integration_test.dart)' isn't returnable from a 'GardenNotifier (where GardenNotifier is
         defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\garden\providers\garden_provider.dart)'
         function, as required by the closure's context -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:163:24 -
         return_of_invalid_type_from_closure
  error - The setter 'state' isn't defined for the type 'GardenNotifier' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:164:19 -
         undefined_setter
  error - Const variables must be initialized with a constant value -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:196:26 -
         const_initialized_with_non_constant_value
  error - The function 'IntelligenceState' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:196:26 -
         undefined_function
  error - The argument type 'IntelligenceStateNotifier Function(dynamic)' can't be assigned to the parameter type
         'IntelligenceStateNotifier Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:210:15 -
         argument_type_not_assignable
  error - The returned type 'IntelligenceStateNotifier (where IntelligenceStateNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\test\features\plant_intelligence\presentation\integration\evo
         lution_timeline_integration_test.dart)' isn't returnable from a 'IntelligenceStateNotifier (where
         IntelligenceStateNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\plant_intelligence\presentation\providers\intell
         igence_state_providers.dart)' function, as required by the closure's context -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:210:24 -
         return_of_invalid_type_from_closure
  error - The setter 'state' isn't defined for the type 'IntelligenceStateNotifier' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:210:53 -
         undefined_setter
  error - The argument type 'PlantCatalogNotifier Function(dynamic)' can't be assigned to the parameter type
         'PlantCatalogNotifier Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:213:15 -
         argument_type_not_assignable
  error - Too many positional arguments: 0 expected, but 2 found -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:214:19 -
         extra_positional_arguments
  error - The argument type 'GardenNotifier Function(dynamic)' can't be assigned to the parameter type 'GardenNotifier
         Function()'.  -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:218:15 -
         argument_type_not_assignable
  error - The returned type 'GardenNotifier (where GardenNotifier is defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\test\features\plant_intelligence\presentation\integration\evo
         lution_timeline_integration_test.dart)' isn't returnable from a 'GardenNotifier (where GardenNotifier is
         defined in
         C:\Users\roman\Documents\apppklod\permacalendarv2\lib\features\garden\providers\garden_provider.dart)'
         function, as required by the closure's context -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:218:24 -
         return_of_invalid_type_from_closure
  error - The setter 'state' isn't defined for the type 'GardenNotifier' -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:219:19 -
         undefined_setter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:253:11 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:265:11 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:310:11 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:322:11 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:377:11 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:389:11 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:401:11 -
         undefined_named_parameter
  error - Classes can only extend other classes -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:437:41 -
         extends_non_class
  error - The name 'IntelligenceState' isn't a type, so it can't be used as a type argument -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:437:55 -
         non_type_as_type_argument
  error - Too many positional arguments: 0 expected, but 1 found -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:439:15 -
         extra_positional_arguments
  error - The name 'IntelligenceState' isn't a class -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:439:21 -
         creation_with_non_type
  error - Classes can only extend other classes -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:466:30 -
         extends_non_class
warning - The value of the field '_ref' isn't used -
       test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:467:13 -
       unused_field
  error - Too many positional arguments: 0 expected, but 1 found -
         test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:468:37 -
         extra_positional_arguments
   info - 'Garden' is deprecated and shouldn't be used. Utilisez GardenFreezed à la place. Utilisez
          GardenMigrationAdapters.fromLegacy() pour migrer. Sera supprimé dans la v3.0 -
          test\features\plant_intelligence\presentation\integration\evolution_timeline_integration_test.dart:472:14 -
          deprecated_member_use_from_same_package
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:52:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:93:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:136:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:177:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:233:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:275:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:317:9 -
         undefined_named_parameter
  error - The named parameter 'stableConditions' isn't defined -
         test\features\plant_intelligence\presentation\widgets\plant_health_degradation_banner_test.dart:362:9 -
         undefined_named_parameter
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\helpers\plant_intelligence_test_helpers.dart:259:10 - missing_required_argument
  error - The named parameter 'gardenId' is required, but there's no corresponding argument -
         test\helpers\plant_intelligence_test_helpers.dart:350:10 - missing_required_argument
  error - The function 'AppSettingsAdapter' isn't defined - test\integration\app_settings_migration_test.dart:34:30 -
         undefined_function
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context - test\integration\biological_control_e2e_test.dart:144:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context - test\integration\biological_control_e2e_test.dart:223:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context - test\integration\biological_control_e2e_test.dart:257:36 -
         return_of_invalid_type_from_closure
  error - The returned type 'Plant' isn't returnable from a 'Future<PlantFreezed?>' function, as required by the
         closure's context - test\integration\biological_control_e2e_test.dart:463:36 -
         return_of_invalid_type_from_closure
   info - Don't invoke 'print' in production code - test\tools\plants_json_migration_test.dart:359:9 - avoid_print
   info - Don't invoke 'print' in production code - test\tools\plants_json_migration_test.dart:373:9 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:24:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:25:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:26:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:30:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:34:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:41:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:44:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:49:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:52:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:83:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:84:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:85:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:87:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:91:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:108:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:111:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:119:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:122:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:123:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:124:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:125:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:126:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:127:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:128:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:129:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:130:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:131:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:132:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:133:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:134:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:136:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:138:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:139:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:140:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:141:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:142:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:143:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:144:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:145:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:149:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:150:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:152:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:155:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:157:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:158:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:159:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:160:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:163:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:164:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:165:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:166:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:167:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:168:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:169:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:170:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:171:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:172:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:173:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:174:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:175:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:176:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:177:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:178:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:179:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:180:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:183:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:184:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:185:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:186:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:187:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:188:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:189:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:190:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:191:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\migrate_plants_json.dart:192:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:16:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:17:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:18:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:29:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:33:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:37:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:41:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:45:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:48:3 - avoid_print
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:133:5 - unnecessary_string_interpolations
   info - Unnecessary braces in a string interpolation - tools\orphan_analyzer.dart:141:45 -
          unnecessary_brace_in_string_interps
   info - Use interpolation to compose strings and values - tools\orphan_analyzer.dart:144:34 -
          prefer_interpolation_to_compose_strings
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:146:3 - avoid_print
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:218:5 - unnecessary_string_interpolations
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:224:5 - unnecessary_string_interpolations
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:226:5 - unnecessary_string_interpolations
   info - Unnecessary braces in a string interpolation - tools\orphan_analyzer.dart:230:77 -
          unnecessary_brace_in_string_interps
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:235:19 -
          unnecessary_string_interpolations
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:237:19 -
          unnecessary_string_interpolations
   info - Use interpolation to compose strings and values - tools\orphan_analyzer.dart:242:34 -
          prefer_interpolation_to_compose_strings
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:244:3 - avoid_print
   info - Unnecessary use of string interpolation - tools\orphan_analyzer.dart:300:18 -
          unnecessary_string_interpolations
   info - Unnecessary braces in a string interpolation - tools\orphan_analyzer.dart:306:80 -
          unnecessary_brace_in_string_interps
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:312:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\orphan_analyzer.dart:508:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:21:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:22:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:23:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:30:3 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:36:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:47:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:51:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:56:9 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:59:9 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:65:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:68:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:75:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:78:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:84:9 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:90:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:96:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:104:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:107:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:113:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:130:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:139:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:151:15 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:165:15 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:177:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:186:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:195:11 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:207:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:208:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:209:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:211:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:212:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:213:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:214:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:215:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:216:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:217:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:218:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:220:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:222:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:225:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:226:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:227:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:228:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:229:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:230:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:231:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:234:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:235:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:236:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:237:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:238:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:239:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:240:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:243:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:244:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:245:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:246:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:247:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:248:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:249:7 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:254:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:255:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:256:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:257:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:258:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:259:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:260:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:261:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:262:5 - avoid_print
   info - Don't invoke 'print' in production code - tools\validate_plants_json.dart:263:5 - avoid_print

1677 issues found. (ran in 1.9s)
PS C:\Users\roman\Documents\apppklod\permacalendarv2>