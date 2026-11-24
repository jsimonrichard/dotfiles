// Pure helpers for the OpenConnect widget. No QML imports, so it can be loaded
// by Node for tests. Everything here treats `ocvpn` output as untrusted: the
// ids become argv entries, names and addresses become display text.

var ID_RE = /^[a-z0-9][a-z0-9-]{0,11}$/
var MAX_PROFILES = 32
var MAX_TEXT = 128

function isValidId(id) {
  return typeof id === "string" && ID_RE.test(id)
}

function cleanText(value, max) {
  var limit = max === undefined ? MAX_TEXT : max
  // Drop control characters; the text is shown with Text.PlainText.
  var text = String(value === undefined || value === null ? "" : value).replace(/[\u0000-\u001f\u007f]/g, " ").trim()
  return text.length > limit ? text.substring(0, limit - 1) + "…" : text
}

function optionalText(value) {
  if (value === undefined || value === null) return ""
  return typeof value === "string" ? cleanText(value) : ""
}

// Parses `ocvpn status --json`. Returns { ok, profiles, error }; a malformed
// document is an error, never a partial list.
function parseStatus(raw) {
  var data
  try {
    data = JSON.parse(String(raw || ""))
  } catch (e) {
    return { ok: false, profiles: [], error: "invalid JSON" }
  }
  if (!(data instanceof Array)) return { ok: false, profiles: [], error: "expected a list of profiles" }
  if (data.length > MAX_PROFILES) return { ok: false, profiles: [], error: "too many profiles" }

  var profiles = []
  var seen = {}
  for (var i = 0; i < data.length; i++) {
    var p = data[i]
    if (!p || typeof p !== "object" || !isValidId(p.id) || seen[p.id]
        || typeof p.name !== "string" || typeof p.connected !== "boolean") {
      return { ok: false, profiles: [], error: "malformed profile at index " + i }
    }
    seen[p.id] = true
    profiles.push({
      id: p.id,
      name: cleanText(p.name),
      server: optionalText(p.server),
      protocol: optionalText(p.protocol),
      connected: p.connected,
      ipv4: optionalText(p.ipv4),
      ipv6: optionalText(p.ipv6)
    })
  }
  return { ok: true, profiles: profiles, error: "" }
}

function connectedCount(profiles) {
  var n = 0
  for (var i = 0; i < profiles.length; i++) if (profiles[i].connected) n++
  return n
}

function hostOf(server) {
  var match = String(server || "").match(/^https?:\/\/([^\/:?#]+)/i)
  return match ? match[1] : cleanText(server)
}

// Last non-empty line of command output, without the CLI's "ocvpn: " prefix.
function lastLine(text) {
  var lines = String(text || "").split("\n")
  for (var i = lines.length - 1; i >= 0; i--) {
    var line = cleanText(lines[i].replace(/^ocvpn:\s*/, ""), 140)
    if (line !== "") return line
  }
  return ""
}

if (typeof module !== "undefined") {
  module.exports = {
    isValidId: isValidId,
    parseStatus: parseStatus,
    connectedCount: connectedCount,
    hostOf: hostOf,
    lastLine: lastLine,
    cleanText: cleanText
  }
}
