import QtQuick
import Quickshell.Io
import "Model.js" as Model

// State and commands for the OpenConnect widget. Everything goes through the
// `ocvpn` CLI: it owns profiles, authentication and the polkit prompt, so this
// file never touches privilege and never builds a shell command line (argv
// only; profile ids are validated against Model.isValidId first).
Item {
  id: root

  property var settings: ({})

  // False until `which ocvpn` has answered; the UI shows nothing wrong yet.
  property bool checked: false
  property bool installed: false
  property bool loaded: false
  property var profiles: []
  property string lastError: ""

  // id -> "connect" | "disconnect" while that action's process is running.
  property var pending: ({})
  // id -> latest progress or failure line from that profile's action.
  property var messages: ({})

  readonly property int refreshIntervalSec: intSetting("refreshIntervalSec", 10, 3, 300)
  readonly property int connectedCount: Model.connectedCount(profiles)
  readonly property bool busy: statusProcess.running

  function setting(name, fallback) {
    var value = settings ? settings[name] : undefined
    return value === undefined || value === null ? fallback : value
  }

  function intSetting(name, fallback, min, max) {
    var n = parseInt(String(setting(name, fallback)), 10)
    if (!isFinite(n)) n = fallback
    return Math.max(min, Math.min(max, n))
  }

  function isPending(id) { return pending[id] !== undefined }

  function withEntry(map, id, value) {
    var next = Object.assign({}, map)
    if (value === undefined) delete next[id]
    else next[id] = value
    return next
  }

  function refresh() {
    if (!installed || statusProcess.running) return
    statusProcess.command = ["ocvpn", "status", "--json"]
    statusProcess.running = true
  }

  function run(verb, id) {
    if (!installed) return
    if (!Model.isValidId(id)) {
      lastError = "Invalid profile id"
      return
    }
    if (isPending(id)) return
    pending = withEntry(pending, id, verb)
    messages = withEntry(messages, id, undefined)
    actionComponent.createObject(root, {
      profileId: id,
      verb: verb,
      command: ["ocvpn", verb, id],
      running: true
    })
  }

  function connectProfile(id) { run("connect", id) }
  function disconnectProfile(id) { run("disconnect", id) }

  function toggleProfile(profile) {
    if (!profile) return
    if (profile.connected) disconnectProfile(profile.id)
    else connectProfile(profile.id)
  }

  function onActionLine(id, line) {
    var text = Model.lastLine(line)
    if (text !== "") messages = withEntry(messages, id, text)
  }

  function finishAction(id, exitCode, lastLine) {
    pending = withEntry(pending, id, undefined)
    // Success clears the progress line; failure keeps the CLI's own reason.
    messages = withEntry(messages, id, exitCode === 0 ? undefined : (lastLine || "Command failed"))
    refresh()
  }

  Timer {
    interval: root.refreshIntervalSec * 1000
    repeat: true
    running: root.installed
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Process {
    id: whichProcess
    command: ["which", "ocvpn"]
    running: true
    onExited: function(exitCode) {
      root.installed = exitCode === 0
      root.checked = true
      if (root.installed) root.refresh()
    }
  }

  Process {
    id: statusProcess
    command: []
    stdout: StdioCollector { id: statusStdout; waitForEnd: true }
    stderr: StdioCollector { id: statusStderr; waitForEnd: true }
    onExited: function(exitCode) {
      if (exitCode !== 0) {
        root.lastError = Model.lastLine(statusStderr.text) || "ocvpn status failed"
        return
      }
      var parsed = Model.parseStatus(statusStdout.text)
      if (!parsed.ok) {
        root.lastError = parsed.error
        return
      }
      root.profiles = parsed.profiles
      root.loaded = true
      root.lastError = ""
    }
  }

  Component {
    id: actionComponent

    Process {
      id: proc
      property string profileId: ""
      property string verb: ""
      property string lastLine: ""
      stdout: SplitParser {
        onRead: function(line) {
          proc.lastLine = line
          root.onActionLine(proc.profileId, line)
        }
      }
      stderr: SplitParser {
        onRead: function(line) {
          proc.lastLine = line
          root.onActionLine(proc.profileId, line)
        }
      }
      onExited: function(exitCode) {
        root.finishAction(proc.profileId, exitCode, Model.lastLine(proc.lastLine))
        proc.destroy()
      }
    }
  }
}
