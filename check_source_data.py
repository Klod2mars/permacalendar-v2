
import json

ids = ["lentil", "climbing_bean", "gobo", "beetroot"]
with open('assets/data/plants.json', 'r', encoding='utf-8') as f:
    data = json.load(f)
    for p in data['plants']:
        if p['id'] in ids:
            print(f"ID: {p['id']}")
            print(f"  Sowing: {p.get('sowingMonths3')}")
            print(f"  Planting: {p.get('plantingMonths3')}")
