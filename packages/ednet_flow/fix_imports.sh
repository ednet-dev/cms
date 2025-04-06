#!/bin/bash

echo "Restoring necessary imports to files..."

# Add common imports to files
add_common_imports() {
    local file=$1
    local temp_file=$(mktemp)

    # Check if file already has these imports
    local has_flutter_material=$(grep -c "import 'package:flutter/material.dart';" "$file")
    local has_ednet_core=$(grep -c "import 'package:ednet_core/ednet_core.dart';" "$file")

    # Add at the top of the file
    echo "// This file is part of the EDNetFlow library.
// Restored imports for source file organization." >"$temp_file"
    echo "" >>"$temp_file"

    # Add imports if needed
    if [ "$has_flutter_material" -eq 0 ] && [[ "$file" == *"visualization"* || "$file" == *"components"* || "$file" == *"painters"* ]]; then
        echo "import 'package:flutter/material.dart';" >>"$temp_file"
    fi

    if [ "$has_ednet_core" -eq 0 ] && [[ "$file" == *"model"* || "$file" == *"adapter"* ]]; then
        echo "import 'package:ednet_core/ednet_core.dart';" >>"$temp_file"
    fi

    # Add a blank line if we added imports
    if [ "$has_flutter_material" -eq 0 ] || [ "$has_ednet_core" -eq 0 ]; then
        echo "" >>"$temp_file"
    fi

    # Append the existing file content
    cat "$file" >>"$temp_file"
    mv "$temp_file" "$file"
}

# Rename duplicate classes
rename_duplicates() {
    # First fix domain components
    if [ -f "lib/src/game_visualization/components/domain_component.dart" ]; then
        echo "Fixing domain_component.dart to resolve duplicate EntityComponent"
        sed -i '' 's/class EntityComponent /class GameEntityComponent /g' "lib/src/game_visualization/components/domain_component.dart"
    fi

    # Fix duplicate session classes - renaming files in session/ to avoid conflict with event_storming/session/
    for file in $(find "lib/src/session" -name "*.dart"); do
        echo "Renaming file $file to avoid duplication with event_storming/session/"
        filename=$(basename "$file")
        dirname=$(dirname "$file")
        mv "$file" "${dirname}/base_${filename}"
    done

    # Update the exports in the main library file
    sed -i '' 's|export .*/session/storming_session.dart|export "src/event_storming/session/storming_session.dart"|g' "lib/ednet_flow.dart"
    sed -i '' 's|export .*/session/participant.dart|export "src/event_storming/session/participant.dart"|g' "lib/ednet_flow.dart"
    sed -i '' 's|export .*/session/event_flow_board.dart|export "src/event_storming/session/event_flow_board.dart"|g' "lib/ednet_flow.dart"
}

# Process each file
find lib -name "*.dart" -type f -not -path "*/ednet_flow.dart" | while read -r file; do
    echo "Processing $file"
    add_common_imports "$file"
done

# Fix duplicate class definitions
rename_duplicates

echo "Import restoration completed!"
