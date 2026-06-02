# mdBook v0.4.52 → v0.5.3 Migration Plan

**Date:** June 2, 2026  
**Status:** Ready for deployment  
**Risk Level:** MEDIUM (FontAwesome & ID namespace changes)

---

## 📋 Executive Summary

Your documentation site requires **3 critical updates**:

1. **Plugin upgrade** (mdbook-admonish: 3.0.2 → 4.8.1+)
2. **FontAwesome migration** (v4 web fonts → v6.2.0 SVG)
3. **HTML ID namespace updates** (preventing collision conflicts)

**Estimated migration time:** 45 minutes (including validation)

---

## 🔍 PHASE 1: PRE-MIGRATION AUDIT RESULTS

### A. Plugin Compatibility Audit

**mdbook-admonish v3.0.2 → v4.8.1+ REQUIRED**

**Why:**
- mdBook 0.5.0 changed JSON protocol for preprocessor communication
- Chapter data structure: `sections` → `items` 
- mdbook-admonish v3 cannot parse new format

**Action:** Update via Cargo during install phase

### B. Environment Variables Check

✅ **PASSED** — No custom `MDBOOK_*` prefixes detected in:
- `book.toml`
- CI/build scripts
- Makefile

### C. FontAwesome Audit

**Critical Issues Found:**

1. **Web Font References:**
   - `theme/index.hbs` line 36: `FontAwesome/css/font-awesome.css`
   - Loads legacy v4 web fonts (no longer bundled in v0.5.x)

2. **Icon Element Issues (8 total):**
   ```html
   ❌ <i class="fa fa-bars"></i>           (sidebar toggle)
   ❌ <i class="fa fa-paint-brush"></i>    (theme toggle)
   ❌ <i class="fa fa-search"></i>         (search)
   ❌ <i class="fa fa-print"></i>          (print)
   ❌ <i class="fa fa-edit"></i>           (edit)
   ❌ <i class="fa fa-angle-left"></i>     (prev nav)
   ❌ <i class="fa fa-angle-right"></i>    (next nav)
   ```

3. **CSS FontAwesome Reference:**
   ```css
   /* theme/css/aggie-custom.css line 28 */
   font-family: FontAwesome;
   content: " \f08e";  /* External link icon */
   ```

**Migration Strategy:**
- Remove font-awesome.css link
- Update `<i>` tags → mdBook v0.5.x built-in SVG icons OR use inline SVG
- Update CSS to use Unicode characters or remove if not needed

### D. HTML ID Namespace Audit

**mdBook 0.5.x adds `mdbook-` prefix to prevent conflicts**

**IDs requiring updates in custom theme:**

```
Sidebar:
  #sidebar                    → #mdbook-sidebar
  #sidebar-toggle             → #mdbook-sidebar-toggle
  #sidebar a (queries)        → #mdbook-sidebar a

Menu Bar:
  #menu-bar                   → #mdbook-menu-bar
  #menu-bar-hover-placeholder → #mdbook-menu-bar-hover-placeholder
  #menu-bar i                 → #mdbook-menu-bar i
  #menu-bar .icon-button      → #mdbook-menu-bar .icon-button

Theme Toggle:
  #theme-toggle               → #mdbook-theme-toggle
  #theme-list                 → #mdbook-theme-list

Search:
  #search-toggle              → #mdbook-search-toggle
  #searchbar                  → #mdbook-searchbar
  #searchbar-outer            → #mdbook-searchbar-outer
  #searchresults              → #mdbook-searchresults
  #searchresults-outer        → #mdbook-searchresults-outer
  #searchresults-header       → #mdbook-searchresults-header

Other:
  #print-button               → #mdbook-print-button
  #git-repository-button      → #mdbook-git-repository-button
  #git-edit-button            → #mdbook-git-edit-button
```

---

## 📦 PHASE 2: FILES REQUIRING UPDATES

### Files to Modify:

1. ✏️ `book.toml` — Plugin version bump
2. ✏️ `theme/index.hbs` — ID namespace + FontAwesome icons
3. ✏️ `theme/css/chrome.css` — ID selectors + icon styling
4. ✏️ `theme/css/aggie-custom.css` — FontAwesome reference
5. ✏️ `Makefile` — mdBook binary version (optional)

### Files to Remove:

- 🗑️ `theme/FontAwesome/css/font-awesome.css` (optional, auto-hidden in v0.5.x)
- 🗑️ `theme/FontAwesome/fonts/*` (optional, auto-hidden in v0.5.x)

---

## 🛠 PHASE 3: IMPLEMENTATION CHECKLIST

### Step 1: Update book.toml
```toml
[preprocessor.admonish]
command = "mdbook-admonish"
assets_version = "1.20.0"  # Changed from 3.0.2
```

### Step 2: Update Handlebars Template (index.hbs)

**Changes:**
- Update all `#sidebar` → `#mdbook-sidebar` in JavaScript
- Update all icon classes (use mdBook built-in SVGs or unicode)
- Update all button IDs with `mdbook-` prefix

### Step 3: Update CSS Selectors

**chrome.css:**
- `#menu-bar` → `#mdbook-menu-bar`
- `#menu-bar-hover-placeholder` → `#mdbook-menu-bar-hover-placeholder`
- `#menu-bar i` → `#mdbook-menu-bar i`
- `#searchresults a` → `#mdbook-searchresults a`

**aggie-custom.css:**
- Remove FontAwesome content reference or replace with Unicode character

### Step 4: Validate Locally

```bash
# Clean old build
mdbook clean

# Install v0.5.3
# (See deployment commands below)

# Test locally
mdbook serve

# Verify:
✓ All icons render correctly
✓ Sidebar navigation works
✓ Theme toggle functional
✓ Search operational
✓ Print button renders
✓ No console errors
```

---

## 🚀 PHASE 4: DEPLOYMENT COMMANDS

### Safe Wipe & Fresh Install:

```bash
# Step 1: Backup current binary (optional)
which mdbook && cp $(which mdbook) ~/mdbook-v0.4.52.backup

# Step 2: Clean build cache
mdbook clean

# Step 3: Install mdBook v0.5.3 (macOS arm64)
curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.5.3/mdbook-v0.5.3-aarch64-apple-darwin.tar.gz | \
  tar -xz && mv mdbook /usr/local/bin/

# Verify installation
mdbook --version  # Should print: mdbook v0.5.3

# Step 4: Install/upgrade mdbook-admonish via Cargo
cargo install mdbook-admonish@4.8.1

# Step 5: Verify plugin installation
mdbook-admonish --version

# Step 5: Full rebuild (tests new config)
mdbook build

# Step 7: Local preview
mdbook serve
```

---

## ✅ PHASE 5: LOCAL VALIDATION CHECKLIST

Before pushing to production, verify each item:

### Visual Rendering:

- [ ] **Sidebar navigation** renders and collapses properly
- [ ] **Menu bar icons** display correctly (hamburger, paintbrush, search)
- [ ] **Theme toggle** button functions
- [ ] **Print button** appears and has correct icon
- [ ] **GitHub edit button** appears with correct icon
- [ ] **Previous/next navigation** buttons visible
- [ ] **External link icon** (`\f08e`) displays next to external links
- [ ] **Admonitions** render with correct styling (aggiecustom, aggiecustom2)

### Functional Testing:

- [ ] **Dark/Light theme toggle** works
- [ ] **Search functionality** operational
- [ ] **Sidebar collapse/expand** smooth
- [ ] **Print to PDF** generates correctly
- [ ] **Mobile responsive** layout intact
- [ ] **Page navigation** links work
- [ ] **No 404 errors** in browser console
- [ ] **No JavaScript errors** on page load

### Browser Console:

```bash
# Open DevTools (F12), check Console tab:
# Expected: No red errors
# ❌ Errors like "Cannot read property of null" indicate ID mismatches
```

---

## 📊 MIGRATION RISK MATRIX

| Risk | Severity | Mitigation |
|------|----------|-----------|
| FontAwesome icons fail | HIGH | Use built-in mdBook icons or Unicode fallback |
| ID selector mismatches | HIGH | Use provided patch files; test locally first |
| Plugin incompatibility | MEDIUM | Update to v4.8.1+; test admonitions |
| CSS breakage | LOW | All CSS updates provided in patch |
| Search indexing breaks | LOW | mdBook 0.5.x maintains compatibility |

---

## 🔄 ROLLBACK PLAN

If issues arise:

```bash
# Revert to v0.4.52
mdbook clean
curl -sSL https://github.com/rust-lang/mdBook/releases/download/v0.4.52/mdbook-v0.4.52-x86_64-apple-darwin.tar.gz | \
  tar -xz && mv mdbook /usr/local/bin/

# Revert theme changes (git)
git checkout theme/index.hbs theme/css/

# Revert plugin
cargo install mdbook-admonish@3.0.2

# Clean and rebuild
mdbook clean && mdbook build
```

---

## 📝 Post-Migration Notes

1. **FontAwesome CDN Option:** If you need full FontAwesome v6.2.0 support beyond built-in icons, add to `book.toml`:
   ```toml
   [output.html]
   additional-css = ["https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"]
   ```
   However, use mdBook's embedded SVGs for core UI icons (recommended).

2. **Archive FontAwesome fonts:** Keep `theme/FontAwesome/` directory but it's ignored by mdBook 0.5.x. Safe to leave as-is.

3. **Future updates:** mdBook now follows semantic versioning strictly. Minor version upgrades (0.5.x → 0.6.x) should be backward compatible.

---

## 📞 Support

If you encounter issues not covered here:
1. Check mdBook [CHANGELOG](https://github.com/rust-lang/mdBook/releases/tag/v0.5.0)
2. Review mdbook-admonish [migration guide](https://github.com/tommilligan/mdbook-admonish)
3. Enable verbose logging: `RUST_LOG=debug mdbook serve`

