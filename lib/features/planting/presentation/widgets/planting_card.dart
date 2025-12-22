// lib/features/planting/presentation/widgets/planting_card.dart
import 'package:flutter/material.dart';

import '../../../../core/models/planting.dart';
import '../../../../core/utils/planting_utils.dart'; // Ensure this exists or use local helpers
import '../../../../shared/widgets/custom_card.dart';
import 'planting_image.dart';

class PlantingCard extends StatelessWidget {
  final Planting planting;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String)? onStatusChange;
  final VoidCallback? onHarvest;
  final Function(String)? onAddCareAction;

  const PlantingCard({
    super.key,
    required this.planting,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChange,
    this.onHarvest,
    this.onAddCareAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(planting.status, theme);
    final statusTextColor = _getStatusTextColor(planting.status, theme);

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero, // Full bleed for image
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HERO IMAGE HEADER (Stack)
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                PlantingImage(
                  planting: planting,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  borderRadius: 0, // Top corners handled by Card
                ),
                
                // Gradient Overlay (Bottom) for text readability? Not needed if using badges.
                
                // TOP RIGHT: Status Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      planting.status,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // TOP LEFT: Quantity Badge (Pill)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.grid_view, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${planting.quantity}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BOTTOM LEFT: Menu (Moved here? No, menu usually top right. Let's put Menu as an overlay button if possible, but PopupMenu is easier in normal flow. Stack overlay menu is fine)
                // Actually, let's put the Menu button Top Right, and push Status to Top Left?
                // User liked "Old Version". Screenshot shows Status Top Right on white.
                // Let's keep Status Top Right.
                // Where to put Menu? Maybe Overlay Icon Button Top Left?
                // Or Overlay Icon Button Top Right (next to status)?
                // Let's put Menu in the Content Body below to avoid gesture conflicts on image tap?
                // Or Top Right Overlay white circle.
                
                Positioned(
                  top: 8,
                  left: 8,
                  // Using a Material generic widget to avoid ripple issues on image?
                  child: Material(
                    color: Colors.transparent,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                      ),
                      onSelected: (value) => _handleAction(value, context),
                      itemBuilder: (context) => _buildMenuItems(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. CONTENT BODY
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE & HARVEST ACTION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planting.plantName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Subtitle: Variety or Latin name if available? Or just empty.
                          // Let's show "Semé le..." here nicely.
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.outline),
                              const SizedBox(width: 4),
                              Text(
                                '${planting.status == 'Semé' ? 'Semé' : 'Planté'} le ${_formatDate(planting.plantedDate)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Harvest Button (Basket)
                    // Visible if ready or growing (Quick Harvest)
                    if (planting.status != 'Récolté' && planting.status != 'Échoué')
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FloatingActionButton.small(
                          heroTag: 'harvest_${planting.id}', // unique tag
                          onPressed: onHarvest,
                          elevation: 0,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          child: const Icon(Icons.shopping_basket_outlined),
                          tooltip: 'Récolter',
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // HARVEST ESTIMATE & STAGES
                Row(
                  children: [
                   if (planting.expectedHarvestStartDate != null)
                      _buildMiniInfo(
                        theme,
                        Icons.timer_outlined,
                        'Récolte: ${_formatDate(planting.expectedHarvestStartDate!)}',
                      ),
                    
                   // Spacer
                   if (planting.expectedHarvestStartDate != null)
                     const SizedBox(width: 16),

                   // Stage count or Next Stage?
                   if (planting.careActions.isNotEmpty)
                      _buildMiniInfo(
                        theme,
                        Icons.flag_outlined,
                        '${planting.careActions.length} étapes',
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // No Footer. Clean.
        ],
      ),
    );
  }

  Widget _buildMiniInfo(ThemeData theme, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.secondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context) {
     return [
      const PopupMenuItem(
        value: 'edit',
        child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Modifier')]),
      ),
      if (planting.status != 'Récolté' && planting.status != 'Échoué') ...[
        const PopupMenuItem(
          value: 'status',
          child: Row(children: [Icon(Icons.update), SizedBox(width: 8), Text('Changer statut')]),
        ),
        const PopupMenuItem(
          value: 'steps',
          child: Row(children: [Icon(Icons.flag), SizedBox(width: 8), Text('Ajouter étape')]),
        ),
      ],
      const PopupMenuItem(
        value: 'delete',
        child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Supprimer', style: TextStyle(color: Colors.red))]),
      ),
    ];
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté': return Colors.blue.withOpacity(0.1);
      case 'En croissance': return Colors.green.withOpacity(0.1);
      case 'Prêt à récolter': return Colors.orange.withOpacity(0.1);
      case 'Récolté': return Colors.grey.withOpacity(0.1);
      case 'Échoué': return Colors.red.withOpacity(0.1);
      default: return theme.colorScheme.surfaceContainerHighest;
    }
  }

  Color _getStatusTextColor(String status, ThemeData theme) {
    switch (status) {
      case 'Planté': return Colors.blue.shade700;
      case 'En croissance': return Colors.green.shade700;
      case 'Prêt à récolter': return Colors.orange.shade800; // Stronger for visibility
      case 'Récolté': return Colors.grey.shade700;
      case 'Échoué': return Colors.red.shade700;
      default: return theme.colorScheme.onSurface;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handleAction(String action, BuildContext context) {
    switch (action) {
      case 'edit': onEdit?.call(); break;
      case 'delete': onDelete?.call(); break;
      case 'status': _showStatusChangeDialog(context); break;
      case 'harvest': onHarvest?.call(); break;
      case 'steps': _showStepActionDialog(context); break;
    }
  }
  
  // Dialog helpers (kept identical to previous version, just moved inside class)
  void _showStatusChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Planting.statusOptions.map((statusOption) {
            if (statusOption == planting.status) return const SizedBox.shrink();
            return ListTile(
              title: Text(statusOption),
              onTap: () {
                Navigator.of(context).pop();
                onStatusChange?.call(statusOption);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStepActionDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter étape'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: Planting.commonCareActions.map((a) {
                    return ListTile(
                      title: Text(a),
                      onTap: () {
                        Navigator.of(context).pop();
                        onAddCareAction?.call(a);
                      },
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Autre étape',
                  hintText: 'Ex: Paillage léger',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.of(context).pop();
                onAddCareAction?.call(text);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
