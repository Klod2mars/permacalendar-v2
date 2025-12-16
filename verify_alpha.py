import os
from PIL import Image

def check_alpha(path):
    try:
        if not os.path.exists(path):
            print(f"MISSING: {path}")
            return
            
        im = Image.open(path)
        print(f"File: {path}")
        print(f"Mode: {im.mode}, Bands: {im.getbands()}")
        
        if 'A' in im.getbands():
            a = im.getchannel('A')
            print('alpha min,max:', a.getextrema())
        else:
            print("NO ALPHA CHANNEL FOUND")
            
    except Exception as e:
        print(f"Error checking {path}: {e}")

# Check specific requested file and others
check_alpha('assets/weather_icons/thunderstorm.png')
check_alpha('assets/weather_icons/partly_cloudy.png')
