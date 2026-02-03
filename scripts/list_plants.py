
import json

try:
    with open('assets/data/plants.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
        for p in data['plants']:
            print(f"{p['id']} : {p.get('commonName', 'NO_NAME')}")
except Exception as e:
    print(e)
