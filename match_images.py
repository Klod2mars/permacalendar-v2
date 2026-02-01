import json
import os
import re

json_path_fr = 'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/plants.json'
assets_dir_1 = 'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/images/plants'
assets_dir_2 = 'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/images/legumes'

def normalize(s):
    if not s: return ""
    s = s.strip().lower()
    accents = {
        'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
        'ç': 'c',
        'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
        'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
        'ñ': 'n',
        'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
        'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
        'ý': 'y', 'ÿ': 'y'
    }
    for k, v in accents.items():
        s = s.replace(k, v)
    # Replace spaces and hyphens with underscores
    s = re.sub(r'[\s\-]+', '_', s)
    # Remove non-alphanumeric/underscore
    s = re.sub(r'[^\w_]', '', s)
    return s

# List all available images
available_images = {}
for d in [assets_dir_1, assets_dir_2]:
    if os.path.exists(d):
        for f in os.listdir(d):
            if f.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
                name_no_ext = os.path.splitext(f)[0]
                available_images[name_no_ext] = f
                # Also index normalized version if different
                norm = normalize(name_no_ext)
                if norm != name_no_ext:
                    available_images[norm] = f

print(f"Found {len(available_images)} images.")

with open(json_path_fr, 'r', encoding='utf-8') as f:
    data = json.load(f)
    plants = data.get('plants', [])

    matches = 0
    missing = 0
    
    proposed_updates = {}

    for p in plants:
        pid = p.get('id')
        name = p.get('commonName')
        existing_image = p.get('image') or p.get('metadata', {}).get('image')
        
        target_filename = None
        
        # Strategy A: Use Existing
        if existing_image:
            # Check if it exists
            base = os.path.splitext(existing_image)[0]
            if existing_image in available_images.values() or base in available_images:
                 target_filename = existing_image
            else:
                 print(f"WARNING: Plant {name} has image {existing_image} but not found on disk.")
        
        # Strategy B: Derive from Name (Preferred if no existing)
        if not target_filename:
            candidate = normalize(name)
            if candidate in available_images:
                target_filename = available_images[candidate]
            # Try ID as fallback
            elif normalize(pid) in available_images:
                 target_filename = available_images[normalize(pid)]
        
        if target_filename:
            matches += 1
            proposed_updates[pid] = target_filename
            # print(f"MATCH: {name} -> {target_filename}")
        else:
            missing += 1
            print(f"MISSING: {name} (ID: {pid}) -> Candidate: {normalize(name)}")

    print(f"Total Matches: {matches}")
    print(f"Total Missing: {missing}")
    
    # Save a mapping plan
    with open('image_mapping_plan.json', 'w', encoding='utf-8') as out:
        json.dump(proposed_updates, out, indent=2)
