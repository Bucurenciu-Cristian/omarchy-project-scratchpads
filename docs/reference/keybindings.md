# Keybindings

| Keys | Action |
|---|---|
| ++super+shift+p++ | Project picker: switch, create, shelve, delete |
| ++super+semicolon++ | Show or hide the current project's workspace |
| ++super+alt+semicolon++ | Send the focused window to the current project |
| ++super+ctrl+alt+enter++ | Open the current project's herdr terminal, beside Omarchy's ++super+ctrl+enter++ for herdr |
| ++ctrl+alt+1++ … ++9++ | Switch to project N and show its workspace |
| ++ctrl+alt+shift+1++ … ++9++ | Send the focused window to project N, without switching |

They are defined in the plugin's `hypr/bindings.lua`, which `~/.config/hypr/bindings.lua`
loads through the line the installer adds:

```lua
-- BEGIN Project Scratchpads
do local f = os.getenv("HOME") .. "/.config/omarchy/plugins/bucurenciu.project-scratchpads/hypr/bindings.lua"; local h = io.open(f, "r"); if h then h:close(); dofile(f) end end
-- END Project Scratchpads
```

## Changing a key

Unbind the plugin's key and bind your own **below** the block:

```lua
hl.unbind("SUPER + SEMICOLON")
o.bind("SUPER + GRAVE", "Toggle project scratchpad",
  "~/.config/omarchy/plugins/bucurenciu.project-scratchpads/bin/omarchy-project-scratchpad toggle")
```

## Freeing a key another binding uses

The installer lists keys the plugin shares with another binding. To give the key to the
plugin, unbind the other one **above** the block:

```lua
hl.unbind("SUPER + SHIFT + P") -- Omarchy's Google Photos
```

List every binding with `omarchy menu keybindings --print`.
