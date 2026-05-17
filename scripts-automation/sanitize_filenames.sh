#!/bin/sh

# USAGE   ... Sanitizes filenames in the current working directory by 
#             converting special characters/spaces to underscores.

for file in *; do
  [ -f "$file" ] || continue

  # Skip files without extensions (redundant, but kept for clarity)
  case "$file" in
    .*) continue ;;
  esac

  # Don't process files:  - without extention
  #                       - that have a leading dot
  #                       - that doesn't fit the list of extentions
  # When adding an extention, make sure the upper-case version is included. (Vim: gUU)
  case "$file" in
    *.txt|*.md|*.pdf|*.mp3|*.mp4|*.png|*.jpg|*.jpeg)
          base="${file%.*}"
          ext="${file##*.}"
          ;;
    *)    continue ;;
  esac

  # TODO: This spawns a lot of sub-shells/processes. 
  # Remove leading special characters.
  cleaned=$(printf "%s" "$base" | sed 's/^[^a-zA-Z0-9]\+//')
  # Remove trailing special characters.
  cleaned=$(printf "%s" "$cleaned" | sed 's/[^a-zA-Z0-9]\+$//')
  # Replace all special characters with underscores.
  cleaned=$(printf "%s" "$cleaned" | sed 's/[^a-zA-Z0-9_-]\+/_/g')
  # Collapse consecutive dashes and underscores to a single underscore.
  cleaned=$(printf "%s" "$cleaned" | sed 's/[-_]\{2,\}/_/g')

  # Skip renameing if name doesn't change
  [ "$base" = "$cleaned" ] && continue

  # Check if nothing remains / empty string
  if [ -z "$cleaned" ]; then
    epoch=$(date +%s%N)
    cleaned="file_${epoch}"
  fi

  # Compile final name
  new_filename="${cleaned}.${ext}"

  # If cleaned name already exists, add epoch timestamp before file extension
  if [ -e "$new_filename" ]; then
    epoch=$(date +%s%N)
    new_filename="${cleaned}_${epoch}.${ext}"
  fi

  # Print change
  echo ""
  echo "$file"
  echo "$new_filename"

  # Rename file
  mv "$file" "$new_filename"
done
