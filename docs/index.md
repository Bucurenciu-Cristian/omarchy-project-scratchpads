# Project Scratchpads

**One hidden workspace per project.** Pull a project up with one key, put it away with
the same key, and jump between projects without losing where you were.

Project Scratchpads is a plugin for [Omarchy](https://omarchy.org) 4. Each project you
work on gets its own [Hyprland special workspace](https://wiki.hypr.land/Configuring/Basics/Dispatchers/#special-workspace),
a floating layer that sits over your normal workspaces. You file a project's windows into
it (its terminal, its browser tab, its database tool) and toggle the whole set in and
out as one.

```
 Your normal workspaces            Super+;              The project, on top
┌──────────────────────────┐  ─────────────────>  ┌──────────────────────────┐
│ 1:Browser  2:Terminals   │                      │ ┌────────┐ ┌───────────┐ │
│                          │                      │ │ herdr  │ │ localhost │ │
│   mail, chat, music...   │  <─────────────────  │ │ agents │ │   :3000   │ │
│                          │       Super+;        │ └────────┘ └───────────┘ │
└──────────────────────────┘                      └──────────────────────────┘
```

## Why

Working on several projects at once usually means one of two things: a workspace per
project that you have to remember the number of, or everything mixed together on a few
workspaces. Both cost you a little every time you switch.

Project Scratchpads gives every project a name, a place, and a terminal session that
survives between windows, so switching back to *acme-api* puts you exactly where you
left it.

It also adds a little **friction** to switching, on purpose. Pausing a project is easy;
coming back to one you shelved asks you *why*, and past your daily budget it asks twice.
See [Focus friction](focus-friction.md).

## At a glance

| Keys | What happens |
|---|---|
| ++super+shift+p++ | Open the picker: switch, create, shelve, delete |
| ++super+semicolon++ | Show or hide the current project |
| ++super+alt+semicolon++ | File the focused window into the current project |
| ++super+ctrl+alt+enter++ | Open the project's [herdr](https://herdr.dev) terminal in its folder |
| ++ctrl+alt+1++ … ++9++ | Switch to project N and show it |
| ++ctrl+alt+shift+1++ … ++9++ | Send the focused window to project N |

The bar shows where you are:

```
󰉋 2: acme-api (3)
│  │  │        └── windows in this project
│  │  └─────────── project name
│  └────────────── position (Ctrl+Alt+2)
└───────────────── folder opens (󰝰) while the project is shown
```

## Next

- [Getting started](getting-started.md) installs it and sets up your first project.
- [Use cases](use-cases.md) walks through real days with it.
