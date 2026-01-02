import 'package:flutter/material.dart';

/// Bouton principal personnalisé
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = icon != null
        ? ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : icon!,
            label: Text(text),
            style: style ?? _defaultButtonStyle(theme),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style ?? _defaultButtonStyle(theme),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(text),
          );

    if (width != null || height != null) {
      button = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    if (isExpanded) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    if (padding != null) {
      button = Padding(
        padding: padding!,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _defaultButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    );
  }
}

/// Bouton secondaire (outline)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = icon != null
        ? OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : icon!,
            label: Text(text),
            style: _outlineButtonStyle(theme),
          )
        : OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: _outlineButtonStyle(theme),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Text(text),
          );

    if (width != null || height != null) {
      button = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    if (isExpanded) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    if (padding != null) {
      button = Padding(
        padding: padding!,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _outlineButtonStyle(ThemeData theme) {
    return OutlinedButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(
        color: theme.colorScheme.primary,
        width: 1.5,
      ),
    );
  }
}

/// Bouton texte personnalisé
class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const CustomTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = icon != null
        ? Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : icon!,
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: textStyle ??
                          theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Text(
                        text,
                        style: textStyle ??
                            theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                      ),
              ),
            ),
          );

    return button;
  }
}

/// Bouton d'action flottant personnalisé
class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool mini;

  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    required this.child,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      elevation: elevation ?? 6,
      mini: mini,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

/// Bouton d'icône personnalisé
class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final bool isSelected;

  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.size,
    this.padding,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: backgroundColor != null || isSelected
          ? BoxDecoration(
              color: backgroundColor ??
                  (isSelected
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : null),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(
          icon,
          color: color ?? (isSelected ? theme.colorScheme.primary : null),
          size: size,
        ),
        padding: padding ?? const EdgeInsets.all(8),
      ),
    );
  }
}

/// Bouton de suppression avec confirmation
class DeleteButton extends StatelessWidget {
  final VoidCallback? onConfirm;
  final String confirmTitle;
  final String confirmMessage;
  final String confirmButtonText;
  final String cancelButtonText;
  final Widget? icon;
  final String? text;
  final bool isIconButton;

  const DeleteButton({
    super.key,
    this.onConfirm,
    this.confirmTitle = 'Confirmer la suppression',
    this.confirmMessage = 'ÃŠtes-vous sûr de vouloir supprimer cet élément ?',
    this.confirmButtonText = 'Supprimer',
    this.cancelButtonText = 'Annuler',
    this.icon,
    this.text,
    this.isIconButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<void> showConfirmDialog() async {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(confirmTitle),
          content: Text(confirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelButtonText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text(confirmButtonText),
            ),
          ],
        ),
      );

      if (result == true) {
        onConfirm?.call();
      }
    }

    if (isIconButton) {
      return CustomIconButton(
        icon: (icon as Icon?)?.icon ?? Icons.delete,
        onPressed: showConfirmDialog,
        color: theme.colorScheme.error,
        tooltip: 'Supprimer',
      );
    } else {
      return SecondaryButton(
        text: text ?? 'Supprimer',
        onPressed: showConfirmDialog,
        icon: icon ??
            Icon(
              Icons.delete,
              color: theme.colorScheme.error,
            ),
      );
    }
  }
}
