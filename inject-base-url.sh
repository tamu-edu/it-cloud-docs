#!/bin/bash
# Script to inject <base href> tag into mdBook HTML output
# Usage: ./inject-base-url.sh <base-url> <book-dir>

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <base-url> <book-dir>"
    echo "Example: $0 /pr-preview/pr-123/ ./book"
    exit 1
fi

BASE_URL="$1"
BOOK_DIR="$2"

# Remove trailing slash for consistency in replacements
BASE_URL="${BASE_URL%/}"

# Validate inputs
if [ ! -d "$BOOK_DIR" ]; then
    echo "Error: Book directory '$BOOK_DIR' does not exist"
    exit 1
fi

# Find all HTML files and prepend base URL to relative asset paths
find "$BOOK_DIR" -name "*.html" -type f | while read -r html_file; do
    # Get the directory of the current HTML file relative to book root
    # This is needed for resolving ./ paths correctly
    rel_dir=$(dirname "${html_file#$BOOK_DIR/}")
    
    # Convert ../ relative paths to absolute paths with base URL
    # This handles paths like: href="../../css/style.css" and href=".././theme/css/style.css"
    sed -i -E "s|href=\"(\.\./)+|href=\"${BASE_URL}/|g" "$html_file"
    sed -i -E "s|src=\"(\.\./)+|src=\"${BASE_URL}/|g" "$html_file"
    
    # Clean up any remaining ./ that may have been left after ../ conversion
    # This handles cases like ".././theme" which becomes "/base/./theme" and needs to be "/base/theme"
    sed -i -E "s|href=\"${BASE_URL}/\./|href=\"${BASE_URL}/|g" "$html_file"
    sed -i -E "s|src=\"${BASE_URL}/\./|src=\"${BASE_URL}/|g" "$html_file"
    
    # Convert ./ relative paths to absolute paths with base URL
    # This handles paths like: src="./image.png"
    if [ "$rel_dir" = "." ]; then
        # File is in root directory
        sed -i -E "s|href=\"\./|href=\"${BASE_URL}/|g" "$html_file"
        sed -i -E "s|src=\"\./|src=\"${BASE_URL}/|g" "$html_file"
    else
        # File is in subdirectory, need to include the subdirectory path
        sed -i -E "s|href=\"\./|href=\"${BASE_URL}/${rel_dir}/|g" "$html_file"
        sed -i -E "s|src=\"\./|src=\"${BASE_URL}/${rel_dir}/|g" "$html_file"
    fi
    
    # Convert simple relative paths (no ../ or ./) to absolute paths with base URL
    # We need to distinguish between:
    #   1. Root-relative paths (contain /): cloud/index.html → /base/cloud/index.html
    #   2. File-relative paths (no /): migrating.html → /base/subdir/migrating.html
    # Also handles paths with anchors: href="page.html#section" → href="/base/page.html#section"
    # But avoid converting:
    #   - already absolute paths (starting with /)
    #   - URLs with schemes (http://, https://, mailto:, etc.) - they contain ":"
    #   - standalone anchors (starting with #) - these don't start with letter/number
    
    # First, handle root-relative paths (paths that contain at least one /)
    # These are paths like "cloud/index.html" or "kion/features/getting_started.html"
    sed -i -E "s|href=\"([a-zA-Z0-9][^\":]*)/([^\"]*)\"|href=\"${BASE_URL}/\1/\2\"|g" "$html_file"
    sed -i -E "s|src=\"([a-zA-Z0-9][^\":]*)/([^\"]*)\"|src=\"${BASE_URL}/\1/\2\"|g" "$html_file"
    
    # Then, handle file-relative paths (simple filenames without /)
    # Match paths that start with a letter or number, don't contain a colon or slash
    if [ "$rel_dir" = "." ]; then
        # File is in root directory
        sed -i -E "s|href=\"([a-zA-Z0-9][^\"/:]*)\"|href=\"${BASE_URL}/\1\"|g" "$html_file"
        sed -i -E "s|src=\"([a-zA-Z0-9][^\"/:]*)\"|src=\"${BASE_URL}/\1\"|g" "$html_file"
    else
        # File is in subdirectory, prepend the subdirectory path
        sed -i -E "s|href=\"([a-zA-Z0-9][^\"/:]*)\"|href=\"${BASE_URL}/${rel_dir}/\1\"|g" "$html_file"
        sed -i -E "s|src=\"([a-zA-Z0-9][^\"/:]*)\"|src=\"${BASE_URL}/${rel_dir}/\1\"|g" "$html_file"
    fi
    
    # Final cleanup: remove any remaining ./ in the middle of paths
    # This handles cases like "/base/kion/features/./features/" which should be "/base/kion/features/features/"
    sed -i -E "s|/\./|/|g" "$html_file"
    
    echo "Converted paths in $(basename "$html_file")"
done

echo "Done! Prepended base URL '${BASE_URL}' to relative paths in '${BOOK_DIR}'"
