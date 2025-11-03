#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

FONT_SIZE="14.0"
FONT_FAMILY="JetBrainsMono Nerd Font Mono"
sketchybar --set "$NAME" label="$(date '+%a %d %b %H:%M')" label.font="$FONT_FAMILY:Regular:$FONT_SIZE"

