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

# Validate inputs
if [ ! -d "$BOOK_DIR" ]; then
    echo "Error: Book directory '$BOOK_DIR' does not exist"
    exit 1
fi

# Find all HTML files and inject/update base tag
find "$BOOK_DIR" -name "*.html" -type f | while read -r html_file; do
    # Check if base tag already exists
    if grep -q '<base href=' "$html_file"; then
        # Update existing base tag
        sed -i "s|<base href=\"[^\"]*\">|<base href=\"${BASE_URL}\">|" "$html_file"
        echo "Updated base URL in $(basename $html_file)"
    else
        # Inject base tag after <head> opening tag
        sed -i "s|<head>|<head>\n        <base href=\"${BASE_URL}\">|" "$html_file"
        echo "Injected base URL into $(basename $html_file)"
    fi
done

echo "Done! Injected base URL '${BASE_URL}' into all HTML files in '${BOOK_DIR}'"
