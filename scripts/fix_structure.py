import json
import argparse
import sys

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(data, path):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

def copy_translations(source_plant, trans_plant):
    # Copy simple string fields
    for key in ['commonName', 'description', 'sunExposure', 'waterNeeds', 'plantingSeason', 'harvestSeason', 'harvestTime']:
        if key in trans_plant:
            source_plant[key] = trans_plant[key]

    # Copy list of strings
    if 'culturalTips' in trans_plant and 'culturalTips' in source_plant:
        source_plant['culturalTips'] = trans_plant['culturalTips']
    
    # Copy biologicalControl text lists
    if 'biologicalControl' in trans_plant and 'biologicalControl' in source_plant:
        for key in ['preparations', 'beneficialInsects', 'companionPlants']:
            if key in trans_plant['biologicalControl']:
                source_plant['biologicalControl'][key] = trans_plant['biologicalControl'][key]

    # Copy companionPlanting lists (plant names translated)
    if 'companionPlanting' in trans_plant and 'companionPlanting' in source_plant:
        for key in ['beneficial', 'avoid']:
            if key in trans_plant['companionPlanting']:
                 source_plant['companionPlanting'][key] = trans_plant['companionPlanting'][key]

    # Copy watering/thinning/weeding TEXT (frequency, amount, method, when, recommendation, bestTime)
    for section in ['watering', 'thinning', 'weeding']:
        if section in trans_plant and section in source_plant:
             for key in ['frequency', 'amount', 'method', 'bestTime', 'when', 'distance', 'recommendation']:
                  if key in trans_plant[section]:
                       source_plant[section][key] = trans_plant[section][key]

    # Copy notificationSettings messages
    if 'notificationSettings' in trans_plant and 'notificationSettings' in source_plant:
        s_ns = source_plant['notificationSettings']
        t_ns = trans_plant['notificationSettings']
        
        for key in s_ns:
            if key in t_ns:
                # Standard pattern: field has "message"
                if 'message' in t_ns[key]:
                    s_ns[key]['message'] = t_ns[key]['message']
                
                # Temperature alert special case
                if key == 'temperature_alert':
                     if 'cold_alert' in t_ns[key] and 'cold_alert' in s_ns[key]:
                         if 'message' in t_ns[key]['cold_alert']:
                             s_ns[key]['cold_alert']['message'] = t_ns[key]['cold_alert']['message']
                     if 'germination_optimal' in t_ns[key] and 'germination_optimal' in s_ns[key]:
                         if 'message' in t_ns[key]['germination_optimal']:
                             s_ns[key]['germination_optimal']['message'] = t_ns[key]['germination_optimal']['message']
    
    # Copy nutritionPer100g unit? No, usually not translated but unit might be.
    if 'defaultUnit' in trans_plant:
        source_plant['defaultUnit'] = trans_plant['defaultUnit']
    if 'germination' in trans_plant and 'germinationTime' in trans_plant['germination']:
         if 'unit' in trans_plant['germination']['germinationTime']:
              source_plant['germination']['germinationTime']['unit'] = trans_plant['germination']['germinationTime']['unit']
    
    return source_plant

def fix_batch(clean_path, trans_path, output_path):
    clean_data = load_json(clean_path)
    trans_data = load_json(trans_path)
    
    # Map translated plants
    trans_map = {p['id']: p for p in trans_data}
    
    fixed_plants = []
    
    for s_plant in clean_data:
        pid = s_plant['id']
        if pid in trans_map:
            print(f"Fixing {pid}...")
            fixed = copy_translations(s_plant, trans_map[pid])
            fixed_plants.append(fixed)
        else:
            print(f"WARNING: Plant {pid} not found in translated file. Keeping original.")
            fixed_plants.append(s_plant)
            
    save_json(fixed_plants, output_path)
    print(f"Saved fixed batch to {output_path}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clean', required=True)
    parser.add_argument('--trans', required=True)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    
    fix_batch(args.clean, args.trans, args.output)
