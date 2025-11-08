1) Conventions YAML pour dialoguer avec Cursor

Chaque mission est un fichier YAML qui suit ce schéma (obligatoire) :

mission_id: "MXXX"                # identifiant unique
title: "Titre clair"
description: |
  Description détaillée en FR.
priority: high|medium|low
max_files: 8                      # limite recommandée par mission
max_lines: 1200                   # recommandation de taille de patch
files:
  - path: "relative/path/to/file.ext"
    action: create|modify|patch|delete
    encoding: text
    content: |
      <contenu exact du fichier (si create) ou patch>
commands:
  - "commande_shell_1"
  - "commande_shell_2"
tests:
  - command: "flutter test"
    expect: "compiles"            # ou "no_missing_files", "no_errors", regex attendu
commit:
  message: "Message de commit"
  files:                            # facultatif : fichiers à inclure explicitement
    - "lib/core/models/app_settings.dart"
artifacts_to_return:
  - "flutter_test_output"
  - "git_status"
  - "git_rev"
notes: |
  Remarques complémentaires / instructions de sécurité


Règles de bonnes pratiques :

Une mission = <= 8 fichiers et ≤ ~1200 lignes modifiées/ajoutées.

Toujours fournir les commandes à exécuter (build, tests) et les résultats attendus.

Fournir commit.message clair et les fichiers à committer.

Si tu veux appliquer un remplacement global (imports), mettre un script/powerShell/commande dans commands (voir Mission 001).

Toujours inclure artifacts_to_return : ce que Cursor doit te renvoyer après push (ex. sortie flutter test, git status, git rev-parse HEAD).

2) Politique de taille / cadence (raisonnable pour Cursor)

Mission raisonnable : ~2–8 fichiers, modifications cohérentes (ex. ajouter un modèle + provider + tests liés).

Pourquoi : limiter le scope minimise les risques de conflits et d’erreurs massives.

Si une tâche est trop grosse (p.ex. ré-hydratation d’un grand nombre d’orphelins), on la divise en sous-missions (A / B / C) suivant les blocs de la roadmap.

Chaque mission doit aboutir à un commit clair et un flutter test non bloquant sur les erreurs ciblées.

3) Mission 001 (YAML complet) — Appliquer tout de suite

Ci-dessous le YAML prêt à donner à Cursor. Il contient les deux fichiers (app_settings.dart et app_settings_provider.dart), l’édition du pubspec.yaml (instructions), la commande de remplacement d’imports, et les commandes de build/test/commit.

⚠️ Important : Cursor applique le YAML, exécute les commandes, commit + push, puis vous m’envoyez la sortie git status + flutter test (ou git rev-parse HEAD + flutter test).
Je vérifierai la sortie et on enchaînera.