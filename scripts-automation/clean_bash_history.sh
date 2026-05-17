#!/bin/sh

# FUNCTION    Remove entries from the bash history file that match the keyword.
#
# USAGE       (1)       history -a
#             (2)       ./clean_bash_history.sh <keyword>
#
# EXAMPLE     ./clean_bash_history.sh "cryptsetup" "/mnt"
#
# WARNING     This does only affect the written bash history file. Bash does not
#             update the history file as it goes. Bash updates the history file
#             when the terminal session is closed. History from the current
#             terminal session remains in cache and will still be written to the
#             (new/sanitized) history file. To combat that, run the following 
#             two commands afterwards:
#
#               history -c    ... CLEAR all bash history from current terminal
#                                 session.
#               history -a    ... APPEND the history from current session into
#                                 the .bash_history file.
#
# FURTHER     This is a one-off script for cleaning the existing history file. 
#             Future entries (keywords) should be excluded via ~/.bashrc
#
#               export HISTIGNORE="man *:*cryptsetup*:*/mnt*"

# Current file that contains bash history.
BASH_HISTORY_FILE="$HOME/.bash_history"
# Temporary file to work with. Gets removed later.
TEMP_FILE="$HOME/.bash_history_temp"

# Check if any argument (keyword) was provided by the user.
if [ $# -eq 0 ]; then
  echo "Usage:  $0 keyword1 keyword2"
  echo "Use double quotes for keywords that contain spaces or special characters."
  exit 1
fi

# Create temporary file to work on.
cp "$BASH_HISTORY_FILE" "$TEMP_FILE"

# Loop through all user provided arguments.
for keyword in "$@"; do
  # The -v flag inverts the matches. grep -v provides all lines that do NOT 
  # contain the keyword. The -F flag treats keywords as fixed strings.
  grep -Fv "$keyword" "$TEMP_FILE" > "$TEMP_FILE.tmp"
  # Replace the working temp file with the newly filtered one for potential
  # next cycle (multiple keywords provided).
  mv "$TEMP_FILE.tmp" "$TEMP_FILE"
done

# Overwrite original history file. This removes the temporary file.
mv "$TEMP_FILE" "$BASH_HISTORY_FILE"

echo "Done."
echo "Run 'history -c && history -r' to clear current bash history and read the cleaned file into the current session. See script comment for further information."
