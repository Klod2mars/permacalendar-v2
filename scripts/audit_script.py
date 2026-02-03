import json

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_keys_recursive(data, prefix=''):
    keys = set()
    if isinstance(data, dict):
        for k, v in data.items():
            full_key = f"{prefix}.{k}" if prefix else k
            keys.add(full_key)
            keys.update(get_keys_recursive(v, full_key))
    elif isinstance(data, list):
        # For lists, we don't index by number for key comparison unless it's a list of objects
        pass
    return keys

def audit_files():
    original_path = 'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/plants.json'
    translated_path = 'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_de.json'

    original = load_json(original_path)
    translated = load_json(translated_path)

    # 1. Check Structure
    # Original is { ..., plants: [ {id: artichoke, ...}, ... ] }
    # Translated is { ..., plants: [ {id: artichoke, ...}, ... ] }
    
    print("--- Structure Check ---")
    
    # Map original plants by ID
    original_plants_map = {}
    if 'plants' in original and isinstance(original['plants'], list):
        for p in original['plants']:
            if 'id' in p:
                original_plants_map[p['id']] = p
    
    # Map translated plants by ID (key)
    translated_plants_map = {}
    if 'plants' in translated and isinstance(translated['plants'], list):
        for p in translated['plants']:
             if 'id' in p:
                 translated_plants_map[p['id']] = p

    print(f"Original Plants Count: {len(original_plants_map)}")
    print(f"Translated Plants Count: {len(translated_plants_map)}")

    # Check key consistency for each translated plant
    all_translated_keys_valid = True
    invalid_keys = []
    
    for pid, t_data in translated_plants_map.items():
        if pid not in original_plants_map:
            print(f"WARNING: Plant ID '{pid}' in translated file not found in original.")
            continue
            
        o_data = original_plants_map[pid]
        
        # Get all keys in t_data
        t_keys = get_keys_recursive(t_data)
        o_keys = get_keys_recursive(o_data)
        
        # Check if t_keys exist in o_keys
        # Note: Translated file might not have ALL keys (partial translation), but it shouldn't have NEW keys.
        for tk in t_keys:
            if tk not in o_keys:
                all_translated_keys_valid = False
                invalid_keys.append(f"{pid}: {tk}")


    if all_translated_keys_valid:
        print("SUCCESS: All keys in translated file exist in original file.")
    else:
        print(f"FAILURE: Found {len(invalid_keys)} invalid keys in translated file:")
        for k in invalid_keys:
            print(f"INVALID_KEY: {k}")

    # 2. Audit "cm" usage
    # print("\n--- Audit 'cm' Usage ---")
    # search_cm(translated)
    
    # print(f"Found {len(cm_occurrences)} strings containing 'cm':")
    # for path, text in cm_occurrences:
    #     print(f"[{path}]: {text[:100]}...")

if __name__ == '__main__':
    audit_files()
