import json
import sys

def get_batch(start, count, output_file):
    path = 'assets/data/plants.json'
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    plants = data.get('plants', [])
    total = len(plants)
    
    end_index = min(start + count, total)
    batch = plants[start:end_index]
    
    # Check if this is the first batch to include metadata
    meta = data.get('metadata', {}) if start == 0 else None
    
    output = {
        "batch_index": start // count,
        "plants": batch
    }
    if meta:
        output["metadata"] = meta
        
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
        
    print(f"BATCH_INFO: Written {len(batch)} plants to {output_file}")

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Usage: python chunk_reader.py <start_index> <count> <output_file>")
        sys.exit(1)
        
    start = int(sys.argv[1])
    count = int(sys.argv[2])
    output_file = sys.argv[3]
    
    get_batch(start, count, output_file)
