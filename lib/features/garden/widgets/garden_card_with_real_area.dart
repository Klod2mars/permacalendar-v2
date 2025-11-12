import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/garden_freezed.dart';
import '../../garden_bed/providers/garden_bed_scoped_provider.dart';
import 'garden_card.dart';

/// Wrapper ConsumerWidget qui calcule la surface totale en temps réel
/// Respecte la clean architecture en séparant la logique de données de la présentation
class GardenCardWithRealArea extends ConsumerWidget {
  /// Le jardin à afficher
  final GardenFreezed garden;

  /// Callback appelé lors du tap sur la carte
  final VoidCallback? onTap;

  /// Callback appelé lors de l'édition du jardin
  final VoidCallback? onEdit;

  /// Callback appelé lors de la suppression du jardin
  final VoidCallback? onDelete;

  /// Callback appelé lors du changement de statut du jardin
  final VoidCallback? onToggleStatus;

  /// Afficher ou masquer les actions (défaut: true)
  final bool showActions;

  const GardenCardWithRealArea({
    super.key,
    required this.garden,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utilise le provider pour calculer la surface totale en temps réel
    final totalAreaAsync = ref.watch(gardenTotalAreaProvider(garden.id));

    return totalAreaAsync.when(
      data: (totalArea) {
        // Crée une copie du jardin avec la surface calculée en temps réel
        final gardenWithRealArea = garden.copyWith(
          totalAreaInSquareMeters: totalArea,
        );

        return GardenCard(
          garden: gardenWithRealArea,
          onTap: onTap,
          onEdit: onEdit,
          onDelete: onDelete,
          onToggleStatus: onToggleStatus,
          showActions: showActions,
        );
      },
      loading: () => GardenCard(
        garden: garden,
        onTap: onTap,
        onEdit: onEdit,
        onDelete: onDelete,
        onToggleStatus: onToggleStatus,
        showActions: showActions,
      ),
      error: (error, stackTrace) {
        // En cas d'erreur, affiche la surface par défaut du jardin
        return GardenCard(
          garden: garden,
          onTap: onTap,
          onEdit: onEdit,
          onDelete: onDelete,
          onToggleStatus: onToggleStatus,
          showActions: showActions,
        );
      },
    );
  }
}

