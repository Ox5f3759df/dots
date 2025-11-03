#!/usr/bin/env python3

import json
import sys
import time
import subprocess
import traceback
from pathlib import Path

app_to_appname_script = Path("~/.config/aerospace/scripts/utils/app_to_appname.py").expanduser()
open_app_script = Path("~/.config/aerospace/scripts/utils/open_app.py").expanduser()
workspace_layout_script = Path("~/.config/aerospace/scripts/workspace_layout.py").expanduser()

fullscreen = [
    'fullscreen',
    'fullscreen-gaps',
    'macos-fullscreen'
]

layouts = [
    "h_tiles",
    "v_accordion",
    "h_accordion",
    "v_tiles",
]

fullscreen = [
    'fullscreen',
    'fullscreen-gaps',
    'macos-fullscreen'
]

move_directions = [
    "left",
    "right",
    "up",
    "down",
    "join-with-left",
    "join-with-right",
    "join-with-up",
    "join-with-down",
    "swap-with-left",
    "swap-with-right",
    "swap-with-up",
    "swap-with-down",
]

move_repeat_delim = "."

def open_application(application_to_open):
    app = application_to_open
    open_app = subprocess.run([str(open_app_script), app], capture_output=True, text=True).stdout.strip()
    if open_app != "yes":
        raise ValueError(f"Could not open application: " + app)

def get_window_ids(app, app_name, max_check=5, workspace=None, no_focus=False, first_only=False):
    window_ids = []
    found = False
    # Before doing anything ensure that workspace is tiling
    subprocess.run(["aerospace", "layout", "tiling"])
    for _ in range(max_check):
        result = subprocess.run(['aerospace', 'list-windows', '--all', '--json'], capture_output=True, text=True)
        windows = json.loads(result.stdout)
        for window in windows:
            if window['app-name'] == app_name:
                found = True
                window_id = window['window-id']
                window_ids.append(window_id)
                if first_only:
                    break
        if not found:
            open_application(app)
            time.sleep(1)
        else:
            break
    if not window_ids:
        raise ValueError("Could not find window IDs")
    # Move to current workspace just in case
    # for window_id in window_ids:
    #     if not workspace:
    #         result = subprocess.run(['aerospace', 'list-workspaces', '--focused'], capture_output=True, text=True)
    #         workspace = result.stdout.strip()
    #     cmd = f"aerospace move-node-to-workspace {workspace} --focus-follows-window --window-id {str(window_id)}"
    #     if no_focus:
    #         cmd = f"aerospace move-node-to-workspace {workspace} --window-id {str(window_id)}"
    #     subprocess.run(cmd.split(" "))
    return window_ids

def main(application_to_open="current", workspace=None, no_focus=False, first_only=False):
    tmp_file = Path(__file__).parent / "logs" / "errors.open_app_cmd.log"
    app_actions = []
    app_name = None
    with open(tmp_file, "a") as f:
        app_and_cmds = application_to_open
        try:
            parts = [app_and_cmds]
            if ":" in app_and_cmds:
                parts = app_and_cmds.split(':')
            app = parts[0]
            window_id = None
            window_ids = []
            if app == "current":
                result = subprocess.run(['aerospace', 'list-windows', '--focused', '--json'], capture_output=True, text=True)
                result = json.loads(result.stdout)[0]
                window_id = result['window-id']
                app_name = result['app-name']
            else:
                app_name = subprocess.run([str(app_to_appname_script), app], capture_output=True, text=True).stdout.strip()
            if not app_name:
                raise ValueError(f"Unsupported application: " + app)
            if not window_id:
                # Get or open the application's window_id
                window_ids = get_window_ids(app, app_name, workspace=workspace, no_focus=no_focus, first_only=first_only)
            else:
                window_ids = [window_id]
            # Parse Actions
            for action in parts[1:]:
                action = action.strip()
                if action in layouts:
                    cmd = f"aerospace layout tiling"
                    app_actions.append(cmd)
                    cmd = f"aerospace layout {action}"
                    app_actions.append(cmd)
                elif action.split(move_repeat_delim)[0] in move_directions:
                    move_action = "move"
                    move_direction = action
                    if "join-with-" in move_direction:
                        move_action = "join-with"
                        move_direction = move_direction.replace("join-with-", "")
                    elif "swap-with-" in move_direction:
                        move_action = "swap"
                        move_direction = move_direction.replace("swap-with-", "")
                    cmd = f"aerospace {move_action} {move_direction}"
                    app_actions.append(cmd)
                elif action in fullscreen:
                    cmd = "aerospace fullscreen --no-outer-gaps"
                    if action == "fullscreen-gaps":
                        cmd = "aerospace fullscreen"
                    elif action == "macos-fullscreen":
                        cmd = "aerospace macos-native-fullscreen on"
                    app_actions.append(cmd)
                else:
                    # Resize
                    direction = "width"
                    resize = str(action)
                    if "w-" in resize:
                        direction = "width"
                        resize = int(resize.replace("w-", ""))
                    elif "h-" in resize:
                        direction = "height"
                        resize = int(resize.replace("h-", ""))
                    else:
                        resize = int(resize)
                    resize_amount = "+" if resize > 0 else "-"
                    resize_amount = resize_amount + str(abs(resize))
                    cmd = f"aerospace resize {direction} {resize_amount}"
                    app_actions.append(cmd)
            for window_id in window_ids:
                # Now run the actions for the window-id
                for action in app_actions:
                    full_cmd = f"{action} --window-id {str(window_id)}"
                    # Debug
                    # f.write(full_cmd + "\n")
                    subprocess.run(full_cmd.split(" "))
                # Lastly just focus the window id
                if not no_focus:
                    subprocess.run(f"aerospace focus --window-id {str(window_id)}".split(" "))

        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    application_to_open = "current"
    try:
        application_to_open = sys.argv[1]
    except:
        pass
    workspace = None
    try:
        workspace = sys.argv[2]
    except:
        pass
    no_focus = False
    try:
        no_focus = sys.argv[3] == "no-focus"
    except:
        pass
    first_only = False
    try:
        first_only = sys.argv[4] == "first-only"
    except:
        pass
    main(application_to_open, workspace, no_focus, first_only)
