import json
import os

mapping_file = 'image_mapping_plan.json'
target_files = [
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/plants.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_en.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_de.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_es.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_it.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_pt.json'
]

with open(mapping_file, 'r', encoding='utf-8') as f:
    mapping = json.load(f)

for file_path in target_files:
    if not os.path.exists(file_path):
        print(f"Skipping missing file: {file_path}")
        continue
        
    print(f"Processing {file_path}...")
    
    try:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"  SKIP: Invalid JSON in {file_path}: {e}")
            continue
            
        plants = []
        is_dict = False
        if isinstance(data, dict):
             plants = data.get('plants', [])
             is_dict = True
        elif isinstance(data, list):
             plants = data
        
        updated_count = 0
        
        for p in plants:
            pid = p.get('id')
            if pid in mapping:
                image_file = mapping[pid]
                
                # 1. Set Root Image (User's request usually implies visible field)
                p['image'] = image_file
                
                # 2. Set Metadata Image (Technical requirement for Hive)
                if 'metadata' not in p:
                    p['metadata'] = {}
                p['metadata']['image'] = image_file
                
                updated_count += 1
        
        # Write back
        if is_dict:
            data['plants'] = plants
        else:
            data = plants
            
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
            
        print(f"  Updated {updated_count} entries.")
        
    except Exception as e:
        print(f"  Error processing {file_path}: {e}")
