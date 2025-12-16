from PIL import Image
import os

def aggressive_remove_bg(path):
    try:
        img = Image.open(path).convert("RGBA")
        datas = img.getdata()
        
        print(f"Aggressively processing {path}...")
        
        newData = []
        for item in datas:
            r, g, b, a = item
            
            # Heuristic 1: If it's a transparency checkerboard grey
            # Checkerboards are usually 204 or 255. But here we see 40-100.
            # It seems the model generated a "dark mode" checkerboard or just dark background.
            
            # Simple luminance
            lum = 0.299*r + 0.587*g + 0.114*b
            
            # Saturation approximation: diff between max and min channel
            sat = max(r,g,b) - min(r,g,b)
            
            # Logic:
            # 1. If it's very dark (black background), transparent.
            # 2. If it's grey (low saturation) and not super bright (white), transparent.
            
            is_dark = lum < 120 # Cover the 96,96,96 greys
            is_grey = sat < 20   # Greyish
            
            # We want to keep the neon green. Neon green has high saturation (green >> red/blue).
            # So if it's grey-ish and dark-ish, kill it.
            
            if is_dark and is_grey:
                newData.append((0, 0, 0, 0)) # Fully transparent
            elif lum < 30: 
                # Kill pure blacks even if slight color noise
                newData.append((0, 0, 0, 0)) 
            else:
                # To smoothen edges, we could lower alpha for semi-dark pixels, but simple threshold first.
                newData.append(item)
        
        img.putdata(newData)
        img.save(path, "PNG")
        print(f"Saved {path}")
            
    except Exception as e:
        print(f"Error processing {path}: {e}")

directory = 'assets/weather_icons'
for filename in os.listdir(directory):
    if filename.endswith(".png"):
        aggressive_remove_bg(os.path.join(directory, filename))
