import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Commons
import qs.Commons as Commons
import qs.Ui
import "Model.js" as Model

// Bar button plus popup for OpenConnect VPN profiles. All state and actions
// live in Service.qml, which talks to the `ocvpn` CLI.
Panel {
  id: root
  moduleName: "jsimonrichard.openconnect"
  ipcTarget: "jsimonrichard.openconnect"

  property int cursorIndex: 0
  property bool cursorActive: false

  readonly property color foreground: bar ? bar.foreground : Commons.Color.foreground
  readonly property color urgent: bar ? bar.urgent : Commons.Color.urgent
  readonly property color dim: Qt.darker(foreground, 1.55)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property color hoverFill: bar ? Style.hoverFillFor(bar.foreground, Commons.Color.accent) : "transparent"
  readonly property bool anyConnected: vpn.connectedCount > 0
  readonly property var profiles: vpn.profiles

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Commons.Translations { id: strings; directory: Qt.resolvedUrl("i18n") }

  Service {
    id: vpn
    settings: root.settings
  }

  function clampCursor() {
    cursorIndex = Math.max(0, Math.min(cursorIndex, profiles.length - 1))
  }

  function moveCursor(dy) {
    if (profiles.length === 0) return
    cursorActive = true
    cursorIndex = Math.max(0, Math.min(profiles.length - 1, cursorIndex + dy))
  }

  function setCursor(index) {
    cursorActive = true
    cursorIndex = index
  }

  function selectedProfile() {
    if (profiles.length === 0) return null
    return profiles[Math.max(0, Math.min(cursorIndex, profiles.length - 1))]
  }

  function toggleSelected() { vpn.toggleProfile(selectedProfile()) }

  function rowDetail(profile) {
    var message = vpn.messages[profile.id]
    if (message) return message
    if (vpn.pending[profile.id] === "connect") return strings.t("connecting")
    if (vpn.pending[profile.id] === "disconnect") return strings.t("disconnecting")
    if (profile.connected && profile.ipv4 !== "") return profile.ipv4
    return Model.hostOf(profile.server)
  }

  function rowDetailIsError(profile) {
    return vpn.messages[profile.id] !== undefined && !vpn.isPending(profile.id)
  }

  onProfilesChanged: clampCursor()
  onOpenedChanged: if (opened) {
    cursorActive = false
    vpn.refresh()
    Qt.callLater(function() { if (panel.loadedContent) panel.loadedContent.forceActiveFocus() })
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󰖂"
    foreground: root.anyConnected ? root.barForeground : Qt.darker(root.barForeground, 1.55)
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.RightButton) vpn.refresh()
      else root.toggle()
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: panel.loadedContent
    contentWidth: panel.fittedContentWidth(Style.space(360))
    contentHeight: panel.fittedContentHeight(panel.loadedContentHeight, Style.space(420))

    content: PanelKeyCatcher {
      id: keyCatcher
      implicitHeight: column.implicitHeight
      anchors.fill: parent
      onMoveRequested: function(dx, dy) {
        if (!root.cursorActive) { root.cursorActive = true; return }
        root.moveCursor(dy)
      }
      onActivateRequested: if (root.cursorActive) root.toggleSelected()
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }
      onTextKey: function(t) {
        if (t === "r" || t === "R") vpn.refresh()
      }

      Column {
        id: column
        width: parent.width
        spacing: Style.space(12)

        PanelHero {
          id: hero
          width: parent.width
          title: strings.t("title")
          meta: vpn.loaded ? strings.tn("summary", root.profiles.length)
            .arg(Commons.I18n.formatNumber(vpn.connectedCount))
            .arg(Commons.I18n.formatNumber(root.profiles.length)) : ""
          foreground: root.foreground
          fontFamily: root.fontFamily
          iconOpacity: root.anyConnected ? 1.0 : 0.5
          iconComponent: Component {
            Text {
              textFormat: Text.PlainText
              text: "󰖂"
              color: root.anyConnected ? root.foreground : root.dim
              font.family: root.fontFamily
              font.pixelSize: Style.font.display
            }
          }
        }

        Text {
          textFormat: Text.PlainText
          visible: vpn.checked && !vpn.installed
          width: parent.width
          text: strings.t("notInstalled") + " — " + strings.t("notInstalledHelp")
          color: root.urgent
          font.family: root.fontFamily
          font.pixelSize: Style.font.bodySmall
          wrapMode: Text.WordWrap
        }

        Text {
          textFormat: Text.PlainText
          visible: vpn.installed && vpn.lastError !== ""
          width: parent.width
          text: strings.t("statusFailed") + ": " + vpn.lastError
          color: root.urgent
          font.family: root.fontFamily
          font.pixelSize: Style.font.bodySmall
          wrapMode: Text.WordWrap
        }

        Text {
          textFormat: Text.PlainText
          visible: vpn.installed && vpn.loaded && vpn.lastError === "" && root.profiles.length === 0
          width: parent.width
          text: strings.t("noProfiles") + "\n" + strings.t("noProfilesHelp")
          color: root.dim
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
          horizontalAlignment: Text.AlignHCenter
          wrapMode: Text.WordWrap
        }

        Column {
          width: parent.width
          spacing: Style.space(6)

          Repeater {
            model: root.profiles
            ProfileRow {
              required property var modelData
              required property int index
              width: parent.width
              profile: modelData
              rowIndex: index
            }
          }
        }
      }
    }
  }

  component ProfileRow: CursorSurface {
    id: row
    property var profile: null
    property int rowIndex: 0
    readonly property bool working: profile ? vpn.isPending(profile.id) : false

    hasCursor: root.cursorActive && root.cursorIndex === rowIndex
    foreground: root.foreground
    implicitHeight: rowLayout.implicitHeight + Style.spacing.rowPaddingX

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onEntered: root.setCursor(row.rowIndex)
      onClicked: vpn.toggleProfile(row.profile)
    }

    RowLayout {
      id: rowLayout
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: Style.space(10)
      anchors.rightMargin: Style.space(10)
      spacing: Style.space(8)

      ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.space(1)

        Text {
          textFormat: Text.PlainText
          Layout.fillWidth: true
          text: row.profile ? row.profile.name : ""
          color: root.foreground
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
          elide: Text.ElideRight
        }

        Text {
          textFormat: Text.PlainText
          Layout.fillWidth: true
          text: row.profile ? root.rowDetail(row.profile) : ""
          color: row.profile && root.rowDetailIsError(row.profile) ? root.urgent : root.dim
          font.family: root.fontFamily
          font.pixelSize: Style.font.caption
          elide: Text.ElideRight
        }
      }

      ToggleSwitch {
        id: toggle
        checked: row.profile ? row.profile.connected : false
        busy: row.working
        hasCursor: row.hasCursor
        foreground: root.foreground
        Layout.alignment: Qt.AlignVCenter
        onHovered: function(on) { if (on) root.setCursor(row.rowIndex) }
        onToggled: vpn.toggleProfile(row.profile)

        PanelToolTip {
          visible: toggle.containsMouse
          text: row.profile && row.profile.connected ? strings.t("disconnect") : strings.t("connect")
          fontFamily: root.fontFamily
        }
      }
    }
  }
}
