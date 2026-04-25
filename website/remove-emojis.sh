#!/bin/bash

# Remove emojis from all HTML files using perl (supports Unicode)
find . -name "*.html" -exec perl -i -pe 's/[\x{1F300}-\x{1F9FF}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F000}-\x{1F02F}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F0A0}-\x{1F0FF}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F100}-\x{1F64F}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F680}-\x{1F6FF}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F700}-\x{1F77F}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F780}-\x{1F7FF}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F800}-\x{1F8FF}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{1F900}-\x{1F9FF}]//g' {} \;
find . -name "*.html" -exec perl -i -pe 's/[\x{2600}-\x{27BF}]//g' {} \;

echo "All emojis removed from HTML files!"
