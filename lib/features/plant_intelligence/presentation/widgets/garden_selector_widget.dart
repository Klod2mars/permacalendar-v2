import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/garden/providers/garden_provider.dart';
import '../providers/intelligence_state_providers.dart';
import '../../../../core/providers/providers.dart';

/// Widget de sélection de jardin pour l'intelligence végétale
///
/// **PROMPT A15 - Multi-Garden UI**
///
/// Permet à l'utilisateur de choisir quel jardin afficher dans le dashboard
/// d'intelligence végétale. Change le `currentIntelligenceGardenIdProvider`
/// qui déclenche la mise à jour de l'interface.
///
/// Features:
/// - Dropdown avec liste des jardins actifs
/// - Affichage du nom et de l'icône du jardin
/// - Gestion automatique du jardin par défaut
/// - Design cohérent avec l'app
class GardenSelectorWidget extends ConsumerWidget {
  /// Style du sélecteur
  final GardenSelectorStyle style;

  /// Callback optionnel appelé lors du changement de jardin
  final void Function(String gardenId)? onGardenChanged;

  const GardenSelectorWidget({
    super.key,
    this.style = GardenSelectorStyle.dropdown,
    this.onGardenChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gardenState = ref.watch(gardenProvider);
    final currentGardenId = ref.watch(currentIntelligenceGardenIdProvider);
    final theme = Theme.of(context);

    // Récupérer les jardins actifs
    final activeGardens = gardenState.activeGardens;

    // Si pas de jardins, afficher un message
    if (activeGardens.isEmpty) {
      return _buildEmptyState(context, theme);
    }

    // Si un seul jardin, pas besoin de sélecteur
    if (activeGardens.length == 1) {
      // Auto-sélectionner le seul jardin disponible
      if (currentGardenId != activeGardens.first.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(currentIntelligenceGardenIdProvider.notifier).state =
              activeGardens.first.id;
        });
      }
      return _buildSingleGarden(context, theme, activeGardens.first.name);
    }

    // Sélectionner automatiquement le premier jardin si aucun n'est sélectionné
    if (currentGardenId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentIntelligenceGardenIdProvider.notifier).state =
            activeGardens.first.id;
      });
    }

    // Afficher le sélecteur selon le style
    switch (style) {
      case GardenSelectorStyle.dropdown:
        return _buildDropdown(
            context, ref, theme, activeGardens, currentGardenId);
      case GardenSelectorStyle.chips:
        return _buildChips(context, ref, theme, activeGardens, currentGardenId);
      case GardenSelectorStyle.list:
        return _buildList(context, ref, theme, activeGardens, currentGardenId);
    }
  }

  /// Affiche un message quand aucun jardin n'est disponible
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Aucun jardin actif',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche le nom du jardin unique
  Widget _buildSingleGarden(
      BuildContext context, ThemeData theme, String gardenName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.park_rounded,
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            gardenName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Sélecteur de type dropdown
  Widget _buildDropdown(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    List<dynamic> gardens,
    String? currentGardenId,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentGardenId,
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: theme.colorScheme.onSurface,
          ),
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          items: gardens.map((garden) {
            return DropdownMenuItem<String>(
              value: garden.id,
              child: Row(
                children: [
                  Icon(
                    Icons.park_rounded,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    garden.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newGardenId) {
            if (newGardenId != null) {
              _onGardenSelected(ref, newGardenId);
            }
          },
        ),
      ),
    );
  }

  /// Sélecteur de type chips (horizontalement scrollable)
  Widget _buildChips(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    List<dynamic> gardens,
    String? currentGardenId,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: gardens.map((garden) {
          final isSelected = garden.id == currentGardenId;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(garden.name),
              avatar: Icon(
                Icons.park_rounded,
                size: 18,
                color: isSelected
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurface,
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _onGardenSelected(ref, garden.id);
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.secondaryContainer,
              checkmarkColor: theme.colorScheme.onSecondaryContainer,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Sélecteur de type liste (vertical)
  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    List<dynamic> gardens,
    String? currentGardenId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: gardens.map((garden) {
        final isSelected = garden.id == currentGardenId;
        return Material(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () => _onGardenSelected(ref, garden.id),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.park_rounded,
                    color: isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      garden.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Gère la sélection d'un jardin
  void _onGardenSelected(WidgetRef ref, String gardenId) {
    // Mettre à jour le provider
    ref.read(currentIntelligenceGardenIdProvider.notifier).state = gardenId;

    // Appeler le callback si fourni
    onGardenChanged?.call(gardenId);

    // Logger pour debug
    debugPrint('🌱 [GardenSelector] Jardin sélectionné: $gardenId');
  }
}

/// Style d'affichage du sélecteur de jardin
enum GardenSelectorStyle {
  /// Dropdown classique (compact)
  dropdown,

  /// Chips horizontalement scrollables (moderne)
  chips,

  /// Liste verticale (détaillée)
  list,
}

/// Widget compact pour l'app bar
///
/// Version simplifiée du sélecteur optimisée pour l'app bar.
class GardenSelectorAppBar extends ConsumerWidget {
  const GardenSelectorAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GardenSelectorWidget(
      style: GardenSelectorStyle.dropdown,
    );
  }
}

/// Bottom sheet pour sélection de jardin
///
/// Affiche une liste complète des jardins dans un bottom sheet.
class GardenSelectorBottomSheet extends ConsumerWidget {
  const GardenSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.park_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Sélectionner un jardin',
                style: theme.textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Liste des jardins
          const GardenSelectorWidget(
            style: GardenSelectorStyle.list,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Affiche le bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => const GardenSelectorBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}


