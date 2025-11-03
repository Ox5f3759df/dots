#!/usr/bin/env python3

import sys
import subprocess
import json
from pathlib import Path

def main(layout):
    tmp_file = Path(__file__).parent / "logs" / "errors.workspace_layout.log"
    with open(tmp_file, "a") as f:
        try:
            assert layout in [
                "tiling",
                "v_accordion",
                "h_accordion",
                "h_tiles",
                "v_tiles",
                "floating"
            ], "Unsupported layout"
            workspace = subprocess.run(['aerospace', 'list-workspaces', '--focused'], capture_output=True, text=True).stdout
            workspace = workspace.strip()
            result = subprocess.run(['aerospace', 'list-windows', '--workspace', workspace, '--json'], capture_output=True, text=True)
            windows = json.loads(result.stdout)
            print(str(windows))
            subprocess.run(['aerospace', 'flatten-workspace-tree'])
            for window in windows:
                window_id = window['window-id']
                if layout != "floating" or layout != "tiling":
                    subprocess.run(['aerospace', 'layout', '--window-id', str(window_id), "tiling"])
                subprocess.run(['aerospace', 'layout', '--window-id', str(window_id), layout])
        except Exception as e:
            f.write(str(e) + "\n")

if __name__ == '__main__':
    layout = sys.argv[1]
    main(layout)