import json
import os
import shutil
import collections
import argparse
import datetime
import csv
import hashlib

# Configuration
BASE_DIR = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n"
SOURCE_FILE = os.path.join(BASE_DIR, "intl_fr.arb")
TARGET_FILES = [
    os.path.join(BASE_DIR, "intl_en.arb"),
    os.path.join(BASE_DIR, "intl_de.arb"),
    os.path.join(BASE_DIR, "intl_es.arb"),
    os.path.join(BASE_DIR, "intl_it.arb"),
    os.path.join(BASE_DIR, "intl_pt.arb"),
]

def load_arb(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f, object_pairs_hook=collections.OrderedDict)

def save_arb(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')

def calculate_hash(path):
    if not os.path.exists(path): return "N/A"
    sha256_hash = hashlib.sha256()
    with open(path, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def check_icu_syntax(value):
    """Simple check for ICU syntax usage like plurals or selects."""
    if isinstance(value, str):
        if "{count, plural," in value or "{select," in value or "{" in value:
             return True
    return False

def main():
    parser = argparse.ArgumentParser(description="Synchronize ARB files with intl_fr.arb as source.")
    parser.add_argument("--dry-run", action="store_true", help="Preview changes without modifying files.")
    args = parser.parse_args()

    print(f"Loading source: {SOURCE_FILE}")
    if not os.path.exists(SOURCE_FILE):
        print(f"Error: Source file {SOURCE_FILE} not found.")
        return

    source_data = load_arb(SOURCE_FILE)
    source_keys = list(source_data.keys())
    
    report_data = [] # List of dicts for report
    
    csv_rows = []
    csv_rows.append(["File", "Key", "Action", "Value Preview", "ICU Warning"])

    for target_path in TARGET_FILES:
        lang_code = os.path.basename(target_path).replace("intl_", "").replace(".arb", "")
        print(f"\nProcessing {os.path.basename(target_path)}...")
        
        if not os.path.exists(target_path):
            print(f"Warning: Target file {target_path} not found. Skipping.")
            continue

        target_data = load_arb(target_path)
        
        # 1. Backup if not dry-run
        if not args.dry_run:
            timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
            backup_path = f"{target_path}.{timestamp}.bak"
            shutil.copy2(target_path, backup_path)
            print(f"  [Backup] Created {os.path.basename(backup_path)}")

        new_target_data = collections.OrderedDict()
        
        # Preserve @@locale
        if "@@locale" in target_data:
            new_target_data["@@locale"] = target_data["@@locale"]
        elif "@@locale" in source_data:
             # Try to smart-guess or just use filename code
             new_target_data["@@locale"] = lang_code 

        added_count = 0
        missing_count_before = 0
        
        # Check integrity before
        target_keys_set = set(target_data.keys())
        source_keys_set = set(k for k in source_keys if not k.startswith("@"))
        missing_keys = source_keys_set - target_keys_set
        missing_count_before = len(missing_keys)

        for key in source_keys:
            if key == "@@locale": continue
            
            # Identify if it is a metadata key
            is_meta = key.startswith("@")
            real_key = key[1:] if is_meta else key

            # LOGIC:
            # 1. If key exists in target, KEEP IT (Strict non-destructive)
            # 2. If key is missing, COPY FROM SOURCE
            # 3. If meta key matches an added real key, copy it.
            # 4. If meta key is missing for an EXISTING real key, copy it (optional, good for consistency)
            
            action = "Skipped (Exists)"
            value_preview = ""
            icu_warning = False

            if key in target_data:
                new_target_data[key] = target_data[key]
                # No action needed
            else:
                # Key MISSING in target
                
                # Special case: don't copy orphaned metadata if we didn't have the parent key? 
                # Actually, if we are iterating source order, we reach real key first usually or we just copy everything missing.
                
                val = source_data[key]
                new_target_data[key] = val
                added_count += 1
                action = "Added"
                value_preview = str(val)[:50].replace("\n", " ")
                
                if not is_meta and check_icu_syntax(val):
                    icu_warning = True
                    print(f"  [WARNING] Added key '{key}' contains potential ICU/Placeholder syntax.")

                report_item = {
                    "file": os.path.basename(target_path),
                    "key": key,
                    "action": action,
                    "value_preview": value_preview,
                    "icu_warning": icu_warning
                }
                report_data.append(report_item)
                csv_rows.append([os.path.basename(target_path), key, action, value_preview, "YES" if icu_warning else ""])

        print(f"  - Missing before: {missing_count_before}")
        print(f"  - Added: {added_count}")
        
        if not args.dry_run:
            save_arb(target_path, new_target_data)
            print(f"  [Saved] Updated {os.path.basename(target_path)}")
        else:
            print(f"  [Dry-Run] Would save {os.path.basename(target_path)}")

    # Write Reports
    report_file_json = "sync_report.json"
    report_file_csv = "sync_report.csv"
    
    with open(report_file_json, 'w', encoding='utf-8') as f:
        json.dump(report_data, f, indent=2, ensure_ascii=False)
    
    with open(report_file_csv, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(csv_rows)
        
    print(f"\nReports generated: {report_file_json}, {report_file_csv}")
    print("Synchronization process finished.")

if __name__ == "__main__":
    main()
