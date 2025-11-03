#!/usr/bin/env bash

# Get the current aerospace mode
# if [ "$1" ];
# then
#     CURRENT_MODE="$1"
# else
#     CURRENT_MODE=$(aerospace list-modes --current)
# fi
CURRENT_MODE="${MODE:-$(aerospace list-modes --current)}"
HELP_TEXT="${HELP:-""}"
BAR_TRANSPARENCY="BB"

# Set different colors/styling based on mode
case "$CURRENT_MODE" in
  "main")
    BG_COLOR="0x44ffffff"  # Default
    TEXT_COLOR="0xffffffff"
    BAR_COLOR="0xFF000000"
    ;;
  "aerospace")
    BG_COLOR="0xff01ff67"  # Green
    TEXT_COLOR="0xff000000"
    BAR_COLOR="0x${BAR_TRANSPARENCY}01ff67"
    ;;
  "layout")
    BG_COLOR="0xffff5370"  # Red
    TEXT_COLOR="0xffffffff"
    BAR_COLOR="0x${BAR_TRANSPARENCY}ff5370"
    ;;
  "tiles")
    BG_COLOR="0xff0000ff"  # Blue
    TEXT_COLOR="0xffffffff"
    BAR_COLOR="0x${BAR_TRANSPARENCY}0000ff"
    ;;
  "v_accordion")
    BG_COLOR="0xffffff00"  # Yellow
    TEXT_COLOR="0xff000000"
    BAR_COLOR="0x${BAR_TRANSPARENCY}ffff00"
    ;;
  "swapmode")
    BG_COLOR="0xffffff00"  # Yellow
    TEXT_COLOR="0xff000000"
    BAR_COLOR="0x${BAR_TRANSPARENCY}ffff00"
    ;;
  "move")
    BG_COLOR="0xffff6e4a"  # Orange
    TEXT_COLOR="0xffffffff"
    BAR_COLOR="0x${BAR_TRANSPARENCY}ff6e4a"
    ;;
  "float")
    BG_COLOR="0xff00b7eb"  # Blue
    TEXT_COLOR="0xff000000"
    BAR_COLOR="0x${BAR_TRANSPARENCY}00b7eb"
    ;;
  *)
    BG_COLOR="0xff000000"  # Black
    TEXT_COLOR="0xffffffff"
    BAR_COLOR="0x${BAR_TRANSPARENCY}000000"
    ;;
esac

if [[ "$HELP_TEXT" != "" ]]; then
    CURRENT_MODE="$CURRENT_MODE | $HELP_TEXT"
fi

# Update the sketchybar item and bar color
sketchybar --set "$NAME" \
  label="$CURRENT_MODE" \
  label.color="$TEXT_COLOR"
  # icon=""

# Update the entire bar color
sketchybar --bar color="$BAR_COLOR"
