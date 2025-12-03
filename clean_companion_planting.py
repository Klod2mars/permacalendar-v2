#!/usr/bin/env python3
# coding: utf-8
"""
Clean companionPlanting in plants_merged.json:
- remove items in companionPlanting.beneficial that contain "éviter" or "eviter"
- try to extract plant names from such phrases and add to companionPlanting.avoid
- store the original phrase(s) in companionPlanting.notes (list) for traceability
- write a cleaned output JSON
"""
import json, re, argparse, sys, os

EVITER_RE = re.compile(r"""(?:é|e)viter\s+(?:les?|la|le|l'|des)?\s*([^\(\,\;]+)""", re.I)

def split_names(s):
    # split by "et", comma, slash, semicolon
    parts = re.split(r'\s*(?:,|/|;|\bet\b|\bavec\b|\bplus\b)\s*', s, flags=re.I)
    out = []
    for p in parts:
        p = p.strip()
        # remove trailing parenthesis or notes
        p = re.sub(r'\(.*\)$','', p).strip()
        if p:
            out.append(p.lower())
    return out

def process_plant(p):
    cp = p.get('companionPlanting') or {}
    # ensure structure
    if 'beneficial' in cp and isinstance(cp['beneficial'], list):
        new_ben = []
        avoid = cp.get('avoid', []) or []
        notes = cp.get('notes', []) or []
        changed = False
        for item in cp['beneficial']:
            if not isinstance(item, str):
                new_ben.append(item)
                continue
            txt = item.strip()
            # detect "éviter" or "eviter"
            if re.search(r'\b(eviter|évider|éviter)\b', txt, re.I) or 'éviter' in txt.lower() or 'eviter' in txt.lower():
                # try to extract plant names
                m = EVITER_RE.search(txt)
                if m:
                    names_str = m.group(1).strip()
                    names = split_names(names_str)
                    for nm in names:
                        if nm and nm not in avoid:
                            avoid.append(nm)
                else:
                    # fallback: try to get words after 'éviter'
                    parts = re.split(r'\b(eviter|éviter)\b', txt, flags=re.I)
                    if len(parts) >= 3:
                        names = split_names(parts[2])
                        for nm in names:
                            if nm and nm not in avoid:
                                avoid.append(nm)
                # keep the original phrase as note for traceability
                if txt not in notes:
                    notes.append(txt)
                changed = True
            else:
                new_ben.append(txt)
        cp['beneficial'] = new_ben
        cp['avoid'] = sorted(list(dict.fromkeys(avoid)))  # dedup preserve order
        if notes:
            cp['notes'] = notes
        if changed:
            p['companionPlanting'] = cp
    return p

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--in', dest='infile', default='assets/data/plants_merged.json')
    parser.add_argument('--out', dest='outfile', default='assets/data/plants_merged_clean.json')
    args = parser.parse_args()

    if not os.path.exists(args.infile):
        print("Input not found:", args.infile, file=sys.stderr)
        sys.exit(2)

    with open(args.infile, 'r', encoding='utf-8') as fh:
        data = json.load(fh)

    plants = data.get('plants', [])
    modified = 0
    for i, p in enumerate(plants):
        before = json.dumps(p.get('companionPlanting', {}), ensure_ascii=False)
        new_p = process_plant(p)
        after = json.dumps(new_p.get('companionPlanting', {}), ensure_ascii=False)
        if before != after:
            modified += 1
            plants[i] = new_p

    data['plants'] = plants
    # update metadata
    meta = data.get('metadata', {})
    meta['cleaned_at'] = meta.get('cleaned_at', []) + ["clean_companionPlanting"]
    data['metadata'] = meta

    with open(args.outfile, 'w', encoding='utf-8') as fh:
        json.dump(data, fh, ensure_ascii=False, indent=2)

    print(f"Done. plants processed: {len(plants)} ; modified: {modified}")
    print("Output written to:", args.outfile)

if __name__ == '__main__':
    main()
