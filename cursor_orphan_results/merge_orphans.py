#!/usr/bin/env python3
"""
Script de fusion des données d'analyse d'orphelins
Fusionne unreferenced_files.txt, orphan_providers.txt et unused_symbols.txt
en un CSV unifié et un JSON de statistiques.
"""

import re
import csv
import json
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Optional, Tuple

# Patterns pour les priorités
HIGH_PRIORITY_PATTERNS = [
    'core/services', 'core/data', 'core/models', 'core/models/v2',
    'core/repositories', 'migration', 'intelligence', 'plant_intelligence',
    'features/plant_intelligence'
]

MEDIUM_PRIORITY_PATTERNS = [
    'core/providers', 'features', 'core/di', 'core/aggregation',
    'core/utils', 'core/widgets', 'features/garden', 'features/planting'
]

LOW_PRIORITY_PATTERNS = [
    'experimental', 'presentation/placeholders', 'widgets/placeholders',
    'presentation/experimental', 'shared/widgets'
]


def normalize_path(path: str) -> str:
    """Normalise un chemin en utilisant / comme séparateur."""
    return path.replace('\\', '/')


def extract_citation(text: str) -> str:
    """Extrait la citation (marqueur 【...】) du texte."""
    match = re.search(r'【([^】]+)】', text)
    return match.group(1) if match else ''


def determine_priority(file_path: str) -> str:
    """Détermine la priorité basée sur le chemin du fichier."""
    normalized = normalize_path(file_path.lower())
    
    # Vérifier high priority
    for pattern in HIGH_PRIORITY_PATTERNS:
        if pattern in normalized:
            return 'high'
    
    # Vérifier medium priority
    for pattern in MEDIUM_PRIORITY_PATTERNS:
        if pattern in normalized:
            return 'medium'
    
    # Vérifier low priority
    for pattern in LOW_PRIORITY_PATTERNS:
        if pattern in normalized:
            return 'low'
    
    # Défaut: medium pour les autres
    return 'medium'


def parse_unreferenced_files(content: str) -> List[Dict]:
    """Parse le fichier unreferenced_files.txt."""
    entries = []
    lines = content.split('\n')
    
    for line in lines:
        line = line.strip()
        if not line or 'Non référencé:' not in line:
            continue
        
        # Extraire le chemin
        match = re.search(r'Non référencé:\s*(.+?)(?:\s*【|$)', line)
        if not match:
            continue
        
        file_path = match.group(1).strip()
        normalized_path = normalize_path(file_path)
        
        citation = extract_citation(line)
        priority = determine_priority(normalized_path)
        
        # Déterminer si c'est un placeholder/demo
        note = ''
        if any(p in normalized_path.lower() for p in ['placeholder', 'demo', 'experimental']):
            note = 'likely placeholder/demo'
        
        entries.append({
            'type': 'file',
            'name': normalized_path,
            'file': normalized_path,
            'line': '',
            'citation': citation,
            'source': 'unreferenced_files',
            'priority': priority,
            'note': note
        })
    
    return entries


def parse_orphan_providers(content: str) -> List[Dict]:
    """Parse le fichier orphan_providers.txt."""
    entries = []
    lines = content.split('\n')
    
    current_provider = None
    current_file = None
    current_line = None
    
    for line in lines:
        line = line.strip()
        if not line or line.startswith('='):
            continue
        
        # Pattern: ORPHELIN: <name> (declared in <file>:<line>)
        match = re.search(r'ORPHELIN:\s*(\w+)\s*\(declared in\s*([^:)]+):(\d+)\)', line)
        if match:
            provider_name = match.group(1)
            file_path = match.group(2).strip()
            line_num = match.group(3)
            
            normalized_path = normalize_path(file_path)
            citation = extract_citation(line)
            priority = determine_priority(normalized_path)
            
            # Vérifier si c'est un provider family
            note = ''
            if '.family' in line.lower():
                note = 'likely used via .family'
            
            entries.append({
                'type': 'provider',
                'name': provider_name,
                'file': normalized_path,
                'line': line_num,
                'citation': citation,
                'source': 'orphan_providers',
                'priority': priority,
                'note': note
            })
    
    return entries


def parse_unused_symbols(content: str) -> List[Dict]:
    """Parse le fichier unused_symbols.txt."""
    entries = []
    lines = content.split('\n')
    
    current_file = None
    
    for line in lines:
        line = line.strip()
        if not line:
            continue
        
        # Pattern: == Fichier: <path>
        file_match = re.search(r'==\s*Fichier:\s*(.+)', line)
        if file_match:
            current_file = normalize_path(file_match.group(1).strip())
            continue
        
        # Pattern: - <kind>: <name> @ligne <N>
        symbol_match = re.search(r'-\s*(\S+):\s*(\S+)\s*@ligne\s*(\d+)', line)
        if symbol_match and current_file:
            kind = symbol_match.group(1)
            name = symbol_match.group(2)
            line_num = symbol_match.group(3)
            
            citation = extract_citation(line)
            priority = determine_priority(current_file)
            
            note = ''
            if 'export' not in kind.lower() and 'private' not in kind.lower():
                note = 'export missing'
            
            entries.append({
                'type': 'symbol',
                'name': name,
                'file': current_file,
                'line': line_num,
                'citation': citation,
                'source': 'unused_symbols',
                'priority': priority,
                'note': note
            })
    
    return entries


def merge_entries(all_entries: List[Dict]) -> Tuple[List[Dict], List[Dict], int]:
    """Fusionne les entrées en gérant les duplications."""
    merged = {}
    ambiguous = []
    duplicates_merged = 0
    
    for entry in all_entries:
        # Clé de fusion: type + name + file
        key = (entry['type'], entry['name'], entry['file'])
        
        if key in merged:
            # Fusionner les sources
            existing = merged[key]
            if entry['source'] not in existing['source'].split(';'):
                existing['source'] += f";{entry['source']}"
                duplicates_merged += 1
            
            # Conserver la citation la plus précise (avec ligne si disponible)
            if not existing['line'] and entry['line']:
                existing['line'] = entry['line']
                existing['citation'] = entry['citation']
            elif existing['line'] and not entry['line']:
                pass  # Garder l'existante
            elif not existing['citation'] and entry['citation']:
                existing['citation'] = entry['citation']
            
            # Fusionner les notes
            if entry['note'] and entry['note'] not in existing['note']:
                if existing['note']:
                    existing['note'] += f"; {entry['note']}"
                else:
                    existing['note'] = entry['note']
            
            # Priorité: garder la plus haute
            priority_order = {'high': 3, 'medium': 2, 'low': 1}
            if priority_order.get(entry['priority'], 0) > priority_order.get(existing['priority'], 0):
                existing['priority'] = entry['priority']
        else:
            merged[key] = entry.copy()
    
    # Vérifier les cas ambigus
    for entry in merged.values():
        if entry['type'] == 'provider' and not entry['file']:
            ambiguous.append({
                'entry': entry,
                'reason': 'Provider sans chemin de fichier'
            })
        elif not entry['line'] and entry['type'] in ['provider', 'symbol']:
            # Pas vraiment ambigu, mais on note
            pass
    
    return list(merged.values()), ambiguous, duplicates_merged


def escape_csv_field(field: str) -> str:
    """Échappe un champ CSV."""
    if not field:
        return ''
    field = str(field)
    if '"' in field or ',' in field or '\n' in field:
        escaped = field.replace('"', '""')
        return f'"{escaped}"'
    return field


def write_csv(entries: List[Dict], output_path: Path):
    """Écrit le fichier CSV."""
    with open(output_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        
        # En-tête
        writer.writerow(['type', 'name', 'file', 'line', 'citation', 'source', 'priority', 'note'])
        
        # Données
        for entry in entries:
            writer.writerow([
                entry['type'],
                entry['name'],
                entry['file'],
                entry['line'],
                entry['citation'],
                entry['source'],
                entry['priority'],
                entry['note']
            ])


def main():
    """Fonction principale."""
    # Déterminer le répertoire de base (où se trouvent les fichiers d'analyse)
    script_path = Path(__file__).resolve()
    base_dir = script_path.parent
    
    # Lire les fichiers
    print("Lecture des fichiers d'analyse...")
    
    with open(base_dir / 'unreferenced_files.txt', 'r', encoding='utf-8') as f:
        unreferenced_content = f.read()
    
    with open(base_dir / 'orphan_providers.txt', 'r', encoding='utf-8') as f:
        providers_content = f.read()
    
    with open(base_dir / 'unused_symbols.txt', 'r', encoding='utf-8') as f:
        symbols_content = f.read()
    
    # Parser
    print("Parsing des données...")
    file_entries = parse_unreferenced_files(unreferenced_content)
    provider_entries = parse_orphan_providers(providers_content)
    symbol_entries = parse_unused_symbols(symbols_content)
    
    print(f"  - Fichiers non référencés: {len(file_entries)}")
    print(f"  - Providers orphelins: {len(provider_entries)}")
    print(f"  - Symboles non utilisés: {len(symbol_entries)}")
    
    # Fusionner
    all_entries = file_entries + provider_entries + symbol_entries
    merged_entries, ambiguous, duplicates_merged = merge_entries(all_entries)
    
    print(f"\nFusion terminée:")
    print(f"  - Entrées totales: {len(all_entries)}")
    print(f"  - Entrées fusionnées: {len(merged_entries)}")
    print(f"  - Duplications fusionnées: {duplicates_merged}")
    print(f"  - Cas ambigus: {len(ambiguous)}")
    
    # Calculer les statistiques
    counts = {
        'files': sum(1 for e in merged_entries if e['type'] == 'file'),
        'providers': sum(1 for e in merged_entries if e['type'] == 'provider'),
        'symbols': sum(1 for e in merged_entries if e['type'] == 'symbol')
    }
    
    priorities = {
        'high': sum(1 for e in merged_entries if e['priority'] == 'high'),
        'medium': sum(1 for e in merged_entries if e['priority'] == 'medium'),
        'low': sum(1 for e in merged_entries if e['priority'] == 'low')
    }
    
    # Extraire le total de fichiers analysés
    total_files_match = re.search(r'Total fichiers analysés:\s*(\d+)', unreferenced_content)
    total_files_analyzed = int(total_files_match.group(1)) if total_files_match else None
    
    # Écrire le CSV principal
    print("\nÉcriture du CSV principal...")
    csv_path = base_dir / 'orphans_summary.csv'
    write_csv(merged_entries, csv_path)
    print(f"  [OK] {csv_path}")
    
    # Écrire un échantillon pour les symboles si > 2000
    symbol_entries_only = [e for e in merged_entries if e['type'] == 'symbol']
    if len(symbol_entries_only) > 2000:
        print(f"\nÉcriture d'un échantillon de symboles (200 premiers sur {len(symbol_entries_only)})...")
        sample_path = base_dir / 'orphans_summary_symbols_sample.csv'
        write_csv(symbol_entries_only[:200], sample_path)
        print(f"  [OK] {sample_path}")
    
    # Écrire le JSON
    print("\nÉcriture du JSON de statistiques...")
    json_data = {
        'total_files_analyzed': total_files_analyzed,
        'counts': counts,
        'priorities': priorities,
        'duplicates_merged': duplicates_merged
    }
    
    json_path = base_dir / 'orphans_summary.json'
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(json_data, f, indent=2, ensure_ascii=False)
    print(f"  [OK] {json_path}")
    
    # Écrire les cas ambigus
    if ambiguous:
        print("\nÉcriture des cas ambigus...")
        ambiguous_path = base_dir / 'orphans_summary_ambiguous.txt'
        with open(ambiguous_path, 'w', encoding='utf-8') as f:
            f.write("Cas ambigus détectés:\n")
            f.write("=" * 60 + "\n\n")
            for item in ambiguous:
                entry = item['entry']
                f.write(f"Type: {entry['type']}\n")
                f.write(f"Name: {entry['name']}\n")
                f.write(f"File: {entry['file']}\n")
                f.write(f"Raison: {item['reason']}\n")
                f.write("-" * 60 + "\n")
        print(f"  [OK] {ambiguous_path}")
    
    # Afficher le résumé
    print("\n" + "=" * 60)
    print("RÉSUMÉ")
    print("=" * 60)
    print(f"\nFichiers générés:")
    print(f"  - {csv_path}")
    print(f"  - {json_path}")
    if len(symbol_entries_only) > 2000:
        print(f"  - {base_dir / 'orphans_summary_symbols_sample.csv'}")
    if ambiguous:
        print(f"  - {base_dir / 'orphans_summary_ambiguous.txt'}")
    
    print(f"\nTotaux:")
    print(f"  - Fichiers: {counts['files']}")
    print(f"  - Providers: {counts['providers']}")
    print(f"  - Symboles: {counts['symbols']}")
    print(f"  - Total: {len(merged_entries)}")
    
    print(f"\nPar priorité:")
    print(f"  - High: {priorities['high']}")
    print(f"  - Medium: {priorities['medium']}")
    print(f"  - Low: {priorities['low']}")
    
    # Top 20 high priority
    high_priority = [e for e in merged_entries if e['priority'] == 'high']
    
    def get_priority_rank(entry):
        """Détermine le rang de priorité pour le tri."""
        file_lower = entry['file'].lower()
        for i, pattern in enumerate(HIGH_PRIORITY_PATTERNS):
            if pattern in file_lower:
                return i
        return 999  # Si aucun pattern n'est trouvé
    
    high_priority.sort(key=lambda x: (get_priority_rank(x), x['file'], x['type']))
    
    print(f"\nTop 20 high priority items:")
    for i, entry in enumerate(high_priority[:20], 1):
        print(f"  {i:2d}. [{entry['type']:7s}] {entry['name'][:50]:50s} | {entry['file'][:50]:50s} | {entry['citation'][:30]}")
    
    print("\n" + "=" * 60)


if __name__ == '__main__':
    main()

