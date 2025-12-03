// lib/features/planting/presentation/widgets/planting_preview.dart
import 'package:flutter/material.dart';
import 'package:permacalendar/core/models/planting.dart';
import 'package:permacalendar/core/services/plant_catalog_service.dart';
import 'package:permacalendar/core/models/plant.dart';

class PlantingPreview extends StatelessWidget {
  final Planting planting;
  final VoidCallback? onTap;
  final double imageSize;

  const PlantingPreview({
    Key? key,
    required this.planting,
    this.onTap,
    this.imageSize = 110,
  }) : super(key: key);

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Color _statusBg(String status, ThemeData theme) {
    switch (status) {
      case 'Planté':
        return Colors.blue.withOpacity(0.18);
      case 'En croissance':
        return Colors.green.withOpacity(0.18);
      case 'Prêt à récolter':
        return Colors.orange.withOpacity(0.18);
      case 'Récolté':
        return Colors.green.withOpacity(0.26);
      case 'Échoué':
        return Colors.red.withOpacity(0.18);
      default:
        return theme.colorScheme.surfaceVariant;
    }
  }

  Color _statusText(String status) {
    switch (status) {
      case 'Planté':
        return Colors.blue.shade700;
      case 'En croissance':
        return Colors.green.shade700;
      case 'Prêt à récolter':
        return Colors.orange.shade700;
      case 'Récolté':
        return Colors.green.shade800;
      case 'Échoué':
        return Colors.red.shade700;
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Plant?>(
      future: PlantCatalogService.getPlantById(planting.plantId),
      builder: (ctx, snap) {
        final plant = snap.data;
        final img = plant?.imageUrl ??
            (plant?.metadata != null
                ? (plant!.metadata['image'] as String?)
                : null);
        final estimateDate = planting.expectedHarvestStartDate ??
            (plant != null
                ? planting.plantedDate.add(Duration(days: plant.daysToMaturity))
                : null);

        Widget imageWidget;
        if (img != null && img.isNotEmpty) {
          final isNetwork =
              RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(img);
          imageWidget = isNetwork
              ? Image.network(img,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(imageSize))
              : Image.asset(img,
                  height: imageSize,
                  width: imageSize,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallback(imageSize));
        } else {
          imageWidget = _fallback(imageSize);
        }

        return GestureDetector(
          onTap: onTap ??
              () =>
                  Navigator.of(context).pushNamed('/plantings/${planting.id}'),
          child: Container(
            width: imageSize,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    SizedBox(
                        height: imageSize,
                        width: imageSize,
                        child: imageWidget),
                    // status pill
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusBg(planting.status, theme),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          planting.status,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _statusText(planting.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // quantity badge
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${planting.quantity}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(planting.plantName,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(
                        planting.status == 'Semé'
                            ? 'Semé le ${_formatDate(planting.plantedDate)}'
                            : 'Planté le ${_formatDate(planting.plantedDate)}',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.outline),
                      ),
                      if (estimateDate != null)
                        Text(
                          'Récolte estimée: ${_formatDate(estimateDate)}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fallback(double size) {
    return Container(
      height: size,
      width: size,
      color: Colors.green.shade50,
      alignment: Alignment.center,
      child: Icon(Icons.eco_outlined,
          size: size * 0.36, color: Colors.green.shade700),
    );
  }
}
