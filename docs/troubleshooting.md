# Troubleshooting

## A key does two things

Another binding uses the same key; Hyprland runs both. Run the installer again to list
the clashes, then unbind the other one above the plugin's block in `bindings.lua`. See
[Keybindings](reference/keybindings.md#freeing-a-key-another-binding-uses).

## The bar widget did not change after an update

The Omarchy shell can keep an already loaded widget after its files change. Restart it:

```bash
omarchy restart shell
```

## Nothing happens on Super+;

- Check there is a current project: `omarchy-project-scratchpad current`.
- Check Hyprland accepts the dispatch: `omarchy-project-scratchpad toggle` prints nothing
  on success and sends a notification when Hyprland rejects it.
- A project name with characters other than letters, numbers, `-` and `_` is ignored.

## The terminal opens in my home folder

The project's folder does not exist on this machine, so the terminal falls back to `~`.
Check it with `omarchy-project-scratchpad dir <name>`.

## New project does not list my folders

Add their parent folder to `search_paths` in the [settings](configuration.md#settings),
or choose **Enter a custom path** in the picker.

## Checking the scripts

From a clone of the repository:

```bash
tests/run.sh
```

runs the scripts against a throwaway `$HOME` with stubbed `hyprctl`, menus and terminal.
