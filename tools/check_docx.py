
import zipfile
import os

path = r'c:\Users\roman\Documents\apppklod\permacalendarv2\assets\templates\task_template.docx'
print(f"Checking file: {path}")

if not os.path.exists(path):
    print("File not found")
    exit(1)

try:
    with zipfile.ZipFile(path, 'r') as zip_ref:
        print("Valid Zip File. Contents:")
        for name in zip_ref.namelist():
            print(f" - {name}")
except zipfile.BadZipFile:
    print("ERROR: Bad Zip File")
except Exception as e:
    print(f"ERROR: {e}")
