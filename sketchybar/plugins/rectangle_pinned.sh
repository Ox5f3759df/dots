#!/bin/bash

# State file to track pinned status
STATE_FILE="/tmp/sketchybar_rectangle_pinned_state"

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "unpinned" > "$STATE_FILE"
fi

# Read current state
CURRENT_STATE=$(cat "$STATE_FILE")

# Toggle state
if [ "$CURRENT_STATE" = "pinned" ]; then
    NEW_STATE="unpinned"
    LABEL=""
    DRAWING="off"
    echo "unpinned" > "$STATE_FILE"
else
    NEW_STATE="pinned"
    LABEL="📌 Pinned"
    DRAWING="on"
    echo "pinned" > "$STATE_FILE"
fi

# Update the sketchybar item
sketchybar --set "$NAME" \
    label="$LABEL" \
    drawing="$DRAWING"