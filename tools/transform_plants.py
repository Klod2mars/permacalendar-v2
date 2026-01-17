import json
import os
import csv
import hashlib
from datetime import datetime

# Configuration
INPUT_FILE = r'assets/data/plants.json'
OUTPUT_TOKENIZED = r'assets/data/plants_tokenized.json'
OUTPUT_I18N_FR = r'assets/data/i18n/plants_fr.json'
REPORT_CSV = r'plants_i18n_report.csv'
REPORT_MD = r'plants_json_migration_report.md'

# Mappings (French -> Token)
SUN_EXPOSURE_MAP = {
    "Plein soleil": "SUN_FULL",
    "Mi-soleil": "SUN_PARTIAL",
    "Mi-ombre": "SUN_PARTIAL_SHADE",
    "Ombre": "SUN_SHADE"
}

WATER_NEEDS_MAP = {
    "Faible": "WATER_LOW",
    "Moyen": "WATER_MEDIUM",
    "Élevé": "WATER_HIGH",
    "Modéré": "WATER_MEDIUM",
    "Modéré à élevé": "WATER_MEDIUM_HIGH" 
}

SEASON_MAP = {
    "Printemps": "SPRING",
    "Été": "SUMMER",
    "Automne": "AUTUMN",
    "Hiver": "WINTER"
}

# Helper to map list of seasons (often comma separated in source)
def map_seasons(season_str):
    if not season_str: return []
    parts = [s.strip() for s in season_str.split(',')]
    mapped = []
    for p in parts:
        if p in SEASON_MAP:
            mapped.append(SEASON_MAP[p])
        else:
            mapped.append(p) # Fallback
    return mapped

def main():
    print(f"Reading {INPUT_FILE}...")
    with open(INPUT_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)

    plants_in = data.get('plants', [])
    plants_out = []
    i18n_fr = {}
    
    report_rows = []
    audit_log = []

    print(f"Processing {len(plants_in)} plants...")

    for p in plants_in:
        pid = p['id']
        p_out = p.copy()
        i18n_entry = {}

        # 1. Common Name
        i18n_entry['commonName'] = p.get('commonName', '')
        report_rows.append([pid, 'commonName', p.get('commonName', ''), 'Extracted'])
        # Keep commonName in tokenized for fallback/debugging or remove? 
        # Strategy says: plants.json -> codes... i18n -> texts. 
        # But commonly we might keep a dev name. Let's REMOVE it to force i18n usage, or keep as 'name_dev'.
        # Decision: Keep it as 'name_dev' for readability in JSON, but logic should use i18n.
        p_out['commonName_dev'] = p.pop('commonName', '')

        # 2. Description
        if 'description' in p:
            i18n_entry['description'] = p['description']
            report_rows.append([pid, 'description', '...', 'Extracted'])
            del p_out['description']

        # 3. Cultural Tips (List)
        if 'culturalTips' in p:
            i18n_entry['culturalTips'] = p['culturalTips']
            report_rows.append([pid, 'culturalTips', f"{len(p['culturalTips'])} items", 'Extracted'])
            del p_out['culturalTips']

        # 4. Biological Control
        if 'biologicalControl' in p:
            bc = p['biologicalControl']
            i18n_entry['biologicalControl'] = {}
            
            # Preparations
            if 'preparations' in bc:
                i18n_entry['biologicalControl']['preparations'] = bc['preparations']
                del bc['preparations']
            
            # Beneficial Insects - often contains names, keep as strings in i18n for now
            if 'beneficialInsects' in bc:
                i18n_entry['biologicalControl']['beneficialInsects'] = bc['beneficialInsects']
                del bc['beneficialInsects']
                
            # Companion Plants - names -> ideally mapping, but for now extract text
            if 'companionPlants' in bc:
                i18n_entry['biologicalControl']['companionPlants'] = bc['companionPlants']
                del bc['companionPlants']
            
            p_out['biologicalControl'] = bc # Empty skeleton or remaining tech fields

        # 5. Harvest Time
        if 'harvestTime' in p:
            i18n_entry['harvestTime'] = p['harvestTime']
            del p_out['harvestTime']

        # 6. Notification Messages
        if 'notificationSettings' in p:
            ns = p['notificationSettings']
            i18n_entry['notificationSettings'] = {}
            for notif_type, settings in ns.items():
                if isinstance(settings, dict) and 'message' in settings:
                    i18n_entry['notificationSettings'][notif_type] = {'message': settings['message']}
                    del settings['message']
                # Handle nested temperature alerts
                if notif_type == 'temperature_alert':
                     i18n_entry['notificationSettings']['temperature_alert'] = {}
                     for sub_key, sub_val in settings.items():
                         if isinstance(sub_val, dict) and 'message' in sub_val:
                             i18n_entry['notificationSettings']['temperature_alert'][sub_key] = {'message': sub_val['message']}
                             del sub_val['message']
            p_out['notificationSettings'] = ns

        # 7. Enum Tokenization
        # Sun Exposure
        sun = p.get('sunExposure')
        if sun:
            if sun in SUN_EXPOSURE_MAP:
                p_out['sunExposure'] = SUN_EXPOSURE_MAP[sun]
            else:
                audit_log.append(f"WARNING: Unknown sunExposure '{sun}' for {pid}")
                p_out['sunExposure'] = "UNKNOWN"

        # Water Needs
        water = p.get('waterNeeds')
        if water:
            # Handle partial matches or "Moderate to High" logic if needed, but dictionary covers observed cases
            found = False
            for k, v in WATER_NEEDS_MAP.items():
                if k.lower() in water.lower(): # Simple substring match for safety? No, exact map indicated in script logic better for consistency, but fuzzy needed for "Modéré à élevé" if not mapped
                     p_out['waterNeeds'] = v
                     found = True
                     break
            if not found:
                 # Check exact keys
                 if water in WATER_NEEDS_MAP:
                     p_out['waterNeeds'] = WATER_NEEDS_MAP[water]
                 else:
                     audit_log.append(f"WARNING: Unknown waterNeeds '{water}' for {pid}")
                     p_out['waterNeeds'] = "UNKNOWN"
        
        # Planting Seasons (String -> List of Enums)
        p_season = p.get('plantingSeason')
        if p_season:
             p_out['plantingSeason'] = map_seasons(p_season) # Becomes a list of CODES
        
        # Harvest Seasons
        h_season = p.get('harvestSeason')
        if h_season:
             p_out['harvestSeason'] = map_seasons(h_season)

        # Add to local map
        i18n_fr[pid] = i18n_entry
        plants_out.append(p_out)

    # Wrap up Output JSON
    output_tech = {
        "schema_version": "2.2.0",
        "metadata": {
            "generated_at": datetime.now().isoformat(),
            "source": "plants.json transformation",
            "total_plants": len(plants_out)
        },
        "plants": plants_out
    }

    print(f"Writing {OUTPUT_TOKENIZED}...")
    with open(OUTPUT_TOKENIZED, 'w', encoding='utf-8') as f:
        json.dump(output_tech, f, indent=2, ensure_ascii=False)

    print(f"Writing {OUTPUT_I18N_FR}...")
    with open(OUTPUT_I18N_FR, 'w', encoding='utf-8') as f:
        json.dump(i18n_fr, f, indent=2, ensure_ascii=False)

    print(f"Writing reports...")
    with open(REPORT_CSV, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['PlantID', 'Field', 'ValueSnippet', 'Action'])
        writer.writerows(report_rows)

    with open(REPORT_MD, 'w', encoding='utf-8') as f:
        f.write("# Plans JSON Migration Report\n\n")
        f.write(f"Generated at: {datetime.now()}\n\n")
        f.write("## Warnings / Ambiguities\n")
        if audit_log:
            for line in audit_log:
                f.write(f"- {line}\n")
        else:
            f.write("No warnings generated.\n")

    print("Done.")

if __name__ == "__main__":
    main()
