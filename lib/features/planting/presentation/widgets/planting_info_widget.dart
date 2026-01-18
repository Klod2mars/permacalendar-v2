// lib/features/planting/presentation/widgets/planting_info_widget.dart
import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

import '../../../plant_catalog/domain/entities/plant_entity.dart';
import '../../../../shared/widgets/custom_card.dart';

/// Widget réutilisable pour afficher les informations botaniques d'une plante.
class PlantingInfoWidget extends StatelessWidget {
  final PlantFreezed plant;
  final ThemeData? theme;

  const PlantingInfoWidget({
    Key? key,
    required this.plant,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData usedTheme = theme ?? Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.planting_info_title,
            style: usedTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (plant.description.isNotEmpty) ...[
            Text(
              plant.description,
              style: usedTheme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
          ],
          _buildInfoGrid(usedTheme, context),
          if (plant.culturalTips != null && plant.culturalTips!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.planting_info_tips_title,
              style: usedTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...plant.culturalTips!
                .map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: usedTheme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: usedTheme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoGrid(ThemeData theme, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = <_InfoItem>[
      if (plant.daysToMaturity > 0)
        _InfoItem(l10n.planting_info_maturity, l10n.planting_info_days(plant.daysToMaturity), Icons.schedule),
      if (plant.spacing > 0)
        _InfoItem(l10n.planting_info_spacing, l10n.planting_info_cm(plant.spacing), Icons.straighten),
      if (plant.depth > 0)
        _InfoItem(
            l10n.planting_info_depth, l10n.planting_info_cm(plant.depth), Icons.vertical_align_bottom),
      if (plant.sunExposure.isNotEmpty)
        _InfoItem(l10n.planting_info_exposure, plant.sunExposure, Icons.wb_sunny),
      if (plant.waterNeeds.isNotEmpty)
        _InfoItem(l10n.planting_info_water, plant.waterNeeds, Icons.water_drop),
      if (plant.plantingSeason.isNotEmpty)
        _InfoItem(
            l10n.planting_info_season, plant.plantingSeason, Icons.calendar_today),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: items
          .map(
            (item) => SizedBox(
              width: (MediaQuery.of(context).size.width - 80) / 2,
              child: Row(
                children: [
                  Icon(item.icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          item.value,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  final IconData icon;
  const _InfoItem(this.label, this.value, this.icon);
}
