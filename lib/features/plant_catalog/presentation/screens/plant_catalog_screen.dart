// lib/features/plant_catalog/presentation/screens/plant_catalog_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ajustez le chemin selon votre architecture si nécessaire.
// J'assume la présence d'une entité PlantFreezed dans ce package.
import 'package:permacalendar/features/plant_catalog/domain/entities/plant_freezed.dart';

/// Écran permettant de sélectionner une plante depuis une base interne.
/// - Recherche normalisée (sans diacritiques, minuscule)
/// - Affichage des images : asset / network / fallback
class PlantCatalogScreen extends StatefulWidget {
  /// Liste de plantes à afficher. Si vide, la grille sera vide.
  final List<PlantFreezed> plants;

  /// Callback appelé lorsque l'utilisateur sélectionne une plante.
  final void Function(PlantFreezed plant)? onPlantSelected;

  const PlantCatalogScreen({
    Key? key,
    this.plants = const [],
    this.onPlantSelected,
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

    // Si vous voulez initialiser la recherche avec un texte déjà présent :
    _searchController.addListener(() {
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

  /// Normalisation pour la recherche : met en minuscules, retire
  /// diacritiques simples et condense les espaces.
  String _normalize(String? input) {
    if (input == null) return '';
    String s = input.toLowerCase().trim();

    // Mappage de base pour les diacritiques français et courants
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
      // Majuscules - rarement nécessaires après toLowerCase, mais on les met pour sûreté
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

    // Remplacer plusieurs espaces par un seul
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
        // IMPORTANT : adaptez ces champs si votre PlantFreezed a d'autres attributs (ex: latinName, tags, etc.)
        final name = _normalize(p.name ?? '');
        final description = _normalize((p.description ?? ''));
        return name.contains(normalizedQuery) ||
            description.contains(normalizedQuery);
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
    final String? rawPath = plant.imagePath?.trim();
    final double imageHeight = 180.0;
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
          // Affiche le fallback si le réseau échoue
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(height: imageHeight),
        );
      } else {
        // Si l'utilisateur a déjà précisé un chemin d'assets complet, on l'utilise tel quel.
        // Autrement, on préfixe avec assets/images/legumes/
        final assetPath = rawPath.startsWith('assets/')
            ? rawPath
            : 'assets/images/legumes/$rawPath';

        imageWidget = Image.asset(
          assetPath,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
          // En cas d'erreur d'asset (ex: fichier manquant), on tombe sur le fallback.
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(height: imageHeight),
        );
      }
    } else {
      imageWidget = _fallbackImage(height: imageHeight);
    }

    return GestureDetector(
      onTap: () {
        if (widget.onPlantSelected != null) {
          widget.onPlantSelected!(plant);
        } else {
          // Default behaviour : nothing. Vous pouvez ajouter une navigation ici si souhaité.
        }
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image (avec clip arrondi via ClipRRect inhérent au Card)
            SizedBox(
              height: imageHeight,
              child: imageWidget,
            ),
            // Espace pour le nom / info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name ?? '—',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((plant.subtitle ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        plant.subtitle ?? '',
                        style: Theme.of(context).textTheme.caption,
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
          // Pour ajuster le nombre de colonnes selon la largeur
          final crossAxisCount = constraints.maxWidth >= 800
              ? 4
              : (constraints.maxWidth >= 600 ? 3 : 2);

          // bottom padding dynamique en fonction du clavier pour éviter le masquage de la grille
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          final bottomPadding = bottomInset + 12.0;

          return Column(
            children: [
              // Barre de recherche
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

              // Info / count
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [
                    Text('${_filteredPlants.length} résultat(s)',
                        style: Theme.of(context).textTheme.caption),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Container()), // pousse pour aligner à gauche
                    // bouton optionnel : tri, filtre, etc.
                  ],
                ),
              ),

              // Grille
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: bottomPadding),
                  child: _filteredPlants.isEmpty
                      ? Center(
                          child: Text(
                            'Aucune plante trouvée',
                            style: Theme.of(context).textTheme.subtitle1,
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
                            // hauteur de la cellule : image(180) + texte => on donne un ratio approximatif
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
