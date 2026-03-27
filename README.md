# omarchy-project-scratchpads

Project-specific special workspaces for [Hyprland](https://hyprland.org/) with tmux session sync. An extension for [omarchy](https://github.com/basecamp/omarchy).

Each project gets its own hidden workspace (Hyprland special workspace) that you can toggle in/out, plus automatic tmux session switching so your terminal context follows your project context.

## Install

```bash
yay -S omarchy-project-scratchpads
```

Then run the setup script to install keybindings and create the config:

```bash
omarchy-install-project-scratchpads
```

## Quick start

1. Open the project picker: `Super+Shift+P`
2. Select "New project" and pick a directory
3. Toggle the project scratchpad: `Super+;`
4. Send windows to it: `Super+Alt+;`

## Keybindings

Installed automatically by the setup script into `~/.config/hypr/bindings.conf`:

| Keys | Action |
|------|--------|
| `Super+;` | Toggle current project scratchpad |
| `Super+Alt+;` | Send focused window to project scratchpad |
| `Super+Shift+P` | Open project picker (create/switch/shelve) |
| `Ctrl+Alt+1-9` | Quick switch to project N and toggle scratchpad |
| `Ctrl+Alt+Shift+1-9` | Send focused window to project N |

## Config

Projects are defined in `~/.config/hypr/projects.conf`:

```
# Format: project_name|tmux_session|directory|status
myapp|myapp|~/dev/myapp|active
sideproject|sideproject|~/dev/sideproject|pending
```

Fields:
- **project_name** -- identifier (alphanumeric, dashes, underscores)
- **tmux_session** -- tmux session name to attach/create
- **directory** -- project root directory
- **status** -- `active` (shown in picker) or `pending` (shelved)

### Settings

Add settings in a `[settings]` block at the bottom of `projects.conf`:

```
# [settings]
# focus_mode=false
# daily_switch_budget=3
```

- **focus_mode** -- when ON, shelved projects are hidden from the picker
- **daily_switch_budget** -- number of project switches before a confirmation prompt (default: 3)

## Scripts

| Script | Purpose |
|--------|---------|
| `omarchy-project-scratchpad` | Toggle/send windows to project scratchpads |
| `omarchy-project-picker` | Walker-based CRUD picker (create/switch/shelve) |
| `omarchy-project-select` | Quick switch by index (used by Ctrl+Alt+1-9) |
| `omarchy-project-terminal` | Open terminal in project directory with tmux session |
| `omarchy-project-indicator` | Waybar module showing current project + window count |
| `omarchy-project-stats` | Waybar module with focus stats (switches, active count) |
| `omarchy-install-project-scratchpads` | Setup script (config, keybindings, state dir) |
| `omarchy-uninstall-project-scratchpads` | Clean uninstaller |

## Waybar integration

### Project indicator

Shows the current project name and window count:

```jsonc
// ~/.config/waybar/config.jsonc
"custom/project": {
  "exec": "omarchy-project-indicator",
  "return-type": "json",
  "interval": 1,
  "on-click": "omarchy-project-scratchpad toggle",
  "tooltip": true
}
```

### Focus stats

Shows active project count and daily switch count:

```jsonc
"custom/projects": {
  "exec": "omarchy-project-stats",
  "interval": 5,
  "return-type": "json"
}
```

## Uninstall

```bash
omarchy-uninstall-project-scratchpads   # remove keybindings and state
yay -R omarchy-project-scratchpads      # remove the package
```

Your `projects.conf` is preserved -- delete it manually if you want a clean slate.

## Dependencies

- **omarchy** -- core omarchy utilities
- **tmux** -- session management
- **jq** -- JSON parsing for hyprctl output
- **walker** (optional) -- GUI picker interface
- **fd** (optional) -- faster directory browsing

## License

MIT
