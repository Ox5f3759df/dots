#!/usr/bin/env python3

import os
import json
import sys
import time
import subprocess
import traceback
from pathlib import Path

directions = [
    "left",
    "right",
    "up",
    "down"
]

move_left = [
    "aerospace join-with left || aerospace move left",
    "aerospace join-with left || aerospace move left",
    "aerospace resize width -700",
    "aerospace focus right"
]
move_left2 = [
    "aerospace join-with left",
    "aerospace join-with left",
    "aerospace join-with up",
    "aerospace layout v_accordion",
    "aerospace focus right"
]

move_right = [
    "aerospace join-with right || aerospace move right",
    "aerospace join-with right || aerospace move right",
    "aerospace resize width -700",
    "aerospace focus left",
]
move_right2 = [
    "aerospace join-with right",
    "aerospace join-with right",
    "aerospace join-with up",
    "aerospace layout v_accordion",
    "aerospace focus left"
]

move_down = [
    "aerospace join-with left",
    "aerospace resize height -350",
    "aerospace focus up"
]

move_up = [
    "aerospace join-with left",
    "aerospace resize height -350",
    "aerospace focus down"
]

def main():
    tmp_file = Path(__file__).parent / "logs" / "errors.mover.log"
    with open(tmp_file, "a") as f:
        direction = sys.argv[1]
        try:
            if direction not in directions:
                raise ValueError(f"Invalid direction: {direction}")
            # Check how many applications are open
            curr_windows = subprocess.run(['aerospace', 'list-windows', '--workspace', 'focused', '--json'], capture_output=True, text=True)
            num_applications = len(json.loads(curr_windows.stdout))
            cmds = []
            if direction == "left":
                if num_applications > 2:
                    cmds = move_left2
                else:
                    cmds = move_left
            if direction == "right":
                if num_applications > 2:
                    cmds = move_right2
                else:
                    cmds = move_right
            if direction == "up":
                cmds = move_up
            if direction == "down":
                cmds = move_down
            for cmd in cmds:
                os.system(cmd)
        except Exception as e:
            f.write(traceback.format_exc() + "\n")

if __name__ == '__main__':
    main()
