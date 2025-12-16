from PIL import Image
import collections

def analyze_pixels(path):
    try:
        im = Image.open(path).convert("RGBA")
        print(f"Analyzing {path} ({im.size})")
        
        # Sample corners and center
        w, h = im.size
        samples = [
            (0, 0), (w-1, 0), (0, h-1), (w-1, h-1), # Corners
            (w//2, h//2), # Center
            (5, 5), (10, 10) # Near corner
        ]
        
        print("Sample pixels (RGBA):")
        for x, y in samples:
            if 0 <= x < w and 0 <= y < h:
                print(f"  ({x},{y}): {im.getpixel((x,y))}")
        
        # histogram of colors to find common background colors
        colors = im.getcolors(maxcolors=256*256)
        if colors:
            print("\nMost common colors (count, color):")
            # Sort by count desc
            sorted_colors = sorted(colors, key=lambda x: x[0], reverse=True)
            for count, color in sorted_colors[:10]:
                print(f"  {count}: {color}")
                
    except Exception as e:
        print(f"Error: {e}")

analyze_pixels('assets/weather_icons/thunderstorm.png')
