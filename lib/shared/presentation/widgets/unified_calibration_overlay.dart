import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/home/presentation/providers/unified_calibration_provider.dart';
import '../../../../core/models/calibration_state.dart';
import '../../../../core/providers/organic_zones_provider.dart';

class UnifiedCalibrationOverlay extends ConsumerStatefulWidget {
  const UnifiedCalibrationOverlay({super.key});

  @override
  ConsumerState<UnifiedCalibrationOverlay> createState() => _UnifiedCalibrationOverlayState();
}

class _UnifiedCalibrationOverlayState extends ConsumerState<UnifiedCalibrationOverlay> {
  bool _isCollapsed = false;

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }





  Future<void> _saveAndExit() async {
    try {
      // 1. Sauvegarder
      await ref.read(organicZonesProvider.notifier).saveAll();
      
      // 2. Désactiver le mode calibration
      ref.read(calibrationStateProvider.notifier).disableCalibration();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Calibration sauvegardée'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur sauvegarde calibration: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unifiedState = ref.watch(unifiedCalibrationProvider);
    final activeTool = unifiedState.activeTool;

    return Stack(
      children: [
        // Zone supérieure transparente
        
        // Barre de contrôle en bas
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.85),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- HEADER / HANDLE (Toujours visible) ---
                GestureDetector(
                  onTap: _toggleCollapse,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(
                      _isCollapsed ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white70,
                      size: 28,
                    ),
                  ),
                ),

                // --- CONTENU REPLIABLE ---
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height: _isCollapsed ? 0 : null,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Titre / Instructions contextuelles
                          Text(
                            _getInstructionText(activeTool),
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          
                          // Tabs de sélection d'outil
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildToolButton(
                                context, 
                                ref, 
                                CalibrationTool.image, 
                                Icons.image, 
                                'Image',
                                activeTool == CalibrationTool.image,
                              ),
                              _buildToolButton(
                                context,
                                ref,
                                CalibrationTool.sky,
                                Icons.cloud,
                                'Ciel',
                                activeTool == CalibrationTool.sky,
                              ),
                              _buildToolButton(
                                context,
                                ref,
                                CalibrationTool.modules,
                                Icons.widgets,
                                'Modules',
                                activeTool == CalibrationTool.modules,
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Actions Globales (Valider / Annuler)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _saveAndExit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Valider & Quitter'),
                            ),
                          ),
                          

                          

                          
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }





  String _getInstructionText(CalibrationTool tool) {
    switch (tool) {
      case CalibrationTool.image:
        return 'Glissez pour déplacer, pincez pour zoomer l\'image de fond.';
      case CalibrationTool.sky:
        return 'Ajustez l\'ovoïde jour/nuit (centre, taille, rotation).';
      case CalibrationTool.modules:
        return 'Déplacez les modules (bulles) à l\'emplacement souhaité.';
      case CalibrationTool.none:
        return 'Sélectionnez un outil pour commencer.';
    }
  }

  Widget _buildToolButton(
    BuildContext context, 
    WidgetRef ref, 
    CalibrationTool tool, 
    IconData icon, 
    String label, 
    bool isActive
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(unifiedCalibrationProvider.notifier).setTool(tool);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? Colors.green : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon, 
              color: isActive ? Colors.greenAccent : Colors.white54,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.greenAccent : Colors.white54,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
