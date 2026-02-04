// lib/shared/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // pour debugPrint
import '../../../features/climate/presentation/providers/weather_providers.dart';
import '../../../l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/environment_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/constants.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/dialogs.dart';
import '../../../app_router.dart';
import '../../../features/weather/providers/commune_provider.dart';
import '../../../core/services/open_meteo_service.dart';
import '../widgets/settings/calibration_settings_section.dart';
import '../widgets/settings/backup_restore_section.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../features/climate/data/commune_storage.dart';
import '../../../features/settings/presentation/screens/language_settings_page.dart';
import '../../../features/climate/presentation/providers/zone_providers.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/models/currency_info.dart';
import '../../../features/premium/presentation/unlock_dialog.dart';


class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.settings_title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // 1. Essentiel (Langue, Localisation, Devise)
          _buildEssentialSection(context, theme, ref),
          const SizedBox(height: 24),
          
          // 2. Jardin (Zone, Gelée)
          _buildGardenConfigSection(context, theme, ref),
          const SizedBox(height: 24),

          // 3. Outils (Catalogue, Calibration)
          _buildToolsSection(context, theme, ref),
          const SizedBox(height: 24),

          // 4. Sauvegarde
          const BackupRestoreSection(),
          const SizedBox(height: 24),

          // 5. À propos
          _buildAboutSection(context, theme),
        ]),
      ),
    );
  }

  Widget _buildEssentialSection(
      BuildContext context, ThemeData theme, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_application, // "Application" maps to "Essentiel" per plan
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          // Langue
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language_title),
            subtitle: const Text('Français, English, Español...'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LanguageSettingsPage(),
              ),
            ),
          ),
          const Divider(height: 1),
          // Localisation (Météo)
          Builder(builder: (ctx) {
            final selected = ref.watch(selectedCommuneProvider);
            final defaultLabel = EnvironmentService.defaultCommuneName;
            final subtitle = selected == null
                ? l10n.settings_commune_default(defaultLabel)
                : l10n.settings_commune_selected(selected);
            return ListTile(
              leading: const Icon(Icons.location_city),
              title: Text(l10n.settings_commune_title),
              subtitle: Text(subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showCommuneSelector(context, ref),
            );
          }),
          const Divider(height: 1),
          // Devise
          ListTile(
            leading: Icon(ref.watch(currencyProvider).icon ?? Icons.attach_money),
            title: const Text('Devise'),
            subtitle: Text('${ref.watch(currencyProvider).symbol} (${ref.watch(currencyProvider).code})'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCurrencySelector(context, ref),
          ),
          const Divider(height: 1),
          // Notifications toggle
          Builder(builder: (ctx) {
            final settings = ref.watch(appSettingsProvider);
            return SwitchListTile(
              title: Text(l10n.settings_notifications_title),
              subtitle: Text(l10n.settings_notifications_subtitle),
              value: settings.notificationsEnabled,
              onChanged: (v) async {
                // Optimistically update local state
                await ref.read(appSettingsProvider.notifier).setNotificationsEnabled(v);

                if (v) {
                  // Request runtime permission (Android 13+, iOS)
                  final status = await Permission.notification.request();
                  if (status.isGranted) {
                    // OK
                  } else if (status.isPermanentlyDenied || status.isDenied) {
                    // Offer to open system settings
                    final open = await showDialog<bool>(
                      context: ctx,
                      builder: (_) => AlertDialog(
                        title: Text(l10n.settings_notification_permission_dialog_title),
                        content: Text(l10n.settings_notification_permission_dialog_content),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.common_cancel)),
                          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l10n.settings_open_system_settings)),
                        ],
                      ),
                    );
                    if (open == true) {
                      openAppSettings(); // from permission_handler
                    }
                  }
                } else {
                  // Cancel all scheduled notifications
                  await NotificationService().cancelAll();
                }
              },
            );
          }),
        ]),
      ),
    ]);
  }

  Widget _buildToolsSection(BuildContext context, ThemeData theme, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_quick_access, // "Accès rapide" maps to "Outils" per plan
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          // Catalogue
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(l10n.settings_plants_catalog),
            subtitle: Text(l10n.settings_plants_catalog_subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.plants),
          ),
          const Divider(height: 1),
          // Calibration (Integrated directly to avoid nested cards)
          const CalibrationSettingsSection(),
        ]),
      ),
    ]);
  }







  void _showCommuneSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (modalCtx) {
        String query = '';
        List<PlaceSuggestion> results = const [];
        bool loading = false;
        final svc = OpenMeteoService.instance;

        Future<void> performSearch(
            String q, void Function(void Function()) setState) async {
          setState(() => loading = true);
          try {
            final r = await svc.searchPlaces(q, count: 12);
            setState(() => results = r);
          } finally {
            setState(() => loading = false);
          }
        }

        return StatefulBuilder(builder: (sbCtx, setState) {
          final l10n = AppLocalizations.of(context)!;
          final theme = Theme.of(sbCtx);
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16 + MediaQuery.of(sbCtx).viewInsets.bottom,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settings_choose_commune,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.settings_search_commune_hint,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      query = v;
                      if (query.trim().isEmpty) {
                        setState(() => results = const []);
                      } else {
                        performSearch(query, setState);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (loading) const LinearProgressIndicator(),
                  Flexible(
                    child: results.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              query.isEmpty
                                  ? l10n.settings_commune_search_placeholder_start
                                  : l10n.settings_commune_search_no_results(query),
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: theme.colorScheme.outline),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (ctx, i) {
                              final p = results[i];
                              final subtitle = [p.admin1, p.country]
                                  .where((s) => s.isNotEmpty)
                                  .join(' • ');
                              return ListTile(
                                leading: const Icon(Icons.place),
                                title: Text(p.name),
                                subtitle: Text(subtitle),
                                onTap: () async {
                                  // Mettre à jour le provider existant (nom)
                                  await ref
                                      .read(selectedCommuneProvider.notifier)
                                      .setCommune(p.name);

                                  // Synchroniser AppSettings pour que les providers météo détectent le changement
                                  await ref
                                      .read(appSettingsProvider.notifier)
                                      .setSelectedCommune(p.name);


                                  // Tenter de résoudre les coordonnées et les persister
                                  // PATCH: On utilise directement les coordonnées de la suggestion
                                  // au lieu de relancer une recherche par nom.
                                  try {
                                    await ref
                                        .read(appSettingsProvider.notifier)
                                        .setLastCoordinates(
                                            p.latitude, p.longitude);
                                    await CommuneStorage.saveCommune(
                                        p.name, p.latitude, p.longitude);

                                    try {
                                      // Forcer Riverpod à relire la commune persistée et à rafraîchir la météo
                                      ref.invalidate(persistedCoordinatesProvider);
                                      ref.invalidate(currentWeatherProvider);
                                    } catch (e, st) {
                                      // Ne pas bloquer l'expérience utilisateur en cas d'erreur d'invalidation.
                                      // Log en debug pour faciliter le diagnostic.
                                      debugPrint(
                                          'Failed to invalidate weather providers after commune save: $e\n$st');
                                    }
                                  } catch (_) {
                                    // Ne pas bloquer l'expérience
                                  }

                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Commune sélectionnée: ${p.name}')),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ]),
          );
        });
      },
    );
  }

  Widget _buildAboutSection(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        l10n.settings_about,
        style:
            theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      CustomCard(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.settings_user_guide),
            subtitle: Text(l10n.settings_user_guide_subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelp(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settings_privacy),
            subtitle: Text(l10n.settings_privacy_policy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.settings_terms),
            subtitle: Text(l10n.settings_terms_subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version 1.0.0'),
            subtitle: const Text('Build 1234'),
            onLongPress: () async {
              if (!kDebugMode) return;
              // SECRET TRIGGER
              await showDialog(
                context: context,
                builder: (_) => const UnlockDialog(),
              );
            },
          ),
        ]),
      ),
    ]);
  }

  Widget _buildGardenConfigSection(BuildContext context, ThemeData theme, WidgetRef ref) {
    // Reconstruire si la zone change
    final l10n = AppLocalizations.of(context)!;
    final zoneAsync = ref.watch(currentZoneProvider);
    final frostAsync = ref.watch(lastFrostDateProvider);
    final settings = ref.watch(appSettingsProvider);

    final currentZone = zoneAsync.asData?.value;
    final currentFrost = frostAsync.asData?.value;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          l10n.settings_garden_config_title,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.public),
              title: Text(l10n.settings_climatic_zone_label),
              subtitle: Text(settings.customZoneId != null 
                  ? l10n.settings_status_manual(_getLocalizedZoneName(l10n, settings.customZoneId!) ?? currentZone?.name ?? settings.customZoneId ?? "") 
                  : currentZone?.name != null
                      ? l10n.settings_status_auto(_getLocalizedZoneName(l10n, currentZone!.id) ?? currentZone!.name)
                      : l10n.settings_status_detecting),
              trailing: const Icon(Icons.edit),
              onTap: () => _showGardenConfigDialog(context, ref),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.ac_unit),
              title: Text(l10n.settings_last_frost_date_label),
              subtitle: Text(settings.customLastFrostDate != null
                  ? l10n.settings_status_manual(_formatDate(currentFrost, l10n))
                  : l10n.settings_status_estimated(_formatDate(currentFrost, l10n))),
              trailing: const Icon(Icons.edit),
              onTap: () => _showGardenConfigDialog(context, ref),
            ),
          ]),
        ),
      ]);
  }

  String _formatDate(DateTime? d, AppLocalizations l10n) {
    if (d == null) return l10n.settings_status_unknown;
    return '${d.day}/${d.month}';
  }

  void _showGardenConfigDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _GardenConfigSheet(),
    );
  }




  void _showHelp(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_user_guide,
        content: l10n.user_guide_text,
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_privacy_policy,
        content: l10n.privacy_policy_text,
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: l10n.settings_terms,
        content: l10n.terms_text,
      ),
    );
  }


  void _showCurrencySelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.settings_currency_selector_title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...defaultCurrencies.values.map((currency) {
                final isSelected = ref.read(currencyProvider).code == currency.code;
                return ListTile(
                  leading: Icon(currency.icon ?? Icons.monetization_on),
                  title: Text('${currency.code} (${currency.symbol})'),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    ref.read(currencyProvider.notifier).setCurrency(currency.code);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _GardenConfigSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_GardenConfigSheet> createState() => _GardenConfigSheetState();
}

class _GardenConfigSheetState extends ConsumerState<_GardenConfigSheet> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final zoneService = ref.watch(zoneServiceProvider);
    final zones = zoneService.getAllZones();
    final settings = ref.watch(appSettingsProvider);
    
    // Valeurs courantes ou overrides
    final overrideZoneId = settings.customZoneId;
    final overrideFrost = settings.customLastFrostDate;

    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settings_garden_config_title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          
          Text(l10n.settings_climatic_zone_label, style: Theme.of(context).textTheme.titleMedium),
          DropdownButtonFormField<String?>(
            value: overrideZoneId, // null = Auto
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.settings_zone_auto_recommended)),
              ...zones.map((z) => DropdownMenuItem(
                value: z.id,
                child: Text(_getLocalizedZoneName(l10n, z.id) ?? z.name),
              ))
            ],
            onChanged: (v) {
              ref.read(appSettingsProvider.notifier).setCustomZoneId(v);
              // Force refresh
              ref.invalidate(currentZoneProvider);
              ref.invalidate(lastFrostDateProvider);
            },
          ),
          const SizedBox(height: 16),
          
          Text(l10n.settings_last_frost_date_title, style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(overrideFrost != null 
              ? '${overrideFrost.day}/${overrideFrost.month}' 
              : l10n.settings_date_auto),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final now = DateTime.now();
              final pick = await showDatePicker(
                context: context, 
                initialDate: overrideFrost ?? DateTime(now.year, 5, 1),
                firstDate: DateTime(now.year, 1, 1),
                lastDate: DateTime(now.year, 12, 31)
              );
              if (pick != null) {
                ref.read(appSettingsProvider.notifier).setCustomLastFrostDate(pick);
                ref.invalidate(lastFrostDateProvider);
              }
            },
          ),
          if (overrideFrost != null)
            TextButton(
              onPressed: () {
                ref.read(appSettingsProvider.notifier).setCustomLastFrostDate(null);
                 ref.invalidate(lastFrostDateProvider);
              }, 
              child: Text(l10n.settings_reset_date_button)
            ),
            
          const SizedBox(height: 24),
        ],
      )
    );
  }
}

String? _getLocalizedZoneName(AppLocalizations l10n, String zoneId) {
  switch (zoneId) {
    case 'NH_temperate_europe':
      return l10n.zone_nh_temperate_europe;
    case 'NH_temperate_na':
      return l10n.zone_nh_temperate_na;
    case 'SH_temperate':
      return l10n.zone_sh_temperate;
    case 'mediterranean':
      return l10n.zone_mediterranean;
    case 'tropical':
      return l10n.zone_tropical;
    case 'arid':
      return l10n.zone_arid;
    default:
      return null;
  }
}
