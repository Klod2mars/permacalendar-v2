import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/organic_dashboard.dart';
import '../../../app_router.dart';

/// HomeScreen - écran d'accueil principal
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final availableHeight = MediaQuery.of(context).size.height - appBarHeight;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'PermaCalendar 2.0',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: availableHeight,
          child: const OrganicDashboardWidget(
            showDiagnostics: false,
          ),
        ),
      ),
    );
  }
}
