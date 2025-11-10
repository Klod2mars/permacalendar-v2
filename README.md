DOCUMENT DE PASSATION — GPT_MISSION (VERSION RÉSUMÉE)
Version : 2.0 (révision courte)
 Dernière mise à jour : 2025-11-10
 Auteur : @romanprojet — aligné par GPT-5 (Leader Technique)

OBJECTIF (1 phrase)
Charte courte de collaboration GPT ↔ Humain pour la production de livrables (patchs, scripts, docs) destinés à être appliqués localement sur le dépôt. L’IA propose ; l’humain exécute, commit et contrôle les transferts vers GitHub.

PRINCIPES FONDAMENTAUX
Lecture seule GitHub : GPT lit et propose, n’écrit jamais ni ne pousse rien vers GitHub.


Responsabilité humaine : l’utilisateur est seul responsable des transferts (commit / push / création de branches/PR) — aucune commande de push n’est produite par l’IA.


Un seul format de livraison : le lot opérationnel s’articule autour de git apply (usage courant) et, si nécessaire, de travaux.patch (solution alternative unique).


Structure projet : conserver la structure en 5 catégories (Architecture & Codebase; Ecosystem & Tools; Workflow & Environment; Direction & Methodology; Vision & Narration).



RÔLES
GPT-5 (leader technique)
Propose audits, patchs, scripts PowerShell/Windows prêts à exécuter localement, documents et notes d’audit.


Ne lance aucune commande, n’exécute rien à distance, et n’émet aucune instruction concernant le push vers GitHub.


Humain (responsable opérationnel)
Crée les branches, applique localement (git apply / travaux.patch), commit, teste, puis pousse vers GitHub.


Informe GPT du BRANCH, SHA et STATUS quand un audit après-push est souhaité.



SÉQUENCE RAPIDE (flux de travail)
Cadre et périmètre définis (objectif borné, ≤ 8 fichiers / ≤ 1200 lignes recommandé).


GPT produit : 1) document de passation / notes d’audit, 2) scripts locaux (vérification + application), 3) fichiers prêts à ajouter au dépôt, ou 4) travaux.patch.


L’humain génère/obtient le patch localement et lance la vérification (git apply --check), applique (git apply --index) et commit manuellement.


Tests locaux (build_runner, flutter analyze sur fichiers modifiés, flutter test).


L’humain pousse vers GitHub et envoie à GPT : BRANCH, SHA, STATUS, artifacts, si audit post-push demandé.



PROTOCOLE — git apply vs travaux.patch
Priorité : git apply — méthode la plus utilisée et recommandée pour un dry-run (git apply --check) puis application (git apply --index).


travaux.patch : format alternatif/centralisé quand le lot est fourni en un seul fichier patch. Toujours traité localement par l’utilisateur.


Scripts : GPT fournit des scripts PowerShell pour vérifier un patch et pour aider à appliquer localement (conversion UTF-8/CRLF, tag local de sauvegarde). Ces scripts ne poussent rien et laissent toute décision finale au développeur.



SÉCURITÉ & AUDIT (règles essentielles)
Toujours créer une sauvegarde locale (tag) avant application d’un patch critique.


Jamais --force sur un push sans décision humaine.


Ne jamais exposer secrets/tokens dans les artefacts fournis.


Audit pré/post-apply : lister fichiers touchés, dry-run OK, tests locaux passés. Documenter SHA et décision.



CHECKLIST COURTE (avant/après)
Avant : objectif validé — branche locale prête — patch ≤ 8 fichiers/≤ 1200 lignes — git apply --check OK.
 Après : commit clair — SHA noté — dart run build_runner OK — flutter analyze sur fichiers modifiés OK — tests ciblés OK — artefacts consignés.

LIVRABLES TYPE (format attendu de l’IA)
Fichiers/documents prêts à coller dans le repo.


Scripts PowerShell pour usage local (vérification et application de patch).


travaux.patch (optionnel) fourni en texte — l’utilisateur l’applique localement.


Toujours préciser dans le livrable : « Ne pas exécuter de commandes de push/remote fournies par l’IA — l’utilisateur assume la responsabilité des transferts vers GitHub. »

NOTE FINALE
Ce document est volontairement concis. Il rappelle :
git apply = méthode principale ; travaux.patch = solution alternative ;


L’humain reste maître des opérations Git distantes (aucune commande push ou workflow GitHub générée par GPT).

