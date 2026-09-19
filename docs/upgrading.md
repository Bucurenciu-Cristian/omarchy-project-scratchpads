# Upgrading from v1

v1 was built for Omarchy 3: Walker for the picker, two Waybar modules, keybindings in
`bindings.conf`, and tmux sessions. Omarchy 4 replaced all four, so v2 is a rewrite of
the same idea.

| v1 | v2 |
|---|---|
| AUR package | `omarchy plugin add` |
| Keybindings appended to `bindings.conf` | Loaded from `bindings.lua` |
| Walker picker | Omarchy menu |
| Waybar `custom/project` and `custom/projects` | One bar widget |
| tmux session per project | herdr session per project |
| — | ++super+ctrl+alt+enter++ opens the project terminal |

## Steps

1. Remove v1: `yay -R omarchy-project-scratchpads`, and delete the
   `# BEGIN Project Scratchpads` block from `~/.config/hypr/bindings.conf` if it is still there.
2. [Install v2](getting-started.md#install).

`projects.conf` keeps its format and location. The second field now names a herdr
session instead of a tmux session; the value can stay the same.

v1 remains available at the
[`v1.0.0`](https://github.com/Bucurenciu-Cristian/omarchy-project-scratchpads/releases/tag/v1.0.0) tag.
