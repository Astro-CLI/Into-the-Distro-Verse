import os
import re

favicon_link = '<link rel="icon" href="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Anonymous_emblem.svg/250px-Anonymous_emblem.svg.png" type="image/svg+xml">'

for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith('.html'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check if favicon already exists
            if 'rel="icon"' in content:
                continue
            
            # Add favicon after <title> tag
            content = re.sub(
                r'(<title>[^<]+</title>)',
                r'\1 ' + favicon_link,
                content
            )
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"Added favicon to {filepath}")

print("Done!")
