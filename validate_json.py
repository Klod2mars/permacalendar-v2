import json
import os

files = [
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/plants.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_en.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_de.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_es.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_it.json',
    'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/json_multilangue_doc/plants_pt.json'
]

for fpath in files:
    try:
        with open(fpath, 'r', encoding='utf-8') as f:
            json.load(f)
        print(f"OK: {os.path.basename(fpath)}")
    except Exception as e:
        print(f"FAIL: {os.path.basename(fpath)} - {e}")
