import json
import argparse
import os

def extract(start, count, output):
    source_path = 'assets/data/plants.json'
    with open(source_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    plants = data['plants']
    batch = plants[start : start + count]
    
    print(f"Extracting plants {start} to {start + count} (Total: {len(batch)})")
    for p in batch:
        print(f"- {p['id']}")

    with open(output, 'w', encoding='utf-8') as f:
        json.dump(batch, f, indent=2, ensure_ascii=False)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--start', type=int, required=True)
    parser.add_argument('--count', type=int, default=10)
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    
    extract(args.start, args.count, args.output)
