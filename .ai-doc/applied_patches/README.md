# Applied patches (M008)
Ce répertoire contient les fichiers de statut pour chaque provider préparé avec M008.
Chaque fichier `<provider>.patch.md` contient :
  - provider
  - prepared_in_file
  - prepared_line
  - backup_file
  - branch
  - status (prepared / skipped / applied)
  - notes

Workflow recommandé après le scaffold :
  1. Ouvrir la branche `apply-provider/<provider>-m008`.
  2. Éditer le fichier où le scaffold a été inséré : remplacer le bloc TODO par
     la conversion `.family` appropriée, ajuster les generics `<ParamType>`, mettre
     à jour les appels `ref.watch(...)` pour passer le param.
  3. Exécuter `flutter pub run build_runner build --delete-conflicting-outputs`.
  4. Lancer `flutter test` ciblé (tests unit + widget + integration affectés).
  5. Mettre à jour `.ai-doc/applied_patches/<provider>.patch.md` : status -> applied,
     ajouter notes sur changements / collisions manuelles, et commit/push.
  6. Respecter la procédure "safe push" (tag backup puis push branch / merge).
