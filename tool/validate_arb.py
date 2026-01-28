import json
import os
import re

BASE_DIR = r"c:\Users\roman\Documents\apppklod\permacalendarv2\lib\l10n"
FILES = [
    "intl_en.arb", "intl_de.arb", "intl_es.arb", "intl_it.arb", "intl_pt.arb"
]

def check_icu_syntax(value):
    """Robust ICU syntax detection."""
    if not isinstance(value, str): return False
    # Look for {variable, plural/select, ...}
    # Matches: { count, plural, ... } or { gender, select, ... }
    # Relaxed regex to catch more: \{[^,]+,\s*(plural|select)
    return bool(re.search(r'\{[^,]+,\s*(plural|select)', value))

def validate_file(filename, output_file):
    path = os.path.join(BASE_DIR, filename)
    output_file.write(f"\nValidating {filename}...\n")
    
    if not os.path.exists(path):
        output_file.write(f"  [ERROR] File not found: {path}\n")
        return

    try:
        with open(path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        output_file.write("  [OK] JSON Syntax Valid\n")
    except json.JSONDecodeError as e:
        output_file.write(f"  [ERROR] JSON Syntax Invalid: {e}\n")
        return

    # 1. Check @@locale
    locale = data.get("@@locale")
    if locale:
        output_file.write(f"  [OK] @@locale found: {locale}\n")
    else:
        output_file.write("  [ERROR] @@locale MISSING\n")

    # 2. Check Metadata Consistency and ICU
    keys = [k for k in data.keys() if not k.startswith("@")]
    warnings = 0
    icu_count = 0
    
    for key in keys:
        value = data[key]
        meta_key = f"@{key}"
        
        # Check if metadata exists
        if meta_key not in data:
            if isinstance(value, str) and "{" in value:
                 output_file.write(f"  [WARNING] Key '{key}' has placeholders but no metadata.\n")
                 warnings += 1
        else:
            # Check placeholders in metadata
            meta = data[meta_key]
            if isinstance(value, str) and "{" in value:
                placeholders = re.findall(r'\{(\w+)\}', value)
                # Filter out 'plural', 'select' etc if matched by regex as placeholder
                # actually \w+ matches 'count' in {count, plural, ...} which IS the variable.
                # but 'plural' is not a variable.
                
                meta_placeholders = meta.get("placeholders", {})
                for ph in placeholders:
                    # Ignore standard ICU keywords if they get picked up? No, {plural} isn't valid syntax usually.
                    if ph not in meta_placeholders:
                         if not check_icu_syntax(value):
                             output_file.write(f"  [WARNING] Key '{key}' uses placeholder '{ph}' but not defined in metadata. Value: {value[:30]}...\n")
                             warnings += 1

        # ICU Check
        if check_icu_syntax(value):
            output_file.write(f"  [ICU] Key '{key}' detected as ICU. Value: {value[:50]}...\n")
            icu_count += 1
            
    output_file.write(f"  Validation complete. Warnings: {warnings}, ICU Keys: {icu_count}\n")

def main():
    with open("validation_results.txt", "w", encoding="utf-8") as f:
        for filename in FILES:
            validate_file(filename, f)
    print("Validation finished. See validation_results.txt")

if __name__ == "__main__":
    main()
