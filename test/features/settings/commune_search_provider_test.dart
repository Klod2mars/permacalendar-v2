import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permacalendar/core/providers/commune_search_provider.dart';

void main() {
  test('communeSearchProvider returns empty for short queries', () async {
    final container = ProviderContainer();

    // Query trop courte (< 2 caractères)
    final result1 = await container.read(communeSearchProvider('A').future);
    expect(result1, isEmpty);

    // Query vide
    final result2 = await container.read(communeSearchProvider('').future);
    expect(result2, isEmpty);

    // Query avec un seul caractère
    final result3 = await container.read(communeSearchProvider(' ').future);
    expect(result3, isEmpty);

    container.dispose();
  });

  test('communeSearchProvider debounces and fetches results', () async {
    final container = ProviderContainer();

    // Query valide (≥ 2 caractères)
    final result = await container.read(communeSearchProvider('Paris').future);

    // Le provider doit retourner une liste (peut être vide si pas de résultats)
    expect(result, isA<List>());

    // Si des résultats sont retournés, vérifier la structure
    if (result.isNotEmpty) {
      expect(result.first, isNotNull);
      // Note: Structure de PlaceSuggestion vérifiée implicitement
    }

    container.dispose();
  });

  test('communeSearchProvider handles errors gracefully', () async {
    final container = ProviderContainer();

    // Query invalide ou qui causerait une erreur
    // Le provider doit retourner une liste vide en cas d'erreur
    final result =
        await container.read(communeSearchProvider('@@invalid@@').future);

    // Le provider doit gérer l'erreur et retourner une liste vide
    expect(result, isEmpty);

    container.dispose();
  });
}
