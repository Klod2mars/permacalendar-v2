import 'package:flutter/material.dart';

class CompanionChevronsWidget extends StatelessWidget {
  final List<String> beneficial;
  final List<String> avoid;

  const CompanionChevronsWidget({
    super.key,
    required this.beneficial,
    required this.avoid,
  });

  @override
  Widget build(BuildContext context) {
    // Audit Patch: Ensure non-null lists
    final List<String> ben = beneficial ?? <String>[];
    final List<String> av = avoid ?? <String>[];
    
    // Si aucune donnée, on n'affiche rien
    if (ben.isEmpty && av.isEmpty) {
      return const SizedBox.shrink();
    }

    // Original Design: Container with translucent background and Row layout
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ben.isNotEmpty)
            _buildChevron(
              context,
              icon: Icons.keyboard_arrow_up,
              color: Colors.greenAccent,
              label: 'Plantes amies',
              items: ben,
            ),
          if (ben.isNotEmpty && av.isNotEmpty)
            const SizedBox(width: 4),
          if (av.isNotEmpty)
            _buildChevron(
              context,
              icon: Icons.keyboard_arrow_down,
              color: Colors.redAccent,
              label: 'Plantes à éviter',
              items: av,
            ),
        ],
      ),
    );
  }

  Widget _buildChevron(BuildContext context,
      {required IconData icon,
      required Color color,
      required String label,
      required List<String> items}) {
    return InkWell(
      onTap: () => _showListDialog(context, label, items, color),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  void _showListDialog(
      BuildContext context, String title, List<String>? items, Color color) {
    // Guard: items ?? [] handled in map
    final safeItems = items ?? <String>[];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Icon(
              title.contains('amies') ? Icons.thumb_up : Icons.thumb_down,
              color: color,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: color),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: safeItems
              .map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          item,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: TextStyle(color: color), // Match theme color
            ),
          ),
        ],
      ),
    );
  }
}
