#!/usr/bin/env bash

# Dynamic front app + other workspace windows as icons.
# Focused line format: "<id> | <app> | <title>"

if [ "$SENDER" = "front_app_switched" ] || [ "$SENDER" = "aerospace_window_change" ]; then
  max_length=35
  title_trunc_length=10
  script_path="$(realpath "$0" 2>/dev/null || echo "$0")"

  focused_line="$(aerospace list-windows --focused 2>/dev/null | head -n1)"
  current_workspace="$(aerospace list-workspaces --focused 2>/dev/null)"

  if [ -n "$focused_line" ]; then
    focused_id="$(printf "%s" "$focused_line" | awk -F'|' '{gsub(/^ *| *$/,"",$1); print $1}')"
    app_name="$(printf "%s" "$focused_line" | awk -F'|' '{gsub(/^ *| *$/,"",$2); print $2}')"
    title="$(printf "%s" "$focused_line" | awk -F'|' '{gsub(/^ *| *$/,"",$3); print $3}')"
  fi

  if [ -z "$app_name" ]; then
    app_name="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)"
    title="$(osascript -e 'tell application "System Events" to tell (first application process whose frontmost is true) to get name of window 1' 2>/dev/null)"
  fi

  app_name="${app_name:0:$max_length}"
  title="${title:0:$max_length}"
  # label="[${current_workspace}] $app_name: $title"
  label="${current_workspace} $app_name"
  # label="$app_name | $title"

  sketchybar --set "$NAME" \
    label="$label" \
    icon.background.image="app.$app_name" \
    icon.background.image.scale=0.7
fi
