#!/bin/sh

# FRONT_APP_FONT="${NON_MONO_FONT_FAMILY:-Departure Mono}"
# FRONT_APP_FONT="${NON_MONO_FONT_FAMILY:-SF Compact Text}"
# FRONT_APP_FONT="${NON_MONO_FONT_FAMILY:-SF Compact}"
FRONT_APP_FONT="${NON_MONO_FONT_FAMILY:-JetBrainsMono Nerd Font Mono}"
FONT_SIZE="14.0"
Y_OFFSET=0

front_app=(
  label.font="$FRONT_APP_FONT:Regular:$FONT_SIZE"
  label.y_offset=$Y_OFFSET \
  icon.background.drawing=on
  display=active
  script="$PLUGIN_DIR/front_app.sh"
  click_script="open -a 'Mission Control'"
)

# sketchybar --add item front_app left \
# sketchybar --add item front_app center \
sketchybar --add item front_app right \
           --set front_app "${front_app[@]}"  \
           --subscribe front_app front_app_switched aerospace_window_change

