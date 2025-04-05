#!/bin/bash

LIBRARY_FILE="lib/ednet_flow.dart"
IMPORT_SECTION_END_LINE=$(grep -n "// Core components" $LIBRARY_FILE | cut -d: -f1)
IMPORT_SECTION_END_LINE=$((IMPORT_SECTION_END_LINE - 1))

echo "Processing library structure..."

# 1. Collect all unique imports from all dart files
echo "Collecting imports from all files..."
TEMP_IMPORTS=$(mktemp)

find lib -name "*.dart" -type f -not -path "*/ednet_flow.dart" | while read -r file; do
    grep "^import " "$file" >>"$TEMP_IMPORTS"
done

# Sort and get unique imports
sort -u "$TEMP_IMPORTS" >"${TEMP_IMPORTS}.unique"

# 2. Add these imports to the library file if they don't already exist
echo "Updating imports in main library file..."
while read -r import_line; do
    if ! grep -q "^$import_line" "$LIBRARY_FILE"; then
        echo "Adding import: $import_line"
        # Create a temporary file for the library with the new import
        TEMP_LIB=$(mktemp)
        head -n $IMPORT_SECTION_END_LINE "$LIBRARY_FILE" >"$TEMP_LIB"
        echo "$import_line" >>"$TEMP_LIB"
        tail -n +$((IMPORT_SECTION_END_LINE + 1)) "$LIBRARY_FILE" >>"$TEMP_LIB"
        mv "$TEMP_LIB" "$LIBRARY_FILE"
        IMPORT_SECTION_END_LINE=$((IMPORT_SECTION_END_LINE + 1))
    fi
done <"${TEMP_IMPORTS}.unique"

# 3. Clean up all dart files to only have "part of ednet_flow;" directive
echo "Cleaning up source files..."
find lib -name "*.dart" -type f -not -path "*/ednet_flow.dart" | while read -r file; do
    echo "Processing $file"
    # Create a temporary file
    TEMP_FILE=$(mktemp)

    # Add the part of directive at the beginning
    echo "part of ednet_flow;" >"$TEMP_FILE"
    echo "" >>"$TEMP_FILE"

    # Add the rest of the file content, skipping imports, exports, libraries, and part of declarations
    sed '/^import /d; /^export /d; /^library /d; /^part of /d' "$file" >>"$TEMP_FILE"

    # Replace the original file
    mv "$TEMP_FILE" "$file"
done

# 4. Verify all paths in the ednet_flow.dart file
echo "Verifying paths in library file..."
TEMP_FILE=$(mktemp)
grep "^part " "$LIBRARY_FILE" | while read -r part_line; do
    # Extract the path from the part declaration
    path=$(echo "$part_line" | sed -e "s/part ['\"]\(.*\)['\"];/\1/")
    if [ ! -f "lib/$path" ]; then
        echo "WARNING: $path referenced in library file does not exist!"
    fi
done

echo "Library migration completed!"

# Clean up temporary files
rm -f "$TEMP_IMPORTS" "${TEMP_IMPORTS}.unique"
