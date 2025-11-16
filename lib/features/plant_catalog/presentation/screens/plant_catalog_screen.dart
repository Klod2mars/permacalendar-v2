// lib/features/plant_catalog/presentation/screens/plant_catalog_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import central : ré-exporte plant_entity + aliases
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_freezed.dart';

/// Écran permettant de sélectionner une plante depuis une base interne.
/// - Recherche normalisée (sans diacritiques, minuscule)
/// - Affichage des images : asset / network / fallback
class PlantCatalogScreen extends StatefulWidget {
  /// Liste de plantes à afficher. Si vide, la grille sera vide.
  final List<PlantFreezed> plants;

  /// Callback appelé lorsque l'utilisateur sélectionne une plante.
  final void Function(PlantFreezed plant)? onPlantSelected;

  /// Si true, l'écran est en mode "sélection" : un tap renvoie l'id de la plante via Navigator.pop(id)
  final bool isSelectionMode;

  const PlantCatalogScreen({
    Key? key,
    this.plants = const [],
    this.onPlantSelected,
    this.isSelectionMode = false,
  }) : super(key: key);

  @override
  State<PlantCatalogScreen> createState() => _PlantCatalogScreenState();
}

class _PlantCatalogScreenState extends State<PlantCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<PlantFreezed> _allPlants;
  late List<PlantFreezed> _filteredPlants;

  @override
  void initState() {
    super.initState();
    _allPlants = List<PlantFreezed>.from(widget.plants);
    _filteredPlants = List<PlantFreezed>.from(_allPlants);

    // Mettre à jour l'affichage du suffixIcon et lancer la recherche
    _searchController.addListener(() {
      setState(() {}); // pour suffixIcon
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void didUpdateWidget(covariant PlantCatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.plants != widget.plants) {
      _allPlants = List<PlantFreezed>.from(widget.plants);
      _applyFilter(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Normalisation pour la recherche : met en minuscules, retire diacritiques simples et condense les espaces.
  String _normalize(String? input) {
    if (input == null) return '';
    String s = input.toLowerCase().trim();

    const Map<String, String> diacritics = {
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'å': 'a',
      'ç': 'c',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ñ': 'n',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
      'À': 'a',
      'Á': 'a',
      'Â': 'a',
      'Ã': 'a',
      'Ä': 'a',
      'Å': 'a',
      'Ç': 'c',
      'È': 'e',
      'É': 'e',
      'Ê': 'e',
      'Ë': 'e',
      'Ì': 'i',
      'Í': 'i',
      'Î': 'i',
      'Ï': 'i',
      'Ñ': 'n',
      'Ò': 'o',
      'Ó': 'o',
      'Ô': 'o',
      'Õ': 'o',
      'Ö': 'o',
      'Ù': 'u',
      'Ú': 'u',
      'Û': 'u',
      'Ü': 'u',
      'Ý': 'y',
      'Ÿ': 'y',
    };

    diacritics.forEach((k, v) {
      s = s.replaceAll(k, v);
    });

    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s;
  }

  void _onSearchChanged(String query) {
    _applyFilter(query);
  }

  void _applyFilter(String query) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      setState(() => _filteredPlants = List<PlantFreezed>.from(_allPlants));
      return;
    }

    setState(() {
      _filteredPlants = _allPlants.where((p) {
        final name = _normalize(p.name);
        final description = _normalize(p.description);
        final subtitle = _normalize(p.subtitle ?? '');
        return name.contains(normalizedQuery) ||
            description.contains(normalizedQuery) ||
            subtitle.contains(normalizedQuery);
      }).toList();
    });
  }

  Widget _fallbackImage({double height = 180}) {
    return Container(
      height: height,
      color: Colors.green.shade50,
      alignment: Alignment.center,
      child: Icon(
        Icons.eco_outlined,
        size: 56,
        color: Colors.green.shade700,
      ),
    );
  }

  /// Construit la carte pour chaque plante :
  /// - Image.network si imagePath commence par http(s)
  /// - Image.asset si chemin local (on préfixe assets/images/legumes/ si nécessaire)
  /// - Fallback si imagePath null/empty ou en cas d'erreur
  Widget _buildPlantCard(PlantFreezed plant) {
    final String? rawPath =
        (plant.imagePath != null && plant.imagePath!.isNotEmpty)
            ? plant.imagePath!.trim()
            : null;
    const double imageHeight = 180.0;
    Widget imageWidget;

    if (rawPath != null && rawPath.isNotEmpty) {
      final isNetwork =
          RegExp(r'^(http|https):\/\/', caseSensitive: false).hasMatch(rawPath);

      if (isNetwork) {
        imageWidget = Image.network(
          rawPath,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(height: imageHeight),
        );
      } else {
        final assetPath = rawPath.startsWith('assets/')
            ? rawPath
            : 'assets/images/legumes/$rawPath';
        imageWidget = Image.asset(
          assetPath,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(height: imageHeight),
        );
      }
    } else {
      // Fallback dérivé depuis l'id -> assets/images/legumes/<id>.png
      final derivedAsset = 'assets/images/legumes/${plant.id}.png';
      imageWidget = Image.asset(
        derivedAsset,
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _fallbackImage(height: imageHeight),
      );
    }

    return GestureDetector(
      onTap: () {
        if (widget.isSelectionMode) {
          Navigator.of(context).pop(plant.id);
          return;
        }
        if (widget.onPlantSelected != null) {
          widget.onPlantSelected!(plant);
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: imageHeight,
              child: imageWidget,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name.isNotEmpty ? plant.name : '—',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((plant.subtitle ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        plant.subtitle ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  @override
  Widget build(BuildContext context) {
    // Eviter que le scaffold remonte automatiquement lors de l'apparition du clavier
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Catalogue de plantes'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth >= 800
              ? 4
              : (constraints.maxWidth >= 600 ? 3 : 2);

          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final bottomPadding = bottomInset + 12.0;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une plante (nom, description...)',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilter('');
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 14.0),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [
                    Text('${_filteredPlants.length} résultat(s)',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 8),
                    const Expanded(
                        child: SizedBox()), // pousse pour aligner à gauche
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: bottomPadding),
                  child: _filteredPlants.isEmpty
                      ? Center(
                          child: Text(
                            'Aucune plante trouvée',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio:
                                (constraints.maxWidth / crossAxisCount) / 280,
                          ),
                          itemCount: _filteredPlants.length,
                          itemBuilder: (context, index) {
                            final plant = _filteredPlants[index];
                            return _buildPlantCard(plant);
                          },
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
