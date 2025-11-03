#!/usr/bin/env python3
import json
import subprocess
import traceback
from pathlib import Path

preference = {
    "Firefox": 'B',
    "Code": 'B',
    "WezTerm": 'B',
    "Obsidian": 'C',
    "IntelliJ IDEA": 'C',
}

default_layout = "v_accordion"

def main():
    tmp_file = Path(__file__).parent / "logs" / "errors.group_apps_into_workspaces.log"
    with open(tmp_file, "a") as f:
        try:
            result = subprocess.run(['aerospace', 'list-windows', '--all', '--json'], capture_output=True, text=True)
            output = result.stdout
            if output:
                windows = json.loads(output)
                app_to_window_ids = {}
                for window in windows:
                    app_name = window['app-name']
                    window_id = window['window-id']
                    if app_name not in app_to_window_ids:
                        app_to_window_ids[app_name] = []
                    app_to_window_ids[app_name].append(window_id)
                for app_name, window_ids in app_to_window_ids.items():
                    if app_name in preference:
                        window_ids = app_to_window_ids[app_name]
                        workspace = preference[app_name]
                        for window_id in window_ids:
                            cmd = ['aerospace', 'move-node-to-workspace', '--window-id', str(window_id), workspace]
                            subprocess.run(cmd)
                            subprocess.run(['aerospace', 'fullscreen', '--window-id', str(window_id)])
                            subprocess.run(['aerospace', 'layout', 'tiling', '--window-id', str(window_id)])
                            subprocess.run(['aerospace', 'layout', default_layout, '--window-id', str(window_id)])
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    main()
