// lib/features/garden_bed/presentation/widgets/create_garden_bed_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:permacalendar/l10n/app_localizations.dart';
import '../../../../core/repositories/garden_rules.dart';

import '../../../../core/models/garden_bed.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../providers/garden_bed_provider.dart';
import '../../../../core/services/activity_observer_service.dart';
import '../../../../core/events/garden_event_bus.dart';
import '../../../../core/events/garden_events.dart';
import '../../../../core/data/hive/garden_boxes.dart';
import '../../providers/garden_bed_scoped_provider.dart';

class CreateGardenBedDialog extends ConsumerStatefulWidget {
  final String gardenId;
  final GardenBed? gardenBed; // For editing

  const CreateGardenBedDialog({
    super.key,
    required this.gardenId,
    this.gardenBed,
  });

  @override
  ConsumerState<CreateGardenBedDialog> createState() =>
      _CreateGardenBedDialogState();
}

class _CreateGardenBedDialogState extends ConsumerState<CreateGardenBedDialog> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sizeController = TextEditingController();

  // Header tuning: editable constants to control title rendering
  static const double _kDialogHeaderFontSize = 22.0;
  static const double _kDialogHeaderLineHeight = 1.05;
  static const int _kDialogHeaderMaxLines = 2;
  static const double _kDialogHeaderIconSize = 26.0;
  static const TextOverflow _kDialogHeaderOverflow = TextOverflow.ellipsis;

  // UI state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.gardenBed != null) {
      final bed = widget.gardenBed!;
      _nameController.text = bed.name;
      _descriptionController.text = bed.description;
      _sizeController.text = bed.sizeInSquareMeters.toString();
      // We intentionally do NOT populate soil/exposure/notes/isActive in the UI.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.gardenBed != null;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isEditing ? Icons.edit : Icons.add,
                  color: theme.colorScheme.primary,
                  size: _kDialogHeaderIconSize,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isEditing ? l10n.bed_create_title_edit : l10n.bed_create_title_new,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: _kDialogHeaderFontSize,
                      height: _kDialogHeaderLineHeight,
                    ),
                    maxLines: _kDialogHeaderMaxLines,
                    overflow: _kDialogHeaderOverflow,
                    softWrap: true,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      TextFormField(
                        controller: _nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: l10n.bed_form_name_label,
                          hintText: l10n.bed_form_name_hint,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.bed_form_error_name_required;
                          }
                          if (value.trim().length < 2) {
                            return l10n.bed_form_error_name_length;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Size field
                      TextFormField(
                        controller: _sizeController,
                        decoration: InputDecoration(
                          labelText: l10n.bed_form_size_label,
                          hintText: l10n.bed_form_size_hint,
                          border: const OutlineInputBorder(),
                          suffixText: 'm²',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.bed_form_error_size_required;
                          }
                          final size = double.tryParse(value);
                          if (size == null || size <= 0) {
                            return l10n.bed_form_error_size_invalid;
                          }
                          if (size > 1000) {
                            return l10n.bed_form_error_size_max;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.bed_form_desc_label,
                          hintText: l10n.bed_form_desc_hint,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // Notes / Soil / Exposure / Active controls intentionally removed
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(l10n.common_cancel),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: isEditing ? l10n.bed_form_submit_edit : l10n.bed_form_submit_create,
                  onPressed: _isLoading ? null : _saveGardenBed,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveGardenBed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      final size = double.parse(_sizeController.text);

      bool success = false;

      if (widget.gardenBed != null) {
        // Update existing garden bed: only update the fields captured by UI.
        final updatedBed = widget.gardenBed!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          sizeInSquareMeters: size,
          // keep soilType, exposure, notes, isActive unchanged (model preserves them)
        );

        // Persist in Hive (sanctuary)
        await GardenBoxes.saveGardenBed(updatedBed);

        // Tracker (we still pass the model values as they exist)
        await ActivityObserverService().captureGardenBedUpdated(
          gardenBedId: updatedBed.id,
          gardenBedName: updatedBed.name,
          gardenId: updatedBed.gardenId,
          area: updatedBed.sizeInSquareMeters,
          soilType: updatedBed.soilType,
          exposure: updatedBed.exposure,
        );

        // Emit event
        try {
          GardenEventBus().emit(
            GardenEvent.gardenContextUpdated(
              gardenId: updatedBed.gardenId,
              timestamp: DateTime.now(),
              metadata: {
                'action': 'bed_updated',
                'bedId': updatedBed.id,
                'bedName': updatedBed.name,
              },
            ),
          );
        } catch (_) {}

        // Force refresh global provider (explicitly using notifier name)
        ref.invalidate(gardenBedNotifierProvider);
        // Force refresh scoped provider (Canonical Source of Truth)
        ref.invalidate(gardenBedsForGardenProvider(updatedBed.gardenId));

        success = true;
      } else {
        // Validation check for new garden bed
        final currentBeds = GardenBoxes.getGardenBeds(widget.gardenId);
        final validation = GardenRules().validateGardenBedCount(currentBeds.length);
        
        if (!validation.isValid) {
           final errorKey = validation.errorMessage ?? 'limit_beds_reached_message';
           String errorMessage = errorKey;
           if (errorKey == 'limit_beds_reached_message') errorMessage = l10n.limit_beds_reached_message;
           // Fallback or other keys if needed

           if (mounted) {
             showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l10n.common_attention, style: TextStyle(color: Colors.orange)),
                  content: Text(errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('OK'),
                    )
                  ],
                ),
             );
           }
           setState(() => _isLoading = false);
           return;
        }

        // Create new garden bed: UI no longer collects soil/exposure/notes/isActive,
        // provide neutral readable defaults so downstream code doesn't see raw UI choices.
        final newBed = GardenBed(
          gardenId: widget.gardenId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          sizeInSquareMeters: size,
          soilType: 'Non spécifié',
          exposure: 'Non spécifié',
          // notes left null
          // isActive left default (constructor default: true)
        );

        // Persist
        await GardenBoxes.saveGardenBed(newBed);

        // Tracker
        await ActivityObserverService().captureGardenBedCreated(
          gardenBedId: newBed.id,
          gardenBedName: newBed.name,
          gardenId: newBed.gardenId,
          area: newBed.sizeInSquareMeters,
          soilType: newBed.soilType,
          exposure: newBed.exposure,
        );

        // Emit event
        try {
          GardenEventBus().emit(
            GardenEvent.gardenContextUpdated(
              gardenId: newBed.gardenId,
              timestamp: DateTime.now(),
              metadata: {
                'action': 'bed_created',
                'bedId': newBed.id,
                'bedName': newBed.name,
              },
            ),
          );
        } catch (_) {}

        // Force refresh global provider
        ref.invalidate(gardenBedNotifierProvider);
        // Force refresh scoped provider (Canonical Source of Truth)
        ref.invalidate(gardenBedsForGardenProvider(newBed.gardenId));

        success = true;
      }

      if (success && mounted) {
        Navigator.of(context).pop(true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(widget.gardenBed != null
                      ? l10n.bed_snack_updated
                      : l10n.bed_snack_created),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.common_error_prefix(e))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
