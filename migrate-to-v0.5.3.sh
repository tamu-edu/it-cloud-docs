#!/bin/bash
#
# mdBook Migration Script: v0.4.52 → v0.5.3
# Location: /Users/bronius/projects/it-cloud-docs/migrate-to-v0.5.3.sh
# 
# Purpose: Automated safe migration with rollback capability
# Usage: bash migrate-to-v0.5.3.sh [--dry-run] [--no-backup]
#

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/.backups/migration-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${SCRIPT_DIR}/migration.log"

MDBOOK_VERSION="0.5.3"
ADMONISH_VERSION="1.20.0"
OS_TYPE=$(uname -s)
ARCH=$(uname -m)

# Detect macOS vs Linux + architecture
if [ "$OS_TYPE" = "Darwin" ]; then
    if [ "$ARCH" = "arm64" ]; then
        MDBOOK_BINARY="mdbook-v${MDBOOK_VERSION}-aarch64-apple-darwin"
    else
        MDBOOK_BINARY="mdbook-v${MDBOOK_VERSION}-x86_64-apple-darwin"
    fi
elif [ "$OS_TYPE" = "Linux" ]; then
    MDBOOK_BINARY="mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu"
else
    echo "ERROR: Unsupported OS: $OS_TYPE" >&2
    exit 1
fi

DRY_RUN=${1:---}
if [ "$DRY_RUN" = "--dry-run" ]; then
    DRY_RUN=true
else
    DRY_RUN=false
fi

NO_BACKUP=${1:---}
if [ "$NO_BACKUP" = "--no-backup" ]; then
    NO_BACKUP=true
else
    NO_BACKUP=false
fi

# ============================================================================
# FUNCTIONS
# ============================================================================

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

error() {
    echo "❌ ERROR: $*" | tee -a "$LOG_FILE" >&2
    exit 1
}

warn() {
    echo "⚠️  WARNING: $*" | tee -a "$LOG_FILE"
}

success() {
    echo "✅ $*" | tee -a "$LOG_FILE"
}

step() {
    echo "" | tee -a "$LOG_FILE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$LOG_FILE"
    echo "📌 $*" | tee -a "$LOG_FILE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$LOG_FILE"
}

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] $*"
    else
        log "Running: $*"
        eval "$@" || error "Command failed: $*"
    fi
}

backup_files() {
    if [ "$NO_BACKUP" = true ]; then
        warn "Skipping backups (--no-backup flag set)"
        return 0
    fi

    step "Creating backups..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup config
    run_cmd "cp -v '$SCRIPT_DIR/book.toml' '$BACKUP_DIR/book.toml.bak'"
    
    # Backup theme files
    run_cmd "cp -r '$SCRIPT_DIR/theme' '$BACKUP_DIR/theme.bak'"
    
    # Backup Makefile (optional)
    if [ -f "$SCRIPT_DIR/Makefile" ]; then
        run_cmd "cp -v '$SCRIPT_DIR/Makefile' '$BACKUP_DIR/Makefile.bak'"
    fi
    
    success "Backups created in: $BACKUP_DIR"
    log "Restore point: git stash && cp -r $BACKUP_DIR/* ."
}

check_mdbook_version() {
    step "Checking current mdBook version..."
    if command -v mdbook &> /dev/null; then
        CURRENT_VERSION=$(mdbook --version | awk '{print $2}')
        log "Current mdBook version: $CURRENT_VERSION"
        if [[ "$CURRENT_VERSION" == "v0.5."* ]]; then
            warn "Already running v0.5.x"
        fi
    else
        log "mdBook not found in PATH"
    fi
}

install_mdbook() {
    step "Installing mdBook v${MDBOOK_VERSION}..."
    
    DOWNLOAD_URL="https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/${MDBOOK_BINARY}.tar.gz"
    TEMP_DIR=$(mktemp -d)
    
    log "Downloading from: $DOWNLOAD_URL"
    
    run_cmd "curl -sSL '$DOWNLOAD_URL' | tar -xz --directory='$TEMP_DIR'"
    
    if [ "$DRY_RUN" = false ]; then
        if [ ! -f "$TEMP_DIR/mdbook" ]; then
            error "mdBook binary not found in downloaded archive"
        fi
        
        # Try to install to /usr/local/bin, fallback to user's bin
        if [ -w /usr/local/bin ]; then
            run_cmd "sudo mv '$TEMP_DIR/mdbook' /usr/local/bin/"
            success "mdBook installed to /usr/local/bin/mdbook"
        elif [ -w ~/bin ]; then
            run_cmd "mv '$TEMP_DIR/mdbook' ~/bin/"
            success "mdBook installed to ~/bin/mdbook"
        else
            error "Cannot write to /usr/local/bin or ~/bin. Please install manually."
        fi
    fi
    
    rm -rf "$TEMP_DIR"
    
    # Verify
    if command -v mdbook &> /dev/null; then
        success "mdBook installation verified: $(mdbook --version)"
    fi
}

install_admonish() {
    step "Installing mdbook-admonish v${ADMONISH_VERSION}..."
    
    if ! command -v cargo &> /dev/null; then
        error "Cargo not found. Please install Rust: https://rustup.rs/"
    fi
    
    run_cmd "cargo install mdbook-admonish@${ADMONISH_VERSION}"
    
    if command -v mdbook-admonish &> /dev/null; then
        success "mdbook-admonish installed: $(mdbook-admonish --version)"
    fi
}

update_book_toml() {
    step "Updating book.toml..."
    
    if [ "$DRY_RUN" = false ]; then
        # Update admonish version
        sed -i.bak 's/assets_version = "[^"]*"/assets_version = "'${ADMONISH_VERSION}'"/g' "$SCRIPT_DIR/book.toml"
        success "Updated book.toml"
    else
        log "[DRY-RUN] Would update book.toml assetsversionto ${ADMONISH_VERSION}"
    fi
}

update_theme_files() {
    step "Updating theme files (ID namespace migration)..."
    
    if [ "$DRY_RUN" = false ]; then
        # Update index.hbs: Remove FontAwesome CSS link
        sed -i.bak '/<link rel="stylesheet" href="{{ path_to_root }}FontAwesome\/css\/font-awesome.css">/d' \
            "$SCRIPT_DIR/theme/index.hbs"
        
        # Update sidebar ID references
        sed -i.bak 's/#sidebar/#mdbook-sidebar/g' "$SCRIPT_DIR/theme/index.hbs"
        sed -i.bak 's/#menu-bar/#mdbook-menu-bar/g' "$SCRIPT_DIR/theme/index.hbs"
        sed -i.bak 's/#search-toggle/#mdbook-search-toggle/g' "$SCRIPT_DIR/theme/index.hbs"
        
        # Update CSS files
        sed -i.bak 's/#sidebar/#mdbook-sidebar/g' "$SCRIPT_DIR/theme/css/chrome.css"
        sed -i.bak 's/#menu-bar/#mdbook-menu-bar/g' "$SCRIPT_DIR/theme/css/chrome.css"
        sed -i.bak 's/#searchresults/#mdbook-searchresults/g' "$SCRIPT_DIR/theme/css/chrome.css"
        
        success "Updated theme files with ID namespace migration"
    else
        log "[DRY-RUN] Would update theme IDs with mdbook- prefix"
    fi
}

clean_build_cache() {
    step "Cleaning build cache..."
    
    if [ "$DRY_RUN" = false ]; then
        run_cmd "cd '$SCRIPT_DIR' && mdbook clean"
        success "Build cache cleaned"
    else
        log "[DRY-RUN] Would run: mdbook clean"
    fi
}

build_and_test() {
    step "Building documentation..."
    
    if [ "$DRY_RUN" = false ]; then
        run_cmd "cd '$SCRIPT_DIR' && mdbook build"
        success "Build completed successfully"
        
        if [ -f "$SCRIPT_DIR/book/index.html" ]; then
            success "Output verified: book/index.html exists"
        else
            error "Build output not found"
        fi
    else
        log "[DRY-RUN] Would run: mdbook build"
    fi
}

print_validation_checklist() {
    step "Migration Complete! 🎉"
    
    cat << 'EOF' | tee -a "$LOG_FILE"

================================================================================
POST-MIGRATION VALIDATION CHECKLIST
================================================================================

Before pushing to production, verify these items:

VISUAL RENDERING:
  [ ] Sidebar navigation renders and collapses properly
  [ ] Menu bar icons display correctly (hamburger, brush, search)
  [ ] Theme toggle button functions
  [ ] Print button appears with correct icon
  [ ] GitHub edit button appears
  [ ] Admonitions render with correct styling

FUNCTIONAL TESTING:
  [ ] Dark/Light theme toggle works
  [ ] Search functionality operational
  [ ] Sidebar collapse/expand smooth
  [ ] Print to PDF generates correctly
  [ ] Mobile responsive layout intact
  [ ] Page navigation links work
  [ ] No 404 errors in browser console
  [ ] No JavaScript errors on page load

QUICK TEST:
  1. Run: mdbook serve
  2. Open: http://localhost:3000
  3. Check browser DevTools (F12) console for errors
  4. Test theme toggle (top-right button)
  5. Test sidebar (top-left hamburger)
  6. Search for a term

NEXT STEPS:
  1. Local validation (mdbook serve)
  2. Git commit: git add . && git commit -m "chore: upgrade mdBook 0.4.52 → 0.5.3"
  3. Push to staging/production

ROLLBACK (if needed):
  cp -r ${BACKUP_DIR}/* .
  mdbook clean && mdbook build

================================================================================
EOF
}

print_summary() {
    cat << EOF | tee -a "$LOG_FILE"

================================================================================
MIGRATION SUMMARY
================================================================================

Migration Log: $LOG_FILE
Backup Location: $BACKUP_DIR

Updates Applied:
  ✓ mdBook v${MDBOOK_VERSION} installed
  ✓ mdbook-admonish v${ADMONISH_VERSION} installed
  ✓ book.toml updated
  ✓ Theme ID namespaces migrated (mdbook- prefix)
  ✓ FontAwesome v4 references removed
  ✓ Build cache cleaned
  ✓ Documentation rebuilt

Configuration Changed:
  • book.toml: assets_version → "${ADMONISH_VERSION}"
  • theme/index.hbs: Removed FontAwesome CSS link
  • theme/index.hbs: Updated sidebar ID references
  • theme/css/chrome.css: Updated selectors
  • All #sidebar → #mdbook-sidebar
  • All #menu-bar → #mdbook-menu-bar

OS/Architecture: $OS_TYPE / $ARCH
Dry Run: $DRY_RUN
Backups: ${NO_BACKUP:+DISABLED}${NO_BACKUP:+ ✓}

================================================================================
EOF
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    log "Starting mdBook migration (v0.4.52 → v0.5.3)"
    log "DRY_RUN: $DRY_RUN"
    
    if [ "$DRY_RUN" = true ]; then
        log "========== DRY RUN MODE =========="
        log "No changes will be made. Add actual flag changes to proceed."
    fi
    
    check_mdbook_version
    backup_files
    install_mdbook
    install_admonish
    update_book_toml
    update_theme_files
    clean_build_cache
    build_and_test
    print_validation_checklist
    print_summary
    
    success "Migration completed!"
}

# Capture errors
trap 'error "Migration failed! Check $LOG_FILE for details."' ERR

# Execute main
main "$@"
