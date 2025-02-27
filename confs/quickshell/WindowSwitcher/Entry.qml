import QtQuick
import QtQuick.Controls
import Qt.labs.sharedimage
import Quickshell.Wayland
import QtQuick.Layouts
import "../Libs"

Rectangle {
    id: entry
    required property var modelData

    width: 160 * 1.75
    height: 90 * 1.75
    radius: Config.globalRadius
    border {
        width: entryArea.containsMouse ?? 1
        color: Config.colors.border
    }
    color: (entry.modelData.activated || entryArea.containsMouse) ? Config.colors.accent : Config.colors.altBackground
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    ScreencopyView {
        id: screenView
        captureSource: grid.active ? entry.modelData : null
        anchors.fill: parent
        anchors {
            fill: parent
            margins: 8
        }
        live: false
    }

    MouseArea {
        id: entryArea
        anchors.fill: parent
        onClicked: {
            entry.modelData.activate();
            IPC.switcherShortcut();
        }
        hoverEnabled: true
        ToolTip.visible: entryArea.containsMouse
        ToolTip.text: entry.modelData.title
        ToolTip.delay: 100
    }

    Image {
        id: windowIcon
        Layout.alignment: Qt.AlignCenter
        anchors {
            verticalCenter: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        mipmap: false
        asynchronous: true
        source: Toplevels.getToplevelIcon(entry.modelData.appId)
        width: 50
        height: 50
        scale: entryArea.containsMouse ? 1.20 : 1
        sourceSize {
            width: windowIcon.width
            height: windowIcon.height
        }
        Behavior on scale {
            ScaleAnimator {
                duration: 100
            }
        }
    }
}
