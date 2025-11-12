import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/constants.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_card.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportPeriod _selectedPeriod = ExportPeriod.month;
  ExportFormat _selectedFormat = ExportFormat.csv;
  final Set<String> _selectedDataTypes = {'gardens', 'plantings'};
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Exporter les donnÃ©es',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Export Period Selection
            _buildPeriodSelection(theme),
            const SizedBox(height: 24),

            // Data Types Selection
            _buildDataTypesSelection(theme),
            const SizedBox(height: 24),

            // Format Selection
            _buildFormatSelection(theme),
            const SizedBox(height: 24),

            // Export Options
            _buildExportOptions(theme),
            const SizedBox(height: 24),

            // Preview Section
            _buildPreviewSection(theme),
            const SizedBox(height: 32),

            // Export Button
            _buildExportButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelection(ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PÃ©riode d\'export',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...ExportPeriod.values.map((period) => RadioListTile<ExportPeriod>(
                  title: Text(period.displayName),
                  subtitle: Text(_getPeriodDescription(period)),
                  value: period,
                  groupValue: _selectedPeriod,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTypesSelection(ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Types de donnÃ©es',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'SÃ©lectionnez les donnÃ©es Ã  inclure dans l\'export',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 16),
            _buildDataTypeCheckbox(
              'gardens',
              'Jardins',
              'Informations sur vos jardins (nom, description, localisation)',
              Icons.eco,
              theme,
            ),
            _buildDataTypeCheckbox(
              'plantings',
              'Plantations',
              'Historique des plantations et rÃ©coltes',
              Icons.eco,
              theme,
            ),
            _buildDataTypeCheckbox(
              'activities',
              'ActivitÃ©s',
              'Journal des activitÃ©s de jardinage',
              Icons.assignment,
              theme,
            ),
            _buildDataTypeCheckbox(
              'weather',
              'DonnÃ©es mÃ©tÃ©o',
              'Historique des conditions mÃ©tÃ©orologiques',
              Icons.wb_sunny,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelection(ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Format d\'export',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...ExportFormat.values.map((format) => RadioListTile<ExportFormat>(
                  title: Text(format.displayName),
                  subtitle: Text(_getFormatDescription(format)),
                  value: format,
                  groupValue: _selectedFormat,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFormat = value;
                      });
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOptions(ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Options d\'export',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Inclure les images'),
              subtitle:
                  const Text('Exporter les photos des jardins et plantations'),
              value: true,
              onChanged: (value) {
                // TODO: Implement image export option
              },
            ),
            CheckboxListTile(
              title: const Text('DonnÃ©es anonymisÃ©es'),
              subtitle: const Text('Supprimer les informations personnelles'),
              value: false,
              onChanged: (value) {
                // TODO: Implement anonymization option
              },
            ),
            CheckboxListTile(
              title: const Text('Compression'),
              subtitle: const Text('Compresser le fichier d\'export (ZIP)'),
              value: _selectedFormat == ExportFormat.json,
              onChanged: _selectedFormat == ExportFormat.json
                  ? (value) {
                      // TODO: Implement compression option
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection(ThemeData theme) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AperÃ§u de l\'export',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _generatePreview(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Actualiser'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPreviewItem('PÃ©riode', _selectedPeriod.displayName, theme),
            _buildPreviewItem('Format', _selectedFormat.displayName, theme),
            _buildPreviewItem(
                'Types de donnÃ©es', _selectedDataTypes.join(', '), theme),
            _buildPreviewItem('Taille estimÃ©e', '~2.5 MB', theme),
            _buildPreviewItem('Nombre d\'enregistrements', '~150', theme),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'L\'export sera sauvegardÃ© dans le dossier TÃ©lÃ©chargements',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
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

  Widget _buildExportButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Exporter les donnÃ©es',
        icon: const Icon(Icons.download),
        isLoading: _isExporting,
        onPressed:
            _selectedDataTypes.isEmpty ? null : () => _startExport(context),
      ),
    );
  }

  Widget _buildDataTypeCheckbox(
    String key,
    String title,
    String description,
    IconData icon,
    ThemeData theme,
  ) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      subtitle: Text(description),
      value: _selectedDataTypes.contains(key),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedDataTypes.add(key);
          } else {
            _selectedDataTypes.remove(key);
          }
        });
      },
    );
  }

  Widget _buildPreviewItem(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPeriodDescription(ExportPeriod period) {
    switch (period) {
      case ExportPeriod.week:
        return 'DonnÃ©es des 7 derniers jours';
      case ExportPeriod.month:
        return 'DonnÃ©es des 30 derniers jours';
      case ExportPeriod.quarter:
        return 'DonnÃ©es des 3 derniers mois';
      case ExportPeriod.year:
        return 'DonnÃ©es des 12 derniers mois';
      case ExportPeriod.all:
        return 'Toutes les donnÃ©es disponibles';
    }
  }

  String _getFormatDescription(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return 'Format tableur, compatible Excel';
      case ExportFormat.json:
        return 'Format structurÃ© pour dÃ©veloppeurs';
      case ExportFormat.pdf:
        return 'Rapport formatÃ© pour impression';
      case ExportFormat.excel:
        return 'Format Excel natif';
    }
  }

  void _generatePreview() {
    // TODO: Generate actual preview data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AperÃ§u actualisÃ©')),
    );
  }

  void _startExport(BuildContext context) async {
    setState(() {
      _isExporting = true;
    });

    try {
      // TODO: Implement actual export logic
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Export terminÃ© avec succÃ¨s!'),
            action: SnackBarAction(
              label: 'Ouvrir',
              onPressed: () {
                // TODO: Open exported file
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide - Export de donnÃ©es'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Formats disponibles:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('â€¢ CSV: IdÃ©al pour Excel et autres tableurs'),
              Text('â€¢ JSON: Format structurÃ© pour les dÃ©veloppeurs'),
              Text('â€¢ PDF: Rapport formatÃ© pour l\'impression'),
              SizedBox(height: 16),
              Text(
                'Types de donnÃ©es:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('â€¢ Jardins: Informations de base sur vos jardins'),
              Text('â€¢ Plantations: Historique des plantations et rÃ©coltes'),
              Text('â€¢ ActivitÃ©s: Journal de vos activitÃ©s de jardinage'),
              Text('â€¢ MÃ©tÃ©o: DonnÃ©es mÃ©tÃ©orologiques collectÃ©es'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}



