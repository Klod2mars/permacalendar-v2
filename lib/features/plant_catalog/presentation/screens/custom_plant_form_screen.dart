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
  late TextEditingController _plantingSeasonController;
  late TextEditingController _harvestSeasonController;
  
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
    _plantingSeasonController = TextEditingController(text: p?.plantingSeason ?? '');
    _harvestSeasonController = TextEditingController(text: p?.harvestSeason ?? '');
    
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
    _plantingSeasonController.dispose();
    _harvestSeasonController.dispose();
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

      // 2. Créer l'objet PlantHive
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
        plantingSeason: _plantingSeasonController.text.trim(),
        harvestSeason: _harvestSeasonController.text.trim(),
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
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _plantingSeasonController,
                            decoration: const InputDecoration(
                              labelText: 'Saison semis',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_month),
                              hintText: 'ex: Printemps',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                             controller: _harvestSeasonController,
                             decoration: const InputDecoration(
                               labelText: 'Saison récolte',
                               border: OutlineInputBorder(),
                               prefixIcon: Icon(Icons.shopping_basket),
                               hintText: 'ex: Été',
                             ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MonthPicker(
                      label: 'Mois de semis',
                      initialSelected: isEdit ? (widget.plantToEdit?.sowingMonths ?? []) : [],
                      onChanged: (months) => setState(() => _sowingMonths = months),
                    ),
                    const SizedBox(height: 12),
                    MonthPicker(
                      label: 'Mois de récolte',
                      initialSelected: isEdit ? (widget.plantToEdit?.harvestMonths ?? []) : [],
                      onChanged: (months) => setState(() => _harvestMonths = months),
                    ),
                    
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _savePlant,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(isEdit ? 'Enregistrer les modifications' : 'Créer la plante'),
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
}
