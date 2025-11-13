ï»¿import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bio_control_recommendation.dart';
import '../../domain/entities/pest_threat_analysis.dart';
import '../../../../core/di/intelligence_module.dart';

/// BioControlRecommendationsScreen - Displays biological control recommendations
///
/// PHILOSOPHY:
/// This screen displays AI-generated recommendations based on user observations.
/// It respects the unidirectional flow: Sanctuary (Observations) â†’ Intelligence (Analysis) â†’ Recommendations (Display)
/// The user can VIEW and APPLY recommendations, but CANNOT create them (only the AI can).
class BioControlRecommendationsScreen extends ConsumerStatefulWidget {
  final String gardenId;
  final PestThreatAnalysis? threatAnalysis;

  const BioControlRecommendationsScreen({
    super.key,
    required this.gardenId,
    this.threatAnalysis,
  });

  @override
  ConsumerState<BioControlRecommendationsScreen> createState() =>
      _BioControlRecommendationsScreenState();
}

class _BioControlRecommendationsScreenState
    extends ConsumerState<BioControlRecommendationsScreen> {
  List<BioControlRecommendation> _recommendations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Using Riverpod to access bio control recommendation repository
      final repo = ref
          .read(IntelligenceModule.bioControlRecommendationRepositoryProvider);
      final recommendations =
          await repo.getRecommendationsForGarden(widget.gardenId);

      // Sort by priority (lower number = higher priority) and effectiveness
      recommendations.sort((a, b) {
        final priorityCompare = a.priority.compareTo(b.priority);
        if (priorityCompare != 0) return priorityCompare;
        return b.effectivenessScore.compareTo(a.effectivenessScore);
      });

      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur chargement recommandations: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsApplied(BioControlRecommendation recommendation) async {
    try {
      // Using Riverpod to access bio control recommendation repository
      final repo = ref
          .read(IntelligenceModule.bioControlRecommendationRepositoryProvider);
      await repo.markRecommendationApplied(
        recommendation.id,
        null, // userFeedback (String?) - could be added via dialog in future
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('âœ… Recommandation marquée comme appliquée'),
            backgroundColor: Colors.green,
          ),
        );
        _loadRecommendations(); // Refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ðŸŒ¿ Lutte Biologique'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRecommendations,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadRecommendations,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _recommendations.isEmpty
                  ? _buildEmptyState()
                  : _buildRecommendationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 80, color: Colors.green.shade300),
            const SizedBox(height: 24),
            Text(
              'Aucune menace détectée',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Votre jardin est en bonne santé ! ðŸŒ±\n\nAucune recommandation de lutte biologique n\'est nécessaire pour le moment.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList() {
    return RefreshIndicator(
      onRefresh: _loadRecommendations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _recommendations.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }
          return _buildRecommendationCard(_recommendations[index - 1]);
        },
      ),
    );
  }

  Widget _buildHeader() {
    final urgentCount = _recommendations.where((r) => r.priority <= 2).length;

    return Card(
      color: urgentCount > 0 ? Colors.orange.shade50 : Colors.green.shade50,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  urgentCount > 0 ? Icons.warning_amber : Icons.check_circle,
                  color: urgentCount > 0 ? Colors.orange : Colors.green,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_recommendations.length} recommandation(s)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (urgentCount > 0)
                        Text(
                          '$urgentCount action(s) urgente(s)',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BioControlRecommendation recommendation) {
    final isApplied = recommendation.isApplied ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isApplied ? 1 : 3,
      child: Opacity(
        opacity: isApplied ? 0.6 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with priority and type
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    _getPriorityColor(recommendation.priority).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  _getPriorityIcon(recommendation.priority),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeLabel(recommendation.type),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          recommendation.description,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (isApplied)
                    Chip(
                      label: const Text('Appliquée'),
                      backgroundColor: Colors.green.shade100,
                      avatar: const Icon(Icons.check, size: 16),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Effectiveness
                  Row(
                    children: [
                      const Icon(Icons.trending_up,
                          size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Efficacité : ${recommendation.effectivenessScore.toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Actions
                  Text(
                    'Actions recommandées :',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...recommendation.actions
                      .map((action) => _buildActionTile(action)),

                  if (!isApplied) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _markAsApplied(recommendation),
                      icon: const Icon(Icons.check),
                      label: const Text('Marquer comme appliquée'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BioControlAction action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      action.timing,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
                if (action.resources.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: action.resources.take(3).map((resource) {
                      return Chip(
                        label: Text(
                          resource,
                          style: const TextStyle(fontSize: 11),
                        ),
                        padding: const EdgeInsets.all(4),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
                if (action.detailedInstructions != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    action.detailedInstructions!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    if (priority <= 1) return Colors.red;
    if (priority == 2) return Colors.orange;
    if (priority == 3) return Colors.amber;
    return Colors.blue;
  }

  Icon _getPriorityIcon(int priority) {
    if (priority <= 1) {
      return const Icon(Icons.dangerous, color: Colors.red);
    }
    if (priority == 2) {
      return const Icon(Icons.warning, color: Colors.orange);
    }
    if (priority == 3) {
      return const Icon(Icons.info, color: Colors.amber);
    }
    return const Icon(Icons.lightbulb, color: Colors.blue);
  }

  String _getTypeLabel(BioControlType type) {
    switch (type) {
      case BioControlType.introduceBeneficial:
        return 'AUXILIAIRE';
      case BioControlType.plantCompanion:
        return 'PLANTE COMPAGNE';
      case BioControlType.createHabitat:
        return 'HABITAT';
      case BioControlType.culturalPractice:
        return 'PRATIQUE CULTURALE';
    }
  }
}


