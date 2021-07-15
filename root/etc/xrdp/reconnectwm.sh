#!/bin/sh

# Write procedures here you want to execute on reconnect
# Initialize clipboard on connection, otherwise emacs will hang when
# performing clipboard operations and the clipboard isn't set.
# This might be specific to the Guacamole setup, but I doubt it.
# echo "Clipboard initialized" | xclip -selection clipboard
echo "" | xclip -selection clipboard
