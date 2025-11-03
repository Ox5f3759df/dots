#!/usr/bin/env python3

import sys
import json
import subprocess
import traceback
from pathlib import Path

def main(space_A, space_B):
    tmp_file = Path(__file__).parent / "logs" / "errors.move_apps_to_space.log"
    with open(tmp_file, "a") as f:
        try:
            result = subprocess.run(['aerospace', 'list-windows', '--workspace', str(space_A), '--json'], capture_output=True, text=True)
            output = result.stdout
            if output:
                windows = json.loads(output)
                for window in windows:
                    window_id = window['window-id']
                    subprocess.run(['aerospace', 'move-node-to-workspace', '--window-id', str(window_id), str(space_B)])
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    space_A = sys.argv[1]
    space_B = sys.argv[2]
    main(space_A, space_B)