import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/pest.dart';
import '../../domain/entities/pest_observation.dart';
import '../../../../core/di/intelligence_module.dart';

/// PestObservationScreen - Allows users to record pest observations
///
/// PHILOSOPHY:
/// This screen embodies the Sanctuary principle - it allows ONLY the user
/// to create pest observations, NEVER the AI. The user observes reality
/// in their garden and records it. This maintains the sacred flow:
/// Reality (User Observation) → Sanctuary (Record) → Intelligence (Analysis)
class PestObservationScreen extends ConsumerStatefulWidget {
  final String gardenId;
  final String plantId;
  final String? bedId;

  const PestObservationScreen({
    super.key,
    required this.gardenId,
    required this.plantId,
    this.bedId,
  });

  @override
  ConsumerState<PestObservationScreen> createState() =>
      _PestObservationScreenState();
}

class _PestObservationScreenState extends ConsumerState<PestObservationScreen> {
  final _formKey = GlobalKey<FormState>();
  Pest? _selectedPest;
  PestSeverity _severity = PestSeverity.moderate;
  String? _notes;
  bool _isLoading = false;
  List<Pest> _availablePests = [];

  @override
  void initState() {
    super.initState();
    _loadPests();
  }

  Future<void> _loadPests() async {
    try {
      // Using Riverpod to access pest repository
      final pestRepo = ref.read(IntelligenceModule.pestRepositoryProvider);
      final pests = await pestRepo.getAllPests();
      setState(() {
        _availablePests = pests;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur chargement ravageurs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveObservation() async {
    if (!_formKey.currentState!.validate() || _selectedPest == null) {
      return;
    }

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final observation = PestObservation(
        id: const Uuid().v4(),
        pestId: _selectedPest!.id,
        plantId: widget.plantId,
        gardenId: widget.gardenId,
        observedAt: DateTime.now(),
        severity: _severity,
        bedId: widget.bedId,
        notes: _notes,
        isActive: true,
      );

      // Using Riverpod to access observation repository
      final observationRepo =
          ref.read(IntelligenceModule.pestObservationRepositoryProvider);
      await observationRepo.savePestObservation(observation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Observation enregistrée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur sauvegarde: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐛 Observer un ravageur'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Info
                    Card(
                      color: Colors.amber.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: Colors.amber.shade800),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Enregistrez vos observations de ravageurs',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'L\'intelligence végétale analysera votre observation et vous proposera des solutions de lutte biologique adaptées.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pest Selection
                    Text(
                      'Type de ravageur *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Pest>(
                      initialValue: _selectedPest,
                      decoration: InputDecoration(
                        hintText: 'Sélectionnez le ravageur observé',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.bug_report),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un ravageur';
                        }
                        return null;
                      },
                      items: _availablePests.map((pest) {
                        return DropdownMenuItem<Pest>(
                          value: pest,
                          child: Row(
                            children: [
                              Text(pest.name),
                              const SizedBox(width: 8),
                              if (pest.description != null)
                                Flexible(
                                  child: Text(
                                    '(${pest.scientificName})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (pest) {
                        setState(() => _selectedPest = pest);
                      },
                    ),

                    // Show pest details if selected
                    if (_selectedPest != null) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedPest!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedPest!.scientificName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                              ),
                              if (_selectedPest!.description != null) ...[
                                const SizedBox(height: 8),
                                Text(_selectedPest!.description!),
                              ],
                              if (_selectedPest!.symptoms.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Symptômes courants :',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                ..._selectedPest!.symptoms
                                    .take(3)
                                    .map((symptom) => Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('• '),
                                              Expanded(child: Text(symptom)),
                                            ],
                                          ),
                                        )),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Severity Selection
                    Text(
                      'Sévérité de l\'attaque *',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<PestSeverity>(
                      segments: const [
                        ButtonSegment(
                          value: PestSeverity.low,
                          label: Text('Faible'),
                          icon: Icon(Icons.check_circle, color: Colors.green),
                        ),
                        ButtonSegment(
                          value: PestSeverity.moderate,
                          label: Text('Modéré'),
                          icon: Icon(Icons.warning, color: Colors.orange),
                        ),
                        ButtonSegment(
                          value: PestSeverity.high,
                          label: Text('Élevé'),
                          icon: Icon(Icons.error, color: Colors.deepOrange),
                        ),
                        ButtonSegment(
                          value: PestSeverity.critical,
                          label: Text('Critique'),
                          icon: Icon(Icons.dangerous, color: Colors.red),
                        ),
                      ],
                      selected: {_severity},
                      onSelectionChanged: (Set<PestSeverity> newSelection) {
                        setState(() {
                          _severity = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getSeverityDescription(_severity),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Notes
                    Text(
                      'Notes (optionnel)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Décrivez ce que vous avez observé...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onSaved: (value) => _notes = value,
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    ElevatedButton.icon(
                      onPressed: _saveObservation,
                      icon: const Icon(Icons.save),
                      label: const Text('Enregistrer l\'observation'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _getSeverityDescription(PestSeverity severity) {
    switch (severity) {
      case PestSeverity.low:
        return 'Quelques individus observés, dégâts minimes';
      case PestSeverity.moderate:
        return 'Présence notable, début de dégâts visibles';
      case PestSeverity.high:
        return 'Infestation importante, dégâts significatifs';
      case PestSeverity.critical:
        return 'Infestation massive, risque de perte de récolte';
    }
  }
}


