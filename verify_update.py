
import json

with open('assets/data/plants.json', 'r', encoding='utf-8') as f:
    data = json.load(f)
    for p in data['plants']:
        if p['id'] == 'broccoli':
            print(f"Broccoli Sowing: {p.get('sowingMonths3')}")
            print(f"Broccoli Planting: {p.get('plantingMonths3')}")
