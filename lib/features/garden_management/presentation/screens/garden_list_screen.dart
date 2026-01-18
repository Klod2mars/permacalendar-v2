import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../../app_router.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/loading_widgets.dart';

/// Écran liste des jardins actifs, avec bouton de création
/// et un rappel pour les jardins archivés.
class GardenListScreen extends ConsumerWidget {
  const GardenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final l10n = AppLocalizations.of(context)!;

    // Chargement
    if (gardenState.isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: l10n.garden_list_title),
        body: const Center(child: LoadingWidget()),
      );
    }

    // Erreur
    if (gardenState.error != null) {
      return Scaffold(
        appBar: CustomAppBar(title: l10n.garden_list_title),
        body: ErrorStateWidget(
          title: l10n.garden_error_title,
          subtitle: l10n.garden_error_subtitle(gardenState.error.toString()),
          onRetry: () => ref.read(gardenProvider.notifier).loadGardens(),
          retryText: l10n.garden_retry,
        ),
      );
    }

    // Données OK
    final activeGardens = gardenState.activeGardens;
    final totalGardens = gardenState.gardens;
    final archivedCount = totalGardens.length - activeGardens.length;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.garden_list_title),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: activeGardens.isEmpty
            ? Center(
                child: Text(l10n.garden_no_gardens),
              )
            : ListView.builder(
                itemCount: activeGardens.length + (archivedCount > 0 ? 1 : 0),
                itemBuilder: (context, index) {
                  // Ligne spéciale : information jardins archivés
                  if (archivedCount > 0 && index == activeGardens.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        l10n.garden_archived_info,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    );
                  }

                  // Jardin actif
                  final garden = activeGardens[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CustomCard(
                      child: ListTile(
                        title: Text(garden.name),
                        subtitle: (garden.description != null &&
                                garden.description!.isNotEmpty)
                            ? Text(garden.description!)
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(
                          AppRoutes.gardenDetail.replaceFirst(':id', garden.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.gardenCreate),
        tooltip: l10n.garden_add_tooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
