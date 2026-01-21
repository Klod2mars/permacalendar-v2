
import json
import os
import re

# ---------------------------------------------------------
# 1. DATA DEFINITIONS
# ---------------------------------------------------------

# Map French month abbreviations (3 letters) to English standard (3 letters, Capitalized)
MONTH_MAP = {
    "jan": "Jan", "fév": "Feb", "mar": "Mar", "avr": "Apr", "mai": "May", "jun": "Jun",
    "jul": "Jul", "aoû": "Aug", "sep": "Sep", "oct": "Oct", "nov": "Nov", "déc": "Dec"
}

# User provided data
# Fields: name, semis (sowing), plantation (planting)
RAW_DATA = [
    {"name": "Brocoli", "semis": "mar-jun", "plantation": "avr-aoû"},
    {"name": "Chou-fleur", "semis": "mar-jun", "plantation": "jun-aoû"},
    {"name": "Chou de Bruxelles", "semis": "mar-mai", "plantation": "mai-jun"},
    {"name": "Chou cabus rouge", "semis": "mar-jun", "plantation": "avr-jul"},
    {"name": "Chou pommé (cabus / Milan)", "semis": "fév-jun", "plantation": "avr-jul"}, # Likely ID: 'cabbage'
    {"name": "Chou kale", "semis": "avr-jun", "plantation": "mai-jul"},
    {"name": "Bok choy (pak choï)", "semis": "mar-sep", "plantation": "avr-sep"},
    {"name": "Chou mizuna", "semis": "avr-sep", "plantation": "mai-oct"},
    {"name": "Fève", "semis": "oct-nov, fév-avr", "plantation": "—"},
    {"name": "Haricot jaune", "semis": "avr-aoû", "plantation": "—"},
    {"name": "Haricot coco", "semis": "avr-jul", "plantation": "—"},
    {"name": "Maïs doux", "semis": "mar-jul", "plantation": "mai-jun"},
    {"name": "Courge / Potiron", "semis": "avr-mai", "plantation": "mai-jun"},
    {"name": "Melon", "semis": "fév-mai", "plantation": "avr-mai"},
    {"name": "Pomme de terre", "semis": "—", "plantation": "mar-avr"}, # Handling Plantation only
    {"name": "Oignon blanc (botte)", "semis": "aoû-sep, fév-mar", "plantation": "oct-fév"},
    {"name": "Radis noir", "semis": "jun-aoû", "plantation": "—"},
    {"name": "Salsifis", "semis": "mar-mai", "plantation": "—"},
    {"name": "Asperge", "semis": "avr", "plantation": "mar-mai"},
    {"name": "Artichaut", "semis": "mar-avr", "plantation": "mar-mai"},
    {"name": "Thym", "semis": "avr-mai", "plantation": "mar-mai, sep-oct"},
    {"name": "Romarin", "semis": "mar-mai", "plantation": "mar-mai, sep-oct"},
    {"name": "Aneth", "semis": "mar-jul", "plantation": "—"},
    {"name": "Coriandre", "semis": "mar-jul", "plantation": "—"},
    {"name": "Roquette", "semis": "mar-sep", "plantation": "—"}
]

# Manual Name Overrides to ensure matching with plants.json IDs
# commonName (from user) -> commonName (in json) OR direct ID mapping if needed?
# Actually we will try to match against 'commonName' in main file.
# If that fails, we can add a map here.
NAME_OVERRIDES = {
    "Chou pommé (cabus / Milan)": "Chou pommé",
    "Bok choy (pak choï)": "Bok choy", # guessed
    "Courge / Potiron": "Courge", # or Potiron?
    "Oignon blanc (botte)": "Oignon blanc" 
}

# ---------------------------------------------------------
# 2. HELPER FUNCTIONS
# ---------------------------------------------------------

def parse_month_range(range_str):
    """
    Parses 'mar-jun' or 'oct-nov, fév-avr' into a list of English 3-letter months.
    """
    if not range_str or range_str == "—" or range_str.strip() == "":
        return []
    
    months_ordered = ["jan", "fév", "mar", "avr", "mai", "jun", "jul", "aoû", "sep", "oct", "nov", "déc"]
    result = set()
    
    parts = range_str.split(',')
    for part in parts:
        part = part.strip()
        if '–' in part: # En dash
            start, end = part.split('–')
        elif '-' in part: # Hyphen
            start, end = part.split('-')
        else:
            # Single month
            if part in MONTH_MAP:
                result.add(MONTH_MAP[part])
            continue
        
        start = start.strip()
        end = end.strip()
        
        if start in months_ordered and end in months_ordered:
            s_idx = months_ordered.index(start)
            e_idx = months_ordered.index(end)
            
            if e_idx >= s_idx:
                # Normal range
                for i in range(s_idx, e_idx + 1):
                    result.add(MONTH_MAP[months_ordered[i]])
            else:
                # Wrap-around (e.g. nov-feb)
                for i in range(s_idx, 12):
                    result.add(MONTH_MAP[months_ordered[i]])
                for i in range(0, e_idx + 1):
                    result.add(MONTH_MAP[months_ordered[i]])
                    
    # Sort logically jan -> dec
    final_list = []
    eng_months_ordered = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    for m in eng_months_ordered:
        if m in result:
            final_list.append(m)
            
    return final_list

def get_plant_id(user_name, plants_data):
    """
    Finds the plant ID based on user_name matching commonName.
    """
    target_name = NAME_OVERRIDES.get(user_name, user_name)
    
    # 1. Exact match on commonName
    for p in plants_data:
        if p.get('commonName', '').lower() == target_name.lower():
            return p['id']
            
    # 2. Fuzzy / Contains math
    for p in plants_data:
        if target_name.lower() in p.get('commonName', '').lower():
             # Avoid false positives (e.g. 'Chou' matches everything)
             # But 'Chou kale' -> 'Chou kale' ok.
             # 'Courge' -> 'Courge' ok.
             return p['id']
             
    return None

# ---------------------------------------------------------
# 3. MAIN SCRIPT
# ---------------------------------------------------------

def main():
    base_dir = r"c:\Users\roman\Documents\apppklod\permacalendarv2"
    # Files to update: main plants.json AND all localized chunks if they exist
    files_to_update = [
        os.path.join(base_dir, "assets", "data", "plants.json"),
        os.path.join(base_dir, "assets", "data", "json_multilangue_doc", "plants_en.json"),
        os.path.join(base_dir, "assets", "data", "json_multilangue_doc", "plants_fr.json"), # If exists? Usually it's i18n
        os.path.join(base_dir, "assets", "data", "i18n", "plants_fr.json"),
        os.path.join(base_dir, "assets", "data", "json_multilangue_doc", "plants_de.json"),
        os.path.join(base_dir, "assets", "data", "json_multilangue_doc", "plants_es.json"),
        os.path.join(base_dir, "assets", "data", "json_multilangue_doc", "plants_it.json"),
        os.path.join(base_dir, "assets", "data", "json_multilangue_doc", "plants_pt.json"),
    ]
    
    # Load Main Data to get ID mapping
    main_file = files_to_update[0]
    with open(main_file, 'r', encoding='utf-8') as f:
        main_json = json.load(f)
        main_plants = main_json['plants']
        
    # Pre-calculate updates for each ID
    id_updates = {} # id -> {sowing: [], planting: []}
    
    print("--- Mapping Plants ---")
    for entry in RAW_DATA:
        pid = get_plant_id(entry['name'], main_plants)
        if pid:
            sowing = parse_month_range(entry['semis'])
            planting = parse_month_range(entry['plantation'])
            id_updates[pid] = {'sowingMonths3': sowing, 'plantingMonths3': planting}
            print(f"Matched '{entry['name']}' -> ID: {pid}. Sowing: {sowing}, Planting: {planting}")
        else:
            print(f"WARNING: No match found for '{entry['name']}'")

    print("\n--- Applying Updates ---")
    for fp in files_to_update:
        if not os.path.exists(fp):
            print(f"Skipping {fp} (not found)")
            continue
            
        print(f"Updating {fp}...")
        try:
            with open(fp, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            modified = False
            
            # Helper to find plant list (some files structure: {'plants': [...]}, others: {'id': {...}})
            # plants_fr.json structure is dict of keys: "artichoke": {...}
            # plants_en.json structure is list: "plants": [{...}]
            
            is_dict_format = False
            plants_list = []
            
            if isinstance(data, dict):
                if "plants" in data and isinstance(data["plants"], list):
                    plants_list = data["plants"]
                else:
                    # Assume dict format (plants_fr.json style)
                    # "artichoke": { ... }
                    is_dict_format = True
            
            if is_dict_format:
                # Iterate keys which are IDs
                for pid, content in data.items():
                    if pid in id_updates and isinstance(content, dict):
                        updates = id_updates[pid]
                        # Only update fields if they are missing or empty? 
                        # User said "compléter uniquement ces informations manquantes" (only missing info).
                        # But also said "intègres les données...".
                        # Assuming overwrite or fill is fine. 
                        # Let's FILL if empty or replace to be "chirurgical".
                        # Given user provided correct data, I'll overwrite to ensure correctness as shown in photos.
                        
                        if updates['sowingMonths3']:
                            content['sowingMonths3'] = updates['sowingMonths3']
                            modified = True
                        if updates['plantingMonths3']:
                            content['plantingMonths3'] = updates['plantingMonths3']
                            modified = True
                            
            else:
                # List format
                for p in plants_list:
                    pid = p.get('id')
                    if pid in id_updates:
                        updates = id_updates[pid]
                        if updates['sowingMonths3']:
                            p['sowingMonths3'] = updates['sowingMonths3']
                            modified = True
                        if updates['plantingMonths3']:
                            p['plantingMonths3'] = updates['plantingMonths3']
                            modified = True

            if modified:
                with open(fp, 'w', encoding='utf-8') as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)
                print("Saved.")
            else:
                print("No changes needed.")
                
        except Exception as e:
            print(f"Error updating {fp}: {e}")

if __name__ == "__main__":
    main()
