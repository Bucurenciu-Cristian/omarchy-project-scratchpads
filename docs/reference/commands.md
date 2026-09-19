# Commands

The installer links these into `~/.local/bin`. The keybindings and the bar widget call
them from the plugin folder directly, so they work without the links too.

## omarchy-project-picker

Opens the picker.

```bash
omarchy-project-picker               # the menu
omarchy-project-picker focus-toggle  # flip focus mode without the menu
```

## omarchy-project-scratchpad

| Command | Does |
|---|---|
| `toggle` | Show or hide the current project's workspace (the default) |
| `send` | Send the focused window to the current project |
| `send-to N` | Send the focused window to project N |
| `set N` | Make project N current, without logging a switch |
| `current` | Print the current project |
| `session [name]` | Print a project's herdr session |
| `dir [name]` | Print a project's folder, `~` expanded |
| `dirs [name]` | Print all of a project's folders |
| `list` | Print all project names, in order |
| `show` | Show the current project in a notification |

## omarchy-project-select N

Switches to project N: makes it current, logs the switch, and notifies. The ++ctrl+alt+n++
keys run this, then `omarchy-project-scratchpad toggle`.

## omarchy-project-terminal [name]

Opens a terminal on the project's herdr session, started in its folder. herdr creates the
session the first time and reattaches after that.

## omarchy-project-status

Prints the state the bar widget shows, as JSON:

```json
{
  "project": "acme-api",
  "index": "2",
  "windows": 3,
  "shown": true,
  "active": 4,
  "total": 5,
  "switches": 2,
  "budget": 3,
  "focus": false,
  "recent": ["10:02:11 switch acme-crm"]
}
```
