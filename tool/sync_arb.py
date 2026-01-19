import json
import os
import collections

# Define paths
base_dir = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n"
source_file = os.path.join(base_dir, "intl_en.arb")
target_files = [
    os.path.join(base_dir, "intl_de.arb"),
    os.path.join(base_dir, "intl_es.arb"),
    os.path.join(base_dir, "intl_it.arb"),
    os.path.join(base_dir, "intl_pt.arb"),
]

def load_arb(path):
    with open(path, 'r', encoding='utf-8') as f:
        # Use OrderedDict to maintain order if possible, though we will sort by source key order
        return json.load(f, object_pairs_hook=collections.OrderedDict)

def save_arb(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n') # Add newline at end of file

def main():
    print(f"Loading source: {source_file}")
    if not os.path.exists(source_file):
        print(f"Error: Source file {source_file} not found.")
        return

    source_data = load_arb(source_file)
    source_keys = list(source_data.keys())

    # Metadata keys verification (optional)
    # We will simply ensure that for every key in source, it exists in target.
    # If not, we copy the value from source.
    # We also attempt to copy the '@key' metadata if it exists and is missing in target.

    for target_path in target_files:
        if not os.path.exists(target_path):
            print(f"Warning: Target file {target_path} not found. Skipping.")
            continue
            
        print(f"Processing {target_path}...")
        target_data = load_arb(target_path)
        
        # We'll create a new OrderedDict to reconstruct the file in the same order as source
        new_target_data = collections.OrderedDict()
        
        # Preserve locale if it exists at the top
        if "@@locale" in target_data:
            new_target_data["@@locale"] = target_data["@@locale"]
        elif "@@locale" in source_data:
             # Try to guess locale from filename if missing
             filename = os.path.basename(target_path)
             if "_" in filename:
                 code = filename.split("_")[1].split(".")[0]
                 new_target_data["@@locale"] = code

        added_count = 0
        
        for key in source_keys:
            if key == "@@locale":
                continue
                
            # If key exists in target, keep it
            if key in target_data:
                new_target_data[key] = target_data[key]
            else:
                # Missing key: copy from source
                new_target_data[key] = source_data[key]
                added_count += 1
        
        print(f"  - Added {added_count} missing keys.")
        save_arb(target_path, new_target_data)

    print("Synchronization complete.")

if __name__ == "__main__":
    main()
