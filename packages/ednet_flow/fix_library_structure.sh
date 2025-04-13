#!/bin/bash

echo "Fixing EDNetFlow library structure..."
echo "==================================="

# Function to extract unique imports from a file
extract_imports() {
    grep "^import " "$1" | sort -u || true
}

# Function to add part of directive if missing
add_part_of() {
    if ! grep -q "^part of ednet_flow;" "$1"; then
        # Preserve any comments at the start of the file
        if head -n1 "$1" | grep -q "^//"; then
            # Get all initial comments
            comments=$(awk '/^\/\//{ print; next; } { exit; }' "$1")
            # Remove the comments from the original file
            sed -i.bak "/^\/\//d" "$1"
            # Add comments, part of directive, and rest of the file
            echo "$comments" >"$1.new"
            echo "" >>"$1.new"
            echo "part of ednet_flow;" >>"$1.new"
            echo "" >>"$1.new"
            cat "$1" >>"$1.new"
            mv "$1.new" "$1"
        else
            # No comments, just add part of directive at the start
            echo -e "part of ednet_flow;\n\n$(cat "$1")" >"$1.new"
            mv "$1.new" "$1"
        fi
    fi
}

# Function to remove imports from a file
remove_imports() {
    sed -i.bak '/^import /d' "$1"
    rm -f "$1.bak"
}

# Collect all unique imports from src files
echo -e "\nCollecting imports from all source files..."
all_imports=""
for file in $(find lib/src -name "*.dart"); do
    imports=$(extract_imports "$file")
    if [ ! -z "$imports" ]; then
        all_imports="$all_imports\n$imports"
    fi
done

# Sort and deduplicate imports
unique_imports=$(echo -e "$all_imports" | sort -u | grep -v "^$" || true)

# Update main library file
echo -e "\nUpdating main library file..."
if [ ! -z "$unique_imports" ]; then
    # Read the current library file
    library_file="lib/ednet_flow.dart"
    library_content=$(cat "$library_file")

    # Find the position after existing imports
    last_import_line=$(grep -n "^import " "$library_file" | tail -n1 | cut -d: -f1)

    if [ ! -z "$last_import_line" ]; then
        # Split the file and add new imports
        head -n "$last_import_line" "$library_file" >"$library_file.new"
        echo -e "\n# Additional imports from source files" >>"$library_file.new"
        echo "$unique_imports" >>"$library_file.new"
        tail -n "+$((last_import_line + 1))" "$library_file" >>"$library_file.new"
        mv "$library_file.new" "$library_file"
    fi
fi

# Process all source files
echo -e "\nProcessing source files..."
for file in $(find lib/src -name "*.dart"); do
    echo "Processing $file"
    add_part_of "$file"
    remove_imports "$file"
done

echo -e "\nDone! Please review the changes and run tests."
