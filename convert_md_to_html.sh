#!/bin/bash

# Usage: ./convert_md_to_html.sh [--dry-run]
# Recursively converts all .md files in the project to HTML using pandoc
# Injects a UNIFIED navigation bar, OLED Cyber stylesheet, and links to RAW MD.

if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed. Please install it first."
    exit 1
fi

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Project Settings
GITHUB_USER="astro-cli"
GITHUB_REPO="Into-the-Distro-Verse"
PROFILE_PIC="https://github.com/${GITHUB_USER}.png"
REPO_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}"

STYLE_PATH_FROM_ROOT="website/style.css"
SCRIPT_PATH_FROM_ROOT="website/script.js"

# Initialize counters
COUNT=0
FAILED=0
declare -a FILES_TO_CONVERT

# Find all .md files recursively, excluding .git directory
while IFS= read -r -d '' file; do
    FILES_TO_CONVERT+=("$file")
done < <(find . -name ".git" -prune -o -name "*.md" -type f -print0 2>/dev/null)

if [[ ${#FILES_TO_CONVERT[@]} -eq 0 ]]; then
    echo "No .md files found."
    exit 0
fi

if [[ "$DRY_RUN" == true ]]; then
    echo "Dry-run mode: Would convert the following ${#FILES_TO_CONVERT[@]} files:"
    for file in "${FILES_TO_CONVERT[@]}"; do
        echo "  $file"
    done
    exit 0
fi

echo "Found ${#FILES_TO_CONVERT[@]} files. Starting conversion..."

for file in "${FILES_TO_CONVERT[@]}"; do
    clean_path=${file#./}
    output="${file%.md}.html"
    md_filename=$(basename "$file")
    
    depth=$(echo "$clean_path" | tr -cd '/' | wc -c)
    rel_prefix=""
    for ((i=0; i<depth; i++)); do rel_prefix="../$rel_prefix"; done
    
    CSS_REL_PATH="${rel_prefix}${STYLE_PATH_FROM_ROOT}"
    JS_REL_PATH="${rel_prefix}${SCRIPT_PATH_FROM_ROOT}"
    INDEX_REL_PATH="${rel_prefix}website/index.html"
    HISTORY_REL_PATH="${rel_prefix}website/history.html"
    
    # Unified Navigation Header
    TMP_HEADER=$(mktemp)
    cat <<EOF > "$TMP_HEADER"
<header id="site-nav">
  <div class="nav-container">
    <a href="${INDEX_REL_PATH}" class="nav-left">
      <img src="${PROFILE_PIC}" alt="Profile" class="profile-pic">
      <h1>Into the Distro-Verse</h1>
    </a>
    <nav class="nav-right">
      <a href="${INDEX_REL_PATH}">Home</a>
      <a href="${HISTORY_REL_PATH}">History</a>
      <a href="${md_filename}" class="markdown-viewer-btn">Raw</a>
      <a href="${REPO_URL}" class="github-link" target="_blank">
        <img src="https://cdn-icons-png.flaticon.com/512/25/25231.png" width="16" style="filter: invert(1);">
        GitHub
      </a>
    </nav>
  </div>
</header>
EOF

    # Footer Include
    TMP_FOOTER=$(mktemp)
    cat <<EOF > "$TMP_FOOTER"
<footer>
  <p>Into the Distro-Verse &copy; 2026 | Created by ${GITHUB_USER} | Built with Pandoc</p>
</footer>
<script src="${JS_REL_PATH}"></script>
EOF

    echo "Converting: $file -> $output"
    
    title=$(basename "$file" .md | sed 's/-/ /g' | sed 's/_/ /g' | sed 's/README//g')
    [ -z "$title" ] && title="Home"

    # Convert to HTML (Added --no-highlight to prevent Pandoc style injection)
    if pandoc -s "$file" -o "$output" \
        --metadata title="$title" \
        -c "$CSS_REL_PATH" \
        --include-before-body="$TMP_HEADER" \
        --include-after-body="$TMP_FOOTER" \
        --toc \
        --no-highlight \
        --toc-depth=3; then
        ((COUNT++))
    else
        echo "  [ERROR] Failed to convert $file"
        ((FAILED++))
    fi
    
    rm "$TMP_HEADER" "$TMP_FOOTER"
done

echo "---------------------------------------"
echo "Summary: $COUNT converted, $FAILED failed."
exit 0
