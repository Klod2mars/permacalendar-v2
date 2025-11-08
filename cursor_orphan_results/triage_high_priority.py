#!/usr/bin/env python3
"""
Script de triage automatique pour les orphelins priority=high
Effectue des vérifications approfondies et classifie chaque item.
"""

import csv
import json
import re
import subprocess
import os
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from collections import defaultdict

# Configuration
LIB_DIR = Path(__file__).parent.parent / "lib"
OUTPUT_DIR = Path(__file__).parent
MAX_HITS = 5

# Dossier lib
BASE_DIR = Path(__file__).parent.parent


def normalize_path(path: str) -> str:
    """Normalise un chemin en utilisant / comme séparateur."""
    return path.replace('\\', '/')


def extract_basename(file_path: str) -> str:
    """Extrait le basename d'un fichier (sans extension)."""
    normalized = normalize_path(file_path)
    basename = os.path.basename(normalized)
    return os.path.splitext(basename)[0]


def search_in_files(pattern: str, exclude_file: Optional[str] = None, max_hits: int = MAX_HITS, 
                    file_glob: Optional[str] = None) -> List[Dict]:
    """
    Recherche dans les fichiers avec Python (remplace ripgrep).
    Retourne une liste de dicts {file, line, snippet}
    """
    results = []
    try:
        compiled_pattern = re.compile(pattern, re.IGNORECASE)
        
        # Déterminer le répertoire de recherche
        search_dir = BASE_DIR / "lib"
        if not search_dir.exists():
            return results
        
        # Globs pour fichiers
        if file_glob:
            if '*.g.dart' in file_glob or '*.freezed.dart' in file_glob or '*.mocks.dart' in file_glob:
                # Chercher dans tous les fichiers générés
                for ext in ['.g.dart', '.freezed.dart', '.mocks.dart']:
                    for file_path in search_dir.rglob(f'*{ext}'):
                        if search_in_single_file(file_path, compiled_pattern, exclude_file, results, max_hits):
                            break
                    if len(results) >= max_hits:
                        break
                return results
        
        # Recherche normale dans lib
        for file_path in search_dir.rglob('*.dart'):
            search_in_single_file(file_path, compiled_pattern, exclude_file, results, max_hits)
            if len(results) >= max_hits:
                break
                
    except Exception as e:
        # Ignorer les erreurs
        pass
    
    return results


def search_in_single_file(file_path: Path, pattern: re.Pattern, exclude_file: Optional[str], 
                         results: List[Dict], max_hits: int) -> bool:
    """Recherche dans un seul fichier. Retourne True si on a atteint max_hits."""
    try:
        # Normaliser les chemins pour comparaison
        file_path_str = normalize_path(str(file_path.relative_to(BASE_DIR)))
        if exclude_file and file_path_str == normalize_path(exclude_file):
            return False
        
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            for line_num, line in enumerate(f, 1):
                if len(results) >= max_hits:
                    return True
                if pattern.search(line):
                    snippet = line.strip()[:100]  # Limiter à 100 caractères
                    results.append({
                        'file': file_path_str,
                        'line': str(line_num),
                        'snippet': snippet
                    })
    except Exception:
        pass
    return False


def run_ripgrep(pattern: str, exclude_file: Optional[str] = None, max_hits: int = MAX_HITS) -> List[Dict]:
    """Wrapper pour compatibilité - utilise maintenant search_in_files."""
    return search_in_files(pattern, exclude_file, max_hits)


def check_barrel_export(basename: str, file_path: str) -> List[Dict]:
    """Vérifie si le fichier est exporté via un barrel file."""
    pattern = f'export .*{re.escape(basename)}'
    results = run_ripgrep(pattern, exclude_file=file_path)
    return results


def check_occurrences_outside_file(name: str, file_path: str) -> Tuple[List[Dict], bool]:
    """
    Vérifie les occurrences du nom en dehors du fichier déclarant.
    Retourne (results, dynamic_usage_found)
    """
    # Pattern pour le nom exact (word boundary)
    pattern = rf'\b{re.escape(name)}\b'
    results = run_ripgrep(pattern, exclude_file=file_path)
    
    # Vérifier aussi les usages Riverpod/dynamiques
    dynamic_usage = False
    # Chercher ref.watch/ref.read avec le nom
    watch_pattern = rf'ref\.watch\s*\(\s*{re.escape(name)}'
    read_pattern = rf'ref\.read\s*\(\s*{re.escape(name)}'
    watch_results = run_ripgrep(watch_pattern, exclude_file=file_path, max_hits=1)
    read_results = run_ripgrep(read_pattern, exclude_file=file_path, max_hits=1)
    
    if watch_results or read_results:
        dynamic_usage = True
    
    # Chercher aussi .notifier et .family sur le nom
    notifier_pattern = rf'{re.escape(name)}\.notifier'
    family_pattern = rf'{re.escape(name)}\.family'
    notifier_results = run_ripgrep(notifier_pattern, exclude_file=file_path, max_hits=1)
    family_results = run_ripgrep(family_pattern, exclude_file=file_path, max_hits=1)
    
    if notifier_results or family_results:
        dynamic_usage = True
    
    return results, dynamic_usage


def check_basename_occurrences(basename: str, file_path: str) -> List[Dict]:
    """Vérifie les occurrences du basename."""
    pattern = re.escape(basename)
    results = run_ripgrep(pattern, exclude_file=file_path)
    return results


def check_generated_files(name: str) -> Tuple[List[Dict], bool]:
    """
    Vérifie si le symbole est référencé dans des fichiers générés.
    Retourne (results, found_in_generated)
    """
    pattern = rf'\b{re.escape(name)}\b'
    results = search_in_files(pattern, file_glob='*.g.dart', max_hits=MAX_HITS)
    found_in_generated = len(results) > 0
    return results, found_in_generated


def check_test_only(occurrences: List[Dict]) -> bool:
    """Vérifie si toutes les occurrences sont dans test/ ou integration_test/."""
    if not occurrences:
        return False
    
    for occ in occurrences:
        file_path = occ['file']
        if not (file_path.startswith('test/') or file_path.startswith('integration_test/')):
            return False
    
    return True


def classify_item(
    item: Dict,
    barrel_export: List[Dict],
    occurrences: List[Dict],
    dynamic_usage: bool,
    basename_occurrences: List[Dict],
    generated_refs: List[Dict],
    found_in_generated: bool,
    test_only: bool
) -> Tuple[str, str, List[Dict]]:
    """
    Classifie l'item selon les règles.
    Retourne (classification, suggested_action, evidence)
    """
    evidence = []
    
    # Construire la liste d'évidence
    if barrel_export:
        for exp in barrel_export[:3]:
            evidence.append({
                'kind': 'barrel_export',
                'file': exp['file'],
                'line': exp['line'],
                'snippet': exp['snippet']
            })
    
    for occ in occurrences[:3]:
        evidence.append({
            'kind': 'occurrence',
            'file': occ['file'],
            'line': occ['line'],
            'snippet': occ['snippet']
        })
    
    if generated_refs:
        for gen in generated_refs[:2]:
            evidence.append({
                'kind': 'generated_reference',
                'file': gen['file'],
                'line': gen['line'],
                'snippet': gen['snippet']
            })
    
    # Limiter à 5 éléments
    evidence = evidence[:5]
    
    # Règles de classification (ordre important)
    
    # 1. Dynamic usage = toujours needs_manual
    if dynamic_usage:
        return ('needs_manual', 'manual_review', evidence)
    
    # 2. Référencé dans fichiers générés = probablement utilisé
    if found_in_generated:
        if occurrences:
            return ('likely_used', 'manual_review', evidence)
        else:
            # Référencé uniquement dans généré = ambigu
            return ('needs_manual', 'manual_review', evidence)
    
    # 3. Exporté via barrel mais pas d'occurrence = ambigu
    if barrel_export and not occurrences:
        return ('needs_manual', 'add_export', evidence)
    
    # 4. Utilisé dans le code (hors tests)
    if occurrences:
        if test_only:
            # Uniquement dans les tests
            return ('needs_manual', 'write_provider_test', evidence)
        else:
            # Utilisé dans le code principal
            return ('likely_used', 'manual_review', evidence)
    
    # 5. Test-only sans occurrences = ambigu
    if test_only:
        return ('needs_manual', 'write_provider_test', evidence)
    
    # 6. Aucune trace = probablement orphelin
    if not occurrences and not barrel_export and not found_in_generated:
        return ('likely_orphan', 'archive', evidence)
    
    # 7. Cas ambigu (par exemple, barrel export avec occurrences dans tests)
    return ('needs_manual', 'manual_review', evidence)


def triage_item(item: Dict) -> Dict:
    """Effectue le triage complet d'un item."""
    # Normaliser le chemin
    file_path = normalize_path(item['file'])
    name = item['name']
    item_type = item['type']
    
    # Extraire basename
    basename = extract_basename(file_path)
    
    # Pour les symboles, utiliser le nom du symbole
    if item_type == 'symbol':
        search_name = name
    elif item_type == 'provider':
        search_name = name
    else:  # file
        # Pour les fichiers, chercher le nom du fichier (sans extension) et aussi les imports
        search_name = basename
    
    # 1. Vérifier exports barrel
    barrel_export = check_barrel_export(basename, file_path)
    
    # 2. Pour les fichiers, aussi chercher les imports
    file_imports = []
    if item_type == 'file':
        # Chercher "import '.../basename.dart'"
        import_pattern = rf"import\s+['\"].*{re.escape(basename)}\.dart['\"]"
        file_imports = run_ripgrep(import_pattern, exclude_file=file_path, max_hits=3)
    
    # 3. Vérifier occurrences hors fichier
    occurrences, dynamic_usage = check_occurrences_outside_file(search_name, file_path)
    
    # 4. Ajouter les imports aux occurrences pour les fichiers
    if item_type == 'file' and file_imports:
        occurrences.extend(file_imports)
    
    # 5. Vérifier occurrences du basename
    basename_occurrences = check_basename_occurrences(basename, file_path)
    
    # 6. Vérifier fichiers générés
    generated_refs, found_in_generated = check_generated_files(search_name)
    
    # 7. Vérifier test-only
    test_only = check_test_only(occurrences)
    
    # Classifier
    classification, suggested_action, evidence = classify_item(
        item,
        barrel_export,
        occurrences,
        dynamic_usage,
        basename_occurrences,
        generated_refs,
        found_in_generated,
        test_only
    )
    
    # Construire le résultat
    result = item.copy()
    result['classification'] = classification
    result['evidence'] = json.dumps(evidence, ensure_ascii=False)
    result['suggested_action'] = suggested_action
    
    # Notes supplémentaires
    notes_parts = []
    if item.get('note'):
        notes_parts.append(item['note'])
    if dynamic_usage:
        notes_parts.append('dynamic_usage_detected')
    if barrel_export:
        notes_parts.append(f'exported_via_barrel({len(barrel_export)})')
    if found_in_generated:
        notes_parts.append('referenced_in_generated')
    if test_only:
        notes_parts.append('test_only')
    
    result['notes'] = '; '.join(notes_parts) if notes_parts else ''
    
    return result


def main():
    """Fonction principale."""
    print("=" * 60)
    print("TRIAGE AUTOMATIQUE - Priority HIGH")
    print("=" * 60)
    
    # Lire le CSV
    csv_path = OUTPUT_DIR / 'orphans_summary.csv'
    print(f"\nLecture de {csv_path}...")
    
    high_priority_items = []
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row.get('priority', '').lower() == 'high':
                high_priority_items.append(row)
    
    print(f"Items priority=high trouvés: {len(high_priority_items)}")
    
    # Triage
    print("\nTriage en cours...")
    triaged_items = []
    
    for i, item in enumerate(high_priority_items, 1):
        print(f"  [{i}/{len(high_priority_items)}] {item['type']}: {item['name'][:50]}...")
        try:
            triaged = triage_item(item)
            triaged_items.append(triaged)
        except Exception as e:
            print(f"    ERREUR: {e}")
            # Ajouter quand même avec classification manuelle
            triaged = item.copy()
            triaged['classification'] = 'needs_manual'
            triaged['evidence'] = '[]'
            triaged['suggested_action'] = 'manual_review'
            triaged['notes'] = f'error: {str(e)}'
            triaged_items.append(triaged)
    
    # Statistiques
    counts_by_classification = defaultdict(int)
    for item in triaged_items:
        counts_by_classification[item['classification']] += 1
    
    ambiguous_count = counts_by_classification.get('needs_manual', 0)
    
    # Écrire CSV
    print("\nÉcriture des fichiers de sortie...")
    csv_output = OUTPUT_DIR / 'orphans_triage_high.csv'
    with open(csv_output, 'w', encoding='utf-8', newline='') as f:
        fieldnames = ['type', 'name', 'file', 'line', 'citation', 'source', 'priority',
                     'classification', 'evidence', 'notes', 'suggested_action']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for item in triaged_items:
            row = {k: item.get(k, '') for k in fieldnames}
            writer.writerow(row)
    
    print(f"  [OK] {csv_output}")
    
    # Écrire JSON
    json_output = OUTPUT_DIR / 'orphans_triage_high.json'
    json_data = {
        'total_processed': len(triaged_items),
        'counts_by_classification': dict(counts_by_classification),
        'ambiguous_count': ambiguous_count
    }
    
    with open(json_output, 'w', encoding='utf-8') as f:
        json.dump(json_data, f, indent=2, ensure_ascii=False)
    
    print(f"  [OK] {json_output}")
    
    # Écrire liste des ambigus
    ambiguous_output = OUTPUT_DIR / 'orphans_triage_high_ambiguous.txt'
    ambiguous_items = [item for item in triaged_items if item['classification'] == 'needs_manual']
    
    with open(ambiguous_output, 'w', encoding='utf-8') as f:
        f.write("Items nécessitant une revue manuelle (classification: needs_manual)\n")
        f.write("=" * 80 + "\n\n")
        
        for item in ambiguous_items:
            f.write(f"Type: {item['type']}\n")
            f.write(f"Name: {item['name']}\n")
            f.write(f"File: {item['file']}\n")
            if item.get('line'):
                f.write(f"Line: {item['line']}\n")
            f.write(f"Source: {item['source']}\n")
            f.write(f"Suggested Action: {item['suggested_action']}\n")
            if item.get('notes'):
                f.write(f"Notes: {item['notes']}\n")
            f.write("-" * 80 + "\n\n")
    
    print(f"  [OK] {ambiguous_output} ({len(ambiguous_items)} items)")
    
    # Résumé console
    print("\n" + "=" * 60)
    print("RÉSUMÉ")
    print("=" * 60)
    print(f"\nTotal traité: {len(triaged_items)}")
    print(f"\nPar classification:")
    for classification, count in sorted(counts_by_classification.items()):
        print(f"  - {classification}: {count}")
    
    print(f"\nItems nécessitant revue manuelle: {ambiguous_count}")
    
    # Top 20 needs_manual
    print(f"\nTop 20 items 'needs_manual':")
    needs_manual_sorted = sorted(
        ambiguous_items,
        key=lambda x: (x.get('file', ''), x.get('name', ''))
    )[:20]
    
    for i, item in enumerate(needs_manual_sorted, 1):
        print(f"  {i:2d}. [{item['type']:7s}] {item['name'][:45]:45s} | {item['suggested_action']:20s}")
    
    print("\n" + "=" * 60)


if __name__ == '__main__':
    main()

