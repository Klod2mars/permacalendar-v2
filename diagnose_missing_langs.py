
import json
import os

def find_ids_and_data():
    base_dir = r"c:\Users\roman\Documents\apppklod\permacalendarv2\assets\data"
    
    # 1. Load Reference Data (Source of Truth)
    # Try plants.json first
    ref_file = os.path.join(base_dir, "plants.json")
    ref_data = {}
    with open(ref_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        if "plants" in data and isinstance(data["plants"], list):
            for p in data["plants"]:
                ref_data[p['id']] = {
                    "sowing": p.get("sowingMonths3"),
                    "planting": p.get("plantingMonths3"),
                    "commonName_en": p.get("commonName") # usually english or mixed
                }

    print(f"Reference data loaded: {len(ref_data)} plants.")

    # 2. Inspect Target Files to find IDs for specific names
    targets = [
        {"file": "json_multilangue_doc/plants_es.json", "names": ["Lenteja", "Judía de Enrame", "Gobo", "Gobo (Bardana)"]},
        {"file": "json_multilangue_doc/plants_de.json", "names": ["Rote Bete"]}
    ]

    for t in targets:
        fp = os.path.join(base_dir, t["file"])
        if not os.path.exists(fp):
            print(f"File not found: {t['file']}")
            continue
            
        print(f"\nScanning {t['file']}...")
        with open(fp, 'r', encoding='utf-8') as f:
            t_data = json.load(f)
        
        # Determine format
        items = []
        if isinstance(t_data, dict) and "plants" in t_data:
            items = t_data["plants"] # list
        elif isinstance(t_data, dict):
             # Dict of IDs or raw dict?
             # Check if first value is dict
             first_val = next(iter(t_data.values())) if t_data else None
             if isinstance(first_val, dict) and "commonName" in first_val:
                 # ID -> content map
                 items = [{"id": k, **v} for k, v in t_data.items()]
             else:
                 print("Unknown dict format")
        elif isinstance(t_data, list):
            items = t_data
            
        # Search for names
        for desired in t["names"]:
            found = False
            for item in items:
                cn = item.get("commonName", "")
                if desired.lower() in cn.lower():
                    pid = item.get("id")
                    print(f"  Found '{desired}' -> ID: '{pid}', commonName: '{cn}'")
                    # Check what we have in Ref for this ID
                    if pid in ref_data:
                        print(f"    Ref Data ({pid}): Sowing={ref_data[pid]['sowing']}, Planting={ref_data[pid]['planting']}")
                    else:
                        print(f"    WARNING: ID '{pid}' not found in Reference plants.json")
                    found = True
            
            if not found:
                print(f"  '{desired}' NOT FOUND in {t['file']}")

if __name__ == "__main__":
    find_ids_and_data()
