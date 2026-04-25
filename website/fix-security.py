import os

md_path = '../docs/security.md'
html_path = 'docs/distroverse--docs--security.html'

# Read markdown file
with open(md_path, 'r', encoding='utf-8') as f:
    md_content = f.read()

# Read HTML file
with open(html_path, 'r', encoding='utf-8') as f:
    html_content = f.read()

# Remove old script tag if exists
if '<script>window.__markdown_content__=' in html_content:
    start = html_content.find('<script>window.__markdown_content__=')
    end = html_content.find('</script>', start) + len('</script>')
    html_content = html_content[:start] + html_content[end:]

# Escape for JavaScript string - proper escaping
escaped_content = md_content.replace('\\', '\\\\').replace("'", "\\'").replace('\n', '\\n').replace('\r', '')

# Create script tag with markdown content
md_script = f"<script>window.__markdown_content__='{escaped_content}';</script>"

# Insert before closing body tag
html_content = html_content.replace('</body>', md_script + '</body>')

with open(html_path, 'w', encoding='utf-8') as f:
    f.write(html_content)

print(f"Fixed {html_path}")
print(f"Content length: {len(escaped_content)}")
