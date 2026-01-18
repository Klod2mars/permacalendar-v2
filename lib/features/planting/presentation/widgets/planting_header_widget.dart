// lib/features/planting/presentation/widgets/planting_header_widget.dart
import 'package:flutter/material.dart';
import 'package:permacalendar/l10n/app_localizations.dart';

/// Header léger et robuste pour afficher photo / titre / sous-titre d'une plantation.
/// Tolérant : accepte `Map<String,dynamic>` (JSON) ou objets domaine Freezed/dynamiques.
class PlantingHeaderWidget extends StatelessWidget {
  final dynamic planting;
  final dynamic plant;
  final ThemeData? theme;

  const PlantingHeaderWidget({
    Key? key,
    required this.planting,
    required this.plant,
    this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData usedTheme = theme ?? Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final String title = _getPlantTitle();
    final String subtitle = _getSubtitle(l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: usedTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6.0),
            Text(
              subtitle,
              style: usedTheme.textTheme.titleMedium?.copyWith(
                color: usedTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    final String? imageUrl = _extractImageUrl();
    const double size = 72.0;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(size),
        ),
      );
    }

    return _placeholder(size);
  }

  Widget _placeholder(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.local_florist,
          size: size * 0.5,
          color: Colors.grey.shade700,
        ),
      );

  String? _extractImageUrl() {
    try {
      if (plant == null) return null;

      // Cas Map (JSON normalisé)
      if (plant is Map<String, dynamic>) {
        final Map<String, dynamic> m = plant as Map<String, dynamic>;
        final dynamic possible = m['image'] ??
            m['photo'] ??
            m['imageUrl'] ??
            m['img'] ??
            m['thumbnail'];
        if (possible != null) return possible.toString();
        return null;
      }

      // Cas objet domaine (Freezed / class) : tenter des accès sécurisés
      final dynamic p = plant;
      try {
        final dynamic v = p.image;
        if (v != null) return v.toString();
      } catch (_) {}
      try {
        final dynamic v = p.photo;
        if (v != null) return v.toString();
      } catch (_) {}
      try {
        final dynamic v = p.imageUrl;
        if (v != null) return v.toString();
      } catch (_) {}
    } catch (_) {
      // fallback silencieux
    }
    return null;
  }

  String _getPlantTitle() {
    try {
      if (plant == null) return 'Plante';
      if (plant is Map<String, dynamic>) {
        final Map<String, dynamic> m = plant as Map<String, dynamic>;
        final dynamic possible = m['commonName'] ?? m['name'] ?? m['title'];
        if (possible != null && possible.toString().isNotEmpty)
          return possible.toString();
        return 'Plante';
      }

      final dynamic p = plant;
      try {
        final dynamic v = p.commonName ?? p.name ?? p.title;
        if (v != null && v.toString().isNotEmpty) return v.toString();
      } catch (_) {}
      return 'Plante';
    } catch (_) {
      return 'Plante';
    }
  }

  String _getSubtitle(AppLocalizations l10n) {
    final String variety = _extractVariety();
    final String planted = _formatPlantedDate(l10n);
    if (variety.isNotEmpty && planted.isNotEmpty) return '$variety · $planted';
    if (variety.isNotEmpty) return variety;
    if (planted.isNotEmpty) return planted;
    return '';
  }

  String _extractVariety() {
    try {
      if (plant == null) return '';
      if (plant is Map<String, dynamic>) {
        final Map<String, dynamic> m = plant as Map<String, dynamic>;
        final dynamic possible = m['variety'] ?? m['cultivar'];
        if (possible != null) return possible.toString();
        return '';
      }

      final dynamic p = plant;
      try {
        final dynamic v = p.variety ?? p.cultivar;
        if (v != null) return v.toString();
      } catch (_) {}
      return '';
    } catch (_) {
      return '';
    }
  }

  String _formatPlantedDate(AppLocalizations l10n) {
    try {
      if (planting == null) return '';
      DateTime? d;

      if (planting is Map<String, dynamic>) {
        final Map<String, dynamic> m = planting as Map<String, dynamic>;
        final dynamic v = m['plantedDate'] ?? m['date'];
        if (v is DateTime) d = v;
        if (v is String) d = DateTime.tryParse(v);
        if (v is int) d = DateTime.fromMillisecondsSinceEpoch(v);
      } else {
        final dynamic p = planting;
        try {
          final dynamic v = p.plantedDate ?? p.date;
          if (v is DateTime) d = v;
          if (v is String) d = DateTime.tryParse(v);
          if (v is int) d = DateTime.fromMillisecondsSinceEpoch(v);
        } catch (_) {}
      }

      if (d == null) return '';

      final String status = _extractStatus().toLowerCase();
      // Use l10n keys for date
      // We assume format date is localized by l10n if we passed locale, 
      // but here we just use helper. Ideally helper should be localized too.
      // For now we use the existing _formatDate helper but wrapping with l10n string.
      
      final dateStr = _formatDate(d);

      if (status == 'semé') return l10n.planting_card_sown_date(dateStr);
      if (status == 'planté') return l10n.planting_card_planted_date(dateStr);
      
      // Fallback
      return l10n.planting_card_planted_date(dateStr);
    } catch (_) {
      return '';
    }
  }

  String _extractStatus() {
    try {
      if (planting == null) return '';
      if (planting is Map<String, dynamic>) {
        final Map<String, dynamic> m = planting as Map<String, dynamic>;
        final dynamic possible = m['status'];
        if (possible != null) return possible.toString();
        return '';
      }
      final dynamic p = planting;
      try {
        final dynamic v = p.status;
        if (v != null) return v.toString();
      } catch (_) {}
      return '';
    } catch (_) {
      return '';
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
