// Global test bootstrap - ensure bindings, adapters and locale
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'helpers/register_hive_adapters.dart';

void _ensureTestBootstrap() {
  // Ensure binding for widgets tests
  TestWidgetsFlutterBinding.ensureInitialized();

  // Register Hive adapters (created by generator)
  try {
    registerAllHiveAdapters();
  } catch (_) {
    // swallow errors during registration in bootstrap
  }

  // Default locale for intl-related tests
  try {
    Intl.defaultLocale = 'en_US';
  } catch (_) {}
}

// Execute on import
// ignore: unused_field
final _testBootstrap = _ensureTestBootstrap();

