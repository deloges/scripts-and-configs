#!/bin/sh

# USAGE   ... Merges files from a source directory into a target directory.
#             Resolves duplicate collisions with epoch timestamps.
#

# Baked in directories
SOURCE_DIR="$HOME/path/to/source/"
TARGET_DIR="$HOME/path/to/target/"

# Resolve directory path with 'realpath'.
SOURCE_DIR=$(realpath "$SOURCE_DIR")
TARGET_DIR=$(realpath "$TARGET_DIR")

echo ""
echo "Files get pulled from:  ${SOURCE_DIR}"
echo "Files are merged into:  ${TARGET_DIR}"
echo ""

# Initialize error variable
error_check=0

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
  echo "ERROR: Source direcory '${SOURCE_DIR}' does not exist."
  error_check=1
fi

# Check target directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "ERROR: Target direcory '${TARGET_DIR}' does not exist."
  error_check=1
fi

# Exit in case of error.
if [ "$error_check" != 0 ]; then
  exit 1
fi

# Go through all files in the source directory.
for file in "$SOURCE_DIR"/*; do

  # Check if file is regular
  if [ ! -f "$file" ]; then
    echo "ERROR: ${file} is not a regular file. Skipped."
    echo ""
    continue
  fi

  file_name=$(basename "$file")

  # Create target file path at target directory.
  new_file="${TARGET_DIR}/${file_name}"

  # Check if file name already exists at target directory.
  if [ -f "$new_file" ]; then

    echo "Duplicate file name: ${file_name}"

    # Reassemble target file path with epoch time stamp.
    base="${new_file%.*}"
    ext="${new_file##*.}"

    # echo "$base"
    # echo "$ext"

    # Create epoch time stamp for duplicate file names.
    epoch=$(date +%s%N)
    new_file="${base}_${epoch}.${ext}"

  fi

  # Rename and copy file to target directory.
  mv "$file" "$new_file"

  echo "File written: ${new_file}"

done

exit 0
