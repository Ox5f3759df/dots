import os
from pathlib import Path

app = "wezterm"
root_dir = Path(__file__).parent

colorscheme_lua = root_dir / "wezterm.lua"
is_dark_true = '-- local is_dark = true;'
is_dark_false = '-- local is_dark = false;'
v_is_dark_true = 'local is_dark = true;'
v_is_dark_false = 'local is_dark = false;'

def main():
    assert colorscheme_lua.exists()
    content = None
    with open(colorscheme_lua, "r") as f:
        content = f.read()
        if is_dark_true in content:
            content = content.replace(is_dark_true, v_is_dark_true)
            content = content.replace(v_is_dark_false, is_dark_false)
            print(f"Toggling Dark Theme for: {app}")
        elif is_dark_false in content:
            content = content.replace(is_dark_false, v_is_dark_false)
            content = content.replace(v_is_dark_true, is_dark_true)
            print(f"Toggling Light Theme for {app}")
    with open(colorscheme_lua, "w") as f:
        f.write(content)

if __name__ == '__main__':
    main()
