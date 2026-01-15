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
    if (beneficial.isEmpty && avoid.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (beneficial.isNotEmpty)
            _buildChevron(
              context,
              Icons.keyboard_arrow_up,
              Colors.greenAccent,
              'Plantes amies',
              beneficial,
            ),
          if (beneficial.isNotEmpty && avoid.isNotEmpty)
            const SizedBox(width: 4),
          if (avoid.isNotEmpty)
            _buildChevron(
              context,
              Icons.keyboard_arrow_down,
              Colors.redAccent,
              'Plantes à éviter',
              avoid,
            ),
        ],
      ),
    );
  }

  Widget _buildChevron(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    List<String> items,
  ) {
    return GestureDetector(
      onTap: () => _showListDialog(context, title, items, color),
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
    BuildContext context,
    String title,
    List<String> items,
    Color headerColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: headerColor.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Icon(
                headerColor == Colors.greenAccent
                    ? Icons.thumb_up_outlined
                    : Icons.thumb_down_outlined,
                color: headerColor == Colors.greenAccent
                    ? Colors.green
                    : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: headerColor == Colors.greenAccent
                          ? Colors.green.shade800
                          : Colors.red.shade800,
                    ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
