#!/bin/sh

# USAGE   ... Sets random wallpaper from target directory using swaybg. 

WALLPAPER_DIR="$HOME/path/to/wallpaper"

# Initialize the list
valid_files=""

# Populate list of valid files. Count files with desired extentions.
while IFS= read -r file; do
  case $file in
    *.jpg|*.jpeg|*.png)
      valid_files="$valid_files
$file"
      ;;
  esac
done <<EOF
$(find "$WALLPAPER_DIR" -type f)
EOF

# Exit if no matches
[ -z "$valid_files" ] && exit 1

# Pick (pseudo-) random number within range.
#
#   /dev/urandom  ... Special file that gives random binary data
#   od            ... Octal dump. Can be used for decimal too
#   -An           ... not print addresses or extra formatting
#   -N2           ... read 2 bytes (enough for a 16-bit number, i.e., max 65535)
#   -tu2          ... output as an unsigned 2-byte decimal
#   tr            ... removes all spaces (useful because od pads output)
#
rand=$(od -An -N2 -tu2 /dev/urandom | tr -d ' ')
total=$(printf "%s" "$valid_files" | wc -l)
line=$(( rand % total + 1 ))

# Extract the N-th line
selected=$(printf "%s" "$valid_files" | sed -n "${line}p")

# Kill any existing swaybg
# swaybg keeps running in the background to maintain the image on screen.
pkill swaybg 2>/dev/null

# Set wallpaper
swaybg -m fill -i "$selected" >/dev/null 2>&1 &

