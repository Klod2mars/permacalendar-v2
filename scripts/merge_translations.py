
import json
import os
import glob
import argparse

def merge_chunks(lang):
    base_dir = f"c:\\Users\\roman\\Documents\\apppklod\\permacalendarv2\\assets\\data\\temp_translations\\{lang}"
    output_file = f"c:\\Users\\roman\\Documents\\apppklod\\permacalendarv2\\assets\\data\\json_multilangue_doc\\plants_{lang}.json"
    
    print(f"Merging chunks for language: {lang}")
    print(f"Source: {base_dir}")
    print(f"Target: {output_file}")

    all_plants = []
    
    # Pattern to match all translated chunks
    # We want to ensure order, so we'll collect them and sort by name
    # Naming convention: translated_chunk_X_Y.json
    # X is batch index, Y is part (a or b)
    
    file_pattern = os.path.join(base_dir, "translated_chunk_*.json")
    files = glob.glob(file_pattern)
    
    if not files:
        print("No chunk files found!")
        return

    # Sort files to maintain original order as much as possible
    # We can rely on alphabetical sorting here because:
    # chunk_0_a, chunk_0_b, chunk_1_a ... chunk_10_a works correctly
    # But wait, chunk_10 would come after chunk_1 lexicographically if not careful?
    # Actually chunk_0 comes before chunk_1. chunk_10 comes after chunk_1.
    # We should sort by batch index and then part.
    
    def sort_key(filename):
        # Extract X and Y from filename
        basename = os.path.basename(filename)
        # expected: translated_chunk_X_Y.json
        parts = basename.replace("translated_chunk_", "").replace(".json", "").split("_")
        try:
            batch_idx = int(parts[0])
            if len(parts) > 1:
                part = parts[1]
            else:
                part = "" # Sorts before "a"
            return (batch_idx, part)
        except:
             return (999, basename) # degradation safe
        
    files.sort(key=sort_key)
    
    print(f"Found {len(files)} chunk files.")
    
    for fpath in files:
        print(f"Processing {os.path.basename(fpath)}...")
        try:
            with open(fpath, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
                # Check if data is a list (chunks are lists of plants)
                if isinstance(data, list):
                    all_plants.extend(data)
                elif isinstance(data, dict) and "plants" in data:
                     # Some chunks might be wrapped? No, my write_to_file calls wrote lists.
                     # But let's handle just in case.
                     all_plants.extend(data["plants"])
                else:
                    print(f"Warning: Unexpected format in {fpath}")
        except Exception as e:
            print(f"Error reading {fpath}: {e}")
            return

    # Create final structure
    final_json = {
        "plants": all_plants
    }
    
    # Write to output
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(final_json, f, indent=2, ensure_ascii=False)
        
    print(f"Successfully merged {len(all_plants)} plants into {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--lang", default="en", help="Language code (en, es, etc.)")
    args = parser.parse_args()
    merge_chunks(args.lang)
