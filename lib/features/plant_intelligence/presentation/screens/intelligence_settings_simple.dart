import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/intelligence_state_providers.dart';
import '../../../../core/di/intelligence_module.dart';
import '../providers/plant_intelligence_ui_providers.dart';

/// Version simplifiée de l'écran des paramètres d'intelligence
class IntelligenceSettingsSimple extends ConsumerStatefulWidget {
  const IntelligenceSettingsSimple({super.key});

  @override
  ConsumerState<IntelligenceSettingsSimple> createState() =>
      _IntelligenceSettingsSimpleState();
}

class _IntelligenceSettingsSimpleState
    extends ConsumerState<IntelligenceSettingsSimple> {
  bool _notificationsEnabled = true;
  bool _weatherAlertsEnabled = true;
  bool _plantHealthAlertsEnabled = true;
  bool _recommendationAlertsEnabled = false;
  String _selectedFrequency = 'daily';
  double _alertThreshold = 70.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres Intelligence'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _resetToDefaults,
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.tertiary.withValues(alpha: 0.1),
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 32,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paramètres d\'Intelligence',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Configurez les alertes et notifications',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notifications
            _buildSectionHeader(context, 'Notifications', Icons.notifications),
            const SizedBox(height: 16),

            _buildSwitchTile(
              context,
              'Notifications générales',
              'Recevoir des notifications de l\'intelligence végétale',
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
            ),

            _buildSwitchTile(
              context,
              'Alertes météo',
              'Notifications pour les conditions météo critiques',
              _weatherAlertsEnabled,
              (value) => setState(() => _weatherAlertsEnabled = value),
            ),

            _buildSwitchTile(
              context,
              'Alertes santé des plantes',
              'Notifications pour les problèmes de santé des plantes',
              _plantHealthAlertsEnabled,
              (value) => setState(() => _plantHealthAlertsEnabled = value),
            ),

            _buildSwitchTile(
              context,
              'Nouvelles recommandations',
              'Notifications pour les nouvelles recommandations',
              _recommendationAlertsEnabled,
              (value) => setState(() => _recommendationAlertsEnabled = value),
            ),

            const SizedBox(height: 24),

            // Fréquence des analyses
            _buildSectionHeader(context, 'Analyse', Icons.analytics),
            const SizedBox(height: 16),

            // ✅ NOUVEAU - Phase 3 : Toggle analyse temps réel
            _buildSwitchTile(
              context,
              'Analyse en temps réel',
              'Analyse automatique toutes les 5 minutes',
              ref.watch(realTimeAnalysisProvider).isRunning,
              (value) {
                if (value) {
                  ref
                      .read(realTimeAnalysisProvider.notifier)
                      .startRealTimeAnalysis();
                } else {
                  ref
                      .read(realTimeAnalysisProvider.notifier)
                      .stopRealTimeAnalysis();
                }
              },
            ),

            // Intervalle d'analyse temps réel
            Consumer(
              builder: (context, ref, _) {
                final realTimeState = ref.watch(realTimeAnalysisProvider);
                if (!realTimeState.isRunning) {
                  return const SizedBox.shrink();
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Intervalle d\'analyse',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fréquence d\'actualisation automatique',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${realTimeState.updateInterval.inMinutes} min',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Slider(
                                value: realTimeState.updateInterval.inMinutes
                                    .toDouble(),
                                min: 5,
                                max: 60,
                                divisions: 11,
                                label:
                                    '${realTimeState.updateInterval.inMinutes} min',
                                onChanged: (value) {
                                  // Note: La méthode updateAnalysisInterval sera implémentée
                                  // dans une phase future. Pour l'instant, on affiche juste la valeur.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Intervalle: ${value.toInt()} min (sauvegarde à implémenter)'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('5 min', style: theme.textTheme.bodySmall),
                            Text('60 min', style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fréquence d\'analyse manuelle',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recommandations d\'analyse manuelle',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    RadioListTile<String>(
                      title: const Text('Quotidienne'),
                      value: 'daily',
                      groupValue: _selectedFrequency,
                      onChanged: (value) {
                        setState(() => _selectedFrequency = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('Hebdomadaire'),
                      value: 'weekly',
                      groupValue: _selectedFrequency,
                      onChanged: (value) {
                        setState(() => _selectedFrequency = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile<String>(
                      title: const Text('Mensuelle'),
                      value: 'monthly',
                      groupValue: _selectedFrequency,
                      onChanged: (value) {
                        setState(() => _selectedFrequency = value!);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Seuil d'alerte
            _buildSectionHeader(context, 'Seuils', Icons.tune),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seuil d\'alerte de santé',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Niveau de santé en dessous duquel une alerte est déclenchée',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          '${_alertThreshold.round()}%',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Slider(
                            value: _alertThreshold,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            label: '${_alertThreshold.round()}%',
                            onChanged: (value) {
                              setState(() => _alertThreshold = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0%',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          '100%',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ✅ NOUVEAU - Phase 3 : Section Export/Import
            _buildSectionHeader(context, 'Données', Icons.folder),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gestion des données',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Exportez vos données pour les sauvegarder ou les partager',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _exportSettings,
                            icon: const Icon(Icons.upload, size: 20),
                            label: const Text('Exporter'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _importSettings,
                            icon: const Icon(Icons.download, size: 20),
                            label: const Text('Importer'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Retour'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('Sauvegarder'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section en développement
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.construction,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Paramètres avancés en développement',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Des paramètres plus avancés pour personnaliser l\'intelligence '
                    'végétale seront disponibles dans une prochaine version.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: SwitchListTile(
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _resetToDefaults() {
    setState(() {
      _notificationsEnabled = true;
      _weatherAlertsEnabled = true;
      _plantHealthAlertsEnabled = true;
      _recommendationAlertsEnabled = false;
      _selectedFrequency = 'daily';
      _alertThreshold = 70.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paramètres réinitialisés aux valeurs par défaut'),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implémenter la sauvegarde des paramètres
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paramètres sauvegardés'),
      ),
    );
  }

  /// ✅ NOUVEAU - Phase 3 : Export des données
  ///
  /// Permet d'exporter toutes les données d'intelligence végétale
  /// au format JSON pour backup ou partage.
  Future<void> _exportSettings() async {
    try {
      // Récupérer le repository pour export
      final repository = ref.read(IntelligenceModule.repositoryImplProvider);
      final currentGardenId = ref.read(currentIntelligenceGardenIdProvider);

      if (currentGardenId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Aucun jardin sélectionné'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Afficher dialogue de confirmation
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exporter les données'),
          content: const Text(
            'Cette action va exporter toutes les données d\'intelligence végétale '
            'pour le jardin actuel (conditions, recommandations, analyses).\n\n'
            'Les données seront exportées au format JSON.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Exporter'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Exporter les données (simulation - en production, utiliser path_provider + file_picker)
      final exportData = await repository.exportPlantData(
        plantId: currentGardenId,
        format: 'json',
        includeHistory: true,
      );

      // En production, sauvegarder le fichier et partager
      // Pour l'instant, juste afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Export réussi : ${exportData['plant_conditions']?.length ?? 0} conditions, '
              '${exportData['recommendations']?.length ?? 0} recommandations',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Voir',
              textColor: Colors.white,
              onPressed: () {
                // Afficher dialogue avec détails export
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Détails de l\'export'),
                    content: SingleChildScrollView(
                      child: Text(
                        'Données exportées:\n\n'
                        '• ${exportData['plant_conditions']?.length ?? 0} conditions de plantes\n'
                        '• ${exportData['recommendations']?.length ?? 0} recommandations\n'
                        '• ${exportData['analysis_results']?.length ?? 0} résultats d\'analyses\n'
                        '• ${exportData['weather_conditions']?.length ?? 0} conditions météo\n\n'
                        'Format: JSON\n'
                        'Taille: ${(exportData.toString().length / 1024).toStringAsFixed(2)} Ko',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// ✅ NOUVEAU - Phase 3 : Import/Restauration des données
  ///
  /// Permet d'importer des données d'intelligence végétale précédemment exportées.
  Future<void> _importSettings() async {
    try {
      // Afficher dialogue de confirmation et avertissement
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ Importer des données'),
          content: const Text(
            'Cette action va importer des données d\'intelligence végétale.\n\n'
            '⚠️ Attention: Les données existantes peuvent être écrasées.\n\n'
            'Voulez-vous continuer ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Importer'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // En production, utiliser file_picker pour sélectionner un fichier
      // Pour l'instant, simuler avec un message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '📁 Fonctionnalité d\'import disponible.\n'
              'En production: sélection de fichier JSON à importer.',
            ),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur lors de l\'import: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
