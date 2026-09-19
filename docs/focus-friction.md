# Focus friction

Switching projects has a cost you don't see at the moment you switch. Project
Scratchpads makes pausing easy and coming back deliberate.

## Active and shelved

Every project is **active** or **shelved** (`pending` in the config).

- The picker's main list shows active projects only.
- Shelved projects keep their position, so ++ctrl+alt+n++ still reaches them.
- Shelve or reactivate any project from the picker: **Shelve or activate a project**.

## Coming back to a shelved project

Picker → **Shelved projects…** → a project, and it asks:

> **Why switch to old-dashboard?**

An empty answer cancels. A real one reactivates the project, switches to it, and records
the reason.

## Daily switch budget

Each project switch counts toward a daily budget, 3 by default:

```
# [settings]
# daily_switch_budget=3
```

Once you are at the budget, unshelving asks once more:

> **3 switches today, over the budget of 3**
> Switch anyway · Stay focused

The budget never blocks you. It makes the choice visible.

## Focus mode

Picker → **Focus mode** hides shelved projects from the picker entirely, and the bar
widget shows `󰈈`. Turn it off the same way. To start with it on, set:

```
# [settings]
# focus_mode=true
```

## The switch log

Every switch, shelve, activation, budget hit and override is appended to
`~/.local/state/hyprland/project-scratchpads/switch-log`:

```
2026-09-19 10:02:11|switch|acme-crm|direct
2026-09-19 11:40:03|shelve|old-dashboard|via toggle
2026-09-19 15:12:47|budget-hit|old-dashboard|count=3 budget=3
2026-09-19 15:12:52|budget-override|old-dashboard|count=3
2026-09-19 15:12:52|switch|old-dashboard|unshelve: client approved v2
```

The bar widget's tooltip shows today's last eight entries.
