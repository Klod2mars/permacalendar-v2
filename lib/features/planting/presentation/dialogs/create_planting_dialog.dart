// lib/features/planting/presentation/dialogs/create_planting_dialog.dart
import 'package:flutter/material.dart';

import '../../../../core/models/planting.dart';
import 'create_planting_dialog_custom.dart';

/// Wrapper de compatibilité : conserve la même API `CreatePlantingDialog`
/// pour ne rien casser dans le code existant.
/// Délègue l'affichage à CreatePlantingDialogCustom (impl sans IntrinsicWidth).
class CreatePlantingDialog extends StatelessWidget {
  final String gardenBedId;
  final Planting? planting;

  const CreatePlantingDialog({
    Key? key,
    required this.gardenBedId,
    this.planting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CreatePlantingDialogCustom(
      gardenBedId: gardenBedId,
      planting: planting,
    );
  }
}
