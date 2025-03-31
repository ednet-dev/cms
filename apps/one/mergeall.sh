#!/usr/bin/env bash

# ------------------------------------------------------------------
# merge_dart.sh
#
# This script merges Dart source files from a specified directory
# (default: "./lib") into a single output file optimized for LLM
# consumption. It performs the following optimizations:
#
# 1. Skips empty/whitespace-only lines.
# 2. Removes comment-only lines (lines starting with "//").
# 3. Skips lines containing "import" or "part" directives.
# 4. Trims leading and trailing whitespace and collapses multiple
#    consecutive whitespace characters into a single space.
# 5. Joins the filtered lines into one continuous line per file.
# 6. Inserts file boundary markers (as comments) for clarity.
#
# Usage:
#   ./merge_dart.sh [subpath]
#
#   Example:
#     ./merge_dart.sh ./lib
#
# The output file "merged_ednet_code_generation.dart" will be created in the
# project root.
# ------------------------------------------------------------------

# Change to the project root directory (where the script is located)
cd "$(dirname "$0")"

# Accept a directory subpath argument; default to "./lib" if not provided
DIR=${1:-"./lib"}
echo "Merging Dart files from: $DIR"

# Temporary file list and output file name
FILE_LIST="dart_files_list.txt"
OUTPUT_FILE="merged_ednet_core.dart"

# Collect all Dart files under the specified directory and sort them
find "$DIR" -type f -name '*.dart' | sort > "$FILE_LIST"

# Remove any old merged output file
rm -f "$OUTPUT_FILE"

# Add a header to the output file
{
  echo "// Merged ednet_core library (optimized for LLM consumption)"
  echo "// Generated on $(date)"
  echo "// Source Directory: $DIR"
  echo ""
} >> "$OUTPUT_FILE"

# Loop through each Dart file in the list
while IFS= read -r dart_file; do
  # Insert a file boundary marker
  echo "// ----- FILE: $dart_file -----" >> "$OUTPUT_FILE"

  # Process file:
  # 1. Use grep to remove empty lines, comment-only lines, import and part lines.
  # 2. Use sed to trim leading/trailing whitespace and collapse multiple spaces.
  # 3. Use tr to join all lines into one (separated by a single space).
  processed_content=$(grep -v -E '^\s*$|^\s*//|^\s*import|^\s*part' "$dart_file" \
    | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[[:space:]]+/ /g' \
    | tr '\n' ' ')

  # Write the processed content into the output file
  echo "$processed_content" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"  # add a newline between files
done < "$FILE_LIST"

# Cleanup temporary file list
rm "$FILE_LIST"

echo "All .dart files in $DIR have been merged into $OUTPUT_FILE."
