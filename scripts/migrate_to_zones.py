
import json
import os
import shutil
from collections import OrderedDict

# Configuration
BASE_DIR = r"c:\Users\roman\Documents\apppklod\permacalendarv2"
PLANTS_JSON = os.path.join(BASE_DIR, 'assets', 'data', 'plants.json')
ZONES_JSON = os.path.join(BASE_DIR, 'assets', 'data', 'zones.json')

# New logic: 
# Move specific month fields to referenceProfile
# Create zoneProfiles structure

FIELDS_TO_MOVE = ['sowingMonths', 'sowingMonths3', 'plantingMonths', 'plantingMonths3', 'harvestMonths', 'harvestMonths3']

def migrate_plant(plant):
    # check if already migrated
    if 'referenceProfile' in plant:
        return plant, False

    # Create reference profile (Europe)
    ref_profile = {
        "referenceId": "NH_temperate_europe",
        "phases": {}
    }

    has_data = False
    
    # Extract sowing
    sowing = plant.get('sowingMonths3') or plant.get('sowingMonths')
    if sowing:
        ref_profile['phases']['sowing'] = {"type": "months", "months": sowing}
        has_data = True
    
    # Extract planting
    planting = plant.get('plantingMonths3') or plant.get('plantingMonths')
    if planting:
        ref_profile['phases']['planting'] = {"type": "months", "months": planting}
        has_data = True
        
    # Extract harvest
    harvest = plant.get('harvestMonths3') or plant.get('harvestMonths')
    if harvest:
        ref_profile['phases']['harvest'] = {"type": "months", "months": harvest}
        has_data = True

    if not has_data:
        return plant, False

    # Construct new plant object
    # We want to keep the order of keys somewhat clean, so we put new fields after 'id' or 'commonName' if possible,
    # but dict order is insertion order in py3.7+. 
    
    # Apply changes
    plant['referenceProfile'] = ref_profile
    
    # Create default zoneProfiles
    plant['zoneProfiles'] = {
        "NH_temperate_na": {
            "preferRelativeRules": True 
            # We don't populate phases here yet, logic will fall back to reference or be manually overriden later
        },
        "SH_temperate": {
             "monthShift": 6
        }
    }

    # Remove old fields (optional? keeping them for backward compat might be safer for now, 
    # but the goal IS migration. Let's keep them for safety in the immediate term 
    # OR remove them to force usage of new system. 
    # User said: "Compatibility: on conserve sowingMonths / harvestMonths pour compatibilité ascendante." 
    # OK, so we KEEP them in the root.)
    
    # plant['sowingMonths3'] = ... (kept)

    return plant, True

def main():
    print(f"Reading {PLANTS_JSON}...")
    with open(PLANTS_JSON, 'r', encoding='utf-8') as f:
        data = json.load(f)

    plants = data.get('plants', [])
    migrated_count = 0
    
    for p in plants:
        _, changed = migrate_plant(p)
        if changed:
            migrated_count += 1

    print(f"Migrated {migrated_count} plants.")

    # Save
    if migrated_count > 0:
        # Backup first
        backup_path = PLANTS_JSON + ".bak"
        shutil.copy(PLANTS_JSON, backup_path)
        print(f"Backup created at {backup_path}")
        
        with open(PLANTS_JSON, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        print("File updated successfully.")
    else:
        print("No changes needed.")

if __name__ == '__main__':
    main()
