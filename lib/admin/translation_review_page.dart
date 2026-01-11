import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/plants_repository.dart';
import '../../models/plant_localized.dart';
import '../../providers/locale_provider.dart';

class TranslationReviewPage extends ConsumerStatefulWidget {
  const TranslationReviewPage({super.key});

  @override
  ConsumerState<TranslationReviewPage> createState() => _TranslationReviewPageState();
}

class _TranslationReviewPageState extends ConsumerState<TranslationReviewPage> {
  // Mock data loader for now, in real app this would query the repo
  // but repo needs a query method for 'needsReview'.
  // I'll just load all for search "a" for demo or add a getAll method.
  // Using search('') to get all.
  
  List<PlantLocalized> _plants = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final locale = ref.read(localeProvider);
    final repo = ref.read(plantsRepositoryProvider);
    final results = await repo.search('', locale.languageCode);
    
    if (mounted) {
      setState(() {
        _plants = results; // Filter by needsReview in UI for now
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    // Filter on client side for MVP
    final reviewList = _plants.where((p) {
       final local = p.localized[locale.languageCode];
       return local?.needsReview == true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Translation Review (${locale.languageCode})')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : reviewList.isEmpty
              ? const Center(child: Text('No translations need review!'))
              : ListView.builder(
                  itemCount: reviewList.length,
                  itemBuilder: (context, index) {
                    final plant = reviewList[index];
                    final local = plant.localized[locale.languageCode]!;
                    
                    return Card(
                      child: ListTile(
                        title: Text(plant.scientificName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current: ${local.commonName}'),
                            const SizedBox(height: 4),
                            Text('Source: ${local.source} (${local.confidence})'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editPlant(plant, locale.languageCode),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _editPlant(PlantLocalized plant, String localeCode) {
    // Show edit dialog
    showDialog(
      context: context,
      builder: (ctx) => _EditTranslationDialog(
        plant: plant,
        locale: localeCode,
        onSave: (p) async {
             final repo = ref.read(plantsRepositoryProvider);
             await repo.importData([p], localeCode);
             _loadData(); // Reload
        },
      ),
    );
  }
}

class _EditTranslationDialog extends StatefulWidget {
  final PlantLocalized plant;
  final String locale;
  final Function(PlantLocalized) onSave;

  const _EditTranslationDialog({required this.plant, required this.locale, required this.onSave});

  @override
  State<_EditTranslationDialog> createState() => _EditTranslationDialogState();
}

class _EditTranslationDialogState extends State<_EditTranslationDialog> {
  late TextEditingController _commonNameCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    final local = widget.plant.localized[widget.locale];
    _commonNameCtrl = TextEditingController(text: local?.commonName ?? '');
    _descCtrl = TextEditingController(text: local?.shortDescription ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.plant.scientificName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _commonNameCtrl, decoration: const InputDecoration(labelText: 'Common Name')),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Short Description')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            // Update object
            final oldLocal = widget.plant.localized[widget.locale]!;
             
            final newLocal = LocalizedPlantFields(
                commonName: _commonNameCtrl.text,
                shortDescription: _descCtrl.text,
                symptoms: oldLocal.symptoms,
                quickAdvice: oldLocal.quickAdvice,
                source: 'human',
                confidence: 1.0,
                needsReview: false,
                lastReviewedBy: 'admin',
                lastReviewedAt: DateTime.now(),
            );
            
            final newMap = Map<String, LocalizedPlantFields>.from(widget.plant.localized);
            newMap[widget.locale] = newLocal;
            
            final newPlant = PlantLocalized(
                id: widget.plant.id,
                scientificName: widget.plant.scientificName,
                localized: newMap,
                lastUpdated: DateTime.now(),
                taxonomy: widget.plant.taxonomy,
                attributes: widget.plant.attributes,
                schemaVersion: widget.plant.schemaVersion
            );
            
            widget.onSave(newPlant);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
