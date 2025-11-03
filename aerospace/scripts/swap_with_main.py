# #!/usr/bin/env python3

# import json
# import sys
# import time
# import subprocess
# import traceback
# from pathlib import Path

# app_to_appname_script = Path("~/.config/aerospace/scripts/utils/app_to_appname.py").expanduser()
# open_app_script = Path("~/.config/aerospace/scripts/utils/open_app.py").expanduser()

# Unused as its a little impossible to swap two windows without knowing
# Which one is where. Swap only allows for left right up down and dfs-next and dfs-prev

# def open_application(app):
#     open_app = subprocess.run([str(open_app_script), app], capture_output=True, text=True).stdout.strip()
#     if open_app != "yes":
#         raise ValueError(f"Could not open application: " + app)

# def open_and_wait_for_window_id(app, app_name, max_check=5):
#     window_id = None
#     open_application(app)
#     for _ in range(max_check):
#         result = subprocess.run(['aerospace', 'list-windows', '--workspace', 'focused', '--json'], capture_output=True, text=True)
#         windows = json.loads(result.stdout)
#         for window in windows:
#             if window['app-name'] == app_name:
#                 found = True
#                 window_id = window['window-id']
#                 break
#         if not window_id:
#             open_application(app)
#             time.sleep(1)
#         else:
#             break
#     if not window_id:
#         raise ValueError("Could not find window ID")
#     return window_id

# def main(app):
#     tmp_file = Path(__file__).parent / "logs" / "errors.swap_with_main.log"
#     with open(tmp_file, "a") as f:
#         try:
#             app_name = subprocess.run([str(app_to_appname_script), app], capture_output=True, text=True).stdout.strip()
#             if not app_name:
#                 raise ValueError(f"Unsupported application: " + app)
#             # Get the current focused window-id
#             result = subprocess.run(['aerospace', 'list-windows', '--focused', '--json'], capture_output=True, text=True)
#             curr_window = json.loads(result.stdout)[0]
#             current_window_id = curr_window['window-id']
#             if not current_window_id:
#                 raise ValueError("Could not get current focused window id")
#             window_id = open_and_wait_for_window_id(app, app_name)
#             # Get the current focused window-id again to check which one to switch to
#             result = subprocess.run(['aerospace', 'list-windows', '--focused', '--json'], capture_output=True, text=True)
#             current_window_id2 = json.loads(result.stdout)[0]['window-id']
#             if current_window_id2 == current_window_id:
#                 subprocess.run(['aerospace', 'swap', '--window-id', str(window_id), '--swap-focus'])
#             else:
#                 subprocess.run(['aerospace', 'swap', '--window-id', str(current_window_id), '--swap-focus'])
#         except Exception as e:
#             f.write(traceback.format_exc() + "\n")


# if __name__ == '__main__':
#     app = sys.argv[1]
#     main(app)