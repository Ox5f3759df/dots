#!/usr/bin/env python3

import sys
import time
import json
import subprocess
import traceback
from pathlib import Path

directions = [
    "left", "right", "up", "down"
]

workspace_layout_script= Path("~/.config/aerospace/scripts/workspace_layout.py").expanduser()

def main(direction, resize_amount=""):
    start_layout = "v_accordion"
    tmp_file = Path(__file__).parent / "logs" / "errors.balance_layout.log"
    with open(tmp_file, "a") as f:
        try:
            if direction and direction not in directions:
                raise ValueError("Direction must be one of: " + ", ".join(directions))
            subprocess.run([str(workspace_layout_script), start_layout], capture_output=True, text=True)
            subprocess.run(['aerospace', 'flatten-workspace-tree'])
            space = subprocess.run(['aerospace', 'list-workspaces', '--focused'], capture_output=True, text=True).stdout.strip()
            subprocess.run(['aerospace', 'workspace', str(space)])
            result = subprocess.run(['aerospace', 'list-windows', '--workspace', str(space), '--json'], capture_output=True, text=True)
            output = result.stdout
            if output:
                windows = json.loads(output)
                for idx, window in enumerate(windows):
                    window_id = str(window['window-id'])
                    move_left_amount = int(idx/2)
                    should_join = (idx % 2) == 1
                    if move_left_amount > 0:
                        for _ in range(move_left_amount):
                            if not should_join:
                                subprocess.run(['aerospace', 'move', direction, '--window-id', window_id])
                            else:
                                subprocess.run(['aerospace', 'join-with', direction, '--window-id', window_id])
                    # time.sleep(0.1)
            if resize_amount:
                # focus the last window on the other side
                focus_direction = "left" if direction == "right" else "right"
                for _ in range(5):
                    subprocess.run(['aerospace', 'focus', focus_direction])
                # Resize
                direction = "width"
                resize = str(resize_amount)
                if "w-" in resize or "w+" in resize:
                    direction = "width"
                    resize = resize.replace("w-", "")
                    resize = resize.replace("w+", "")
                    resize = int(resize)
                elif "h-" in resize or "h+" in resize:
                    direction = "height"
                    resize = resize.replace("h-", "")
                    resize = resize.replace("h+", "")
                    resize = int(resize)
                else:
                    resize = int(resize)
                resize_amount = "+" if resize > 0 else "-"
                resize_amount = resize_amount + str(abs(resize))
                cmd = f"aerospace resize {direction} {resize_amount}"
                subprocess.run(cmd.split())
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    direction = "left"
    try:
        direction = sys.argv[1]
    except:
        pass
    resize_amount = ""
    try:
        resize_amount = sys.argv[2]
    except:
        pass
    main(direction, resize_amount)