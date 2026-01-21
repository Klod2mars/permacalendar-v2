
import json
import os

TARGET_IDS = ["lentil", "climbing_bean", "gobo", "beetroot"]

def main():
    base_dir = r"c:\Users\roman\Documents\apppklod\permacalendarv2\assets\data"
    source_file = os.path.join(base_dir, "plants.json")
    
    # Load Source
    source_map = {}
    with open(source_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
        for p in data['plants']:
            if p['id'] in TARGET_IDS:
                source_map[p['id']] = {
                    "sowing": p.get("sowingMonths3", []),
                    "planting": p.get("plantingMonths3", [])
                }
                print(f"Loaded source for {p['id']}: Sowing={len(source_map[p['id']]['sowing'])} months")

    # Target Files
    targets = [
        "json_multilangue_doc/plants_es.json",
        "json_multilangue_doc/plants_de.json",
        "json_multilangue_doc/plants_it.json",
        "json_multilangue_doc/plants_pt.json",
        # Maybe French too?
        "json_multilangue_doc/plants_fr.json",
        "i18n/plants_fr.json"
    ]

    for t_rel in targets:
        fp = os.path.join(base_dir, t_rel)
        if not os.path.exists(fp):
            continue
            
        print(f"Updating {t_rel}...")
        try:
            with open(fp, 'r', encoding='utf-8') as f:
                t_data = json.load(f)
            
            modified = False
            
            # Helper for list vs dict
            is_list = False
            iterable = []
            if isinstance(t_data, dict) and "plants" in t_data and isinstance(t_data["plants"], list):
                is_list = True
                iterable = t_data["plants"]
            elif isinstance(t_data, list):
                is_list = True
                iterable = t_data
            elif isinstance(t_data, dict):
                # Dict of IDs
                is_list = False
                iterable = t_data.items()
            
            if is_list:
                for p in iterable:
                    pid = p.get('id')
                    if pid in source_map:
                        src = source_map[pid]
                        # Update Sowing if empty/missing
                        if not p.get('sowingMonths3'):
                            p['sowingMonths3'] = src['sowing']
                            modified = True
                        # Update Planting if empty/missing
                        if not p.get('plantingMonths3'):
                             p['plantingMonths3'] = src['planting']
                             modified = True
            else:
                for pid, content in iterable:
                    if pid in source_map:
                        src = source_map[pid]
                        if isinstance(content, dict):
                             if not content.get('sowingMonths3'):
                                 content['sowingMonths3'] = src['sowing']
                                 modified = True
                             if not content.get('plantingMonths3'):
                                 content['plantingMonths3'] = src['planting']
                                 modified = True
                                 
            if modified:
                with open(fp, 'w', encoding='utf-8') as f:
                    json.dump(t_data, f, indent=2, ensure_ascii=False)
                print("  -> Saved changes.")
            else:
                print("  -> No changes needed.")

        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    main()
