import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/soil_metrics_repository.dart';
import '../../data/repositories/soil_metrics_repository_impl.dart';
import '../../data/datasources/soil_metrics_local_ds.dart';

/// Provider for soil metrics repository
///
/// This provider creates and initializes the soil metrics repository
/// with its dependencies.
final soilMetricsRepositoryProvider = Provider<SoilMetricsRepository>((ref) {
  // Create the local data source
  final localDataSource = SoilMetricsLocalDataSourceImpl();

  // Initialize the data source (this should be done once)
  // In a real app, this would be handled by the app initializer
  localDataSource.initialize();

  // Create and return the repository implementation
  return SoilMetricsRepositoryImpl(localDataSource: localDataSource);
});


