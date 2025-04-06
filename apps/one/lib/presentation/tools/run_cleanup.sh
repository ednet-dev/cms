#!/bin/bash

# Script to run code cleanup tools

set -e # Exit immediately if a command exits with a non-zero status

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRESENTATION_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== EDNet One Code Cleanup Tool ==="
echo "This script will run multiple cleanup tools on the presentation layer."
echo "Working directory: $PRESENTATION_DIR"
echo

# Check if we want to run in dry-run mode
DRY_RUN=""
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
    echo "Running in dry-run mode (no changes will be made)"
fi

# Function to run a Dart script
run_dart_script() {
    local script_name=$1
    local script_path="$SCRIPT_DIR/$script_name"

    echo
    echo ">>> Running $script_name"
    echo "-------------------------------------"

    if [ -f "$script_path" ]; then
        cd "$PRESENTATION_DIR"
        # Use '.' for the current directory as the target
        dart "$script_path" $DRY_RUN --dir=.
    else
        echo "Error: Script not found at $script_path"
        exit 1
    fi
}

# First, run the Dart analyzer to see initial issues
echo ">>> Running Dart analyzer (before cleanup)"
echo "-------------------------------------"
cd "$PRESENTATION_DIR"
dart analyze .

# Run each cleanup script
run_dart_script "fix_unused_imports.dart"
run_dart_script "update_material_apis.dart"
run_dart_script "fix_opacity_api.dart"
run_dart_script "fix_unused_variables.dart"
run_dart_script "fix_bloc_warnings.dart"
run_dart_script "fix_dead_code.dart"

# Run the Dart analyzer again to see remaining issues
echo
echo ">>> Running Dart analyzer (after cleanup)"
echo "-------------------------------------"
cd "$PRESENTATION_DIR"
dart analyze .

echo
echo "=== Cleanup completed! ==="
if [[ -n "$DRY_RUN" ]]; then
    echo "This was a dry run. Run without --dry-run to apply changes."
else
    echo "All cleanup scripts have been executed."
fi
