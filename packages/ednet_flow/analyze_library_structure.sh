#!/bin/bash

echo "Analyzing EDNetFlow library structure..."
echo "======================================="

# Find all Dart files in src directory
echo -e "\nScanning for Dart files in src..."
dart_files=$(find lib/src -name "*.dart")

echo -e "\nAnalyzing imports and part directives..."
echo "----------------------------------------"

has_issues=false

for file in $dart_files; do
    echo -e "\nChecking $file"

    # Check for import directives
    imports=$(grep -n "^import " "$file" || true)
    if [ ! -z "$imports" ]; then
        echo "❌ Found imports:"
        echo "$imports"
        has_issues=true
    else
        echo "✅ No imports found"
    fi

    # Check for part of directive
    part_of=$(grep -n "^part of " "$file" || true)
    if [ -z "$part_of" ]; then
        echo "❌ Missing 'part of' directive"
        has_issues=true
    else
        echo "✅ Has 'part of' directive"
    fi
done

# Check main library file
echo -e "\nChecking main library file (lib/ednet_flow.dart)..."
echo "------------------------------------------------"

# Check for part declarations
parts=$(grep -n "^part " "lib/ednet_flow.dart" || true)
if [ ! -z "$parts" ]; then
    echo "Found part declarations:"
    echo "$parts"
else
    echo "❌ No part declarations found in main library file"
    has_issues=true
fi

if [ "$has_issues" = true ]; then
    echo -e "\n⚠️  Issues found that need to be addressed"
    exit 1
else
    echo -e "\n✅ No issues found"
    exit 0
fi
