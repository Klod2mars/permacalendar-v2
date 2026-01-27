import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'package:permacalendar/features/plant_catalog/domain/entities/plant_entity.dart';
import 'package:permacalendar/features/plant_catalog/data/models/plant_hive.dart';
import 'package:permacalendar/features/plant_catalog/providers/plant_catalog_provider.dart';
import 'package:permacalendar/shared/widgets/month_picker.dart';
import 'package:permacalendar/features/plant_catalog/application/sowing_utils.dart'; // Added for derivation

class CustomPlantFormScreen extends ConsumerStatefulWidget {
  final PlantFreezed? plantToEdit;

  const CustomPlantFormScreen({Key? key, this.plantToEdit}) : super(key: key);

  @override
  ConsumerState<CustomPlantFormScreen> createState() => _CustomPlantFormScreenState();
}

class _CustomPlantFormScreenState extends ConsumerState<CustomPlantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _commonNameController;
  late TextEditingController _scientificNameController;
  late TextEditingController _familyController;
  late TextEditingController _descriptionController;
  
  // New Fields (Phase C)
  late TextEditingController _marketPriceController;
  late TextEditingController _notesController; // For associations/tips
  
  // Nutrition Controllers
  late TextEditingController _calController;
  late TextEditingController _protController;
  late TextEditingController _carbController;
  late TextEditingController _fatController;
  
  // Champs techniques
  String? _imagePath;
  bool _isLoading = false;

  // Selection de mois
  List<String> _sowingMonths = [];
  List<String> _harvestMonths = [];

  @override
  void initState() {
    super.initState();
    final p = widget.plantToEdit;
    
    _commonNameController = TextEditingController(text: p?.commonName ?? '');
    _scientificNameController = TextEditingController(text: p?.scientificName ?? '');
    _familyController = TextEditingController(text: p?.family ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    
    // Init Phase C fields
    _marketPriceController = TextEditingController(text: p?.marketPricePerKg?.toString() ?? '');
    _notesController = TextEditingController(text: p?.notes ?? '');
    
    // Init Nutrition
    final nut = p?.nutritionPer100g ?? {};
    _calController = TextEditingController(text: nut['calories']?.toString() ?? '');
    _protController = TextEditingController(text: nut['protein_g']?.toString() ?? '');
    _carbController = TextEditingController(text: nut['carbs_g']?.toString() ?? '');
    _fatController = TextEditingController(text: nut['fat_g']?.toString() ?? '');
    
    // Récupérer l'image existante
    if (p != null && p.metadata != null) {
      final img = p.metadata!['image'] ?? p.metadata!['imagePath'];
      if (img != null && img is String && img.isNotEmpty) {
        _imagePath = img;
      }
    }

    _sowingMonths = p?.sowingMonths ?? [];
    _harvestMonths = p?.harvestMonths ?? [];
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _scientificNameController.dispose();
    _familyController.dispose();
    _descriptionController.dispose();
    // Phase C dispose
    _marketPriceController.dispose();
    _notesController.dispose();
    _calController.dispose();
    _protController.dispose();
    _carbController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path; // Temporaire, sera copié au save
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
        );
      }
    }
  }

  Future<String?> _saveImagePermanent(String tempPath) async {
    try {
      // Si c'est déjà dans l'app storage, on retourne tel quel (cas édition sans modif)
      final appDir = await getApplicationDocumentsDirectory();
      if (tempPath.startsWith(appDir.path)) {
        return tempPath;
      }
      
      // Sinon on copie
      final imagesDir = Directory('${appDir.path}/plant_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      final fileName = '${const Uuid().v4()}${p.extension(tempPath)}';
      final savedImage = await File(tempPath).copy('${imagesDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Sauvegarder l'image si nécessaire
      String? finalImagePath = _imagePath;
      if (_imagePath != null && File(_imagePath!).existsSync()) {
        final saved = await _saveImagePermanent(_imagePath!);
        if (saved != null) finalImagePath = saved;
      }

      // 2. Derive Seasons
      // Import sowning_utils not needed explicitly if we put the helper here or in utils
      // We assume deriveSeasonLabelFromMonths is available (we just added it to sowing_utils.dart)
      // Wait we need to import sowing_utils.dart in this file?
      // Yes, check imports. It wasn't imported. I need to make sure I add the import or duplicate the helper.
      // Better to import. I will assume I can fix imports in a second pass or now. 
      // Actually I am replacing a big block, I can add the import at the top if I replace the whole file or I can just use the tool to add import. 
      // This replace block is for the class body. I cannot add import here easily.
      // I will rely on the helper being available if I can calling it `SowingUtils.derive...` or just the global function.
      // I will implement a quick local helper or assume I'll add the import later.
      // Let's implement the logic using the SowingUtils global function I just created.
      // But I need to import `package:permacalendar/features/plant_catalog/application/sowing_utils.dart`.
      
      // I will use a local trick to resolve the import issue:
      // I'll assume the function is `deriveSeasonLabelFromMonths`. The code will fail to compile if I don't add the import.
      // I will add the import in a separate tool call to be safe because I am only replacing the class body here.
      
      final derivedPlanting = deriveSeasonLabelFromMonths(_sowingMonths);
      final derivedHarvest = deriveSeasonLabelFromMonths(_harvestMonths);

      // 3. Créer l'objet PlantHive
      final isEdit = widget.plantToEdit != null;
      final plantId = isEdit ? widget.plantToEdit!.id : 'custom-${const Uuid().v4().substring(0, 8)}';
      
      final meta = isEdit ? Map<String, dynamic>.from(widget.plantToEdit!.metadata ?? {}) : <String, dynamic>{};
      
      meta['isCustom'] = true;
      meta['origin'] = 'user';
      if (finalImagePath != null) {
        meta['image'] = finalImagePath;
      }

      final plant = PlantHive(
        id: plantId,
        commonName: _commonNameController.text.trim(),
        scientificName: _scientificNameController.text.trim(),
        family: _familyController.text.trim(),
        description: _descriptionController.text.trim(),
        plantingSeason: derivedPlanting, // Automagically derived
        harvestSeason: derivedHarvest,   // Automagically derived
        
        // Phase C: New fields
        marketPricePerKg: double.tryParse(_marketPriceController.text.replaceAll(',', '.')),
        defaultUnit: 'kg', // Forced as per user request
        notes: _notesController.text.trim(),
        nutritionPer100g: {
          'calories': double.tryParse(_calController.text) ?? 0,
          'protein_g': double.tryParse(_protController.text.replaceAll(',', '.')) ?? 0,
          'carbs_g': double.tryParse(_carbController.text.replaceAll(',', '.')) ?? 0,
          'fat_g': double.tryParse(_fatController.text.replaceAll(',', '.')) ?? 0,
        },

        // Valeurs par défaut pour le reste pour éviter null check errors
        daysToMaturity: isEdit ? widget.plantToEdit!.daysToMaturity : 90,
        spacing: isEdit ? widget.plantToEdit!.spacing : 30,
        depth: isEdit ? widget.plantToEdit!.depth : 1.0,
        sunExposure: isEdit ? widget.plantToEdit!.sunExposure : 'Plein soleil',
        waterNeeds: isEdit ? widget.plantToEdit!.waterNeeds : 'Moyen',
        sowingMonths: _sowingMonths,
        harvestMonths: _harvestMonths,
        
        metadata: meta,
        createdAt: isEdit ? widget.plantToEdit!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      // 3. Sauvegarder via le provider
      final notifier = ref.read(plantCatalogProvider.notifier);
      
      if (isEdit) {
        await notifier.updateCustomPlant(plant);
      } else {
        await notifier.addCustomPlant(plant);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plante enregistrée avec succès')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  Future<void> _deletePlant() async {
    if (widget.plantToEdit == null) return;
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la plante ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true), 
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
       setState(() => _isLoading = true);
       try {
         await ref.read(plantCatalogProvider.notifier).deleteCustomPlant(widget.plantToEdit!.id);
         
         // Optionnel: supprimer l'image locale si elle existe
         if (_imagePath != null && File(_imagePath!).existsSync()) {
            // Best effort delete
            try { await File(_imagePath!).delete(); } catch (_) {}
         }
         
         if (mounted) {
           Navigator.pop(context);
         }
       } catch (e) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
           setState(() => _isLoading = false);
         }
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.plantToEdit != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier la plante' : 'Nouvelle plante'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _deletePlant,
            ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker Section
                    _buildImagePicker(),
                    const SizedBox(height: 24),
                    
                    // Fields
                    TextFormField(
                      controller: _commonNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom commun *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.grass),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _scientificNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom scientifique',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.science),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _familyController,
                      decoration: const InputDecoration(
                        labelText: 'Famille',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    
                    
                    // --- SEASONS SECTION (Refactored) ---
                    const Divider(height: 32),
                    
                    // --- PRICE SECTION ---
                    Text('Prix', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _marketPriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Prix moyen par Kg (€)',
                        hintText: 'ex: 4.50',
                        border: OutlineInputBorder(),
                        suffixText: '€/kg',
                        prefixIcon: Icon(Icons.euro),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- NUTRITION SECTION ---
                    Text('Nutrition (pour 100g)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _calController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Calories',
                              suffixText: 'kcal',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _protController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Protéines',
                              suffixText: 'g',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _carbController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Glucides',
                              suffixText: 'g',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _fatController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              labelText: 'Lipides',
                              suffixText: 'g',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- NOTES / ASSOCIATIONS SECTION ---
                    Text('Notes & Associations', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Notes personnelles',
                        hintText: 'Plantes compagnes, astuces de culture...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.note_alt_outlined),
                      ),
                    ),

                    const Divider(height: 48),
                    Text('Cycle de culture', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    
                    // Sowing
                    _buildSeasonSection(
                      context,
                      label: 'Période de semis',
                      months: _sowingMonths,
                      onMonthsChanged: (m) => setState(() => _sowingMonths = m),
                      icon: Icons.calendar_month,
                    ),
                    const SizedBox(height: 24),
                    
                    // Harvest
                    _buildSeasonSection(
                      context,
                      label: 'Période de récolte',
                      months: _harvestMonths,
                      onMonthsChanged: (m) => setState(() => _harvestMonths = m),
                      icon: Icons.shopping_basket,
                    ),
                    const Divider(height: 32),

                    
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 48.0), // Add safe padding for scroll
                        child: ElevatedButton(
                          onPressed: _savePlant,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(isEdit ? 'Enregistrer les modifications' : 'Créer la plante'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showImageSourceSheet(),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImageWidget(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'Ajouter une photo',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
          ),
        ),
        if (_imagePath != null)
          TextButton.icon(
            onPressed: () => setState(() => _imagePath = null),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Supprimer la photo', style: TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
  
  Widget _buildImageWidget() {
    if (_imagePath!.startsWith('http')) {
      return Image.network(_imagePath!, fit: BoxFit.cover);
    } else if (File(_imagePath!).existsSync()) {
      return Image.file(File(_imagePath!), fit: BoxFit.cover);
    } else {
      // Fallback assets logic if editing existing asset plant (rare but possible)
      if (_imagePath!.startsWith('assets/')) {
        return Image.asset(_imagePath!, fit: BoxFit.cover);
      }
      return const Center(child: Icon(Icons.broken_image));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonSection(
    BuildContext context, {
    required String label,
    required List<String> months,
    required ValueChanged<List<String>> onMonthsChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final derivedLabel = deriveSeasonLabelFromMonths(months);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            if (months.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  derivedLabel.isEmpty ? '...' : derivedLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
        if (months.isEmpty)
          Padding(
             padding: const EdgeInsets.only(top: 4, left: 28),
             child: Text(
               'Sélectionnez les mois ci-dessous',
               style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey),
             ),
          ),
        const SizedBox(height: 8),
        MonthPicker(
          label: '', // Hidden internal label as we use custom header
          initialSelected: months,
          onChanged: onMonthsChanged,
        ),
      ],
    );
  }
}
