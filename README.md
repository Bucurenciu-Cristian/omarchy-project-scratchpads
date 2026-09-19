# omarchy-project-scratchpads

One hidden [Hyprland](https://hyprland.org/) workspace per project, a [herdr](https://herdr.dev)
session per project, and a picker that makes you say why before you switch.
An [Omarchy](https://omarchy.org) 4 plugin.

Each project gets a special workspace you toggle in and out with `Super+;`. Send the
windows you need for that project into it, open the project's terminal, and jump
between projects with `Ctrl+Alt+1-9`. The bar shows which project you are on and how
many windows it holds.

> v2 targets Omarchy 4 (Lua Hyprland config, Quickshell bar, Omarchy menu).
> v1 targeted Omarchy 3 with Walker, Waybar and tmux; it is still available at the
> [`v1.0.0`](https://github.com/Bucurenciu-Cristian/omarchy-project-scratchpads/releases/tag/v1.0.0) tag.

## Install

```bash
omarchy plugin add https://github.com/Bucurenciu-Cristian/omarchy-project-scratchpads
~/.config/omarchy/plugins/bucurenciu.project-scratchpads/bin/install
```

The installer:

- loads the keybindings from `~/.config/hypr/bindings.lua` (one guarded line, so a
  machine without the plugin still loads its config)
- creates `~/.config/hypr/projects.conf` if it is missing
- links the `omarchy-project-*` commands into `~/.local/bin`
- enables the bar widget, then reloads Hyprland and checks for config errors
- lists any key it shares with another binding. Omarchy binds `Super+Shift+P` to
  Google Photos by default; free it with `hl.unbind("SUPER + SHIFT + P")` above the
  Project Scratchpads block in `bindings.lua`

Running it again is safe.

## Quick start

1. `Super+Shift+P` opens the picker. Choose **New project** and pick its folder.
2. `Super+Ctrl+Alt+Return` opens the project's herdr session in that folder.
3. `Super+Alt+;` sends the focused window into the project's scratchpad.
4. `Super+;` hides and shows it again.

## Keybindings

| Keys | Action |
|------|--------|
| `Super+Shift+P` | Project picker: switch, create, shelve, delete |
| `Super+;` | Toggle the current project's scratchpad |
| `Super+Alt+;` | Send the focused window to the current project |
| `Super+Ctrl+Alt+Return` | Open the current project's herdr session (next to Omarchy's `Super+Ctrl+Return` for herdr) |
| `Ctrl+Alt+1-9` | Switch to project N and show its scratchpad |
| `Ctrl+Alt+Shift+1-9` | Send the focused window to project N |

## Bar widget

Shows `󰉋 2: myapp (3)`: position, project, and windows in its scratchpad. The folder
opens (`󰝰`) while the scratchpad is shown, and `󰈈` marks focus mode.

- **Click** toggles the scratchpad
- **Right-click** opens the picker
- **Middle-click** opens the project terminal
- **Hover** shows active projects, today's switches against your budget, and recent activity

Move it with `omarchy bar move bucurenciu.project-scratchpads --section right`.

## Focus friction

Switching projects has a cost, so the picker adds a little friction:

- **Shelve** projects you are not working on. They leave the main list and
  `Ctrl+Alt+N` still reaches them.
- **Unshelving** asks *why*. An empty answer cancels.
- Past your **daily switch budget**, unshelving asks once more before it goes ahead.
- **Focus mode** hides shelved projects from the picker entirely.

Every switch, shelve and override is logged in
`~/.local/state/hyprland/project-scratchpads/switch-log`.

The picker also marks projects that have a dev server running in their folder
(`bun`, `node`, `pnpm`, `python`, `uv`, `deno`) with `▶ dev server`.

## Config

Projects live in `~/.config/hypr/projects.conf`, one per line, in the order that
`Ctrl+Alt+1-9` follows:

```
# name|session|directory|status
myapp|myapp|~/Work/myapp|active
sideproject|sideproject|~/Work/sideproject|pending
```

- **name**: letters, numbers, `-` and `_`; its scratchpad is `special:project:<name>`
- **session**: the herdr session the project terminal opens (created on first use)
- **directory**: the project folder; with several comma-separated, the first is used
- **status**: `active`, or `pending` for shelved

Settings go in a commented block at the end of the file:

```
# [settings]
# focus_mode=false
# daily_switch_budget=3
# search_paths=~/Projects,~/projects,~/Work,~/dev,~/code
# search_depth=2
```

`search_paths` and `search_depth` control which folders **New project** offers.

Because the file lives in `~/.config/hypr`, a dotfiles setup that syncs that folder
carries your project list to every machine.

## Commands

| Command | Purpose |
|---------|---------|
| `omarchy-project-picker` | The picker; `omarchy-project-picker focus-toggle` flips focus mode |
| `omarchy-project-scratchpad` | `toggle`, `send`, `send-to N`, `set N`, `current`, `session`, `dir`, `dirs`, `list` |
| `omarchy-project-select N` | Switch to project N |
| `omarchy-project-terminal [name]` | Open a project's herdr session in its folder |
| `omarchy-project-status` | Current project and focus stats as JSON |

## Uninstall

```bash
~/.config/omarchy/plugins/bucurenciu.project-scratchpads/bin/uninstall
omarchy plugin remove bucurenciu.project-scratchpads
```

Your `projects.conf` is kept.

## Upgrading from v1

- Remove the v1 package (`yay -R omarchy-project-scratchpads`) and its block from
  `~/.config/hypr/bindings.conf`, then install v2 as above.
- `projects.conf` keeps the same format; the second field now names a herdr session.
- The Waybar modules are replaced by the bar widget.

## Documentation

Use cases, focus friction, configuration and the command reference live in [`docs/`](docs/)
as plain Markdown, and build into a [Zensical](https://zensical.org) site:

```bash
mise run docs:serve   # live preview at http://localhost:8000
mise run docs         # static site in site/
```

## Development

```bash
tests/run.sh
```

runs the scripts against a throwaway `$HOME` with stubbed `hyprctl`, menus and
terminal.

## Dependencies

- Omarchy 4 (Hyprland Lua config, `omarchy-menu-select`, Quickshell bar)
- `jq`
- `herdr` for project terminals
- `fd` (optional) for faster folder browsing

## License

MIT
