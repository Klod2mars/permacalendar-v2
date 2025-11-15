#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
migrate_plants_to_3letter_months.py

But : convertir les tokens de mois (ex: "J","M","A","F"... ou déjà "Jan"/"Mar")
en abréviations de 3 lettres non ambiguës (ex: "Jan","Feb","Mar",...).

Fonctionnalités :
 - détecte format legacy (array) ou structured ({..., "plants":[...]})
 - collecte tous les tokens trouvés dans `sowingMonths` et `harvestMonths`
 - propose un mapping par défaut (heuristique) et permet l'interaction
 - option non-interactive avec `--mapping-file mapping.json`
 - sauvegarde automatique du fichier original (backup)
 - ajoute des champs non-destructifs `sowingMonths3` / `harvestMonths3` par défaut
 - option `--replace` pour remplacer `sowingMonths` / `harvestMonths` par les 3-letters
 - option `--add-month-map` : ajoute `metadata.month_map` avec le mapping utilisé
 - produit un rapport final

Usage exemple (interactif) :
  python migrate_plants_to_3letter_months.py --input assets/data/plants.json

Usage non interactif (avec mapping) :
  python migrate_plants_to_3letter_months.py --input assets/data/plants.json --mapping-file month_mapping.json --replace

"""

import argparse
import copy
import datetime
import json
import os
import sys
from collections import defaultdict

# Canonical 3-letter months (English-style — simple & unambiguous)
MONTHS_3 = {
    1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr",
    5: "May", 6: "Jun", 7: "Jul", 8: "Aug",
    9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"
}

# Reverse lookup for validation
MONTH_NAME_TO_NUM = {v.upper(): k for k, v in MONTHS_3.items()}

# Default proposals for single-letter tokens (these are proposals, interactive will confirm)
DEFAULT_PROPOSAL = {
    'J': ["Jan", "Jun", "Jul"],  # Jan / Jun / Jul
    'F': ["Feb"],
    'M': ["Mar", "May"],         # Mar / May
    'A': ["Apr", "Aug"],         # Apr / Aug
    'S': ["Sep"],
    'O': ["Oct"],
    'N': ["Nov"],
    'D': ["Dec"],
    # If other tokens appear, we will propose nothing and ask user
}

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def write_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"Wrote: {path}")

def backup_file(path):
    ts = datetime.datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
    dst = f"{path}.backup.{ts}"
    with open(path, "rb") as s, open(dst, "wb") as d:
        d.write(s.read())
    print(f"Backup created: {dst}")
    return dst

def find_plants_container(data):
    """Retourne (plants_list, is_root_list)"""
    if isinstance(data, list):
        return data, True
    if isinstance(data, dict) and isinstance(data.get("plants"), list):
        return data["plants"], False
    raise RuntimeError("Input must be an array of plants or an object with 'plants' list.")

def normalize_token(t):
    if t is None:
        return ""
    s = str(t).strip()
    return s

def token_is_3letter_month(token):
    if not token:
        return False
    t = token.strip()
    return t.upper() in MONTH_NAME_TO_NUM

def propose_for_token(token):
    t = token.strip().upper()
    if t in DEFAULT_PROPOSAL:
        return DEFAULT_PROPOSAL[t]
    # If token already numeric '3' => map to that month
    if t.isdigit():
        m = int(t)
        if 1 <= m <= 12:
            return [MONTHS_3[m]]
    # If 3-letter english exists (case-insensitive), keep it
    if len(t) == 3 and t.capitalize() in MONTH_NAME_TO_NUM:
        return [t.capitalize()]
    # else empty proposal
    return []

def interactive_resolve(unique_tokens, initial_mapping):
    mapping = dict(initial_mapping)  # copy
    print("\nInteractive mapping: associe chaque token trouvé à des abréviations 3 lettres.")
    print("Pour chaque token tu peux :")
    print(" - appuyer sur Entrée ou taper 'y' pour accepter la proposition")
    print(" - taper une liste séparée par des virgules, ex : Jan,Jul")
    print(" - taper 's' pour sauter (aucun mapping)")
    print(" - taper 'a' pour accepter la proposition pour tous les tokens restants\n")

    tokens = sorted([t for t in unique_tokens if t != ""])
    accept_all = False
    for token in tokens:
        if accept_all:
            continue
        current = mapping.get(token)
        proposal = current if current else propose_for_token(token)
        prop_str = ", ".join(proposal) if proposal else "(aucune proposition)"
        print(f"\nToken: '{token}'  -> proposition : {prop_str}")
        choice = input("Choix [y / Jan,Jul / s / a]: ").strip()
        if choice == "" or choice.lower() == "y":
            mapping[token] = proposal
        elif choice.lower() == "a":
            accept_all = True
            mapping[token] = proposal
        elif choice.lower() == "s":
            mapping[token] = []
        else:
            parts = [p.strip().capitalize() for p in choice.split(",") if p.strip()]
            validated = []
            for p in parts:
                # Accept if it's a known 3-letter month or numeric
                if p.upper() in MONTH_NAME_TO_NUM:
                    validated.append(p.capitalize())
                elif p.isdigit():
                    n = int(p)
                    if 1 <= n <= 12:
                        validated.append(MONTHS_3[n])
                    else:
                        print(f"Ignored invalid month number: {p}")
                else:
                    print(f"Ignored unrecognized month: {p}")
            mapping[token] = validated
    return mapping

def apply_mapping_to_tokens(tokens, mapping):
    """
    tokens: list of tokens (ex: ["F","M","A"] or ["Jan","Mar"])
    mapping: dict token -> list[str] (3-letter months)
    Returns : flattened unique list of 3-letter months
    """
    out = []
    for t in tokens:
        if t is None:
            continue
        s = normalize_token(t)
        if s == "":
            continue
        # if already 3-letter month => keep
        if token_is_3letter_month(s):
            out.append(s.capitalize())
            continue
        # mapping lookup (try exact then upper)
        mapped = mapping.get(s)
        if mapped is None:
            mapped = mapping.get(s.upper())
        if mapped is None:
            # try proposal automatically
            mapped = propose_for_token(s)
        out.extend(mapped or [])
    # deduplicate preserving order
    seen = set()
    result = []
    for m in out:
        mm = m.capitalize()
        if mm not in seen:
            seen.add(mm)
            result.append(mm)
    return result

def validate_mapping(mapping):
    """Vérifie que toutes les valeurs sont des abréviations 3-letter valides"""
    bad = {}
    for k, v in mapping.items():
        cleaned = []
        for item in v:
            if isinstance(item, str) and item.upper() in MONTH_NAME_TO_NUM:
                cleaned.append(item.capitalize())
            else:
                # try if number-like
                if isinstance(item, int) and 1 <= item <= 12:
                    cleaned.append(MONTHS_3[item])
                elif isinstance(item, str) and item.isdigit():
                    n = int(item)
                    if 1 <= n <= 12:
                        cleaned.append(MONTHS_3[n])
                    else:
                        bad.setdefault(k, []).append(item)
                else:
                    bad.setdefault(k, []).append(item)
        mapping[k] = cleaned
    return bad

def main():
    parser = argparse.ArgumentParser(description="Migrate plants.json tokens to 3-letter months")
    parser.add_argument("--input", "-i", required=True, help="Path to plants.json")
    parser.add_argument("--mapping-file", "-m", help="Optional mapping JSON file (token -> list of 3-letter months)")
    parser.add_argument("--non-interactive", action="store_true", help="Do not prompt (requires mapping-file or default proposals for all tokens)")
    parser.add_argument("--replace", action="store_true", help="Replace original sowingMonths/harvestMonths with 3-letter arrays (default: add sowingMonths3/havestMonths3)")
    parser.add_argument("--add-month-map", action="store_true", help="Add metadata.month_map with the resolved mapping (for reference)")
    parser.add_argument("--output", "-o", help="Optional output path (if omitted the input file is overwritten after backup)")
    args = parser.parse_args()

    # Load
    if not os.path.exists(args.input):
        print(f"Input file not found: {args.input}")
        sys.exit(1)
    data = load_json(args.input)
    try:
        plants, is_root_list = find_plants_container(data)
    except Exception as e:
        print("Error:", e)
        sys.exit(1)

    # Gather unique tokens
    unique_tokens = set()
    for p in plants:
        for field in ("sowingMonths", "harvestMonths"):
            val = p.get(field)
            if isinstance(val, list):
                for it in val:
                    unique_tokens.add(normalize_token(it))
            elif isinstance(val, (str, int)):
                unique_tokens.add(normalize_token(val))

    # Prepare initial mapping
    mapping = {}
    if args.mapping_file:
        if not os.path.exists(args.mapping_file):
            print(f"Mapping file not found: {args.mapping_file}")
            sys.exit(1)
        mapping_in = load_json(args.mapping_file)
        # normalize mapping: keys as-is, values to list of 3-letter months
        for k, v in mapping_in.items():
            if isinstance(v, list):
                mapping[k] = [ (str(it).capitalize() if isinstance(it, str) else MONTHS_3[int(it)]) for it in v if it ]
            else:
                mapping[k] = [str(v).capitalize()]
    else:
        # initialize mapping with defaults for tokens we know
        for t in unique_tokens:
            if t == "":
                continue
            if t.upper() in DEFAULT_PROPOSAL:
                mapping[t] = DEFAULT_PROPOSAL[t.upper()]
            elif token_is_3letter_month(t):
                mapping[t] = [t.capitalize()]

    # If interactive
    if not args.non_interactive:
        mapping = interactive_resolve(unique_tokens, mapping)

    # Validate mapping
    bad = validate_mapping(mapping)
    if bad:
        print("Mapping contains invalid entries:")
        for k, v in bad.items():
            print(f"  {k} -> {v}")
        print("Fix the mapping file or re-run interactively.")
        sys.exit(1)

    # Confirm mapping summary
    print("\n=== Final mapping ===")
    for k in sorted(mapping.keys()):
        if k.strip() == "":
            continue
        print(f"'{k}' -> {mapping[k]}")

    # Backup original
    backup_file(args.input)

    # Apply mapping to plants
    changed = 0
    for p in plants:
        p_changed = False
        for field in ("sowingMonths", "harvestMonths"):
            v = p.get(field, [])
            # Normalize to list
            if isinstance(v, list):
                tokens = v
            elif v is None:
                tokens = []
            else:
                tokens = [v]
            mapped = apply_mapping_to_tokens(tokens, mapping)
            # write non-destructive fields
            dest_field = "sowingMonths3" if field == "sowingMonths" else "harvestMonths3"
            if p.get(dest_field) != mapped:
                p[dest_field] = mapped
                p_changed = True
            if args.replace:
                # Replace original field with mapped 3-letter abbreviations
                if p.get(field) != mapped:
                    p[field] = mapped
                    p_changed = True
        if p_changed:
            changed += 1

    # Optionally add metadata.month_map
    if args.add_month_map:
        month_map = {k: v for k, v in mapping.items() if k.strip() != ""}
        if not is_root_list:
            if "metadata" not in data or not isinstance(data["metadata"], dict):
                data["metadata"] = {}
            data["metadata"]["month_map"] = month_map
        else:
            # if the file is just a list, create a top-level metadata container
            data = {"__migration_metadata": {"month_map": month_map}, "plants": plants}

    # Write output
    out_path = args.output if args.output else args.input
    write_json(out_path, data)
    print(f"\nDone. Plants modified: {changed}")
    if not args.replace:
        print("-> Non-destructive: fields 'sowingMonths3' and 'harvestMonths3' were added.")
    else:
        print("-> Destructive: original 'sowingMonths'/'harvestMonths' replaced by 3-letter months (--replace).")
    if args.add_month_map:
        print("-> month_map added to metadata (or __migration_metadata if legacy list file).")
    print("End.")
