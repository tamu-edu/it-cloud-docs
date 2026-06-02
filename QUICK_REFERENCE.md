# QUICK REFERENCE: mdBook 0.4.52 → 0.5.3 Changes

## 🚀 3 Commands to Deploy

```bash
# 1. Make the script executable
chmod +x migrate-to-v0.5.3.sh

# 2. DRY RUN (test without changes)
./migrate-to-v0.5.3.sh --dry-run

# 3. EXECUTE migration
./migrate-to-v0.5.3.sh
```

---

## 📋 What Changed (TL;DR)

| Component | Old (v0.4.52) | New (v0.5.3) | Impact |
|-----------|---------------|--------------|--------|
| **Plugin** | mdbook-admonish 3.0.2 | 1.20.0+ | ⚠️ BREAKING: JSON protocol changed |
| **Icons** | FontAwesome v4 web fonts | Built-in SVGs + Unicode | ⚠️ FontAwesome CSS removed |
| **HTML IDs** | `#sidebar`, `#menu-bar` | `#mdbook-sidebar`, `#mdbook-menu-bar` | ⚠️ Namespace collision prevention |
| **CSS** | ID selectors unchanged | All prefixed with `mdbook-` | ⚠️ Selector updates required |
| **Build Cache** | Compatible | NOT compatible | 🔧 Must run `mdbook clean` |

---

## 🎯 Critical Files Updated

```
✏️ book.toml                      (plugin version bump)
✏️ theme/index.hbs                (ID namespace + icon classes)
✏️ theme/css/chrome.css           (CSS selectors)
✏️ theme/css/aggie-custom.css     (FontAwesome removal)
🗑️ theme/FontAwesome/             (no longer used, auto-hidden)
```

---

## 🔄 ID Replacements (Automated by Script)

**In HTML & JavaScript:**
```
#sidebar                     → #mdbook-sidebar
#menu-bar                    → #mdbook-menu-bar
#menu-bar-hover-placeholder  → #mdbook-menu-bar-hover-placeholder
#search-toggle               → #mdbook-search-toggle
#searchresults               → #mdbook-searchresults
```

**In CSS Selectors:**
```
#menu-bar i                  → #mdbook-menu-bar i
#searchresults a             → #mdbook-searchresults a
```

---

## 🎨 Icon Replacements (FontAwesome v4 → v6.2.0)

**Removed Web Font Link:**
```html
<!-- DELETED -->
<link rel="stylesheet" href="{{ path_to_root }}FontAwesome/css/font-awesome.css">
```

**Icon Class Changes:**
| Icon | Old | New | Alt |
|------|-----|-----|-----|
| Menu | `fa fa-bars` | `mdbook-hamburger` | Or use Unicode `☰` |
| Theme | `fa fa-paint-brush` | `mdbook-paintbrush` | Or use Unicode `🎨` |
| Search | `fa fa-search` | `mdbook-search` | Or use Unicode `🔍` |
| Print | `fa fa-print` | `mdbook-print` | Or use Unicode `🖨️` |
| Edit | `fa fa-edit` | `mdbook-edit` | Or use Unicode `✏️` |
| Prev | `fa fa-angle-left` | `mdbook-angle-left` | Or use Unicode `‹` |
| Next | `fa fa-angle-right` | `mdbook-angle-right` | Or use Unicode `›` |

---

## 🧪 Validation Checklist

After migration, verify locally (`mdbook serve`):

### Visual:
- [ ] Icons render (hamburger, paintbrush, search, print, edit)
- [ ] Sidebar toggles
- [ ] Theme switch works
- [ ] Admonitions styled
- [ ] External link icons visible (↗)

### Functional:
- [ ] No console errors (F12 DevTools)
- [ ] Search works
- [ ] Navigation links functional
- [ ] Print to PDF works
- [ ] Mobile responsive
- [ ] Dark/Light theme toggle works

### Console Check (paste in DevTools):
```javascript
// Should return 0 (no errors)
console.getEventListeners(document).error?.length || 0
```

---

## 🚨 Common Issues & Fixes

| Issue | Cause | Solution |
|-------|-------|----------|
| Icons missing/broken | Old icon classes not updated | Run `migrate-to-v0.5.3.sh` |
| Sidebar doesn't work | ID selectors not prefixed | Check theme/index.hbs for `#mdbook-sidebar` |
| Admonitions broken | Plugin incompatibility | Ensure mdbook-admonish 4.8.1+ installed |
| Search doesn't work | Search ID not updated | Check `#mdbook-searchresults` in CSS |
| CSS styling off | Selectors pointing to old IDs | Run full script, don't skip CSS updates |
| Build fails | Old cache incompatible | Run `mdbook clean` before build |

---

## 🔄 Rollback (if issues)

```bash
# Quick rollback to previous version
git checkout HEAD -- book.toml theme/
mdbook clean
cargo install mdbook-admonish@3.0.2
mdbook build
```

---

## 📊 Migration Paths

### **Path 1: Automated (Recommended)**
```bash
./migrate-to-v0.5.3.sh      # Full automated migration with backups
```
**Time:** 5 minutes  
**Risk:** Very low  
**Includes:** Backups, rollback point, full validation

### **Path 2: Manual (Control)**
```bash
# Follow MANUAL_MIGRATION.md step-by-step
# Allows you to inspect each change
```
**Time:** 45 minutes  
**Risk:** Medium (manual errors possible)  
**Benefit:** Full control & understanding

### **Path 3: Hybrid (Review + Automate)**
```bash
./migrate-to-v0.5.3.sh --dry-run    # See what changes
./migrate-to-v0.5.3.sh              # Apply changes
```
**Time:** 10 minutes  
**Risk:** Low  
**Benefit:** Best of both worlds

---

## 📚 Additional Resources

- **mdBook v0.5.0 Release Notes:** https://github.com/rust-lang/mdBook/releases/tag/v0.5.0
- **mdbook-admonish Upgrade Guide:** https://github.com/tommilligan/mdbook-admonish
- **Full Migration Plan:** `MIGRATION_PLAN.md`
- **Manual Steps:** `MANUAL_MIGRATION.md`
- **Patch Files:** `*.v0.5.3.patch`

---

## ⏱️ Timeline

```
Pre-Migration (5 min)
  └─ git commit current state
  └─ Read MIGRATION_PLAN.md

Migration (5-10 min)
  └─ Run migrate-to-v0.5.3.sh
  └─ mdbook build
  └─ mdbook serve

Validation (10-15 min)
  └─ Verify checklist items
  └─ Browser testing
  └─ Console error check

Deployment (5 min)
  └─ git commit changes
  └─ git push
  └─ Monitor production

TOTAL: ~30-40 minutes
```

---

## 🎓 Key Learning Points

1. **Plugin Protocol Change:** mdBook v0.5.0 changed how preprocessors communicate
2. **Namespace Collision Prevention:** The `mdbook-` prefix avoids conflicts with user CSS
3. **FontAwesome Transition:** mdBook now embeds SVGs instead of web fonts
4. **Build Cache Incompatibility:** Always run `mdbook clean` after major version upgrades
5. **Environment Variable Validation:** v0.5.0+ validates all MDBOOK_* prefixes strictly

---

## 📞 Support

If you run into issues:

1. Check the **Common Issues & Fixes** table above
2. Review **MANUAL_MIGRATION.md** for detailed steps
3. Run with verbose logging: `RUST_LOG=debug mdbook serve`
4. Check browser DevTools console (F12) for errors
5. Verify all IDs have `mdbook-` prefix

---

**Status:** Ready to deploy  
**Risk Level:** LOW (fully automated with backups)  
**Recommended Approach:** Automated script with dry-run first
