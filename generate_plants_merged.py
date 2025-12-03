    # --- Nettoyage FR : déplacer les mentions "éviter ..." de beneficial -> avoid
    # Re-obtenir cp (au cas où on l'ait créé ci-dessus)
    cp = p.get('companionPlanting')
    if isinstance(cp, dict):
        ben = cp.get('beneficial', []) or []
        avoid = cp.get('avoid', []) or []
        moved = []
        # Déplacer les entrées contenant "éviter" de beneficial vers avoid
        for item in list(ben):
            try:
                if isinstance(item, str) and ('éviter' in item.lower() or item.lower().strip().startswith('éviter')):
                    # retirer de beneficial et ajouter dans avoid
                    try:
                        ben.remove(item)
                    except ValueError:
                        pass
                    avoid.append(item)
                    moved.append(item)
            except Exception:
                # sécurité : ignorer les items non-string ou erreurs inattendues
                continue
        # normaliser et dédupliquer
        cp['beneficial'] = normalize_companion_list(ben)
        cp['avoid'] = normalize_companion_list(avoid)
        if moved:
            print(f"[normalize_plant] moved beneficial->avoid for {p.get('id')}: {moved}")
