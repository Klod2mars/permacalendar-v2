import os
import sys

path = 'assets/images/dashboard/bubbles/'
print(f"--- Listing {path} ---")
try:
    if not os.path.exists(path):
        print(f"Path does not exist: {path}")
    else:
        files = os.listdir(path)
        for f in files:
            full = os.path.join(path, f)
            stat = os.stat(full)
            print(f"File: '{f}' | Size: {stat.st_size} | Date (ts): {stat.st_mtime}")
            
            # Check for suspicion
            suspicious = []
            if ' ' in f: suspicious.append("Space in name")
            if f.endswith('.PNG'): suspicious.append("Extension .PNG")
            if 'Unit' in f: suspicious.append("Capitalized 'Unit'")
            if '(' in f or ')' in f: suspicious.append("Parenthesis")
            
            if suspicious:
                print(f"  ⚠ SUSPICIOUS: {', '.join(suspicious)}")
                
            # Image info
            if f.lower().endswith('.png'):
                try:
                    from PIL import Image
                    img = Image.open(full)
                    print(f"  IMAGE: Mode={img.mode}, Size={img.size}, Format={img.format}")
                    if 'transparency' in img.info: print(f"  Transparency: {img.info['transparency']}")
                    # bit depth check
                    mode_to_depth = {'1': 1, 'L': 8, 'P': 8, 'RGB': 24, 'RGBA': 32, 'CMYK': 32, 'YCbCr': 24, 'I': 32, 'F': 32}
                    print(f"  BitDepth: {mode_to_depth.get(img.mode, 'Unknown')}")
                    print(f"  Interlaced: {img.info.get('interlace', 'No')}")
                except ImportError:
                    print("  (PIL not installed, using header fallback)")
                    with open(full, 'rb') as fp:
                        header = fp.read(24)
                        print(f"  Header Hex: {header.hex()}")
                except Exception as e:
                     print(f"  Image Read Error: {e}")

    print("\n--- Exact Existence Check ---")
    target_unit = os.path.join(path, 'bubble_garden_unit.png')
    target_std = os.path.join(path, 'bubble_garden.png')
    print(f"'{target_unit}' exists? {os.path.exists(target_unit)}")
    print(f"'{target_std}' exists? {os.path.exists(target_std)}")

except Exception as e:
    print(f"Global Error: {e}")
