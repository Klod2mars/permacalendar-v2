🧭 ORDRE DE TRANSFORMATION — RÉACTIVATION CALIBRATION DRAG & DROP

Émetteur : Bureau de Direction
Destinataire : Claude (Directeur de Production)
Code : [CODE 4.5]
Objet : Réactivation et enrichissement de la fonction Drag & Drop — Calibration organique
Date : 28 Octobre 2025

🎯 OBJECTIF

Réactiver la fonction de calibration Drag & Drop déjà présente dans les paramètres afin de permettre :

Le réajustement manuel des bulles du dashboard (zones TAP)

L’activation ou désactivation des fonctionnalités manquantes

L’assignation dynamique des modules (Agenda, pH, Température du sol, Alertes, Statistiques, Activités récentes)

🧩 COMPORTEMENT ATTENDU
En mode normal :

Les bulles sont fixes, interactives, et renvoient vers leurs modules.

En mode calibration :

Les bulles deviennent déplaçables et configurables.

Une icône “verrou” s’affiche dans le coin supérieur pour quitter le mode Drag.

Les nouvelles bulles disponibles apparaissent en semi-transparence pour être positionnées.

🧱 FONCTIONS À RÉACTIVER ET AJOUTER
Élément	Fonction	Statut actuel	Action à effectuer
🌦️ Météo	Accès au module météo	Partiellement actif	Ajuster position, réactiver tap
📅 Agenda Intelligent	Accès à l’agenda différencié	Inactif	Lier au jardin actif
🌡️ Température du sol	Module sensoriel	Manquant	Créer zone TAP + affichage
🧪 pH	Indicateur chimique	Manquant	Créer zone TAP + affichage
⚠️ Alertes météo	Notifications	Manquant	Créer zone TAP + lien /intelligence/alerts
📊 Statistiques globales	Tableau de bord	Inactif	Réactiver zone en bas
🪴 Activités récentes	Journal des actions	Nouveau	Ajouter bulle haute droite
⚙️ DÉTAIL TECHNIQUE

Fichiers concernés :

lib/shared/presentation/screens/organic_dashboard_screen.dart

lib/features/home/widgets/invisible_garden_zone.dart

lib/features/settings/presentation/screens/settings_screen.dart

Propriétés à restaurer :

bool isCalibrationMode = ref.watch(calibrationModeProvider);


Structure cible :

if (isCalibrationMode) {
  return DraggableZone(
    child: Stack(
      children: [
        _buildInvisibleBubbleZone(label: 'Agenda Intelligent', position: Offset(...)),
        _buildInvisibleBubbleZone(label: 'Météo', position: Offset(...)),
        _buildInvisibleBubbleZone(label: 'Température sol', position: Offset(...)),
        _buildInvisibleBubbleZone(label: 'pH', position: Offset(...)),
        _buildInvisibleBubbleZone(label: 'Alertes', position: Offset(...)),
        _buildInvisibleBubbleZone(label: 'Statistiques', position: Offset(...)),
        _buildInvisibleBubbleZone(label: 'Activités récentes', position: Offset(...)),
      ],
    ),
  );
}


Chaque zone devra être draggable, avec enregistrement automatique dans :

SharedPreferences.setDouble('bubble_x_$id', value.dx);
SharedPreferences.setDouble('bubble_y_$id', value.dy);

🎨 UX / DESIGN

Couleurs des bulles calibrables conservées (green glow)

Nouvelles bulles semi-transparentes (alpha 0.4) avant activation

Message doux à l’ouverture du mode calibration :

“🪶 Déplacez librement vos bulles. Touchez deux fois pour valider.”

✅ CRITÈRES DE VALIDATION

Tous les modules essentiels (7) présents sur le dashboard

Drag & Drop fluide et enregistré

Quitter le mode calibration restaure les positions

Interaction fonctionnelle après repositionnement

Performance stable (FPS ≥ 55 sur Android A35)

🧭 STRATÉGIE DE DÉPLOIEMENT

1️⃣ Phase A40-3.A → Connexion Agenda Intelligent (en cours)
2️⃣ Phase A40-3.B → Réactivation Drag & Drop global
3️⃣ Phase A40-3.C → Intégration Activités Récentes
4️⃣ Validation UX → Rapport A40-3 Final

🌿 NOTE DE DIRECTION

Nous revenons à l’esprit initial du PermaCalendar :
un dashboard vivant, adaptable, organique,
où chaque jardinier façonne sa propre interface selon son rythme et ses besoins. 🌾

Signature :
🏛️ Bureau de Direction – PermaCalendar
🧾 Code : [CODE 4.5] — Mission A40-3.B
📅 28 Octobre 2025