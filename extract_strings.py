import json

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def extract_strings(data):
    """
    Extracts only string fields defined in our translation scope.
    """
    translated_plants = {}
    
    plants = data.get('plants', [])
    
    # Fields to translate
    root_fields = ['commonName', 'description', 'sunExposure', 'waterNeeds', 
                   'plantingSeason', 'harvestSeason', 'harvestTime']
    
    for plant in plants:
        pid = plant.get('id')
        if not pid: continue
        
        entry = {}
        
        # Root Strings
        for f in root_fields:
            if f in plant and isinstance(plant[f], str):
                entry[f] = plant[f]
                
        # Watering
        if 'watering' in plant:
            w = plant['watering']
            w_entry = {}
            for k in ['frequency', 'amount', 'method', 'bestTime']:
                 if k in w: w_entry[k] = w[k]
            if w_entry: entry['watering'] = w_entry

        # Thinning
        if 'thinning' in plant:
            t = plant['thinning']
            t_entry = {}
            for k in ['distance', 'when']:
                 if k in t: t_entry[k] = t[k]
            if t_entry: entry['thinning'] = t_entry
            
        # Weeding
        if 'weeding' in plant:
            w = plant['weeding']
            w_entry = {}
            for k in ['method', 'frequency', 'recommendation']:
                 if k in w: w_entry[k] = w[k]
            if w_entry: entry['weeding'] = w_entry

        # Arrays
        if 'culturalTips' in plant:
            entry['culturalTips'] = plant['culturalTips']
            
        # Biological Control
        if 'biologicalControl' in plant:
            bc = plant['biologicalControl']
            bc_entry = {}
            if 'preparations' in bc: bc_entry['preparations'] = bc['preparations']
            if 'beneficialInsects' in bc: bc_entry['beneficialInsects'] = bc['beneficialInsects']
            if 'companionPlants' in bc: bc_entry['companionPlants'] = bc['companionPlants']
            if bc_entry: entry['biologicalControl'] = bc_entry
            
        # Companion Planting (Text lists only)
        if 'companionPlanting' in plant:
            cp = plant['companionPlanting']
            cp_entry = {}
            # beneficial/avoid are usually just list of IDs/Names, but sometimes contain text like "pois (intercalaire)"
            if 'beneficial' in cp: cp_entry['beneficial'] = cp['beneficial']
            if 'avoid' in cp: cp_entry['avoid'] = cp['avoid']
            if cp_entry: entry['companionPlanting'] = cp_entry
            
        # Notifications (Messages only)
        if 'notificationSettings' in plant:
            ns = plant['notificationSettings']
            ns_entry = {}
            for k, v in ns.items():
                if isinstance(v, dict) and 'message' in v:
                    ns_entry[k] = {'message': v['message']}
            if ns_entry: entry['notificationSettings'] = ns_entry

        translated_plants[pid] = entry

    # Wrap in overlay structure
    output = {
        "schema_version": "overlay_v1",
        "metadata": {"lang": "fr_source_text_only"},
        "plants": [ {pid: data} for pid, data in translated_plants.items() ] 
        # Wait, the user prompt asked for { "pid": {data} }. 
        # But my previous verification saw [ { "pid": {data} } ].
        # I will match the requested simpler Map structure: { "pid1": {...}, "pid2": {...} } 
        # which is cleaner for the overlay file.
    }
    
    # Actually, let's output a MAP { "artichoke": {...}, "basil": {...} } directly.
    # It consumes less tokens due to fewer brackets.
    
    final_overlay = {}
    for pid, data in translated_plants.items():
        final_overlay[pid] = data
        
    return final_overlay

if __name__ == '__main__':
    data = load_json('c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/plants.json')
    extracted = extract_strings(data)
    
    print(json.dumps(extracted, ensure_ascii=False, indent=2))
