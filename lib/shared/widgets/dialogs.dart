ï»¿import 'package:flutter/material.dart';

/// Dialog de confirmation personnalisé
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDestructive;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isDestructive
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(
            cancelText ?? 'Annuler',
            style: TextStyle(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ??
                (isDestructive
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary),
            foregroundColor: isDestructive
                ? theme.colorScheme.onError
                : theme.colorScheme.onPrimary,
          ),
          child: Text(confirmText ?? 'Confirmer'),
        ),
      ],
    );
  }

  /// Affiche le dialog et retourne le résultat
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    IconData? icon,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        icon: icon,
        isDestructive: isDestructive,
      ),
    );
  }
}

/// Dialog d'information
class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;

  const InfoDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText,
    this.onPressed,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        content,
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        ElevatedButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Text(buttonText ?? 'OK'),
        ),
      ],
    );
  }

  /// Affiche le dialog d'information
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    String? buttonText,
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        content: content,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}

/// Dialog de sélection d'options
class OptionsDialog<T> extends StatelessWidget {
  final String title;
  final List<OptionsDialogItem<T>> options;
  final T? selectedValue;
  final void Function(T)? onSelected;

  const OptionsDialog({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option.value == selectedValue;

          return ListTile(
            leading: option.icon != null
                ? Icon(
                    option.icon,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  )
                : null,
            title: Text(
              option.title,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w500 : null,
              ),
            ),
            subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    color: theme.colorScheme.primary,
                  )
                : null,
            onTap: () {
              onSelected?.call(option.value);
              Navigator.of(context).pop(option.value);
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }

  /// Affiche le dialog de sélection et retourne la valeur sélectionnée
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<OptionsDialogItem<T>> options,
    T? selectedValue,
    void Function(T)? onSelected,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => OptionsDialog<T>(
        title: title,
        options: options,
        selectedValue: selectedValue,
        onSelected: onSelected,
      ),
    );
  }
}

/// Item pour le dialog d'options
class OptionsDialogItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final IconData? icon;

  const OptionsDialogItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
  });
}

/// Dialog de saisie de texte
class TextInputDialog extends StatefulWidget {
  final String title;
  final String? hint;
  final String? initialValue;
  final String? confirmText;
  final String? cancelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;

  const TextInputDialog({
    super.key,
    required this.title,
    this.hint,
    this.initialValue,
    this.confirmText,
    this.cancelText,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        widget.title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            widget.cancelText ?? 'Annuler',
            style: TextStyle(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          child: Text(widget.confirmText ?? 'Confirmer'),
        ),
      ],
    );
  }
}

/// Dialog de chargement
class LoadingDialog extends StatelessWidget {
  final String? message;
  final bool canDismiss;

  const LoadingDialog({
    super.key,
    this.message,
    this.canDismiss = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => canDismiss,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Affiche le dialog de chargement
  static void show(
    BuildContext context, {
    String? message,
    bool canDismiss = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: canDismiss,
      builder: (context) => LoadingDialog(
        message: message,
        canDismiss: canDismiss,
      ),
    );
  }

  /// Ferme le dialog de chargement
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Bottom sheet personnalisé
class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showHandle;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showHandle = true,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          if (showHandle) ...[
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Titre
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],

          // Contenu
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),

          // Actions
          if (actions != null) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Affiche le bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool showHandle = true,
    double? height,
    EdgeInsetsGeometry? padding,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomBottomSheet(
        title: title,
        actions: actions,
        showHandle: showHandle,
        height: height,
        padding: padding,
        child: child,
      ),
    );
  }
}


