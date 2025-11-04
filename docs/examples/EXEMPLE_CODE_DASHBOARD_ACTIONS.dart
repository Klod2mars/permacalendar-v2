// 🔧 Exemple de code Mobile First pour plant_intelligence_dashboard_screen.dart
// Ce fichier contient le code optimisé pour une utilisation mobile
// Toutes les interfaces sont conçues pour être tactiles et ergonomiques

// ============================================================================
// PARTIE 1 : Imports nécessaires (à ajouter en haut du fichier si manquants)
// ============================================================================

import 'package:go_router/go_router.dart';
import '../../../../app_router.dart';

// ============================================================================
// PARTIE 2 : Méthode Mobile First (RECOMMANDÉE)
// ============================================================================

/// Section d'actions rapides pour la lutte biologique (Mobile First)
/// 
/// Cette version est optimisée pour :
/// - Utilisation tactile (zones de 48dp minimum)
/// - Lisibilité sur petit écran
/// - Navigation simple et intuitive
Widget _buildQuickActionsSection(BuildContext context, ThemeData theme) {
  final intelligenceState = ref.watch(intelligenceStateProvider);
  final gardenId = intelligenceState.currentGardenId ?? '';
  final hasGarden = gardenId.isNotEmpty;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Titre de la section
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.flash_on,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Actions Rapides',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      
      // Message si aucun jardin sélectionné
      if (!hasGarden)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sélectionnez un jardin pour accéder aux actions rapides',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      
      // Action 1 : Signaler un ravageur
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: hasGarden ? 2 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasGarden ? () {
            context.push(
              '${AppRoutes.pestObservation}?gardenId=$gardenId',
            );
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icône avec fond coloré (zone tactile optimale)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasGarden 
                        ? Colors.red.withOpacity(0.1) 
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bug_report,
                    color: hasGarden ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Texte (lisible et hiérarchisé)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Signaler un ravageur',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: hasGarden 
                              ? theme.colorScheme.onSurface 
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Identifiez et obtenez des recommandations de lutte biologique',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Flèche (indication de navigation)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: hasGarden 
                      ? theme.colorScheme.onSurfaceVariant 
                      : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Action 2 : Lutte biologique
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: hasGarden ? 2 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: hasGarden ? () {
            context.push(
              '${AppRoutes.bioControlRecommendations}?gardenId=$gardenId',
            );
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icône avec fond coloré (zone tactile optimale)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasGarden 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: hasGarden ? Colors.green : Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Texte (lisible et hiérarchisé)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lutte biologique',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: hasGarden 
                              ? theme.colorScheme.onSurface 
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Consultez les auxiliaires et méthodes naturelles pour votre jardin',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Flèche (indication de navigation)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: hasGarden 
                      ? theme.colorScheme.onSurfaceVariant 
                      : Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ),
      ),
      
      const SizedBox(height: 16),
    ],
  );
}

// ============================================================================
// PARTIE 3 : Intégration dans la méthode build()
// ============================================================================

/*
Dans la méthode build() du Dashboard, intégrer la section comme suit :

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intelligenceState = ref.watch(intelligenceStateProvider);
    final alertsState = ref.watch(intelligentAlertsProvider);
    
    return Scaffold(
      appBar: AppBar(
        // ... AppBar existante ...
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            
            // ===== Section d'en-tête / statistiques (existant) =====
            // ... code existant ...
            
            // ===== Section d'alertes (existant) =====
            // ... code existant ...
            
            // ✅ NOUVEAU : Section Actions Rapides (Mobile First)
            _buildQuickActionsSection(context, theme),
            
            // ===== Section des plantes (existant) =====
            // ... code existant ...
            
          ],
        ),
      ),
    );
  }
*/

// ============================================================================
// PARTIE 4 : Version Minimaliste (Alternative Mobile First)
// ============================================================================

/// Version ultra-simple avec boutons pleine largeur
/// À utiliser si l'espace est vraiment limité
Widget _buildQuickActionsMinimal(BuildContext context, ThemeData theme) {
  final intelligenceState = ref.watch(intelligenceStateProvider);
  final gardenId = intelligenceState.currentGardenId ?? '';
  final hasGarden = gardenId.isNotEmpty;
  
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Bouton 1 : Signaler
        ElevatedButton.icon(
          onPressed: hasGarden ? () {
            context.push(
              '${AppRoutes.pestObservation}?gardenId=$gardenId',
            );
          } : null,
          icon: const Icon(Icons.bug_report, size: 20),
          label: const Text('Signaler un ravageur'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            minimumSize: const Size(double.infinity, 52), // Zone tactile optimale
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            alignment: Alignment.centerLeft,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Bouton 2 : Lutte Bio
        ElevatedButton.icon(
          onPressed: hasGarden ? () {
            context.push(
              '${AppRoutes.bioControlRecommendations}?gardenId=$gardenId',
            );
          } : null,
          icon: const Icon(Icons.eco, size: 20),
          label: const Text('Lutte biologique'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade50,
            foregroundColor: Colors.green.shade700,
            minimumSize: const Size(double.infinity, 52), // Zone tactile optimale
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            alignment: Alignment.centerLeft,
          ),
        ),
        
        const SizedBox(height: 16),
      ],
    ),
  );
}

// ============================================================================
// PARTIE 5 : Boutons pour home_screen.dart (Mobile First)
// ============================================================================

/// Boutons d'accès rapide pour l'écran d'accueil (Section Intelligence)
/// À intégrer dans _buildIntelligenceSection() de home_screen.dart
Widget _buildIntelligenceQuickButtons(BuildContext context, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      OutlinedButton.icon(
        onPressed: () => context.push(AppRoutes.recommendations),
        icon: const Icon(Icons.lightbulb, size: 20),
        label: const Text('Recommandations'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          alignment: Alignment.centerLeft,
        ),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => context.push(AppRoutes.notifications),
        icon: const Icon(Icons.notifications, size: 20),
        label: const Text('Notifications'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          alignment: Alignment.centerLeft,
        ),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => context.push(AppRoutes.intelligenceSettings),
        icon: const Icon(Icons.settings, size: 20),
        label: const Text('Paramètres'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          alignment: Alignment.centerLeft,
        ),
      ),
    ],
  );
}

// ============================================================================
// PARTIE 6 : Principes Mobile First Appliqués
// ============================================================================

/*
🎯 PRINCIPES MOBILE FIRST DANS CE CODE :

1. ✅ DISPOSITION VERTICALE (Column)
   - Pas de calculs de largeur
   - Défilement naturel
   - Une action par ligne

2. ✅ ZONES TACTILES OPTIMALES
   - Padding de 16px vertical minimum
   - Hauteur totale >= 48dp (standard Material)
   - Espacement de 12px entre éléments

3. ✅ LISIBILITÉ MOBILE
   - Icônes de 20-28px
   - Texte hiérarchisé (titre + sous-titre)
   - Contraste renforcé

4. ✅ SIMPLICITÉ DU CODE
   - Pas de MediaQuery
   - Pas de Wrap avec calculs
   - Pas de responsive complexe
   - Une seule version

5. ✅ FEEDBACK VISUEL
   - États désactivés clairement visibles
   - InkWell pour l'effet de clic
   - Elevation sur les cartes actives

6. ✅ ACCESSIBILITÉ
   - Semantics implicite via Material widgets
   - Tooltip sur les IconButtons
   - Tailles minimales respectées

---

📐 SPÉCIFICATIONS TACTILES :

Zone Interactive Minimale :
- Boutons : 48x48 dp
- ListTile : 56 dp de hauteur
- Card cliquable : 48 dp de hauteur
- IconButton : 48x48 dp

Espacements :
- Entre boutons : 12 dp
- Padding horizontal : 16 dp (marges écran)
- Padding interne cartes : 16 dp
- Entre sections : 16 dp

Tailles d'Icônes :
- Bouton : 20 dp
- Décorative : 24 dp
- Principale : 28 dp

---

🚫 CE QU'ON ÉVITE (Anti-patterns) :

❌ MediaQuery.of(context).size.width
❌ Wrap avec calculs de largeur
❌ Conditions if (mobile) else (desktop)
❌ GridView avec crossAxisCount dynamique
❌ Padding < 12dp entre éléments tactiles
❌ Icônes < 20dp dans les boutons

---

✅ CHECKLIST D'INTÉGRATION :

1. Copier la méthode _buildQuickActionsSection() 
2. Ajouter les imports nécessaires
3. Appeler la méthode dans build()
4. Tester sur smartphone physique ou émulateur
5. Vérifier la zone tactile (essayer avec le pouce)
6. Vérifier la lisibilité sans zoom
7. Tester en mode portrait ET paysage

*/

// ============================================================================
// FIN DU FICHIER MOBILE FIRST
// ============================================================================

/*
INSTRUCTIONS D'UTILISATION :

1. ✅ RECOMMANDÉ : Utiliser _buildQuickActionsSection() (PARTIE 2)
   Version complète et détaillée, optimisée mobile
   
2. Alternative minimaliste : _buildQuickActionsMinimal() (PARTIE 4)
   Si besoin d'une version ultra-compacte

3. Pour home_screen.dart : _buildIntelligenceQuickButtons() (PARTIE 5)
   Boutons pour la section Intelligence de l'accueil

IMPORTANT :
- Ce code est 100% Mobile First
- Pas besoin de version desktop séparée
- Fonctionne naturellement sur tablette
- Respecte les standards Material Design
- Optimisé pour le tactile

ÉTAPES :
1. Copier la méthode choisie dans votre fichier
2. Ajouter les imports (PARTIE 1)
3. Appeler la méthode dans build() (PARTIE 3)
4. Tester sur appareil mobile
5. Valider l'ergonomie tactile

Pour toute question : voir CORRECTIF_NAVIGATION_INTELLIGENCE.md
*/
