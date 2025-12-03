#!/usr/bin/env python3
# coding: utf-8
"""
scripts/generate_plants_merged.py

- Scanne assets/data/*.json and *.json.* files
- Shows first plant of each file (id + keys) for quick inspection
- Merges all plant entries into a normalized plants_merged.json
- Does NOT modify original files
"""
import os
import glob
import json
import argparse
import datetime
import re
from collections import defaultdict

MONTH_ORDER_3 = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
LETTER_MAP_FROM_3 = {
    'Jan':'J','Feb':'F','Mar':'M','Apr':'A','May':'M','Jun':'J',
    'Jul':'J','Aug':'A','Sep':'S','Oct':'O','Nov':'N','Dec':'D'
}

def normalize_months3(lst):
    if not isinstance(lst, list):
        return []
    seen = []
    for m in lst:
        if not isinstance(m, str): continue
        mm = m.strip().title()
        if mm in MONTH_ORDER_3 and mm not in seen:
            seen.append(mm)
    # sort
    seen.sort(key=lambda x: MONTH_ORDER_3.index(x))
    return seen

def one_letter_months_from_3(months3):
    out = []
    for m in months3:
        if isinstance(m, str):
            mm = m.strip().title()
            if mm in LETTER_MAP_FROM_3:
                code = LETTER_MAP_FROM_3[mm]
            else:
                code = mm[:1].upper()
            if code not in out:
                out.append(code)
    return out

def to_num_if_possible(v):
    if v is None:
        return None
    if isinstance(v, (int,float)):
        return v
    if isinstance(v, str):
        s = v.strip()
        # try integer
        try:
            return int(s)
        except:
            try:
                return float(s.replace(',', '.'))
            except:
                return v
    return v

def split_to_list(s):
    if s is None:
        return []
    if isinstance(s, list):
        return [str(x).strip() for x in s if str(x).strip()]
    if isinstance(s, str):
        parts = re.split(r'[,;\/\-\—\–]', s)
        out = [p.strip() for p in parts if p.strip()]
        return out
    return []

def normalize_companion_list(lst):
    if not lst:
        return []
    out = []
    for x in lst:
        if not isinstance(x, str): continue
        v = x.strip().lower()
        if not v: continue
        if v not in out:
            out.append(v)
    return out

def merge_lists_union(a,b):
    a = a or []
    b = b or []
    out = []
    for item in (a + b):
        if item not in out:
            out.append(item)
    return out

def merge_objects(a,b):
    if not isinstance(a, dict):
        return b
    out = dict(a)
    for k,v in (b or {}).items():
        if k not in out or out[k] in (None, "", []):
            out[k] = v
            continue
        # both exist
        ak = out[k]
        if isinstance(ak, dict) and isinstance(v, dict):
            out[k] = merge_objects(ak, v)
        elif isinstance(ak, list) and isinstance(v, list):
            out[k] = merge_lists_union(ak, v)
        elif isinstance(ak, list) and isinstance(v, str):
            out[k] = merge_lists_union(ak, split_to_list(v))
        elif isinstance(ak, str) and isinstance(v, list):
            out[k] = merge_lists_union(split_to_list(ak), v)
        else:
            # both primitive: keep existing if not empty, else take new
            if out[k] in (None, "") and v not in (None, ""):
                out[k] = v
            # otherwise keep out[k]
    return out

def normalize_plant(p):
    # In-place normalization
    if not isinstance(p, dict):
        return p
    # biologicalControl.companionPlants string -> array
    bc = p.get('biologicalControl')
    if isinstance(bc, dict):
        comp = bc.get('companionPlants')
        if comp is not None:
            comp_list = split_to_list(comp)
            bc['companionPlants'] = normalize_companion_list(comp_list)
    # companionPlanting.* normalize lists
    cp = p.get('companionPlanting')
    if isinstance(cp, dict):
        if 'beneficial' in cp:
            cp['beneficial'] = normalize_companion_list(cp['beneficial'])
        if 'avoid' in cp:
            cp['avoid'] = normalize_companion_list(cp['avoid'])
    # ensure companionPlanting exists if biologicalControl.companionPlants present
    if isinstance(bc, dict) and bc.get('companionPlants'):
        if not isinstance(cp, dict):
            p['companionPlanting'] = {'beneficial': normalize_companion_list(bc.get('companionPlants')), 'avoid': []}
        else:
            # merge into companionPlanting.beneficial
            ben = cp.get('beneficial', [])
            cp['beneficial'] = normalize_companion_list(merge_lists_union(ben, bc.get('companionPlants')))
    # months 3
    if 'sowingMonths3' in p:
        p['sowingMonths3'] = normalize_months3(p.get('sowingMonths3', []))
    if 'harvestMonths3' in p:
        p['harvestMonths3'] = normalize_months3(p.get('harvestMonths3', []))
    # build 1-letter months from 3 if missing
    if 'sowingMonths' not in p and 'sowingMonths3' in p:
        p['sowingMonths'] = one_letter_months_from_3(p['sowingMonths3'])
    if 'harvestMonths' not in p and 'harvestMonths3' in p:
        p['harvestMonths'] = one_letter_months_from_3(p['harvestMonths3'])
    # numeric conversions for temperatures
    g = p.get('germination')
    if isinstance(g, dict):
        if 'minTemperature' in g: g['minTemperature'] = to_num_if_possible(g['minTemperature'])
        if 'optimalTemperature' in g and isinstance(g['optimalTemperature'], dict):
            ot = g['optimalTemperature']
            if 'min' in ot: ot['min'] = to_num_if_possible(ot['min'])
            if 'max' in ot: ot['max'] = to_num_if_possible(ot['max'])
    gr = p.get('growth')
    if isinstance(gr, dict):
        if 'minTemperature' in gr: gr['minTemperature'] = to_num_if_possible(gr['minTemperature'])
        if 'idealTemperature' in gr and isinstance(gr['idealTemperature'], dict):
            it = gr['idealTemperature']
            if 'min' in it: it['min'] = to_num_if_possible(it['min'])
            if 'max' in it: it['max'] = to_num_if_possible(it['max'])
    # ensure notificationSettings exists (skeleton)
    if 'notificationSettings' not in p or not isinstance(p['notificationSettings'], dict):
        p['notificationSettings'] = {}
    ns = p['notificationSettings']
    # ensure watering, thinning, and harvest skeletons
    ns.setdefault('watering', {'enabled': False, 'frequency': '7 days', 'message': ''})
    ns.setdefault('thinning', {'enabled': False, 'daysAfterPlanting': 28, 'message': ''})
    ns.setdefault('biological_control', {'enabled': False, 'conditions': [], 'message': ''})
    ns.setdefault('harvest', {'enabled': False, 'daysAfterPlanting': p.get('daysToMaturity', 60), 'message': ''})
    ns.setdefault('temperature_alert', {'enabled': False})
    # Normalize companionPlanting keys to lists if present as strings
    if 'companionPlanting' in p and isinstance(p['companionPlanting'], dict):
        cp = p['companionPlanting']
        for key in ('beneficial','avoid'):
            if key in cp:
                if isinstance(cp[key], str):
                    cp[key] = normalize_companion_list(split_to_list(cp[key]))
                elif isinstance(cp[key], list):
                    cp[key] = normalize_companion_list(cp[key])
    return p

def read_first_plant(path):
    try:
        with open(path, encoding='utf-8') as fh:
            data = json.load(fh)
        if isinstance(data, dict) and 'plants' in data and isinstance(data['plants'], list):
            return data['plants'][0] if data['plants'] else None
        if isinstance(data, list):
            return data[0] if data else None
    except Exception as e:
        print("Error reading", path, e)
    return None

def read_all_plants(path):
    try:
        with open(path, encoding='utf-8') as fh:
            data = json.load(fh)
        if isinstance(data, dict) and 'plants' in data and isinstance(data['plants'], list):
            return data['plants'], data.get('metadata')
        if isinstance(data, list):
            return data, None
    except Exception as e:
        print("Error reading", path, e)
    return [], None

def parse_date_score(s):
    if not s:
        return 0
    if isinstance(s, (int,float)):
        return int(s)
    try:
        # ISO format might contain Z
        if s.endswith('Z'):
            s2 = s[:-1]
            dt = datetime.datetime.fromisoformat(s2)
        else:
            dt = datetime.datetime.fromisoformat(s)
        return int(dt.timestamp())
    except:
        # try YYYY-MM-DD
        try:
            dt = datetime.datetime.strptime(s, '%Y-%m-%d')
            return int(dt.timestamp())
        except:
            return 0

def choose_best_and_merge(entries, prefer_plants_json=False):
    # entries: list of (plant, source_path, metadata)
    # strategy: sort entries by (from_plants_json_bonus, keycount, metadata_date)
    def score(e):
        plant, path, meta = e
        kcount = len(plant.keys()) if isinstance(plant, dict) else 0
        date_score = parse_date_score(meta.get('updated_at') if isinstance(meta, dict) else (meta or '')) if meta else 0
        bonus = 1 if prefer_plants_json and os.path.basename(path) == 'plants.json' else 0
        return (bonus, kcount, date_score)
    entries_sorted = sorted(entries, key=lambda e: score(e), reverse=True)
    # merge in that order, starting from top (highest priority)
    merged = {}
    for pl, path, meta in entries_sorted:
        merged = merge_objects(merged, pl)
    merged = normalize_plant(merged)
    return merged

def main():
    parser = argparse.ArgumentParser(description="Generate plants_merged.json from assets/data")
    parser.add_argument('--data-dir', default='assets/data', help='Path to assets/data')
    parser.add_argument('--out-file', default=os.path.join('assets','data','plants_merged.json'), help='Output merged file')
    args = parser.parse_args()

    data_dir = args.data_dir
    out_file = args.out_file

    patterns = [os.path.join(data_dir, '*.json'), os.path.join(data_dir, '*.json.*')]
    files = []
    for p in patterns:
        files.extend(glob.glob(p))
    files = sorted(list(set(files)))
    if not files:
        print("No JSON files found in", data_dir)
        return

    print("Found files:")
    for f in files:
        print("  -", f)

    print("\nFirst plant in each file:")
    for f in files:
        fp = read_first_plant(f)
        if fp:
            print(f"- {os.path.basename(f)}: id={fp.get('id')} keys={len(fp.keys())} keys_preview={list(fp.keys())[:12]}")
        else:
            print(f"- {os.path.basename(f)}: (no plants or empty)")

    # gather all entries
    all_by_id = defaultdict(list)  # id -> list of (plant, path, metadata)
    for f in files:
        plants, metadata = read_all_plants(f)
        for pl in plants:
            pid = pl.get('id') or pl.get('commonName')
            if not pid:
                continue
            all_by_id[pid].append((pl, f, metadata))

    print("\nMerging plants (total distinct ids):", len(all_by_id))
    merged_plants = []
    # prefer plants.json if present as primary source
    prefer_plants_json = any(os.path.basename(f)=='plants.json' for f in files)
    for pid, entries in all_by_id.items():
        merged = choose_best_and_merge(entries, prefer_plants_json=prefer_plants_json)
        # final safety: ensure id is present
        if 'id' not in merged:
            merged['id'] = pid
        merged_plants.append(merged)

    # final metadata
    metadata = {
        "version": "merged_v1",
        "updated_at": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "total_plants": len(merged_plants),
        "source": "merged_from_assets"
    }

    final = {
        "schema_version": "2.1.0",
        "metadata": metadata,
        "plants": sorted(merged_plants, key=lambda x: x.get('id') or x.get('commonName',''))
    }

    os.makedirs(os.path.dirname(out_file), exist_ok=True)
    with open(out_file, 'w', encoding='utf-8') as fh:
        json.dump(final, fh, ensure_ascii=False, indent=2)

    print("\nWrote merged file:", out_file)
    print("Total plants merged:", len(merged_plants))
    # short sample for beetroot if present
    sample = next((p for p in merged_plants if p.get('id') in ('beetroot','betterave')), None)
    if sample:
        print("\nSample (beetroot) keys:", list(sample.keys())[:40])
        # print compact sample ID+companionPlanting
        print("beetroot companionPlanting:", sample.get('companionPlanting'))
    else:
        print("\nNo beetroot found in merged output (check IDs).")

if __name__ == '__main__':
    main()
