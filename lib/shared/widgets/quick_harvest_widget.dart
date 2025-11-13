ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/planting/providers/planting_provider.dart';
import '../../core/models/planting.dart';
import '../../core/analytics/ui_analytics.dart';

/// Widget optimisé pour une saisie rapide des récoltes
class QuickHarvestWidget extends ConsumerStatefulWidget {
  const QuickHarvestWidget({super.key});

  @override
  ConsumerState<QuickHarvestWidget> createState() => _QuickHarvestWidgetState();
}

class _QuickHarvestWidgetState extends ConsumerState<QuickHarvestWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedPlantings = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to avoid modifying provider during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (!mounted) return;

    try {
      await UIAnalytics.measureOperation(
        'quick_harvest_open',
        () => ref.read(plantingProvider.notifier).loadAllPlantings(),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        final readyCount = ref.read(plantingsReadyForHarvestProvider).length;
        UIAnalytics.quickHarvestOpened(readyPlantsCount: readyCount);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final readyForHarvest = ref.watch(plantingsReadyForHarvestProvider);

    final filteredPlantings = _searchQuery.isEmpty
        ? readyForHarvest
        : readyForHarvest.where((p) {
            return p.plantName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          }).toList();

    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.agriculture,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Récolte rapide',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sélectionnez les plantes à récolter',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une plante...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.3),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Compteur de sélections
            if (_selectedPlantings.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedPlantings.length} plante(s) sélectionnée(s)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Liste des plantations
            Expanded(
              child: filteredPlantings.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredPlantings.length,
                      itemBuilder: (context, index) {
                        final planting = filteredPlantings[index];
                        final isSelected =
                            _selectedPlantings.contains(planting.id);

                        return _buildPlantingTile(
                          planting,
                          isSelected,
                          theme,
                        );
                      },
                    ),
            ),

            // Actions en bas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Tout sélectionner / Tout désélectionner
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (_selectedPlantings.length ==
                              filteredPlantings.length) {
                            _selectedPlantings.clear();
                          } else {
                            _selectedPlantings.clear();
                            _selectedPlantings.addAll(
                              filteredPlantings.map((p) => p.id),
                            );
                          }
                        });
                      },
                      icon: Icon(
                        _selectedPlantings.length == filteredPlantings.length
                            ? Icons.deselect
                            : Icons.select_all,
                      ),
                      label: Text(
                        _selectedPlantings.length == filteredPlantings.length
                            ? 'Tout désélectionner'
                            : 'Tout sélectionner',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Bouton Récolter
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _selectedPlantings.isEmpty
                          ? null
                          : () => _harvestSelected(context),
                      icon: const Icon(Icons.agriculture),
                      label: Text('Récolter (${_selectedPlantings.length})'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantingTile(
    Planting planting,
    bool isSelected,
    ThemeData theme,
  ) {
    final daysSincePlanted =
        DateTime.now().difference(planting.plantedDate).inDays;
    final isOverdue = planting.expectedHarvestStartDate != null &&
        planting.expectedHarvestStartDate!.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedPlantings.remove(planting.id);
              } else {
                _selectedPlantings.add(planting.id);
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedPlantings.add(planting.id);
                      } else {
                        _selectedPlantings.remove(planting.id);
                      }
                    });
                  },
                ),
                const SizedBox(width: 12),

                // Icône de la plante
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Informations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              planting.plantName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isOverdue)
                            const Icon(
                              Icons.warning,
                              size: 16,
                              color: Colors.red,
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Quantité: ${planting.quantity} • ${daysSincePlanted}j',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (planting.expectedHarvestStartDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          isOverdue
                              ? 'En retard de récolte!'
                              : 'Prêt à récolter',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isOverdue ? Colors.red : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.agriculture,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune plante prête à récolter',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Les plantes prêtes à être récoltées\napparaÃ®tront ici',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _harvestSelected(BuildContext context) async {
    final selectedCount = _selectedPlantings.length;

    if (selectedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune plante sélectionnée'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.agriculture, size: 48),
        title: const Text('Confirmer la récolte'),
        content: Text(
          'Voulez-vous récolter $selectedCount plante(s) ?\n\n'
          'Cette action marquera les plantations comme récoltées avec la date d\'aujourd\'hui.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              UIAnalytics.quickHarvestCancelled();
              Navigator.of(context).pop(false);
            },
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Récolter'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    // Afficher un indicateur de progression
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(child: Text('Récolte en cours...')),
          ],
        ),
      ),
    );

    // Récolter les plantations sélectionnées avec mesure de performance
    int successCount = 0;
    int errorCount = 0;
    final List<String> errorDetails = [];

    try {
      for (final plantingId in _selectedPlantings) {
        try {
          final success = await ref
              .read(plantingProvider.notifier)
              .harvestPlanting(plantingId, DateTime.now());

          if (success) {
            successCount++;
          } else {
            errorCount++;
            errorDetails.add('Échec pour plantation $plantingId');
          }
        } catch (e) {
          errorCount++;
          errorDetails.add('Erreur pour $plantingId: ${e.toString()}');
        }
      }

      // Log analytics
      UIAnalytics.quickHarvestConfirmed(
        count: selectedCount,
        successCount: successCount,
        errorCount: errorCount,
      );
    } catch (e) {
      errorDetails.add('Erreur globale: ${e.toString()}');
    }

    // Fermer le dialogue de progression
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Afficher le résultat
    if (!context.mounted) return;

    if (errorCount > 0 && errorDetails.isNotEmpty) {
      // Afficher les détails des erreurs
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning, size: 48, color: Colors.orange),
          title: const Text('Récolte partielle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$successCount plante(s) récoltée(s) avec succès'),
                Text('$errorCount échec(s)',
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                const Text('Détails des erreurs:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...errorDetails.take(5).map(
                    (e) => Text('• $e', style: const TextStyle(fontSize: 12))),
                if (errorDetails.length > 5)
                  Text('... et ${errorDetails.length - 5} autres erreurs'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                errorCount == 0 ? Icons.check_circle : Icons.warning,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  errorCount == 0
                      ? '$successCount plante(s) récoltée(s) avec succès!'
                      : '$successCount récoltée(s), $errorCount échec(s)',
                ),
              ),
            ],
          ),
          backgroundColor: errorCount == 0 ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    // Réinitialiser et fermer si succès complet
    if (mounted) {
      setState(() {
        _selectedPlantings.clear();
      });
    }

    if (errorCount == 0 && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Bouton flottant pour ouvrir le widget de récolte rapide
class QuickHarvestFAB extends StatelessWidget {
  const QuickHarvestFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const QuickHarvestWidget(),
        );
      },
      icon: const Icon(Icons.agriculture),
      label: const Text('Récolte rapide'),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      elevation: 4,
    );
  }
}


