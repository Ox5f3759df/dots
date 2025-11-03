#!/usr/bin/env python3
import time
import json
import sys
import subprocess
import traceback
from pathlib import Path

move_apps_to_space_script = Path("~/.config/aerospace/scripts/move_apps_to_space.py").expanduser()
move_to_space_script = Path("~/.config/aerospace/scripts/move_to_space.py").expanduser()
layout_script = Path("~/.config/aerospace/scripts/workspace_layout.py").expanduser()
app_to_appname_script = Path("~/.config/aerospace/scripts/utils/app_to_appname.py").expanduser()

focus = [
    "focus"
]

layouts = [
    "h_tiles",
    "v_accordion"
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

def main(applications, space_A, space_B, layout, focus_workspace=None):
    tmp_file = Path(__file__).parent / "logs" / "errors.app_layout.log"
    app_resizes = {}
    app_layouts = {}
    app_movement = {}
    app_order = {}
    app_fullscreen = {}
    app_focus = {}
    with open(tmp_file, "a") as f:
        try:
            result = subprocess.run(['aerospace', 'list-windows', '--all', '--json'], capture_output=True, text=True)
            output = result.stdout
            windows = None
            if output:
                windows = json.loads(output)
            # Move apps out of space_A
            subprocess.run([str(move_apps_to_space_script), space_A, space_B])
            # Focus workspace space_A
            subprocess.run(['aerospace', 'workspace', space_A])
            app_list = applications.split(",")
            for app in app_list:
                app = app.strip()
                parts = app.split(":")
                app_name = subprocess.run([str(app_to_appname_script), parts[0]], capture_output=True, text=True).stdout.strip()
                if not app_name:
                    raise ValueError(f"Unsupported application: " + app)
                if ":" in app:
                    if app_name not in app_order:
                        app_order[app_name] = []
                    for other_part in parts[1:]:
                        other_part = other_part.strip()
                        if other_part in layouts:
                            app_layouts[app_name] = other_part
                            app_order[app_name].append('layout')
                        elif other_part.split(move_repeat_delim)[0] in move_directions:
                            app_order[app_name].append('move')
                            app_movement[app_name] = other_part
                        elif other_part in fullscreen:
                            app_order[app_name].append('fullscreen')
                            app_fullscreen[app_name] = other_part
                        elif other_part in focus:
                            app_order[app_name].append('focus')
                            app_focus[app_name] = other_part
                        else:
                            app_order[app_name].append('resize')
                            app_resizes[app_name] = other_part
                subprocess.run([str(move_to_space_script), parts[0], space_A])
            if focus_workspace:
                subprocess.run(['aerospace', 'workspace', focus_workspace])
            if layout:
                subprocess.run([str(layout_script), layout])
            subprocess.run(['aerospace', 'flatten-workspace-tree'])
            for app in app_list:
                parts = app.split(":")
                app_name = subprocess.run([str(app_to_appname_script), parts[0]], capture_output=True, text=True).stdout.strip()
                if not app_name:
                    raise ValueError(f"Unsupported application: " + app)
                resize = app_resizes.get(app_name, None)
                move_direction = app_movement.get(app_name, None)
                layout = app_layouts.get(app_name, None)
                _focus = app_focus.get(app_name, None)
                _fullscreen = app_fullscreen.get(app_name, None)
                for window in windows:
                    window_id = str(window['window-id'])
                    if window['app-name'] == app_name:
                        for app_name, actions in app_order.items():
                            for action in actions:
                                if action == 'resize' and resize:
                                    # Check if resize has h- for width resize and v- for height resize
                                    direction = "width"
                                    resize = str(resize)
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
                                    cmd = ['aerospace', 'resize', direction, resize_amount, '--window-id', window_id]
                                    # Debug write command run
                                    f.write(' '.join(cmd) + "\n")
                                    subprocess.run(cmd)
                                if action == 'fullscreen' and _fullscreen:
                                    cmd = ['aerospace', 'fullscreen', '--no-outer-gaps', '--window-id', window_id]
                                    if _fullscreen == 'fullscreen-gaps':
                                        cmd = ['aerospace', 'fullscreen', '--window-id', window_id]
                                    elif _fullscreen == 'macos-fullscreen':
                                        cmd = ['aerospace', 'macos-native-fullscreen', '--window-id', window_id]
                                    subprocess.run(cmd)
                                if action == 'move' and move_direction:
                                    repeat = 1
                                    if move_repeat_delim in move_direction:
                                        parts = move_direction.split(move_repeat_delim, 1)
                                        move_direction, repeat = parts
                                        assert repeat.isdigit()
                                        repeat = int(repeat)
                                    for _ in range(repeat):
                                        cmd = ['aerospace', 'move', move_direction, '--window-id', window_id]
                                        if 'join-with-' in move_direction:
                                            cmd = ['aerospace', 'join-with', move_direction.split('join-with-', 1)[-1], '--window-id', window_id]
                                        if 'swap-with-'  in move_direction:
                                            cmd = ['aerospace', 'swap', move_direction.split('swap-with-', 1)[-1], '--window-id', window_id]
                                    # Debug
                                    # f.write(' '.join(cmd) + "\n")
                                    subprocess.run(cmd)
                                if action == 'focus' and _focus:
                                    cmd = ['aerospace', 'focus', '--window-id', window_id]
                                    subprocess.run(cmd)
                                if action == 'layout' and layout:
                                    cmd = ['aerospace', 'layout', layout, '--window-id', window_id]
                                    f.write(' '.join(cmd) + "\n")
                                    subprocess.run(cmd)
                # time.sleep(0.1)
            # Trigger sketchybar
            subprocess.run(['sketchybar', '--trigger', 'aerospace_workspace_change', 'FOCUSED_WORKSPACE=' + space_A])
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    # Comma delimited
    applications = sys.argv[1]
    space_A = sys.argv[2]
    space_B = sys.argv[3]
    layout = "v_accordion"
    focus_workspace = None
    try:
        layout = sys.argv[4]
    except IndexError:
        pass
    try:
        focus_workspace = sys.argv[5]
    except IndexError:
        pass
    main(applications, space_A, space_B, layout, focus_workspace)
