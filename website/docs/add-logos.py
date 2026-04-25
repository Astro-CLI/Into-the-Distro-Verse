import re

# Arch Linux
with open('distroverse--docs--arch.html', 'r', encoding='utf-8') as f:
    arch_content = f.read()

arch_logo_html = '<div style="float: right; margin: 0 0 20px 20px; text-align: center;"><img src="https://archlinux.org/static/logos/archlinux-logo-light-90dpi.png" alt="Arch Linux Logo" style="max-width: 200px; height: auto;"></div>'
arch_content = arch_content.replace(
    '<h1 id="arch-linux-setup-maintenance-guide-">Arch Linux Setup &amp; Maintenance Guide',
    arch_logo_html + '<h1 id="arch-linux-setup-maintenance-guide-">Arch Linux Setup &amp; Maintenance Guide'
)

with open('distroverse--docs--arch.html', 'w', encoding='utf-8') as f:
    f.write(arch_content)

print("Added Arch Linux logo")

# Fedora Linux
with open('distroverse--docs--fedora.html', 'r', encoding='utf-8') as f:
    fedora_content = f.read()

fedora_logo_html = '<div style="float: right; margin: 0 0 20px 20px; text-align: center;"><img src="https://fedoraproject.org/w/uploads/2/2d/Logo_fedoralogo.png" alt="Fedora Logo" style="max-width: 200px; height: auto;"></div>'
fedora_content = fedora_content.replace(
    '<h1 id="fedora-linux-the-modern-desktop-guide">Fedora Linux: The Modern Desktop Guide',
    fedora_logo_html + '<h1 id="fedora-linux-the-modern-desktop-guide">Fedora Linux: The Modern Desktop Guide'
)

with open('distroverse--docs--fedora.html', 'w', encoding='utf-8') as f:
    f.write(fedora_content)

print("Added Fedora logo")

# Debian
with open('distroverse--docs--debian.html', 'r', encoding='utf-8') as f:
    debian_content = f.read()

debian_logo_html = '<div style="float: right; margin: 0 0 20px 20px; text-align: center;"><img src="https://www.debian.org/logos/openlogo-75.jpg" alt="Debian Logo" style="max-width: 200px; height: auto;"></div>'
debian_content = debian_content.replace(
    '<h1 id="debian-the-stable-foundation-">Debian: The Stable Foundation',
    debian_logo_html + '<h1 id="debian-the-stable-foundation-">Debian: The Stable Foundation'
)

with open('distroverse--docs--debian.html', 'w', encoding='utf-8') as f:
    f.write(debian_content)

print("Added Debian logo")
