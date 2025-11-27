#!/bin/bash
# Script to fix Lazy plugin conflicts and reapply our nvdash fix

set -e

echo "=== Fixing Lazy Plugin Conflicts ==="
echo

# Fix LuaSnip
echo "1. Resetting LuaSnip to clean state..."
cd ~/.local/share/nvim/lazy/LuaSnip
git reset --hard HEAD
git clean -fd
echo "✓ LuaSnip cleaned"
echo

# Fix UI plugin and preserve our nvdash fix
echo "2. Resetting UI plugin..."
cd ~/.local/share/nvim/lazy/ui
git reset --hard HEAD
git clean -fd
echo "✓ UI plugin cleaned"
echo

echo "3. Reapplying nvdash cursor fix..."
cd ~/.local/share/nvim/lazy/ui
if patch -p1 < ~/.config/nvim/nvdash-fix.patch; then
    echo "✓ nvdash fix reapplied successfully"
else
    echo "⚠ Patch failed - you may need to manually reapply the fix"
    echo "  See FIXES_DOCUMENTATION.md for instructions"
fi
echo

echo "=== All Done! ==="
echo "Now run ':Lazy sync' in Neovim to install new plugins"
