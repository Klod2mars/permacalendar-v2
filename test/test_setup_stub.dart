// Global test bootstrap - ensure bindings, adapters and locale
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'helpers/register_hive_adapters.dart';

Future<void> _ensureTestBootstrap() async {
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
    await initializeDateFormatting('en_US');
  } catch (_) {}
}

// Execute on import (synchronously schedule)
final Future<void> _testBootstrapFuture = _ensureTestBootstrap();
// ignore: unused_element
Future<void> _ensureTestBootstrapDone() async => await _testBootstrapFuture;

