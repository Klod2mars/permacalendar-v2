import json

file_path = 'c:/Users/roman/Documents/apppklod/permacalendarv2/assets/data/plants.json'

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        plants = data.get('plants', [])
        
        print(f"Total plants: {len(plants)}")
        
        count_root = 0
        count_meta = 0
        
        for p in plants:
            pid = p.get('id')
            if 'image' in p:
                count_root += 1
                if count_root < 5:
                    print(f"ROOT image for {pid}: {p['image']}")
            
            meta = p.get('metadata', {})
            if 'image' in meta:
                count_meta += 1
                if count_meta < 5:
                    print(f"META image for {pid}: {meta['image']}")
                    
        print(f"Total with ROOT image: {count_root}")
        print(f"Total with META image: {count_meta}")

except Exception as e:
    print(f"Error: {e}")
