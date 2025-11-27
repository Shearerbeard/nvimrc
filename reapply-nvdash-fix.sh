#!/bin/bash
# Script to reapply nvdash cursor fix after UI plugin updates

NVDASH_FILE="$HOME/.local/share/nvim/lazy/ui/lua/nvchad/nvdash/init.lua"

echo "Checking if nvdash fix is needed..."

# Check if fix is already applied
if grep -q "Fallback: return first key position" "$NVDASH_FILE"; then
    echo "✓ Fix already applied - nothing to do"
    exit 0
fi

echo "Applying nvdash cursor fix..."

# Create backup
cp "$NVDASH_FILE" "$NVDASH_FILE.backup"

# Find the line with "end" that closes the key_movements function
# and insert the fallback returns before it
awk '
/^  local key_movements = function/ { in_function = 1 }
in_function && /^    end$/ && !found {
    print ""
    print "    -- Fallback: return first key position if no match found"
    print "    if key_lines[1] then"
    print "      return { key_lines[1].i, key_lines[1].col }"
    print "    end"
    print "    -- Ultimate fallback: return current position"
    print "    return { curline, 0 }"
    found = 1
}
{ print }
in_function && /^  end$/ { in_function = 0 }
' "$NVDASH_FILE.backup" > "$NVDASH_FILE"

echo "✓ Fix applied successfully"
echo "  Backup saved to: $NVDASH_FILE.backup"
