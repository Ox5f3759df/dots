#!/usr/bin/env python3

import sys
import subprocess
from pathlib import Path


def open_application(application_to_open):
    app = application_to_open
    success = True
    if app == "vscode" or app == "code":
        subprocess.run(['open', '-a', 'Visual Studio Code'])
    elif app == "vscode_insiders" or app == "code_insiders":
        subprocess.run(['open', '-a', 'Visual Studio Code'])
    elif app == "firefox":
        subprocess.run(['open', '-a', 'Firefox'])
    elif app == "wezterm" or app == "wez":
        subprocess.run(['open', '-a', 'Wezterm'])
    elif app == "chrome" or app == "google_chrome":
        subprocess.run(['open', '-a', 'Google Chrome'])
    elif app == "obsidian":
        subprocess.run(['open', '-a', 'Obsidian'])
    elif app == "zen":
        subprocess.run(['open', '-a', 'Zen'])
    elif app == "iterm" or app == "iterm2":
        subprocess.run(['open', '-a', 'iTerm'])
    elif app == "intellij":
        subprocess.run(['open', '-a', 'IntelliJ IDEA'])
    elif app == "slack":
        subprocess.run(['open', '-a', 'Slack'])
    elif app == "outlook":
        subprocess.run(['open', '-a', 'Microsoft Outlook'])
    elif app == "chatgpt":
        subprocess.run(['open', '-a', 'ChatGPT'])
    elif app == "perplexity":
        subprocess.run(['open', '-a', 'Perplexity'])
    elif app == "datagrip":
        subprocess.run(['open', '-a', 'DataGrip'])
    elif app == "postman":
        subprocess.run(['open', '-a', 'Postman'])
    elif app == "preview":
        subprocess.run(['open', '-a', 'Preview'])
    elif app == "teams":
        subprocess.run(['open', '-a', 'Microsoft Teams'])
    elif app == "dbeaver":
        subprocess.run(['open', '-a', 'DBeaver'])
    elif app == "kitty":
        subprocess.run(['open', '-a', 'kitty'])
    elif app == "codium" or app == "vscodium":
        subprocess.run(['open', '-a', 'VSCodium'])
    elif app == "neovide":
        subprocess.run(['open', '-a', 'Neovide'])
    else:
        success = False
    return success

if __name__ == '__main__':
    tmp_file = Path(__file__).parent.parent / "logs" / "errors.open_app.log"
    with open(tmp_file, "a") as f:
        try:
            success = open_application(sys.argv[1])
            if success:
                print("yes")
            else:
                print("no")
        except Exception as e:
            f.write(str(e) + "\n")
            print("no")
