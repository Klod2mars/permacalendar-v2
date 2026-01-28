import json
import collections
import os

path = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n\intl_en.arb.20260128_095230.bak"

def load_arb(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f, object_pairs_hook=collections.OrderedDict)

data = load_arb(path)
if "calendar_title" in data:
    print("calendar_title FOUND")
else:
    print("calendar_title MISSING")

if "@calendar_title" in data:
    print("@calendar_title FOUND")
else:
    print("@calendar_title MISSING")
