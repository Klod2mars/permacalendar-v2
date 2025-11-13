ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/models/garden_state.dart';

import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/loading_widgets.dart';
import '../../../../features/garden/widgets/garden_card_with_real_area.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../../../../app_router.dart';

class GardenListScreen extends ConsumerStatefulWidget {
  const GardenListScreen({super.key});

  @override
  ConsumerState<GardenListScreen> createState() => _GardenListScreenState();
}

class _GardenListScreenState extends ConsumerState<GardenListScreen> {
  bool _showArchived = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load gardens when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gardenProvider.notifier).loadGardens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gardenState = ref.watch(gardenProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Mes jardins'),
      body: _buildBody(gardenState, Theme.of(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.gardenCreate),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(GardenState gardenState, ThemeData theme) {
    if (gardenState.isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (gardenState.error != null) {
      return ErrorStateWidget(
        title: gardenState.error!,
        onRetry: () => ref.read(gardenProvider.notifier).loadGardens(),
      );
    }

    final filteredGardens = gardenState.gardens.where((garden) {
      final matchesSearch = _searchQuery.isEmpty ||
          garden.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (garden.description
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);

      final matchesArchiveFilter = _showArchived || garden.isActive;

      return matchesSearch && matchesArchiveFilter;
    }).toList();

    if (filteredGardens.isEmpty) {
      return _buildEmptyState(gardenState, theme);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(gardenProvider.notifier).loadGardens(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredGardens.length,
        itemBuilder: (context, index) {
          final garden = filteredGardens[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GardenCardWithRealArea(
              garden: garden,
              onTap: () => context.push('/gardens/${garden.id}'),
              onEdit: () => _editGarden(garden.id),
              onDelete: () => _deleteGarden(garden.id),
              onToggleStatus: () => _toggleGardenStatus(garden.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(GardenState gardenState, ThemeData theme) {
    if (_searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'Aucun résultat',
        subtitle:
            'Aucun jardin ne correspond à votre recherche "$_searchQuery"',
        actionText: 'Effacer la recherche',
        onAction: () {
          setState(() {
            _searchQuery = '';
          });
        },
      );
    }

    if (!_showArchived && gardenState.gardens.any((g) => !g.isActive)) {
      return EmptyStateWidget(
        icon: Icons.eco,
        title: 'Aucun jardin actif',
        subtitle:
            'Vous avez des jardins archivés. Activez l'affichage des jardins archivés pour les voir.',
        actionText: 'Afficher les jardins archivés',
        onAction: () {
          setState(() {
            _showArchived = true;
          });
        },
      );
    }

    return EmptyStateWidget(
      icon: Icons.eco,
      title: 'Aucun jardin',
      subtitle:
          'Commencez par Créer votre premier jardin pour suivre vos plantations.',
      actionText: 'Créer un jardin',
      onAction: () => context.push(AppRoutes.gardenCreate),
    );
  }

  void _editGarden(String gardenId) {
    // TODO: Navigate to edit screen or show edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Édition à implémenter')),
    );
  }

  void _deleteGarden(String gardenId) {
    ref.read(gardenProvider.notifier).deleteGarden(gardenId);
  }

  void _toggleGardenStatus(String gardenId) {
    ref.read(gardenProvider.notifier).toggleGardenStatus(gardenId);
  }
}







