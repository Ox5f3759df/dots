#!/usr/bin/env python3

import json
import sys
import time
import subprocess
import traceback
from pathlib import Path

app_to_appname_script = Path("~/.config/aerospace/scripts/utils/app_to_appname.py").expanduser()
open_app_script = Path("~/.config/aerospace/scripts/utils/open_app.py").expanduser()

fullscreen = [
    'fullscreen',
    'fullscreen-gaps',
    'macos-fullscreen'
]

def open_application(application_to_open):
    app = application_to_open
    open_app = subprocess.run([str(open_app_script), app], capture_output=True, text=True).stdout.strip()
    if open_app != "yes":
        raise ValueError(f"Could not open application: " + app)

def get_window_ids(app, app_name, max_check=5):
    window_ids = {}
    found = False
    for _ in range(max_check):
        result = subprocess.run(['aerospace', 'list-windows', '--all', '--json'], capture_output=True, text=True)
        windows = json.loads(result.stdout)
        for window in windows:
            if window['app-name'] == app_name:
                found = True
                window_id = window['window-id']
                if app_name not in window_ids:
                    window_ids[app_name] = []
                if window_id not in window_ids[app_name]:
                    window_ids[app_name].append(window_id)
        if not found:
            open_application(app)
            time.sleep(1)
        else:
            break
    if not window_ids:
        raise ValueError("Could not find window ID")
    return window_ids

def main(application_to_open, space_to_move_to, fullscreen_cmd=None):
    tmp_file = Path(__file__).parent / "logs" / "errors.move_to_space.log"
    with open(tmp_file, "a") as f:
        app = application_to_open
        try:
            app_name = subprocess.run([str(app_to_appname_script), app], capture_output=True, text=True).stdout.strip()
            if not app_name:
                raise ValueError(f"Unsupported application: " + app)
            is_current = space_to_move_to == "current"
            if is_current:
                space_to_move_to = subprocess.run(['aerospace', 'list-workspaces', '--focused'], capture_output=True, text=True).stdout.strip()
            window_ids = get_window_ids(app, app_name)
            for app, ids in window_ids.items():
                for id in ids:
                    will_fullscreen = fullscreen_cmd and fullscreen_cmd in fullscreen
                    cmd = ['aerospace', 'move-node-to-workspace', '--window-id', str(id), str(space_to_move_to)]
                    subprocess.run(cmd)
                    if will_fullscreen:
                        cmd = ['aerospace', 'fullscreen', '--no-outer-gaps', '--window-id', str(id)]
                        if fullscreen_cmd == 'fullscreen-gaps':
                            cmd = ['aerospace', 'fullscreen', '--window-id', str(id)]
                        elif fullscreen_cmd == 'macos-fullscreen':
                            cmd = ['aerospace', 'macos-native-fullscreen', '--window-id', str(id)]
                        f.write(app + ": ".join(cmd) + "\n")
                        f.write(str(window_ids) + "\n")
                        subprocess.run(cmd)
                        cmd = ['aerospace', 'focus', '--window-id', str(id)]
                        subprocess.run(cmd)
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    application_to_open = sys.argv[1]
    # If specified current then find the current workspace and move application there
    space_to_move_to = sys.argv[2]
    fullscreen_cmd = None
    try:
        fullscreen_cmd = sys.argv[3]
    except:
        pass
    main(application_to_open, space_to_move_to, fullscreen_cmd)