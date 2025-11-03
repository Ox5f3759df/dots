#!/usr/bin/env bash

# if [ "$1" ];
# then
#     IS_FULLSCREEN="$1"
# else
#     IS_FULLSCREEN=$(aerospace list-windows --focused --format "%{window-is-fullscreen}")
# fi

IS_FULLSCREEN=$(aerospace list-windows --focused --format "%{window-is-fullscreen}")

STATUS="Normal"
# Set different colors/styling based on mode
if [[ "$IS_FULLSCREEN" == "true" ]];
then
    TEXT_COLOR="0xffff57f4" # Pink
    STATUS="Fullscreen"
else
    TEXT_COLOR="0xffffffff"
fi

# Update the sketchybar item and bar color
sketchybar --set "$NAME" \
  label="$STATUS" \
  label.color="$TEXT_COLOR" \
  icon=""