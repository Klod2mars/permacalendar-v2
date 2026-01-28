import json
import collections

FR = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n\intl_fr.arb"
EN = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n\intl_en.arb"
DE = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n\intl_de.arb"

def load(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f, object_pairs_hook=collections.OrderedDict)

fr_data = load(FR)
en_data = load(EN)
de_data = load(DE)

print("--- planting_info_days Check ---")
print(f"FR has @planting_info_days: {'@planting_info_days' in fr_data}")
print(f"EN has @planting_info_days: {'@planting_info_days' in en_data}")
if '@planting_info_days' in fr_data:
    print(f"FR content: {fr_data['@planting_info_days']}")

print("\n--- activity_time_days_ago Check (DE) ---")
if 'activity_time_days_ago' in de_data:
    print(f"Value: {de_data['activity_time_days_ago']}")
else:
    print("MISSING")

print("\n--- Reading stats_full.txt (fixing encoding) ---")
try:
    with open(r"c:\Users\roman\Documents\apppklod\permacalendarv2\stats_full.txt", "r", encoding="utf-16-le") as f:
        print(f.read())
except Exception as e:
    print(f"Failed to read utf-16-le: {e}")
    try:
        with open(r"c:\Users\roman\Documents\apppklod\permacalendarv2\stats_full.txt", "r", encoding="utf-8") as f:
            print(f.read())
    except Exception as e2:
        print(f"Failed to read utf-8: {e2}")
