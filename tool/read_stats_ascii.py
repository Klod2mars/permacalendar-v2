import re

path = r"c:\Users\roman\Documents\apppklod\permacalendarv2\stats_full.txt"
try:
    with open(path, 'r', encoding='utf-16-le') as f:
        content = f.read()
except:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

# Replace non-ascii to avoid tool output issues
content = ''.join([i if ord(i) < 128 else '?' for i in content])
print(content)
