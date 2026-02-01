import json
import sys

def check(path):
    print(f"Checking {path}...")
    try:
        with open(path, 'r', encoding='utf-8') as f:
            json.load(f)
        print("Valid JSON")
    except json.JSONDecodeError as e:
        print(f"JSON Error: {e.msg}")
        print(f"Line {e.lineno}, Column {e.colno}")
        
        # Show context
        try:
            with open(path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
                start = max(0, e.lineno - 5)
                end = min(len(lines), e.lineno + 5)
                for i in range(start, end):
                    marker = ">>" if i+1 == e.lineno else "  "
                    print(f"{marker} {i+1}: {lines[i].rstrip()}")
        except Exception as ex:
            print(f"Could not read context: {ex}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        check(sys.argv[1])
    else:
        print("Usage: python check.py <file>")
