import os
from pathlib import Path

app = "nvim"
root_dir = Path(__file__).parent

target_lua = root_dir / "lua" / "theme.lua"
is_dark_true = '-- local is_dark = true'
is_dark_false = '-- local is_dark = false'
v_is_dark_true = 'local is_dark = true'
v_is_dark_false = 'local is_dark = false'

def main():
    assert target_lua.exists()
    content = None
    with open(target_lua, "r") as f:
        content = f.read()
        if is_dark_true in content:
            content = content.replace(is_dark_true, v_is_dark_true)
            content = content.replace(v_is_dark_false, is_dark_false)
            print(f"Toggling Dark Theme for: {app}")
        elif is_dark_false in content:
            content = content.replace(is_dark_false, v_is_dark_false)
            content = content.replace(v_is_dark_true, is_dark_true)
            print(f"Toggling Light Theme for {app}")
    with open(target_lua, "w") as f:
        f.write(content)

if __name__ == '__main__':
    main()

