import os
import re

for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith('.html'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check if we need to fix the path
            if '<script src="script.js">' in content:
                # Replace script.js with ../script.js only for files in subdirectories
                if root != '.':
                    content = content.replace('<script src="script.js"></script>', '<script src="../script.js"></script>')
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Fixed {filepath}")

print("Done!")
