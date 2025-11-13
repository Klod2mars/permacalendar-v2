import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/plant_evolution_report.dart';
import '../providers/plant_evolution_providers.dart';
import '../screens/plant_evolution_history_screen.dart';

/// âœ… CURSOR PROMPT A9 - PlantHealthDegradationBanner
///
/// Widget conditionnel qui affiche une alerte lorsqu'une plante présente
/// une dégradation significative de son score de santé.
///
/// **Conditions d'affichage:**
/// - deltaScore < -1.0 OU trend == 'down'
/// - La bannière apparaÃ®t dans PlantingDetailScreen ou PlantDetailScreen
///
/// **Features:**
/// - Design alert avec icône âš ï¸
/// - Animation slide-in
/// - CTA vers PlantEvolutionTimeline
/// - État retractable (peut être replié)
///
/// **Usage:**
/// ```dart
/// PlantHealthDegradationBanner(
///   plantId: 'tomato-001',
///   plantName: 'Tomate Cerise',
/// )
/// ```
class PlantHealthDegradationBanner extends ConsumerStatefulWidget {
  final String plantId;
  final String plantName;
  final bool isExpandable;

  const PlantHealthDegradationBanner({
    super.key,
    required this.plantId,
    required this.plantName,
    this.isExpandable = true,
  });

  @override
  ConsumerState<PlantHealthDegradationBanner> createState() =>
      _PlantHealthDegradationBannerState();
}

class _PlantHealthDegradationBannerState
    extends ConsumerState<PlantHealthDegradationBanner>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latestEvolutionAsync =
        ref.watch(latestEvolutionProvider(widget.plantId));

    return latestEvolutionAsync.when(
      data: (latestEvolution) {
        // Vérifier si on doit afficher la bannière
        if (latestEvolution == null || !_shouldShowBanner(latestEvolution)) {
          return const SizedBox.shrink();
        }

        return _buildBanner(context, latestEvolution);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Détermine si la bannière doit être affichée
  bool _shouldShowBanner(PlantEvolutionReport evolution) {
    return evolution.deltaScore < -1.0 || evolution.trend == 'down';
  }

  Widget _buildBanner(BuildContext context, PlantEvolutionReport evolution) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(_animation),
      child: Card(
        margin: const EdgeInsets.all(16),
        color: Colors.orange.shade50,
        elevation: 4,
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.isExpandable ? _toggleExpanded : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icône d'alerte
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.trending_down,
                        color: Colors.orange,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Texte principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'âš ï¸ ',
                                style: TextStyle(fontSize: 20),
                              ),
                              Expanded(
                                child: Text(
                                  'Santé en baisse',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getDescriptionText(evolution),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Indicateur expand/collapse
                    if (widget.isExpandable)
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.orange.shade700,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Contenu extensible
            if (_isExpanded && widget.isExpandable)
              _buildExpandedContent(context, evolution),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
      BuildContext context, PlantEvolutionReport evolution) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),

          // Détails du changement
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  context,
                  'Score actuel',
                  evolution.currentScore.toStringAsFixed(1),
                  Icons.monitor_heart_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  context,
                  'Variation',
                  '${evolution.deltaScore.toStringAsFixed(1)} pts',
                  Icons.arrow_downward,
                  isNegative: true,
                ),
              ),
            ],
          ),

          // Conditions dégradées
          if (evolution.degradedConditions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Conditions affectées:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: evolution.degradedConditions
                  .take(3)
                  .map((condition) => Chip(
                        label: Text(
                          _formatCondition(condition),
                          style: const TextStyle(fontSize: 12),
                        ),
                        avatar: const Icon(Icons.arrow_downward, size: 14),
                        backgroundColor: Colors.red.shade50,
                        side: BorderSide(color: Colors.red.shade200),
                        padding: const EdgeInsets.all(4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          ],

          const SizedBox(height: 16),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToTimeline(context),
              icon: const Icon(Icons.timeline),
              label: const Text('Voir l\'historique complet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
      BuildContext context, String label, String value, IconData icon,
      {bool isNegative = false}) {
    final theme = Theme.of(context);
    final color = isNegative ? Colors.red : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getDescriptionText(PlantEvolutionReport evolution) {
    final delta = evolution.deltaScore.abs().toStringAsFixed(1);
    final days = evolution.timeBetweenReports.inDays;
    return 'Score baissé de $delta points en $days jours';
  }

  String _formatCondition(String condition) {
    final translations = {
      'temperature': 'Température',
      'humidity': 'Humidité',
      'light': 'Lumière',
      'soil': 'Sol',
      'water': 'Eau',
      'nutrients': 'Nutriments',
    };

    return translations[condition.toLowerCase()] ??
        condition[0].toUpperCase() + condition.substring(1);
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _navigateToTimeline(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlantEvolutionHistoryScreen(
          plantId: widget.plantId,
          plantName: widget.plantName,
        ),
      ),
    );
  }
}


