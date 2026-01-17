import json
import os
import csv
import re
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
    "Ombre": "SUN_SHADE",
    "Ombre légère": "SUN_PARTIAL_SHADE", # Added
    "Plein soleil, Mi-ombre": "SUN_FULL_PARTIAL", # Added hybrid
    "Mi-ombre, Ombre": "SUN_PARTIAL_SHADE_SHADE" # Added hybrid
}

WATER_NEEDS_MAP = {
    "Faible": "WATER_LOW",
    "Moyen": "WATER_MEDIUM",
    "Élevé": "WATER_HIGH",
    "Modéré": "WATER_MEDIUM",
    "Modéré à élevé": "WATER_MEDIUM_HIGH",
    "Régulier": "WATER_MEDIUM", # Mapped as requested
    "Tres faible": "WATER_LOW"
}

SEASON_MAP = {
    "Printemps": "SPRING",
    "Été": "SUMMER",
    "Automne": "AUTUMN",
    "Hiver": "WINTER"
}

# Regex to find numbers/values in messages for templating
# Matches numbers like 25, 2.5, ranges 25-50, and simple units
VALUE_REGEX = re.compile(r'(\d+(?:[.,]\d+)?(?:-\d+(?:[.,]\d+)?)?)\s*([°a-zA-Z%]+)?')

def templatisze_message(msg):
    # Simple strategy: replace numbers with placeholders? 
    # Actually, simplistic replacement is dangerous. 
    # For now, we just pass the message as is to i18n, but we could try to identify known patterns.
    # The DoD asks for {{commonName}}, {{amount}} etc. 
    # Without NLP, hard to map "25-50 mm" to {{amount}} reliably for ALL strings.
    # We will mark it as requiring manual review in the report if it looks like a template candidate.
    return msg

def map_seasons(season_str):
    if not season_str: return []
    parts = [s.strip() for s in season_str.split(',')]
    mapped = []
    for p in parts:
        pk = p.capitalize() # normalize
        if pk in SEASON_MAP:
            mapped.append(SEASON_MAP[pk])
        else:
             # Try simple fuzzy match
             found = False
             for k, v in SEASON_MAP.items():
                 if k in pk: 
                     mapped.append(v)
                     found = True
                     break
             if not found:
                mapped.append("UNKNOWN_" + p)
    return list(set(mapped)) # Dedup

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

        # 1. Common Name - Remove from tokenized (legacy field handling)
        i18n_entry['commonName'] = p.get('commonName', '')
        report_rows.append([pid, 'commonName', p.get('commonName', ''), 'Extracted'])
        if 'commonName' in p_out: del p_out['commonName']
        p_out['commonName_legacy_dev'] = p.get('commonName', '') # For debug purposes only

        # 2. Description
        if 'description' in p:
            i18n_entry['description'] = p['description']
            report_rows.append([pid, 'description', '...', 'Extracted'])
            del p_out['description']
        
        # 3. Cultural Tips
        if 'culturalTips' in p:
            i18n_entry['culturalTips'] = p['culturalTips']
            del p_out['culturalTips']

        # 4. Biological Control
        if 'biologicalControl' in p:
            bc = p['biologicalControl']
            i18n_entry['biologicalControl'] = {}
            if 'preparations' in bc:
                i18n_entry['biologicalControl']['preparations'] = bc['preparations']
                del bc['preparations']
            if 'beneficialInsects' in bc:
                i18n_entry['biologicalControl']['beneficialInsects'] = bc['beneficialInsects']
                del bc['beneficialInsects']
            if 'companionPlants' in bc:
                i18n_entry['biologicalControl']['companionPlants'] = bc['companionPlants']
                del bc['companionPlants']
            p_out['biologicalControl'] = bc 

        # 5. Harvest Time
        if 'harvestTime' in p:
            i18n_entry['harvestTime'] = p['harvestTime']
            del p_out['harvestTime']

        # 6. Notifications
        if 'notificationSettings' in p:
            ns = p['notificationSettings']
            i18n_entry['notificationSettings'] = {}
            for notif_type, settings in ns.items():
                if isinstance(settings, dict) and 'message' in settings:
                    original_msg = settings['message']
                    # Tokenize message ? For now extract full string.
                    i18n_entry['notificationSettings'][notif_type] = {'message': original_msg}
                    del settings['message']
                
                if notif_type == 'temperature_alert':
                     i18n_entry['notificationSettings']['temperature_alert'] = {}
                     for sub_key, sub_val in settings.items():
                         if isinstance(sub_val, dict) and 'message' in sub_val:
                             i18n_entry['notificationSettings']['temperature_alert'][sub_key] = {'message': sub_val['message']}
                             del sub_val['message']
            p_out['notificationSettings'] = ns

        # 7. Enum Tokenization
        
        # Sun
        sun = p.get('sunExposure')
        if sun:
            # Normalize
            sun_norm = sun.replace("’", "'").strip()
            if sun_norm in SUN_EXPOSURE_MAP:
                p_out['sunExposure'] = SUN_EXPOSURE_MAP[sun_norm]
            else:
                # Try simple comma logic
                if "," in sun_norm:
                     parts = [s.strip() for s in sun_norm.split(',')]
                     if "Plein soleil" in parts and "Mi-ombre" in parts:
                         p_out['sunExposure'] = "SUN_FULL_PARTIAL"
                     else:
                         p_out['sunExposure'] = "UNKNOWN_" + sun_norm
                         audit_log.append(f"WARNING: Unknown sunExposure '{sun}' for {pid}")
                else:
                    p_out['sunExposure'] = "UNKNOWN_" + sun_norm
                    audit_log.append(f"WARNING: Unknown sunExposure '{sun}' for {pid}")

        # Water
        water = p.get('waterNeeds')
        if water:
            water_norm = water.split('(')[0].strip() # Remove comments like (surtout en été)
            if water_norm in WATER_NEEDS_MAP:
                p_out['waterNeeds'] = WATER_NEEDS_MAP[water_norm]
            else:
                 found = False
                 for k,v in WATER_NEEDS_MAP.items():
                     if k.lower() == water_norm.lower(): 
                         p_out['waterNeeds'] = v
                         found = True
                 if not found:
                     p_out['waterNeeds'] = "UNKNOWN_" + water
                     audit_log.append(f"WARNING: Unknown waterNeeds '{water}' for {pid}")

        # Seasons
        p_season = p.get('plantingSeason')
        if p_season:
             p_out['plantingSeason'] = map_seasons(p_season)
        
        h_season = p.get('harvestSeason')
        if h_season:
             p_out['harvestSeason'] = map_seasons(h_season)

        # Watering fields cleanup (often has free text)
        if 'watering' in p_out:
            w = p_out['watering']
            # We should move 'frequency', 'method', 'bestTime' to i18n instructions? 
            # Yes, these are text. The DoD says "suppression/renommage des champs textuels résiduels".
            # We'll extract them similarly to notification messages.
            i18n_entry['watering'] = {}
            for k in ['frequency', 'amount', 'method', 'bestTime']:
                if k in w:
                    i18n_entry['watering'][k] = w[k]
                    del w[k]
            p_out['watering'] = w # Should be empty or mostly empty now

        # Add to local map
        i18n_fr[pid] = i18n_entry
        plants_out.append(p_out)

    # Output writing...
    output_tech = {
        "schema_version": "2.2.0",
        "metadata": {
            "generated_at": datetime.now().isoformat(),
            "source": "plants.json transformation v2",
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
        f.write("# Plans JSON Migration Report V2\n\n")
        f.write(f"Generated at: {datetime.now()}\n\n")
        f.write("## Warnings / Ambiguities\n")
        if audit_log:
            for line in audit_log:
                f.write(f"- {line}\n")
        else:
            f.write("No warnings generated.\n")

    print("Done (v2).")

if __name__ == "__main__":
    main()
