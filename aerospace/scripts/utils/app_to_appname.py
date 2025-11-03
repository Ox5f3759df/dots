#!/usr/bin/env python3

import sys
from pathlib import Path

def app_to_appname(app):
    app_name = ""
    if app == "vscode" or app == "code":
        app_name = "Code"
    elif app == "vscode_insiders" or app == "code_insiders":
        app_name = ""
    elif app == "firefox":
        app_name = "Firefox"
    elif app == "wezterm" or app == "wez":
        app_name = "WezTerm"
    elif app == "chrome" or app == "google_chrome":
        app_name = "Google Chrome"
    elif app == "obsidian":
        app_name = "Obsidian"
    elif app == "zen":
        app_name = "Zen"
    elif app == "iterm" or app == "iterm2":
        app_name = "iTerm2"
    elif app == "intellij":
        app_name = "IntelliJ IDEA"
    elif app == "slack":
        app_name = "Slack"
    elif app == "outlook":
        app_name = "Microsoft Outlook"
    elif app == "chatgpt":
        app_name = "ChatGPT"
    elif app == "perplexity":
        app_name = "Perplexity"
    elif app == "datagrip":
        app_name = "DataGrip"
    elif app == "postman":
        app_name = "Postman"
    elif app == "preview":
        app_name = "Preview"
    elif app == "teams":
        app_name = "Microsoft Teams"
    elif app == "dbeaver":
        app_name = "DBeaver"
    elif app == "kitty":
        app_name = "kitty"
    elif app == "vscodium" or app == "codium":
        app_name = "VSCodium"
    elif app == "neovide":
        app_name = "Neovide"
    else:
        raise ValueError(f"Unsupported application: {app}")
    return app_name

if __name__ == "__main__":
    tmp_file = Path(__file__).parent.parent / "logs" / "errors.app_to_appname.log"
    with open(tmp_file, "a") as f:
        try:
            print(app_to_appname(sys.argv[1]))
        except Exception as e:
            f.write(str(e) + "\n")
            print()
