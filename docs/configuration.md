# Configuration

Everything lives in one file, `~/.config/hypr/projects.conf`. The picker edits it for
you; you can also open it from the picker with **Edit projects.conf**.

## Projects

One project per line:

```
# name|session|directory|status
acme-crm|acme-crm|~/Projects/acme-crm|active
shop-api|shop-api|~/Work/shop-api|active
landing-site|landing|~/Work/landing-site,~/Work/landing-assets|active
old-dashboard|old-dashboard|~/Work/old-dashboard|pending
```

| Field | Meaning |
|---|---|
| **name** | Letters, numbers, `-` and `_`. The project's workspace is `special:project:<name>`. Lines with other characters are ignored. |
| **session** | The herdr session the project terminal opens. Created on first use. |
| **directory** | The project folder. With several, comma-separated, the first is used. `~` is expanded. |
| **status** | `active`, or `pending` for shelved. |

The order of the lines sets ++ctrl+alt+1++ to ++9++. Reorder the lines to renumber.

## Settings

Settings go in a commented block after the projects. The `# ` prefix is part of the
syntax:

```
# [settings]
# focus_mode=false
# daily_switch_budget=3
# search_paths=~/Projects,~/Work
# search_depth=2
```

| Setting | Default | Meaning |
|---|---|---|
| `focus_mode` | `false` | Start with [focus mode](focus-friction.md#focus-mode) on |
| `daily_switch_budget` | `3` | Switches per day before unshelving asks twice |
| `search_paths` | `~/Projects,~/projects,~/Work,~/dev,~/code` | Folders **New project** lists |
| `search_depth` | `2` | How deep **New project** looks inside them |

## State

Per-machine state lives in `~/.local/state/hyprland/project-scratchpads/`:

| File | Holds |
|---|---|
| `current-project` | The project ++super+semicolon++ acts on |
| `focus-mode` | Whether focus mode is on |
| `switch-log` | The [switch log](focus-friction.md#the-switch-log) |
