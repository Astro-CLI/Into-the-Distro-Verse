#!/bin/bash

# Fix CSS links in docs folder (change style.css to ../style.css)
sed -i 's|href="style.css"|href="../style.css"|g' docs/*.html

# Fix index links in docs folder (change index.html to ../index.html)
sed -i 's|href="index.html"|href="../index.html"|g' docs/*.html
sed -i 's|href="script.js"|href="../script.js"|g' docs/*.html

# Fix CSS links in configs folder
sed -i 's|href="style.css"|href="../style.css"|g' configs/*.html
sed -i 's|href="index.html"|href="../index.html"|g' configs/*.html
sed -i 's|href="script.js"|href="../script.js"|g' configs/*.html

# Fix CSS links in packages folder
sed -i 's|href="style.css"|href="../style.css"|g' packages/*.html
sed -i 's|href="index.html"|href="../index.html"|g' packages/*.html
sed -i 's|href="script.js"|href="../script.js"|g' packages/*.html

# Fix CSS links in apps/packettracer folder
sed -i 's|href="style.css"|href="../../style.css"|g' apps/packettracer/*.html
sed -i 's|href="index.html"|href="../../index.html"|g' apps/packettracer/*.html
sed -i 's|href="script.js"|href="../../script.js"|g' apps/packettracer/*.html

echo "CSS and JS links fixed!"
