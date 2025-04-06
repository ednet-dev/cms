#!/bin/bash

# Find all Dart files in the lib directory excluding ednet_flow.dart
find lib -name "*.dart" -type f -not -path "*/ednet_flow.dart" | while read -r file; do
    # Check if file doesn't already have the part of directive
    if ! grep -q "part of ednet_flow;" "$file"; then
        echo "Adding part of directive to $file"
        # Create a temporary file
        temp_file=$(mktemp)
        # Add the part of directive at the beginning of the file
        echo "part of ednet_flow;" >"$temp_file"
        echo "" >>"$temp_file"
        # Append the original file, skipping any existing library or part declarations
        sed '/^library/d; /^part of/d; /^import/d; /^export/d' "$file" >>"$temp_file"
        # Replace the original file with the temporary file
        mv "$temp_file" "$file"
    else
        echo "Skipping $file - already has the part of directive"
    fi
done

echo "All Dart files updated with 'part of ednet_flow;' directive"
