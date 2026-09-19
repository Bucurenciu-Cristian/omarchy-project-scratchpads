# Use cases

Four real situations, with the keys you press. The project names are examples.

## A client project and an interruption

You are deep in **acme-crm** when a message asks for a quick fix on **shop-api**.

1. ++ctrl+alt+2++ switches to shop-api and shows it. Its herdr session, its browser tab
   on `localhost:8000` and its log viewer are right where you left them yesterday.
2. Fix, commit, push.
3. ++ctrl+alt+1++ goes back to acme-crm. Its windows come back exactly as they were;
   nothing from shop-api is in the way.

Nothing was closed or rearranged. The two projects never shared a workspace.

## Building up a project's workspace

The first time you work on a project, its workspace is empty. Fill it as you go:

1. ++ctrl+alt+3++: switch to **landing-site** and show its empty workspace.
2. ++super+ctrl+alt+enter++: open its herdr session. herdr starts it in the project folder
   and keeps its panes and agents alive after you close the window.
3. Open the browser on the dev server, and the design file. On each, press
   ++super+alt+semicolon++ to file it into the project.
4. ++super+semicolon++ hides all of it at once.

Already have a window open somewhere else? Focus it and press
++ctrl+alt+shift+3++ to send it straight to project 3 without switching.

## Pausing a project for a week

**old-dashboard** is waiting on the client. It should not sit in your picker asking for
attention.

1. ++super+shift+p++ → **Shelve or activate a project** → old-dashboard.
2. It leaves the main list. Its position still works: ++ctrl+alt+4++ reaches it if you
   really need it.

When the client answers, open the picker → **Shelved projects…** → old-dashboard. It asks
**Why switch to old-dashboard?** Type a reason ("client approved v2") and it comes back
as an active project. The reason is kept in the [switch log](focus-friction.md#the-switch-log).

## A deadline day

You have one thing to finish today.

1. Picker → **Focus mode: off** turns it on. Shelved projects disappear from the picker
   entirely, and the bar shows `󰈈`.
2. The [daily switch budget](focus-friction.md#daily-switch-budget) counts every project
   switch. Hover the bar widget to see `Switches today: 2/3`.
3. Past the budget, unshelving something asks once more: *Switch anyway* or *Stay focused*.

At the end of the day, hover the widget for the recent activity: every switch, shelve
and override, with times.

## Knowing what is running

The picker marks a project with `▶ dev server` when a `bun`, `node`, `pnpm`, `python`,
`uv` or `deno` process is running inside its folder. Before switching away for the day,
open the picker to see which projects still have something running.

## Two machines

`projects.conf` lives in `~/.config/hypr`. If you sync that folder between machines
(with a dotfiles tool), both machines get the same project list and the same
++ctrl+alt+1++ to ++9++ order. Keep project folders at the same paths on both.

The workspaces themselves and the herdr sessions stay on each machine.
