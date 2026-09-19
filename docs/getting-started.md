# Getting started

## Requirements

- Omarchy 4 (Hyprland with the Lua config, the Omarchy menu, the Quickshell bar)
- `jq`
- [herdr](https://herdr.dev) for project terminals (Omarchy 4 ships it)
- `fd`, optional, for faster folder browsing in the picker

## Install

```bash
omarchy plugin add https://github.com/Bucurenciu-Cristian/omarchy-project-scratchpads
~/.config/omarchy/plugins/bucurenciu.project-scratchpads/bin/install
```

The installer:

1. adds one guarded line to `~/.config/hypr/bindings.lua` that loads the plugin's
   keybindings. A machine without the plugin still loads its config.
2. creates `~/.config/hypr/projects.conf` if it is missing
3. links the `omarchy-project-*` commands into `~/.local/bin`
4. enables the bar widget on the left of the bar
5. reloads Hyprland, checks for config errors, and lists any key the plugin shares
   with another binding

Running it again is safe.

!!! warning "Super+Shift+P and Google Photos"
    Omarchy binds ++super+shift+p++ to Google Photos by default, so both open. Free the
    key by adding this to `~/.config/hypr/bindings.lua`, **above** the
    `-- BEGIN Project Scratchpads` block:

    ```lua
    hl.unbind("SUPER + SHIFT + P")
    ```

## Your first project

1. Press ++super+shift+p++ and choose **New project**.
2. Pick the project's folder. The picker lists folders under `~/Projects`, `~/Work` and
   a few other common places; [change that](configuration.md#settings) with `search_paths`.
3. Accept the suggested name, or type your own.

The project becomes the current one. Now try the loop:

| Step | Keys |
|---|---|
| Show the (empty) project | ++super+semicolon++ |
| Open its terminal | ++super+ctrl+alt+enter++ |
| Open a browser window, then file it into the project | ++super+alt+semicolon++ |
| Hide the project | ++super+semicolon++ |
| Bring it back | ++super+semicolon++ |

Add two or three more projects the same way. Their order sets ++ctrl+alt+1++ to ++9++.

## Uninstall

```bash
~/.config/omarchy/plugins/bucurenciu.project-scratchpads/bin/uninstall
omarchy plugin remove bucurenciu.project-scratchpads
```

This removes the keybindings, the command links, the bar widget and the switch log.
Your `projects.conf` stays.
