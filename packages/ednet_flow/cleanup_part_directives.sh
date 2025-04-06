#!/bin/bash

echo "Removing 'part of ednet_flow;' directives from files..."

# Find all Dart files in the lib directory
find lib -name "*.dart" -type f -not -path "*/ednet_flow.dart" | while read -r file; do
    echo "Processing $file"
    # Create a temporary file
    TEMP_FILE=$(mktemp)

    # Remove the part of directive but keep the rest of the file
    sed '/^part of ednet_flow;/d' "$file" >"$TEMP_FILE"

    # Replace the original file
    mv "$TEMP_FILE" "$file"
done

echo "All part directives removed successfully!"
