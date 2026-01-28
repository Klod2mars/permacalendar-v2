import json
import os
import glob
import collections

BASE_DIR = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n"
FILES = ["intl_en.arb", "intl_de.arb", "intl_es.arb", "intl_it.arb", "intl_pt.arb"]

def load_keys(path):
    if not os.path.exists(path): return set()
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f, object_pairs_hook=collections.OrderedDict)
        return set(data.keys())

stats = []

for filename in FILES:
    current_path = os.path.join(BASE_DIR, filename)
    backups = glob.glob(os.path.join(BASE_DIR, f"{filename}.*.bak"))
    backups.sort(key=os.path.getmtime, reverse=True)
    
    backup_path = backups[0] if backups else None
    
    pre_keys_count = 0
    if backup_path:
        pre_keys = load_keys(backup_path)
        pre_keys_count = len(pre_keys)
    
    post_keys = load_keys(current_path)
    post_keys_count = len(post_keys)
    
    diff = post_keys_count - pre_keys_count
    
    stats.append({
        "file": filename,
        "pre": pre_keys_count,
        "post": post_keys_count,
        "diff": diff
    })

print(json.dumps(stats, indent=2))
