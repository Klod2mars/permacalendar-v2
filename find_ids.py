
import json

target_names = [
    "Brocoli", "Chou-fleur", "Chou de Bruxelles", "Chou cabus rouge",
    "Chou pommé (cabus / Milan)", "Chou kale", "Bok choy (pak choï)", "Chou mizuna",
    "Fève", "Haricot jaune", "Haricot coco", "Maïs doux", "Courge / Potiron", "Melon",
    "Pomme de terre", "Oignon blanc (botte)", "Radis noir", "Salsifis", "Asperge",
    "Artichaut", "Thym", "Romarin", "Aneth", "Coriandre", "Roquette"
]

# Normalize for fuzzy search
def normalize(s):
    return s.lower().replace("é", "e").replace("è", "e").replace("à", "a").replace("-", " ").replace("(", "").replace(")", "").replace("/", " ")

try:
    with open('assets/data/plants.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    found_map = {}
    for p in data['plants']:
        cn = p.get('commonName', '')
        # Direct match check or partial
        for t in target_names:
            if t == cn:
                found_map[t] = p['id']
            elif t in cn or cn in t:
                # Store potential match
                if t not in found_map:
                    found_map[t] = []
                if isinstance(found_map[t], list):
                    found_map[t].append((p['id'], cn))

    for t, content in found_map.items():
        print(f"Target: '{t}' -> {content}")
        
except Exception as e:
    print(e)
