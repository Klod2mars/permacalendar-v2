with open('assets/data/json_multilangue_doc/plants_it.json', 'r', encoding='utf-8') as f:
    for i, line in enumerate(f):
        if '"sowingMonths3":' in line and '[' not in line:
             print(f"Line {i+1}: {line.strip()}")
