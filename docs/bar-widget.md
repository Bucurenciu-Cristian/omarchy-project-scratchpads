# Bar widget

The widget shows the current project in the Omarchy bar:

| Shows | Meaning |
|---|---|
| `󰉋 2: acme-api` | Project 2 is current; its workspace is hidden |
| `󰝰 2: acme-api (3)` | Its workspace is shown and holds 3 windows |
| `… 󰈈` | Focus mode is on |

It stays hidden until you have at least one project.

## Clicks

| Click | Action |
|---|---|
| Left | Show or hide the project's workspace |
| Right | Open the picker |
| Middle | Open the project's herdr terminal |

## Tooltip

Hover for the numbers behind it:

```
Project 2: acme-api · 3 windows
Active: 4/5 projects
Switches today: 2/3

Recent:
10:02:11 switch acme-crm
11:40:03 shelve old-dashboard

Click: toggle · Right: picker · Middle: terminal
```

## Placing it

The installer puts it on the left. Move it like any bar widget:

```bash
omarchy bar move bucurenciu.project-scratchpads --section right
```

## How it stays current

It refreshes when Hyprland reports a window opening, closing or moving, or a special
workspace toggling, and every three seconds for switches made from the keyboard or the
picker.
