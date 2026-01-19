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
        _InfoItem(l10n.planting_info_exposure, _getLocalizedExposure(context, plant.sunExposure), Icons.wb_sunny),
      if (plant.waterNeeds.isNotEmpty)
        _InfoItem(l10n.planting_info_water, _getLocalizedWater(context, plant.waterNeeds), Icons.water_drop),
      if (plant.plantingSeason.isNotEmpty)
        _InfoItem(
            l10n.planting_info_season, _getLocalizedSeason(context, plant.plantingSeason), Icons.calendar_today),
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

  String _getLocalizedExposure(BuildContext context, String value) {
    if (value.isEmpty) return value;
    final l10n = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower.contains('plein')) return l10n.info_exposure_full_sun;
    if (lower.contains('mi-ombre') || lower.contains('partial')) return l10n.info_exposure_partial_sun;
    if (lower.contains('ombre') || lower.contains('shade')) return l10n.info_exposure_shade;
    return value;
  }

  String _getLocalizedWater(BuildContext context, String value) {
    if (value.isEmpty) return value;
    final l10n = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    if (lower.contains('faible') || lower.contains('low')) return l10n.info_water_low;
    if (lower.contains('élevé') || lower.contains('high')) return l10n.info_water_high;
    if (lower.contains('modéré') || lower.contains('moderate')) return l10n.info_water_moderate;
    if (lower.contains('moyen') || lower.contains('medium')) return l10n.info_water_medium;
    return value;
  }

  String _getLocalizedSeason(BuildContext context, String value) {
    if (value.isEmpty) return value;
    final l10n = AppLocalizations.of(context)!;
    final lower = value.toLowerCase();
    // Handle "Toute saison"
    if (lower.contains('toute') || lower.contains('all')) return l10n.info_season_all;
    
    // Handle multiple seasons (comma separated) or single
    // For simplicity, we check keywords. If multiple, we might want to return as is or try to replace each.
    // Given the UI displays them simply, let's try to map the most specific ones.
    
    List<String> parts = value.split(RegExp(r'[,/]\s*'));
    List<String> localizedParts = parts.map((part) {
      final p = part.toLowerCase().trim();
      if (p.contains('printemps') || p.contains('spring')) return l10n.info_season_spring;
      if (p.contains('été') || p.contains('summer')) return l10n.info_season_summer;
      if (p.contains('automne') || p.contains('autumn')) return l10n.info_season_autumn;
      if (p.contains('hiver') || p.contains('winter')) return l10n.info_season_winter;
      return part;
    }).toList();
    
    return localizedParts.join(', ');
  }
}

class _InfoItem {
  final String label;
  final String value;
  final IconData icon;
  const _InfoItem(this.label, this.value, this.icon);
}
