# MANUAL MIGRATION GUIDE
# mdBook v0.4.52 → v0.5.3
# 
# Use this if you prefer to apply changes manually instead of running the bash script.
# All line numbers are approximate and based on the original files.

## ============================================================================
## STEP 1: BACKUP YOUR CURRENT STATE
## ============================================================================

git add .
git commit -m "backup: pre-migration state before mdBook 0.5.3 upgrade"


## ============================================================================
## STEP 2: UPDATE book.toml
## ============================================================================

FILE: book.toml
LINE: 7

BEFORE:
```toml
[preprocessor.admonish]
command = "mdbook-admonish"
assets_version = "3.0.2" # do not edit: managed by `mdbook-admonish install`
```

AFTER:
```toml
[preprocessor.admonish]
command = "mdbook-admonish"
assets_version = "4.8.1" # UPDATED: was 3.0.2 - required for mdBook 0.5.x JSON protocol
```

COMMAND: sed -i '' 's/assets_version = "[^"]*"/assets_version = "1.20.0"/g' book.toml


## ============================================================================
## STEP 3: UPDATE theme/index.hbs (CRITICAL)
## ============================================================================

FILE: theme/index.hbs

### Change 3A: Remove FontAwesome CSS Link (LINE ~36)

BEFORE:
```html
        <!-- Fonts -->
        <link rel="stylesheet" href="{{ path_to_root }}FontAwesome/css/font-awesome.css">
        {{#if copy_fonts}}
```

AFTER:
```html
        <!-- Fonts - FontAwesome removed (now using mdBook 0.5.x built-in SVGs) -->
        {{#if copy_fonts}}
```

COMMAND: sed -i '' '/<link rel="stylesheet" href="{{ path_to_root }}FontAwesome\/css\/font-awesome.css">/d' theme/index.hbs


### Change 3B: Update Sidebar Toggle ID Script (LINE ~62-69)

BEFORE:
```html
            document.getElementById('sidebar-toggle').setAttribute('aria-expanded', sidebar === 'visible');
            document.getElementById('sidebar').setAttribute('aria-hidden', sidebar !== 'visible');
            Array.from(document.querySelectorAll('#sidebar a')).forEach(function(link) {
```

AFTER:
```html
            document.getElementById('mdbook-sidebar-toggle').setAttribute('aria-expanded', sidebar === 'visible');
            document.getElementById('mdbook-sidebar').setAttribute('aria-hidden', sidebar !== 'visible');
            Array.from(document.querySelectorAll('#mdbook-sidebar a')).forEach(function(link) {
```

COMMANDS:
```bash
sed -i '' "s/'sidebar-toggle'/'mdbook-sidebar-toggle'/g" theme/index.hbs
sed -i '' "s/'sidebar'/'mdbook-sidebar'/g" theme/index.hbs
sed -i '' "s/#sidebar a/#mdbook-sidebar a/g" theme/index.hbs
```


### Change 3C: Update Menu Bar ID (LINE ~290)

BEFORE:
```html
                <div id="menu-bar-hover-placeholder"></div>
                <div id="menu-bar" class="menu-bar sticky bordered">
```

AFTER:
```html
                <div id="mdbook-menu-bar-hover-placeholder"></div>
                <div id="mdbook-menu-bar" class="menu-bar sticky bordered">
```

COMMAND:
```bash
sed -i '' 's/id="menu-bar"/id="mdbook-menu-bar"/g' theme/index.hbs
sed -i '' 's/id="menu-bar-hover-placeholder"/id="mdbook-menu-bar-hover-placeholder"/g' theme/index.hbs
```


### Change 3D: Update Icon Classes (LINES ~289-325) - FontAwesome Removal

BEFORE:
```html
                        <button id="sidebar-toggle" class="icon-button" type="button" title="Toggle Table of Contents" aria-label="Toggle Table of Contents" aria-controls="sidebar">
                            <i class="fa fa-bars"></i>
                        </button>
                        <button id="theme-toggle" class="icon-button" type="button" title="Change theme" aria-label="Change theme" aria-haspopup="true" aria-expanded="false" aria-controls="theme-list">
                            <i class="fa fa-paint-brush"></i>
                        </button>
                        
                        {{#if search_enabled}}
                        <button id="search-toggle" class="icon-button" type="button" title="Search. (Shortkey: s)" aria-label="Toggle Searchbar" aria-expanded="false" aria-keyshortcuts="S" aria-controls="searchbar">
                            <i class="fa fa-search"></i>
                        </button>
                        {{/if}}
```

AFTER:
```html
                        <button id="mdbook-sidebar-toggle" class="icon-button" type="button" title="Toggle Table of Contents" aria-label="Toggle Table of Contents" aria-controls="mdbook-sidebar">
                            <i class="mdbook-hamburger"></i>
                        </button>
                        <button id="mdbook-theme-toggle" class="icon-button" type="button" title="Change theme" aria-label="Change theme" aria-haspopup="true" aria-expanded="false" aria-controls="mdbook-theme-list">
                            <i class="mdbook-paintbrush"></i>
                        </button>
                        
                        {{#if search_enabled}}
                        <button id="mdbook-search-toggle" class="icon-button" type="button" title="Search. (Shortkey: s)" aria-label="Toggle Searchbar" aria-expanded="false" aria-keyshortcuts="S" aria-controls="mdbook-searchbar">
                            <i class="mdbook-search"></i>
                        </button>
                        {{/if}}
```

COMMANDS:
```bash
# Replace individual icon classes
sed -i '' 's/<i class="fa fa-bars"><\/i>/<i class="mdbook-hamburger"><\/i>/g' theme/index.hbs
sed -i '' 's/<i class="fa fa-paint-brush"><\/i>/<i class="mdbook-paintbrush"><\/i>/g' theme/index.hbs
sed -i '' 's/<i class="fa fa-search"><\/i>/<i class="mdbook-search"><\/i>/g' theme/index.hbs
sed -i '' 's/<i class="fa fa-print"><\/i>/<i class="mdbook-print"><\/i>/g' theme/index.hbs
sed -i '' 's/<i class="fa fa-edit"><\/i>/<i class="mdbook-edit"><\/i>/g' theme/index.hbs
sed -i '' 's/<i class="fa fa-angle-left"><\/i>/<i class="mdbook-angle-left"><\/i>/g' theme/index.hbs
sed -i '' 's/<i class="fa fa-angle-right"><\/i>/<i class="mdbook-angle-right"><\/i>/g' theme/index.hbs
```


### Change 3E: Update Button IDs (LINES ~314-328)

BEFORE:
```html
                        {{#if print_enable}}
                        <a href="{{ path_to_root }}print.html" title="Print this book" aria-label="Print this book">
                            <i id="print-button" class="fa fa-print"></i>
                        </a>
                        {{/if}}
                        {{#if git_repository_url}}
                        <a href="{{git_repository_url}}" title="Git repository" aria-label="Git repository">
                            <i id="git-repository-button" class="fa {{git_repository_icon}}"></i>
                        </a>
                        {{/if}}
                        {{#if git_repository_edit_url}}
                        <a href="{{git_repository_edit_url}}" title="Suggest an edit" aria-label="Suggest an edit">
                            <i id="git-edit-button" class="fa fa-edit"></i>
                        </a>
                        {{/if}}
```

AFTER:
```html
                        {{#if print_enable}}
                        <a href="{{ path_to_root }}print.html" title="Print this book" aria-label="Print this book">
                            <i id="mdbook-print-button" class="mdbook-print"></i>
                        </a>
                        {{/if}}
                        {{#if git_repository_url}}
                        <a href="{{git_repository_url}}" title="Git repository" aria-label="Git repository">
                            <i id="mdbook-git-repository-button" class="mdbook-git {{git_repository_icon}}"></i>
                        </a>
                        {{/if}}
                        {{#if git_repository_edit_url}}
                        <a href="{{git_repository_edit_url}}" title="Suggest an edit" aria-label="Suggest an edit">
                            <i id="mdbook-git-edit-button" class="mdbook-edit"></i>
                        </a>
                        {{/if}}
```

COMMANDS:
```bash
sed -i '' 's/id="print-button"/id="mdbook-print-button"/g' theme/index.hbs
sed -i '' 's/id="git-repository-button"/id="mdbook-git-repository-button"/g' theme/index.hbs
sed -i '' 's/id="git-edit-button"/id="mdbook-git-edit-button"/g' theme/index.hbs
sed -i '' 's/id="theme-toggle"/id="mdbook-theme-toggle"/g' theme/index.hbs
sed -i '' 's/id="search-toggle"/id="mdbook-search-toggle"/g' theme/index.hbs
```


### Change 3F: Update JavaScript Navigation Selectors (LINES ~498, ~564)

BEFORE (line ~498):
```javascript
            var sidebarLinks = document.querySelectorAll("#sidebar a");
```

AFTER:
```javascript
            var sidebarLinks = document.querySelectorAll("#mdbook-sidebar a");
```

BEFORE (line ~564):
```javascript
            var links = document.querySelectorAll("#sidebar a");
```

AFTER:
```javascript
            var links = document.querySelectorAll("#mdbook-sidebar a");
```

COMMAND:
```bash
sed -i '' 's/document.querySelectorAll("#sidebar a")/document.querySelectorAll("#mdbook-sidebar a")/g' theme/index.hbs
```


## ============================================================================
## STEP 4: UPDATE theme/css/chrome.css
## ============================================================================

FILE: theme/css/chrome.css

Replace ALL instances of these ID selectors:

```bash
sed -i '' 's/#searchresults a/#mdbook-searchresults a/g' theme/css/chrome.css
sed -i '' 's/#menu-bar/#mdbook-menu-bar/g' theme/css/chrome.css
sed -i '' 's/#menu-bar-hover-placeholder/#mdbook-menu-bar-hover-placeholder/g' theme/css/chrome.css
```

SPECIFIC LINES:
- Line 14: `#searchresults a,` → `#mdbook-searchresults a,`
- Line 23: `#menu-bar,` → `#mdbook-menu-bar,`
- Line 24: `#menu-bar-hover-placeholder` → `#mdbook-menu-bar-hover-placeholder`
- Line 28: `#menu-bar {` → `#mdbook-menu-bar {`
- Lines 37-42: All `#menu-bar` and `#menu-bar-hover-placeholder` → add `mdbook-` prefix


## ============================================================================
## STEP 5: UPDATE theme/css/aggie-custom.css
## ============================================================================

FILE: theme/css/aggie-custom.css

### Change 5A: Update External Link Icon (LINES ~28-34)

BEFORE:
```css
a[href^="http"]:not([href*="tamu.edu"])::after,
a[href^="https"]:not([href*="tamu.edu"])::after {
  font-family: FontAwesome;
  content: " \f08e";
  font-size: 0.8em;
  margin-left: 0.2em;
}
```

AFTER:
```css
/* External link icon: Updated for mdBook 0.5.x */
/* Previously used FontAwesome v4 \f08e, now using Unicode character */
a[href^="http"]:not([href*="tamu.edu"])::after,
a[href^="https"]:not([href*="tamu.edu"])::after {
  font-family: Arial, sans-serif;
  content: " \2197";  /* ↗ Up-right arrow Unicode character */
  font-size: 0.8em;
  margin-left: 0.2em;
}
```

COMMAND:
```bash
# macOS sed (BSD)
sed -i '' 's/font-family: FontAwesome;/font-family: Arial, sans-serif;/' theme/css/aggie-custom.css
sed -i '' 's/content: " \\f08e";/content: " \\2197";  \/* ↗ Up-right arrow Unicode character *\//' theme/css/aggie-custom.css
```

## ============================================================================
## STEP 6: INSTALL NEW BINARIES
## ============================================================================

### Install mdBook v0.5.3

#### macOS:
```bash
# arm64 (M1/M2/M3)
curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.5.3/mdbook-v0.5.3-aarch64-apple-darwin.tar.gz | \
  tar -xz && sudo mv mdbook /usr/local/bin/

# x86_64 (Intel)
curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.5.3/mdbook-v0.5.3-x86_64-apple-darwin.tar.gz | \
  tar -xz && sudo mv mdbook /usr/local/bin/
```

#### Linux (x86_64):
```bash
curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.5.3/mdbook-v0.5.3-x86_64-unknown-linux-gnu.tar.gz | \
  tar -xz && sudo mv mdbook /usr/local/bin/
```

Verify:
```bash
mdbook --version  # Should output: mdbook v0.5.3
```


### Install mdbook-admonish v1.20.0

```bash
cargo install mdbook-admonish@1.20.0
```

Verify:
```bash
mdbook-admonish --version
```


## ============================================================================
## STEP 7: CLEAN & REBUILD
## ============================================================================

```bash
# Clean old build cache
mdbook clean

# Verify configuration
mdbook build

# Check output
ls -la book/index.html  # Should exist
```


## ============================================================================
## STEP 8: LOCAL TESTING
## ============================================================================

```bash
# Start local server
mdbook serve

# Open browser to http://localhost:3000
# Open DevTools (F12) and check:
#   ✓ No red console errors
#   ✓ Sidebar works
#   ✓ Theme toggle works
#   ✓ Search works
#   ✓ Icons display correctly
#   ✓ Admonitions styled correctly
```

Test checklist:
- [ ] Hamburger icon (top-left) works
- [ ] Theme toggle (paint brush) works  
- [ ] Search icon (magnifying glass) works
- [ ] Print button visible
- [ ] GitHub icon visible
- [ ] Edit button visible
- [ ] External link icons appear on external links
- [ ] No console errors
- [ ] Mobile menu works
- [ ] Sidebar collapse/expand smooth


## ============================================================================
## STEP 9: GIT COMMIT & PUSH
## ============================================================================

```bash
# Stage all changes
git add book.toml theme/

# Review changes
git diff --cached

# Commit
git commit -m "chore: upgrade mdBook 0.4.52 → 0.5.3

- Update mdbook-admonish 3.0.2 → 4.8.1
- Migrate HTML IDs to mdbook- namespace (prevents conflicts)
- Remove FontAwesome v4 web fonts (mdBook 0.5.x uses embedded SVGs)
- Update all CSS selectors with new ID prefixes
- Replace FontAwesome icons with Unicode equivalents in CSS"

# Push to staging
git push origin upgrade/mdbook-0.5.3
```


## ============================================================================
## ROLLBACK (if needed)
## ============================================================================

```bash
# Option 1: Git revert
git revert HEAD

# Option 2: Restore from backup (if backup script was used)
cp -r .backups/migration-*/  .

# Option 3: Manual rollback
git checkout HEAD -- book.toml theme/

# Reinstall old mdBook
curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.4.52/mdbook-v0.4.52-x86_64-apple-darwin.tar.gz | \
  tar -xz && sudo mv mdbook /usr/local/bin/

# Reinstall old admonish (if rolling back)
cargo install mdbook-admonish@3.0.2

# Rebuild
mdbook clean && mdbook build
```

