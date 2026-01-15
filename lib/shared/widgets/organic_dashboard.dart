// lib/shared/widgets/organic_dashboard.dart
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:permacalendar/features/garden/providers/garden_provider.dart';
import '../../app_router.dart';
import '../../core/models/organic_zone_config.dart';
import '../../core/providers/organic_zones_provider.dart';
import '../../core/models/calibration_state.dart';
import '../widgets/calibration_debug_overlay.dart';
import '../../core/repositories/dashboard_slots_repository.dart';
import '../../core/providers/active_garden_provider.dart';

// Nouveaux imports pour affichage météo dans la bulle
import '../../features/climate/presentation/providers/weather_providers.dart';
import '../../core/utils/weather_icon_mapper.dart';
import '../presentation/widgets/weather_bubble_widget.dart';
import '../presentation/widgets/temperature_bubble_widget.dart';
import '../presentation/widgets/sky_calibration_overlay.dart'; // [NEW]
import '../presentation/widgets/weather_sky_background.dart'; // [NEW]
import '../presentation/widgets/weather_bio_layer.dart'; // [NEW]
import '../../features/home/widgets/invisible_stats_zone.dart';
import '../widgets/garden_bubble_widget.dart';
import '../widgets/garden_creation_dialog.dart';
import '../../core/models/garden_freezed.dart';
import '../../core/models/garden_freezed.dart';
import '../../features/home/presentation/providers/dashboard_image_settings_provider.dart'; // [NEW]
import '../../features/home/presentation/providers/unified_calibration_provider.dart'; // [NEW]
import '../presentation/widgets/unified_calibration_overlay.dart'; // [NEW]

/// 1) Active/désactive l’affichage des cadres bleus (debug)
const bool kShowTapZonesDebug = true;

/// 2) Ici tu ajustes TES COTES (en % du canvas).
class TapZonesSpec {
  static const Rect activity = Rect.fromLTWH(0.12, 0.20, 0.30, 0.13);
  static const Rect weather = Rect.fromLTWH(0.38, 0.25, 0.36, 0.20);
  static const Rect weatherStats =
      Rect.fromLTWH(0.18, 0.22, 0.20, 0.20); // NEW: Zone tap gauche
  static const Rect settings = Rect.fromLTWH(0.60, 0.40, 0.10, 0.06);
  static const Rect calendar = Rect.fromLTWH(0.11, 0.44, 0.22, 0.14);
  static const Rect temperature = Rect.fromLTWH(0.175, 0.105, 0.15, 0.15);

  static const Rect garden1 = Rect.fromLTWH(0.33, 0.58, 0.13, 0.09);
  static const Rect garden2 = Rect.fromLTWH(0.45, 0.58, 0.13, 0.09);
  static const Rect garden3 = Rect.fromLTWH(0.57, 0.58, 0.13, 0.09);
  static const Rect garden4 = Rect.fromLTWH(0.40, 0.66, 0.13, 0.09);
  static const Rect garden5 = Rect.fromLTWH(0.52, 0.66, 0.13, 0.09);
}

/// Widget helper : place une zone tap en % du parent.
class TapZone extends StatelessWidget {
  const TapZone({
    super.key,
    required this.rect01,
    required this.onTap,
    this.label,
  });

  final Rect rect01; // Rect en 0..1
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;

        final left = rect01.left * w;
        final top = rect01.top * h;
        final width = rect01.width * w;
        final height = rect01.height * h;

        // Safety-clamp the computed geometry to avoid an accidental full-screen tap-zone
        // (utile pour diagnostiquer/éviter le bug où le slot 5 couvre tout l'écran).
        final computedLeft = left;
        final computedTop = top;
        final computedWidth = width;
        final computedHeight = height;

        final safeWidth = (computedWidth.clamp(0.0, w)) as double;
        final safeHeight = (computedHeight.clamp(0.0, h)) as double;
        final maxLeft = (w - safeWidth).clamp(0.0, w) as double;
        final maxTop = (h - safeHeight).clamp(0.0, h) as double;
        final safeLeft = (computedLeft.clamp(0.0, maxLeft)) as double;
        final safeTop = (computedTop.clamp(0.0, maxTop)) as double;

        if (kDebugMode) {
          debugPrint(
              'TapZone "${label ?? ''}" rect01=$rect01 -> left=$computedLeft top=$computedTop width=$computedWidth height=$computedHeight | safeLeft=$safeLeft safeTop=$safeTop safeWidth=$safeWidth safeHeight=$safeHeight');
        }

        return Positioned(
          left: safeLeft,
          top: safeTop,
          width: safeWidth,
          height: safeHeight,
          child: SizedBox(
            width: safeWidth,
            height: safeHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque, // IMPORTANT
              // NEW: log the exact tap position and which zone received it.
              onTapDown: (details) {
                if (kDebugMode) {
                  final renderBox = context.findRenderObject() as RenderBox?;
                  final size = renderBox?.size;
                  final globalPos = renderBox?.localToGlobal(Offset.zero);
                  debugPrint(
                      'TapDown "${label ?? ''}" global=${details.globalPosition} local=${details.localPosition} rect01=$rect01 -> safeLeft=$safeLeft safeTop=$safeTop safeWidth=$safeWidth safeHeight=$safeHeight');
                  debugPrint(
                      'TapDownRenderBox "${label ?? ''}" renderBox.size=$size renderBox.topLeftGlobal=$globalPos');
                }
              },
              onTap: onTap,
              child: kShowTapZonesDebug
                  ? DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.cyanAccent, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          (label ?? '').toLowerCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            shadows: [
                              Shadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  offset: Offset(0, 2))
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.expand(),
            ),
          ),
        );
      },
    );
  }
}

/// OrganicDashboardWidget
class OrganicDashboardWidget extends ConsumerStatefulWidget {
  const OrganicDashboardWidget({
    super.key,
    this.assetPath = 'assets/images/backgrounds/dashboard_organic_final.png',
    this.showDiagnostics = true,
    this.imageZoom = 1.18, // zoom par défaut (ajuster ensuite)
    this.imageAlignment = const Alignment(-0.15, -0.03),
  });

  final String assetPath;
  final bool showDiagnostics;

  /// Zoom appliqué à l'image (1.0 = pas de zoom). Valeur par défaut : 1.18.
  final double imageZoom;

  /// Alignement de l'image agrandie dans le cadre.
  /// Alignment(x,y) : x ∈ [-1..1] (gauche..droite), y ∈ [-1..1] (haut..bas).
  final Alignment imageAlignment;

  static final List<_Hotspot> _hotspots = <_Hotspot>[
    _Hotspot(
        id: 'weather_stats',
        centerX: 0.133,
        centerY: 0.303,
        widthFrac: 0.200,
        heightFrac: 0.200,
        route: AppRoutes.weather,
        label: 'Weather Stats'),
    _Hotspot(
        id: 'soil_temperature',
        centerX: 0.723,
        centerY: 0.174,
        widthFrac: 0.135,
        heightFrac: 0.135,
        route: AppRoutes.soilTemperature,
        label: 'Soil Temp'),
    _Hotspot(
        id: 'temperature',
        centerX: 0.308,
        centerY: 0.187,
        widthFrac: 0.150,
        heightFrac: 0.150,
        route: null, // Pas de navigation, affichage pur
        label: 'Temperature'),
    _Hotspot(
        id: 'statistique',
        centerX: 0.437,
        centerY: 0.703,
        widthFrac: 0.200,
        heightFrac: 0.200,
        route: 'statistics-global',
        label: 'Statistique'),
    _Hotspot(
        id: 'calendar',
        centerX: 0.239,
        centerY: 0.443,
        widthFrac: 0.200,
        heightFrac: 0.200,
        route: AppRoutes.calendar,
        label: 'Calendar'),
    _Hotspot(
        id: 'activities',
        centerX: 0.597,
        centerY: 0.350,
        widthFrac: 0.200,
        heightFrac: 0.200,
        route: AppRoutes.activities,
        label: 'Activities'),
    _Hotspot(
        id: 'weather',
        centerX: 0.503,
        centerY: 0.230,
        widthFrac: 0.260,
        heightFrac: 0.260,
        route: null,
        label: 'Weather'),
    _Hotspot(
        id: 'settings',
        centerX: 0.334,
        centerY: 0.308,
        widthFrac: 0.070,
        heightFrac: 0.070,
        route: AppRoutes.settings,
        label: 'Paramètres'),
    _Hotspot(
        id: 'garden_1',
        centerX: 0.395,
        centerY: 0.562,
        widthFrac: 0.180,
        heightFrac: 0.180,
        route: AppRoutes.gardens,
        label: 'Jardin 1'),
    _Hotspot(
        id: 'garden_2',
        centerX: 0.603,
        centerY: 0.511,
        widthFrac: 0.180,
        heightFrac: 0.180,
        route: AppRoutes.gardens,
        label: 'Jardin 2'),
    _Hotspot(
        id: 'garden_3',
        centerX: 0.830,
        centerY: 0.506,
        widthFrac: 0.180,
        heightFrac: 0.180,
        route: AppRoutes.gardens,
        label: 'Jardin 3'),
    _Hotspot(
        id: 'garden_4',
        centerX: 0.669,
        centerY: 0.757,
        widthFrac: 0.180,
        heightFrac: 0.180,
        route: AppRoutes.gardens,
        label: 'Jardin 4'),
    _Hotspot(
        id: 'garden_5',
        centerX: 0.765,
        centerY: 0.635,
        widthFrac: 0.180,
        heightFrac: 0.180,
        route: AppRoutes.gardens,
        label: 'Jardin 5'),
  ];

  @override
  ConsumerState<OrganicDashboardWidget> createState() =>
      _OrganicDashboardWidgetState();
}

extension _WidgetExt on Widget {
  Widget wrappedInIgnorePointer({required bool ignoring}) {
    // If not ignoring, just return the widget to avoid unnecessary depth, 
    // or return IgnorePointer(ignoring: false, child: this).
    // IgnorePointer with ignoring:false allows hits.
    return IgnorePointer(ignoring: ignoring, child: this);
  }
}

class _OrganicDashboardWidgetState
    extends ConsumerState<OrganicDashboardWidget> {
  final GlobalKey _containerKey = GlobalKey();
  double? _initialSizeForScale;
  
  // [GESTURE STATE]
  double _baseZoom = 1.0;
  double _baseAlignX = 0.0;
  double _baseAlignY = 0.0;
  Offset? _lastFocalPoint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDefaultsIfNeeded();
    });
  }

  Future<void> _loadDefaultsIfNeeded() async {
    // [FIX] S'assurer que le repository des slots est prêt (boîte ouverte)
    // pour que la lecture synchrone dans build() fonctionne.
    await DashboardSlotsRepository.init();
    if (mounted) setState(() {});

    final currentMap = ref.read(organicZonesProvider);

    // On prépare les listes de ce qui manque potentiellement
    final defaultPositions = <String, Offset>{};
    final defaultSizes = <String, double>{};
    final defaultEnabled = <String, bool>{};

    bool needsUpdate = false;

    for (final h in OrganicDashboardWidget._hotspots) {
      if (!currentMap.containsKey(h.id)) {
        // Ce hotspot n'existe pas dans la config utilisateur -> on l'ajoute
        needsUpdate = true;
        defaultPositions[h.id] = Offset(h.centerX, h.centerY);

        final sizeFrac = ((h.widthFrac + h.heightFrac) / 2.0).clamp(0.05, 1.0);
        defaultSizes[h.id] = sizeFrac;

        // Active par défaut, sauf si on décide autrement
        defaultEnabled[h.id] = true;
      }
    }

    if (!needsUpdate) {
      if (kDebugMode) {
        debugPrint('🔧 [CALIBRATION] no new defaults to inject, skipping');
      }
      return;
    }

    try {
      if (kDebugMode) {
        debugPrint(
            '🔧 [CALIBRATION] injecting new defaults: ${defaultPositions.keys.toList()}');
      }
      // On utilise loadFromStorage qui fait un merge dans le Notifier (s'il est bien foutu)
      // ou bien on doit s'assurer que le repository fait un "upsert".
      // Note: OrganicZonesNotifier.loadFromStorage remplace souvent tout si on ne fait pas gaffe,
      // mais ici on suppose qu'on veut juste INIT si vide, ou PATCH.
      // VERIFICATION: Le repository Hive fait souvent un put complet.
      // SÉCURITÉ: On va lire l'existant, merger, et réécrire pour être sûr de ne rien perdre.

      // 1. Récupérer l'existant déjà chargé dans currentMap
      final mergedPositions = <String, Offset>{};
      final mergedSizes = <String, double>{};
      final mergedEnabled = <String, bool>{};

      // Copie existant
      for (final kv in currentMap.entries) {
        mergedPositions[kv.key] = kv.value.position;
        mergedSizes[kv.key] = kv.value.size;
        mergedEnabled[kv.key] = kv.value.enabled;
      }

      // [PATCH] Migration de compatibilité : weather_stat -> weather_stats
      // Si l'utilisateur a une ancienne zone 'weather_stat', on la réutilise pour 'weather_stats'
      if (mergedPositions.containsKey('weather_stat') &&
          !mergedPositions.containsKey('weather_stats')) {
        if (kDebugMode) {
          debugPrint(
              '🔧 [CALIBRATION] MIGRATION: found old "weather_stat", migrating to "weather_stats"');
        }
        // 1. Migrer les valeurs de l'ancienne clé vers la nouvelle
        mergedPositions['weather_stats'] = mergedPositions['weather_stat']!;
        mergedSizes['weather_stats'] = mergedSizes['weather_stat']!;
        mergedEnabled['weather_stats'] = mergedEnabled['weather_stat']!;

        // 2. Supprimer l'ancienne clé pour ne plus la traîner
        mergedPositions.remove('weather_stat');
        mergedSizes.remove('weather_stat');
        mergedEnabled.remove('weather_stat');

        // 3. IMPORTANT : Retirer weather_stats des defaults pour ne pas écraser la migration par les valeurs par défaut
        defaultPositions.remove('weather_stats');
        defaultSizes.remove('weather_stats');
        defaultEnabled.remove('weather_stats');
      }

      // Ajout des nouveaux (ceux qui restent dans default* après nettoyage éventuel)
      mergedPositions.addAll(defaultPositions);
      mergedSizes.addAll(defaultSizes);
      mergedEnabled.addAll(defaultEnabled);

      await ref.read(organicZonesProvider.notifier).loadFromStorage(
            defaultPositions: mergedPositions,
            defaultSizes: mergedSizes,
            defaultEnabled: mergedEnabled,
          );

      if (kDebugMode) {
        debugPrint(
            '🔧 [CALIBRATION] defaults injected and merged successfully');
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('⚠️ [CALIBRATION] failed loading defaults: $e\n$st');
      }
    }
    if (kDebugMode) {
      debugPrint(
          '[CALIBRATION] after loadFromStorage zones: ${ref.read(organicZonesProvider).keys.toList()}');
    }
  }

  Future<void> _onGardenTap(int slot) async {
    final gardenId = await DashboardSlotsRepository.getGardenIdForSlot(slot);
    if (gardenId != null && mounted) {
      ref.read(gardenProvider.notifier).selectGarden(gardenId);
      context.push('/gardens/$gardenId?fromOrganic=1');
    } else if (mounted) {
      // Slot libre : proposer la création
      final name = await showDialog<String>(
        context: context,
        builder: (_) => const GardenCreationDialog(),
      );

      if (name != null && name.isNotEmpty) {
        final newGarden = GardenFreezed.create(name: name);
        final success = await ref
            .read(gardenProvider.notifier)
            .createGardenForSlot(slot, newGarden);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Jardin "${newGarden.name}" créé avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  Future<void> _createFirstGarden() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const GardenCreationDialog(),
    );

    if (name != null && name.isNotEmpty && mounted) {
      // Create simple garden object
      final newGarden = GardenFreezed.create(name: name);

      // Create and assign to slot 1 (First Garden)
      final success = await ref
          .read(gardenProvider.notifier)
          .createGardenForSlot(1, newGarden);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Jardin "${newGarden.name}" créé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la création du jardin.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<_AssetDiagnostic> _diagnoseAsset(String assetPath) async {
    final diag = _AssetDiagnostic();
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      diag.manifestLoaded = true;
      diag.declared =
          manifest.contains('"$assetPath"') || manifest.contains(assetPath);
    } catch (e) {
      diag.manifestLoaded = false;
      diag.manifestError = e.toString();
      diag.declared = false;
    }

    try {
      final bd = await rootBundle.load(assetPath);
      diag.loadOk = true;
      diag.sizeBytes = bd.lengthInBytes;
    } catch (e) {
      diag.loadOk = false;
      diag.loadError = e.toString();
    }
    return diag;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('OrganicDashboard: build called -> ${widget.assetPath}');
    }

    final zones = ref.watch(organicZonesProvider);
    final calibState = ref.watch(calibrationStateProvider);
    // [UNIFIED] Check if we are in the unified organic mode
    final isCalibrating = calibState.activeType == CalibrationType.organic;
    final unifiedState = ref.watch(unifiedCalibrationProvider);
    final activeTool = unifiedState.activeTool;

    // [NEW] Read image settings from provider (handling persistence + live update)
    final imageSettings = ref.watch(dashboardImageSettingsProvider);
    final activeGardenId = ref.watch(activeGardenIdProvider);

    if (kDebugMode) {
      debugPrint('[CALIBRATION BUILD] zones keys: ${zones.keys.toList()}');
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double width = constraints.maxWidth.isFinite
          ? constraints.maxWidth
          : MediaQuery.of(context).size.width;
      final double height = (width * 1.7778).clamp(300.0, 1400.0);

      if (kDebugMode) {
        debugPrint(
            'OrganicDashboard: Width=$width Height=$height Zoom=${imageSettings.zoom}');
        debugPrint('OrganicDashboard: Constraints=$constraints');
      }

      return SizedBox(
        width: double.infinity,
        height: height,
        child: Container(
          // Letterbox / marges haut/bas en noir pour éviter toute déformation visible
          color: Colors.black,
          child: Stack(
            clipBehavior: Clip.none,
            key: _containerKey,
            children: [
              // VERSION ZOOM + ALIGN : on aligne et agrandit le conteneur de l'image pour
              // réduire les marges latérales et verticales tout en conservant le ratio.
              // VERSION ZOOM + ALIGN : utilisation de OverflowBox pour permettre le dépassement réel
              // 1) Background Image Layer (with unified gestures)
              Positioned.fill(
                child: GestureDetector(
                  onScaleStart: (details) {
                    if (!isCalibrating || activeTool != CalibrationTool.image) return;
                    
                    final settings = ref.read(dashboardImageSettingsProvider);
                    _baseZoom = settings.zoom;
                    _baseAlignX = settings.alignX;
                    _baseAlignY = settings.alignY;
                    _lastFocalPoint = details.localFocalPoint;
                  },
                  onScaleUpdate: (details) {
                    if (!isCalibrating || activeTool != CalibrationTool.image) return;

                    final notifier = ref.read(dashboardImageSettingsProvider.notifier);
                    
                    // 1. ZOOM (Scale)
                    // details.scale is the scale factor since the start of the gesture.
                    // New zoom = base * current_scale_factor
                    final newZoom = (_baseZoom * details.scale).clamp(0.5, 4.0);
                    notifier.setZoom(newZoom);

                    // 2. PAN (Translation)
                    // We need to calculate how much the focal point moved in pixels
                    if (_lastFocalPoint != null) {
                      // Calculate delta in pixels since START of gesture? 
                      // No, onScaleUpdate gives us the current focal point.
                      // Relative to the start of gesture?
                      // Actually, if we use details.focalPointDelta, it's the delta since the PREVIOUS update.
                      // But since we are setting state every frame, relying on incremental updates might drift 
                      // if we don't assume the base.
                      // HOWEVER, Align is absolute.
                      // Let's use the displacement from START.
                      // details.localFocalPoint is the current position.
                      // But we need the start position. We didn't store startFocalPoint?
                      // Let's just use incremental delta provided by GestureDetector for simplicity 
                      // IF we trust it, or use (current - last) if we track last.
                      
                      // Better approach with Aliases:
                      // Delta in pixels = details.focalPointDelta (since last frame)
                      // We can just apply this small delta to the CURRENT settings?
                      // NO, because we are rewriting settings based on _base variables for Zoom.
                      // If we mix "Base * Scale" for Zoom and "Current + Delta" for Pan, it works 
                      // because Zoom is absolute-ish (relative to start), Pan is incremental.
                      // Let's try incremental Pan.
                      
                      final dx = details.focalPointDelta.dx;
                      final dy = details.focalPointDelta.dy;
                      
                      // Convert pixel delta to Alignment units (-1..1).
                      // Total width represented by Align(-1) to Align(1) is "width - imageWidth"?
                      // No, Alignment units are awkward.
                      // Alignment(0,0) = center. Alignment(1,0) = right edge.
                      // The distance from -1 to 1 corresponds to "width of container - width of child".
                      // Wait, OverflowBox child size is: containerWidth * Zoom.
                      // The "play area" for alignment is (ChildWidth - ContainerWidth).
                      // If ChildWidth == ContainerWidth, Alignment has no effect (division by zero effectively).
                      
                      final childW = width * newZoom;
                      final childH = height * newZoom;
                      
                      final playW = childW - width;
                      final playH = childH - height;
                      
                      // If playW is 0, we can't pan.
                      if (playW.abs() > 1.0) {
                        // Movement of 1 pixel corresponds to what change in Align?
                        // Total Range of Align (2.0) covers `playW` pixels.
                        // So 1 pixel = 2.0 / playW;
                        
                        // Dragging content Right (+dx) means we want to see Left (Align decreases).
                        // So Align -= dx * (2.0 / playW).
                        
                        final alignDeltaX = dx * (2.0 / playW);
                        // However, we must apply this to the LATEST alignment state?
                        // Or can we calculate from base? 
                        // Since newZoom changes playW every frame, incremental is risky if we don't integrate perfectly.
                        // Let's update the "current" align directly via the notifier, 
                        // but we need to fetch the LATEST value, which might be `settings.alignX` 
                        // from the closure? No, `ref.read` gets fresh value.
                        final currentSettings = ref.read(dashboardImageSettingsProvider);
                        notifier.setAlignX((currentSettings.alignX - alignDeltaX).clamp(-1.5, 1.5));
                      }
                      
                      if (playH.abs() > 1.0) {
                        final alignDeltaY = dy * (2.0 / playH);
                        final currentSettings = ref.read(dashboardImageSettingsProvider);
                        notifier.setAlignY((currentSettings.alignY - alignDeltaY).clamp(-1.5, 1.5));
                      }
                    }
                  },
                  child: OverflowBox(
                    maxWidth: width * imageSettings.zoom,
                    maxHeight: height * imageSettings.zoom,
                    alignment:
                        Alignment(imageSettings.alignX, imageSettings.alignY),
                    child: SizedBox(
                      width: width * imageSettings.zoom,
                      height: height * imageSettings.zoom,
                      child: Image.asset(
                        widget.assetPath,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        isAntiAlias: true,
                        errorBuilder: (context, error, stack) =>
                            const SizedBox(),
                      ),
                    ),
                  ),
                ),
              ),

              // 1.5) [NEW] Organic Sky Layer (Dessiné par-dessus le fond, sous les bulles)
              // Always ignore pointers as this is just a visual layer
              const Positioned.fill(
                  child: IgnorePointer(child: WeatherSkyBackground())),

              // 1.6) [NEW] Bio Weather Layer (Particles - Pluie/Neige/Nuages)
              // WeatherBioLayer already implements IgnorePointer internally, but we can be safe
              const Positioned.fill(child: WeatherBioLayer()),

              // 2) Les zones TAP : mode normal = TapZone statique ; mode calibration = hotspots dynamiques
              Positioned.fill(
                child: LayoutBuilder(builder: (ctx, c) {
                  final w = c.maxWidth;
                  final h = c.maxHeight;
                  final shortest = w < h ? w : h;

                  if (isCalibrating) {
                    // [UNIFIED] Only show interactive hotspots if Modules tool is active
                    final areModulesEditable = activeTool == CalibrationTool.modules;
                    
                    if (!areModulesEditable) {
                       // If not editing modules, we might want to show them as static or hidden?
                       // If editing Image or Sky, modules usually distract or block view.
                       // Let's show them but non-interactive? Or just hide them?
                       // User request: "calibration des modules" is one mode.
                       // Maybe show them semi-transparent if not active?
                       // Let's keep them visible but not draggable.
                       // ACTUALLY, checking current map logic below...
                    }

                    return Stack(
                      children: [
                        for (final entry in zones.entries)
                          if (entry.value.enabled)
                            (() {
                              final cfg = entry.value;
                              final diameter = cfg.size * shortest;
                              final dx = cfg.position.dx * w - diameter / 2;
                              final dy = cfg.position.dy * h - diameter / 2;
                              // ... clamp logic ...
                              final maxLeft = (w - diameter).clamp(0.0, w);
                              final maxTop = (h - diameter).clamp(0.0, h);
                              final left = dx.clamp(0.0, maxLeft) as double;
                              final top = dy.clamp(0.0, maxTop) as double;
                              return Positioned(
                                left: left,
                                top: top,
                                width: diameter,
                                height: diameter,
                                child: _CalibratableHotspot(
                                  id: cfg.id,
                                  cfg: cfg,
                                  isCalibrating: areModulesEditable, // Only draggable if modules tool
                                  onTapRoute: null,
                                  containerKey: _containerKey,
                                  ref: ref,
                                  showDebugOutline: areModulesEditable, // Show outline only if editable
                                ),
                              );
                            })(),
                      ],
                    );
                  }

                  // Mode normal (non-calibration) : utiliser les positions persistées depuis le provider
                  final gardenState = ref.watch(gardenProvider);

                  return Stack(
                    children: [
                      // Construire dynamiquement à partir de `zones` pour garantir
                      // que le dashboard reflète l'état persistant (post-redémarrage).
                      for (final entry in zones.entries)
                        if (entry.value.enabled)
                          (() {
                            final cfg = entry.value;
                            // taille en pixels (diamètre) basée sur la plus petite dimension
                            final diameter = cfg.size * shortest;
                            final dx = cfg.position.dx * w - diameter / 2;
                            final dy = cfg.position.dy * h - diameter / 2;
                            final maxLeft =
                                (w - diameter).clamp(0.0, w) as double;
                            final maxTop =
                                (h - diameter).clamp(0.0, h) as double;
                            final left = dx.clamp(0.0, maxLeft) as double;
                            final top = dy.clamp(0.0, maxTop) as double;

                            // Trouver la route correspondante si elle existe dans _hotspots
                            String? route;
                            try {
                              route = OrganicDashboardWidget._hotspots
                                  .firstWhere((h) => h.id == cfg.id)
                                  .route;
                            } catch (e) {
                              route = null;
                            }

                            // [NEW] Logic to show GardenBubbleWidget
                            Widget? childWidget;
                            if (cfg.id.startsWith('garden_')) {
                              final slot =
                                  int.tryParse(cfg.id.split('_')[1]) ?? 0;

                              // Robust read: check if box is open logic
                              String? gardenId;
                              if (DashboardSlotsRepository.isOpen()) {
                                gardenId = DashboardSlotsRepository
                                    .getGardenIdForSlotSync(slot);
                              }

                              if (gardenId != null) {
                                final garden =
                                    gardenState.findGardenById(gardenId);
                                if (garden != null) {
                                  childWidget = GardenBubbleWidget(
                                    gardenName: garden.name,
                                    radius: diameter / 2,
                                    onTap: () => _onGardenTap(slot),
                                    isActive: activeGardenId == garden.id,
                                    auraColor: Theme.of(context).colorScheme.primaryContainer,
                                  );
                                }
                              }
                            }

                            return Positioned(
                              left: left,
                              top: top,
                              width: diameter,
                              height: diameter,
                              child: _CalibratableHotspot(
                                id: cfg.id,
                                cfg: cfg,
                                isCalibrating: false,
                                onTapRoute: route,
                                containerKey: _containerKey,
                                ref: ref,
                                // En mode normal on veut que les hotspots restent interactifs
                                // mais **non visibles** (pas d'outline de debug).
                                showDebugOutline: false,
                                child:
                                    childWidget, // Pass the bubble widget here
                              ),
                            );
                          })(),
                    ],
                  );
                }),
              ).wrappedInIgnorePointer(
                  ignoring: isCalibrating && activeTool != CalibrationTool.modules),

              // [NEW] Global "+" Button if no gardens exist
              if (!isCalibrating && ref.watch(activeGardensCountProvider) == 0)
                Positioned(
                  bottom: 30, // Safe distance from bottom
                  right: 30, // Safe distance from right
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color(0xFF4CAF50),
                    onPressed: _createFirstGarden,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),

              // [UNIFIED] Sky Calibration Overlay
              if (isCalibrating && activeTool == CalibrationTool.sky)
                const Positioned.fill(
                    child: SkyCalibrationOverlay(showCloseButton: false)),

              // [UNIFIED] Main Unified Overlay (Bottom Bar)
              if (isCalibrating)
                const Positioned.fill(child: UnifiedCalibrationOverlay()),
            ],
          ),
        ),
      );
    });
  }
}

class _AssetDiagnostic {
  bool manifestLoaded = false;
  bool declared = false;
  String? manifestError;

  bool loadOk = false;
  int? sizeBytes;
  String? loadError;
}

class _Hotspot {
  const _Hotspot({
    required this.id,
    required this.centerX,
    required this.centerY,
    required this.widthFrac,
    required this.heightFrac,
    required this.route,
    this.label,
  });

  final String id;
  final double centerX;
  final double centerY;
  final double widthFrac;
  final double heightFrac;
  final String? route; // Nullable -> if null, no navigation
  final String? label;
}

class _HotspotButton extends StatelessWidget {
  const _HotspotButton({
    required this.onTap,
    this.onLongPress,
    this.showDebugOutline = false,
    this.semanticLabel,
    this.child,
  });
  final VoidCallback? onTap; // Nullable pour display-only
  final VoidCallback? onLongPress;
  final bool showDebugOutline;
  final String? semanticLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white24,
        child: Semantics(
          button: true,
          label: semanticLabel ?? 'Dashboard hotspot',
          child: Container(
            decoration: showDebugOutline
                ? BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.orangeAccent.withOpacity(0.95),
                        width: 1.5),
                  )
                : const BoxDecoration(color: Colors.transparent),
            child: child ??
                (showDebugOutline
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            semanticLabel ?? 'hotspot',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.98),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              shadows: const [
                                Shadow(
                                    blurRadius: 2,
                                    color: Colors.black87,
                                    offset: Offset(0, 1))
                              ],
                            ),
                          ),
                        ),
                      )
                    : null),
          ),
        ),
      ),
    );
  }
}

/// Hotspot widget that supports calibration (pan + pinch-to-scale)
class _CalibratableHotspot extends StatefulWidget {
  const _CalibratableHotspot({
    Key? key,
    required this.id,
    required this.cfg,
    required this.isCalibrating,
    required this.onTapRoute,
    required this.containerKey,
    required this.ref,
    this.showDebugOutline = false,
    this.child,
  }) : super(key: key);

  final String id;
  final OrganicZoneConfig cfg;
  final bool isCalibrating;
  final String? onTapRoute;
  final GlobalKey containerKey;
  final WidgetRef ref;
  final bool showDebugOutline;
  final Widget? child;

  @override
  State<_CalibratableHotspot> createState() => _CalibratableHotspotState();
}

class _CalibratableHotspotState extends State<_CalibratableHotspot> {
  // Convert "garden_3" -> 3
  int? _extractSlotNumber(String id) {
    if (id.startsWith('garden_')) {
      final parts = id.split('_');
      if (parts.length == 2) {
        return int.tryParse(parts[1]);
      }
    }
    return null;
  }

  double? _startSize;
  Offset? _startFocalLocal;
  Offset? _startNormalizedPos;

  bool _isResizing = false;
  double? _resizeStartSize;

  final Map<int, Offset> _activePointers = {};
  bool _isPinchingInside = false;

  // Awakening/LayerLink removed.

  // Resolved gardenId for this slot (may be null until async resolution)
  String? _gardenId;

  @override
  void initState() {
    super.initState();
    _resolveGardenId();
  }

  Future<void> _resolveGardenId() async {
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) return;
    try {
      final gid = await DashboardSlotsRepository.getGardenIdForSlot(slot);
      if (!mounted) return;

      // Awakening registry logic removed.

      if (kDebugMode) {
        debugPrint(
            '[Insect][resolve] resolved gardenId for ${widget.id} -> $_gardenId');
      }
    } catch (e, st) {
      if (kDebugMode)
        debugPrint(
            '[Insect][resolve] error resolving gardenId for ${widget.id}: $e\n$st');
    }
  }

  void _onPointerDown(PointerDownEvent e) {
    _activePointers[e.pointer] = e.position;
  }

  void _onPointerMove(PointerMoveEvent e) {
    _activePointers[e.pointer] = e.position;
  }

  void _onPointerUp(PointerEvent e) {
    _activePointers.remove(e.pointer);
  }

  void _onPointerCancel(PointerCancelEvent e) {
    _activePointers.remove(e.pointer);
  }

  bool _areAllActivePointersInsideBox(RenderBox box) {
    if (_activePointers.length < 2) return false;
    final size = box.size;
    for (final pos in _activePointers.values) {
      final local = box.globalToLocal(pos);
      if (local.dx < 0 ||
          local.dx > size.width ||
          local.dy < 0 ||
          local.dy > size.height) {
        return false;
      }
    }
    return true;
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    _isResizing = true;
    _resizeStartSize = widget.cfg.size;
    final box =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      _startFocalLocal = box.globalToLocal(details.globalPosition);
      _startNormalizedPos = widget.cfg.position;
    }
    if (kDebugMode) {
      print(
          'DBG: CalibratableHotspot.longPressStart id=${widget.id} resizeStartSize=$_resizeStartSize');
    }
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    _isResizing = false;
    _resizeStartSize = null;
    if (kDebugMode)
      print('DBG: CalibratableHotspot.longPressEnd id=${widget.id}');
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _startSize = widget.cfg.size;
    final box =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      _isPinchingInside = false;
    } else {
      _startFocalLocal = box.globalToLocal(details.focalPoint);
      _startNormalizedPos = widget.cfg.position;
      _isPinchingInside = _areAllActivePointersInsideBox(box);
    }
    if (kDebugMode) {
      print(
          'DBG: CalibratableHotspot.scaleStart id=${widget.id} startSize=$_startSize isPinchingInside=$_isPinchingInside');
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final box =
        widget.containerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      if (kDebugMode)
        print(
            'DBG: CalibratableHotspot.scaleUpdate id=${widget.id} - no renderbox');
      return;
    }
    final size = box.size;

    if (_isPinchingInside &&
        _startSize != null &&
        (details.scale - 1.0).abs() > 0.0001) {
      final newSize = (_startSize! * details.scale).clamp(0.05, 1.0);
      widget.ref
          .read(organicZonesProvider.notifier)
          .setSize(widget.id, newSize);
      if (kDebugMode) {
        print(
            'DBG: CalibratableHotspot.pinchResize id=${widget.id} scale=${details.scale} newSize=$newSize');
      }
      widget.ref.read(calibrationStateProvider.notifier).markAsModified();
      return;
    }

    if (_isResizing && _resizeStartSize != null) {
      final delta = details.focalPointDelta.dy;
      final deltaNormalizedSize = -(delta / size.shortestSide);
      final newSize =
          (_resizeStartSize! + deltaNormalizedSize).clamp(0.05, 1.0);
      widget.ref
          .read(organicZonesProvider.notifier)
          .setSize(widget.id, newSize);
      if (kDebugMode) {
        print(
            'DBG: CalibratableHotspot.resize id=${widget.id} delta=$delta deltaNorm=$deltaNormalizedSize newSize=$newSize');
      }
      widget.ref.read(calibrationStateProvider.notifier).markAsModified();
      return;
    }

    if (details.focalPointDelta != Offset.zero) {
      final deltaGlobal = details.focalPointDelta;
      final deltaNormalized =
          Offset(deltaGlobal.dx / size.width, deltaGlobal.dy / size.height);
      final currentPos = widget.cfg.position;
      final newPos = Offset(
        (currentPos.dx + deltaNormalized.dx).clamp(0.0, 1.0),
        (currentPos.dy + deltaNormalized.dy).clamp(0.0, 1.0),
      );
      widget.ref
          .read(organicZonesProvider.notifier)
          .setPosition(widget.id, newPos);
      if (kDebugMode) {
        print(
            'DBG: CalibratableHotspot.pan id=${widget.id} deltaGlobal=$deltaGlobal deltaNormalized=$deltaNormalized newPos=$newPos');
      }
      widget.ref.read(calibrationStateProvider.notifier).markAsModified();
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _startSize = null;
    _startFocalLocal = null;
    _startNormalizedPos = null;
    _resizeStartSize = null;
    _isResizing = false;
    _isPinchingInside = false;
    _activePointers.clear();

    if (kDebugMode) print('DBG: CalibratableHotspot.scaleEnd id=${widget.id}');
  }

  Future<void> _handleGardenTap() async {
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) {
      if (kDebugMode) print('DBG: Slot invalide pour id=${widget.id}');
      return;
    }

    final gardenId = await DashboardSlotsRepository.getGardenIdForSlot(slot);

    if (gardenId != null) {
      // Awakening stop logic removed.

      // 2) Planifier la modification du provider + navigation APRÈS la frame courante
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Efface proprement l'active garden (après le build), évite l'assert Riverpod.
          widget.ref
              .read(activeGardenIdProvider.notifier)
              .setActiveGarden(null);
          if (kDebugMode)
            debugPrint(
                '[Insect][navigate] cleared activeGarden (postFrame) before navigation');
        } catch (e, st) {
          if (kDebugMode)
            debugPrint(
                '[Insect][navigate] error clearing active garden postFrame: $e\n$st');
        }

        try {
          // Sélection du jardin et navigation (toujours après le clear).
          widget.ref.read(gardenProvider.notifier).selectGarden(gardenId);
          context.push('/gardens/$gardenId?fromOrganic=1');
        } catch (e, st) {
          if (kDebugMode)
            debugPrint('[Insect][navigate] select or push error: $e\n$st');
        }
      });
    } else {
      // Pas de garden : navigation vers création, planifiée hors frame pour cohérence.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          context.push('/gardens/create?slot=$slot');
        } catch (e, st) {
          if (kDebugMode)
            debugPrint('[Insect][navigate] push create error: $e\n$st');
        }
      });
    }
  }

  Future<void> _handleGardenLongPress() async {
    final slot = _extractSlotNumber(widget.id);
    if (slot == null) {
      if (kDebugMode) print('DBG: Slot invalide pour id=${widget.id}');
      return;
    }

    final gardenId = await DashboardSlotsRepository.getGardenIdForSlot(slot);

    if (gardenId != null) {
      // 1) Sélection logique (contexte)
      try {
        widget.ref.read(gardenProvider.notifier).selectGarden(gardenId);
      } catch (e, st) {
        if (kDebugMode)
          debugPrint('[Insect][select] selectGarden error: $e\n$st');
      }

      // 2) Toggle atomique via le provider central (qui orchestre registry)
      try {
        widget.ref
            .read(activeGardenIdProvider.notifier)
            .toggleActiveGarden(gardenId);
        if (kDebugMode)
          debugPrint('[Insect][activate] toggleActiveGarden -> $gardenId');
      } catch (e, st) {
        if (kDebugMode)
          debugPrint(
              '[Insect][activate] error toggling active garden: $e\n$st');
      }

      // 3) Lire l'état APRES le toggle pour décider du feedback visuel:
      final nowActive = widget.ref.read(activeGardenIdProvider);

      // Récupérer le nom du jardin pour l'affichage
      final gardenState = widget.ref.read(gardenProvider);
      final garden = gardenState.findGardenById(gardenId);
      final gardenName = garden?.name ?? 'Jardin $gardenId';

      if (nowActive == gardenId) {
        // Nous venons d'activer ce garden:
        // Awakening triggering removed.
        // Message utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('$gardenName activé'),
              duration: const Duration(seconds: 2)),
        );
      } else {
        // Nous venons de désactiver ce garden.
        // Message utilisateur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('$gardenName désactivé'),
              duration: const Duration(seconds: 1)),
        );
      }
    } else {
      // Pas de garden assigné : feedback + navigation si tu veux.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun jardin assigné à ce slot')),
      );
    }
  }

  Future<void> _handleWeatherLongPress() async {
    // Active le mode calibration du ciel
    if (kDebugMode)
      debugPrint('[CALIBRATION] Activating Sky Calibration via long press');
    widget.ref.read(calibrationStateProvider.notifier).enableSkyCalibration();
  }

  @override
  Widget build(BuildContext context) {
    final isGardenHotspot = widget.id.startsWith('garden_');

    // 1) Define content widget (Weather, Stats, or Widget passed as child)
    Widget? contentWidget = widget.child;

    if (contentWidget == null) {
      contentWidget = (!isGardenHotspot && widget.id == 'weather')
          ? const WeatherBubbleWidget()
          : (!isGardenHotspot && widget.id == 'temperature')
              ? const TemperatureBubbleWidget() // NEW: Slot dédié température
              : (!isGardenHotspot && widget.id == 'weather_stats')
                  ? null // Revert: Transparent tap zone
                  : (!isGardenHotspot && widget.id == 'statistique')
                      ? Hero(
                          tag: 'stats-bubble-hero-global',
                          child: InvisibleStatsZone(
                            isCalibrationMode: widget.isCalibrating,
                            glowColor: Colors.greenAccent,
                          ),
                        )
                      : null;
    }

    if (widget.isCalibrating) {
      return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: GestureDetector(
          onLongPressStart: _handleLongPressStart,
          onLongPressEnd: _handleLongPressEnd,
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onScaleEnd: _handleScaleEnd,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.08),
              border: Border.all(color: Colors.cyan.withOpacity(0.7), width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            // Show content AND ID when in calibration mode
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                if (contentWidget != null) Center(child: contentWidget),
                Center(
                  child: Text(
                    widget.cfg.id,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final hotspotButton = _HotspotButton(
      onTap: isGardenHotspot
          ? _handleGardenTap
          : (widget.id == 'weather')
              ? null // Désactive le tap pour weather (interactive drag), active pour temperature
              : () {
                  if (kDebugMode) {
                    debugPrint(
                        'OrganicDashboard: tapped calibrated hotspot (${widget.id}) -> ${widget.onTapRoute}');
                  }
                  if (widget.onTapRoute != null) {
                    // Special handling for statistics default route if needed,
                    // but now it is generic so we can just push.
                    // If specific handling is needed for others, keep the switch.
                    if (widget.id == 'statistique') {
                      context.pushNamed('statistics-global');
                    } else {
                      context.push(widget.onTapRoute!);
                    }
                  }
                },
      onLongPress: isGardenHotspot && !widget.isCalibrating
          ? _handleGardenLongPress
          : (widget.id == 'weather' && !widget.isCalibrating)
              ? _handleWeatherLongPress
              : null,
      semanticLabel: widget.cfg.id,
      showDebugOutline: widget.showDebugOutline,
      child: contentWidget,
    );

    if (isGardenHotspot) {
      return hotspotButton;
    }

    return hotspotButton;
  }

  @override
  void dispose() {
    // Registry unregister removed.

    _activePointers.clear();
    super.dispose();
  }
}

class WeatherBubbleContent extends ConsumerWidget {
  const WeatherBubbleContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weatherAsync = ref.watch(currentWeatherProvider);

    return Center(
      child: weatherAsync.when(
        loading: () => const SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (e, st) =>
            Icon(Icons.cloud_off, color: theme.colorScheme.onSurface, size: 28),
        data: (data) {
          final tempVal = data.temperature ?? data.currentTemperatureC;
          final temp = tempVal != null ? tempVal.toStringAsFixed(0) : '--';
          final iconPath = data.icon ?? WeatherIconMapper.getFallbackIcon();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 6),
              Text('$temp°C',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                          blurRadius: 2,
                          color: Colors.black54,
                          offset: Offset(0, 1))
                    ],
                  )),
              if (data.description != null)
                Text(data.description!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.white70)),
            ],
          );
        },
      ),
    );
  }
}
