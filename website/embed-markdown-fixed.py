import os

# Map markdown files to their HTML counterparts
md_to_html_map = {
    '../docs/arch.md': 'docs/distroverse--docs--arch.html',
    '../docs/fedora.md': 'docs/distroverse--docs--fedora.html',
    '../docs/debian.md': 'docs/distroverse--docs--debian.html',
    '../docs/nix.md': 'docs/distroverse--docs--nix.html',
    '../docs/security.md': 'docs/distroverse--docs--security.html',
    '../docs/snapshots.md': 'docs/distroverse--docs--snapshots.html',
    '../docs/timeshift-io-optimization.md': 'docs/distroverse--docs--timeshift-io-optimization.html',
    '../docs/system_maintenance.md': 'docs/distroverse--docs--system_maintenance.html',
    '../docs/file-sync-guide.md': 'docs/distroverse--docs--file-sync-guide.html',
    '../docs/wayland-privilege-escalation.md': 'docs/distroverse--docs--wayland-privilege-escalation.html',
    '../docs/homebrew.md': 'docs/distroverse--docs--homebrew.html',
    '../docs/flatpak.md': 'docs/distroverse--docs--flatpak.html',
    '../docs/snaps.md': 'docs/distroverse--docs--snaps.html',
    '../docs/virtualization.md': 'docs/distroverse--docs--virtualization.html',
    '../docs/audio-video.md': 'docs/distroverse--docs--audio-video.html',
    '../docs/local-ai.md': 'docs/distroverse--docs--local-ai.html',
    '../docs/accessibility-tts.md': 'docs/distroverse--docs--accessibility-tts.html',
    '../docs/apache-tor-docker.md': 'docs/apache-tor-docker.html',
    '../docs/streaming/README.md': 'docs/distroverse--docs--streaming--README.html',
    '../docs/streaming/music.md': 'docs/distroverse--docs--streaming--music.html',
    '../docs/streaming/video.md': 'docs/distroverse--docs--streaming--video.html',
}

for md_path, html_path in md_to_html_map.items():
    if not os.path.exists(html_path):
        print(f"Skipping {html_path} - not found")
        continue
    
    try:
        with open(md_path, 'r', encoding='utf-8') as f:
            md_content = f.read()
    except FileNotFoundError:
        print(f"Skipping {md_path} - not found")
        continue
    
    # Escape for JavaScript string
    escaped_content = md_content.replace('\\', '\\\\').replace("'", "\\'").replace('\n', '\\n')
    
    with open(html_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    
    # Remove old data-markdown attribute if it exists
    html_content = html_content.replace(' data-markdown=' + html_content.split(' data-markdown=')[1].split('>')[0] if ' data-markdown=' in html_content else '', '')
    
    # Create script tag with markdown content
    md_script = f"<script>window.__markdown_content__='{escaped_content}';</script>"
    
    # Insert before closing body tag
    html_content = html_content.replace('</body>', md_script + '</body>')
    
    with open(html_path, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"Embedded markdown in {html_path}")

print("Done!")
