import json
import os

base_dir = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n"
fr_path = os.path.join(base_dir, "intl_fr.arb")
en_path = os.path.join(base_dir, "intl_en.arb")

def load_keys(path):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        # Filter out metadata keys usually (keys starting with @ are metadata for the key without @)
        # But wait, ARB structure: "key": "val", "@key": {...}
        # We should check if the set of "real" keys is identical.
        return set(k for k in data.keys() if not k.startswith('@'))

def main():
    fr_keys = load_keys(fr_path)
    en_keys = load_keys(en_path)
    
    fr_only = fr_keys - en_keys
    en_only = en_keys - fr_keys
    
    if not fr_only and not en_only:
        print("SUCCESS: FR and EN files have identical keys.")
    else:
        print(f"FAILURE: Key mismatch.")
        if fr_only:
            print(f"Keys in FR but not EN ({len(fr_only)}): {list(fr_only)[:10]}...")
        if en_only:
            print(f"Keys in EN but not FR ({len(en_only)}): {list(en_only)[:10]}...")

if __name__ == "__main__":
    main()
