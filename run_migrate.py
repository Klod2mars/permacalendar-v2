#!/usr/bin/env python3
# run_migrate.py
# Helper: importe et lance migrate_plants_to_3letter_months.py en affichant toute sortie/trace.

import importlib.util
import os
import sys
import traceback

SCRIPT = os.path.abspath("migrate_plants_to_3letter_months.py")
OUT = os.path.abspath(os.path.join("assets", "data", "plants_migrated.json"))
INPUT = os.path.abspath(os.path.join("assets", "data", "plants.json"))
MAPPING = os.path.abspath("month_mapping.json")

print("Runner: script path ->", SCRIPT)
if not os.path.exists(SCRIPT):
    print("ERROR: migrate script not found at:", SCRIPT)
    sys.exit(1)

spec = importlib.util.spec_from_file_location("migrate_mod", SCRIPT)
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)

# Simulate CLI args (same as you've tried)
sys.argv = [
    "migrate_plants_to_3letter_months.py",
    "--input", INPUT,
    "--mapping-file", MAPPING,
    "--non-interactive",
    "--output", OUT
]

print("ABOUT TO CALL main()")
try:
    m.main()
    print("MAIN_FINISHED")
except SystemExit as e:
    print("SystemExit:", e)
except Exception:
    print("EXCEPTION RAISED:")
    traceback.print_exc()

print("Final checks:")
print(" - Output path:", OUT)
print(" - Output exists?:", os.path.exists(OUT))
if os.path.exists(OUT):
    try:
        with open(OUT, "r", encoding="utf-8") as fh:
            preview = fh.read(2000)
        print(" - First 1200 chars of output:")
        print(preview[:1200])
    except Exception as e:
        print(" - Could not read output:", e)

# show possible backups
backups = sorted([p for p in os.listdir(os.path.dirname(INPUT)) if p.startswith("plants.json.backup")])
print(" - Backups (in assets/data):", backups)
