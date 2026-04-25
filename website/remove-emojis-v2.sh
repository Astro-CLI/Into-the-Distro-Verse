#!/bin/bash

# More comprehensive emoji removal using Python
python3 << 'PYTHON'
import os
import re

# All emoji patterns
emoji_pattern = re.compile(
    "["
    "\U0001F1E0-\U0001F1FF"  # flags (iOS)
    "\U0001F300-\U0001F5FF"  # symbols & pictographs
    "\U0001F600-\U0001F64F"  # emoticons
    "\U0001F680-\U0001F6FF"  # transport & map symbols
    "\U0001F1F2-\U0001F1F4"  # flags (iOS)
    "\U0001F191-\U0001F251"  # enclosed characters
    "\U0001F900-\U0001F9FF"  # Supplemental Symbols and Pictographs
    "\U0001FA00-\U0001FA6F"  # Chess Symbols
    "\U0001FA70-\U0001FAFF"  # Symbols and Pictographs Extended-A
    "\u2702-\u27B0"          # Dingbats
    "\u24C2-\U0001F251"
    "\U0001f926-\U0001f937"  # More emoticons
    "\u200d"                  # Zero-width joiner
    "\u2640-\u2642"          # Gender symbols
    "]+", flags=re.UNICODE)

for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith('.html'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Replace emojis with empty string
            new_content = emoji_pattern.sub('', content)
            
            # Clean up extra spaces
            new_content = re.sub(r'\s+', ' ', new_content)
            new_content = re.sub(r' \n', '\n', new_content)
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            
            print(f"Processed: {filepath}")

print("All emojis removed!")
PYTHON
