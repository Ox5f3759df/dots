#!/usr/bin/env python3

import sys
import json
import subprocess
import traceback
from pathlib import Path

def main(space):
    tmp_file = Path(__file__).parent / "logs" / "errors.move_all_apps_to_space.log"
    with open(tmp_file, "a") as f:
        try:
            result = subprocess.run(['aerospace', 'list-windows', '--all', '--json'], capture_output=True, text=True)
            output = result.stdout
            if output:
                windows = json.loads(output)
                for window in windows:
                    window_id = window['window-id']
                    subprocess.run(['aerospace', 'move-node-to-workspace', '--window-id', str(window_id), str(space)])
                    subprocess.run(['aerospace', 'layout', 'tiling', '--window-id', str(window_id)])
                    subprocess.run(['aerospace', 'layout', 'v_accordion', '--window-id', str(window_id)])
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    space = sys.argv[1]
    main(space)