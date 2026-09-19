import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons

// Current project in the bar: "<position>: <name> (<windows>)".
// Left click toggles the project scratchpad, right click opens the picker,
// middle click opens the project's herdr terminal. The tooltip carries the
// focus stats: active projects, switches against the daily budget, recent log.
BarWidget {
  id: root
  moduleName: "bucurenciu.project-scratchpads"

  readonly property string binDir: Qt.resolvedUrl("bin").toString().replace(/^file:\/\//, "")
  property var status: ({})
  property bool refreshPending: false

  readonly property string project: status.project || ""
  readonly property string label: {
    if (!project) return ""
    let text = (status.shown ? "󰝰 " : "󰉋 ") + (status.index ? status.index + ": " : "") + project
    if (status.windows > 0) text += " (" + status.windows + ")"
    if (status.focus) text += " 󰈈"
    return text
  }
  readonly property string tooltip: {
    if (!project) return ""
    let lines = [
      "Project " + (status.index || "?") + ": " + project + (status.windows > 0 ? " · " + status.windows + " windows" : ""),
      "Active: " + status.active + "/" + status.total + " projects",
      "Switches today: " + status.switches + "/" + status.budget
    ]
    if (status.focus) lines.push("󰈈 Focus mode on")
    if (status.recent && status.recent.length) lines.push("", "Recent:", ...status.recent)
    lines.push("", "Click: toggle · Right: picker · Middle: terminal")
    return lines.join("\n")
  }

  function refresh() {
    if (statusProc.running) {
      refreshPending = true
      return
    }
    refreshPending = false
    statusProc.running = true
  }

  function run(script, args) {
    if (root.bar) root.bar.run(Util.shellQuote(root.binDir + "/" + script) + (args ? " " + args : ""))
    refreshTimer.restart()
  }

  Component.onCompleted: refresh()

  Process {
    id: statusProc
    command: [root.binDir + "/omarchy-project-status"]
    onRunningChanged: if (!running && root.refreshPending) root.refresh()
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        try {
          root.status = JSON.parse(text || "{}")
        } catch (e) {
          root.status = {}
        }
      }
    }
  }

  // Window moves and scratchpad toggles change the count and the shown state
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      const name = event && event.name ? String(event.name) : ""
      if (["activespecial", "activespecialv2", "openwindow", "closewindow", "movewindow", "movewindowv2"].indexOf(name) !== -1)
        refreshTimer.restart()
    }
  }

  Timer {
    id: refreshTimer
    interval: 250
    onTriggered: root.refresh()
  }

  // Project switches from keybindings and the picker happen outside Hyprland's events
  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  visible: label !== ""
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    fontSize: Style.font.caption
    horizontalMargin: 6
    tooltipText: root.tooltip
    onPressed: function(b) {
      if (b === Qt.RightButton) root.run("omarchy-project-picker")
      else if (b === Qt.MiddleButton) root.run("omarchy-project-terminal")
      else root.run("omarchy-project-scratchpad", "toggle")
    }
  }
}
