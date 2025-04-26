import QtQuick
import "root:Libs"
import QtQuick.Layouts

Rectangle {
    id: gsrControls
    color: Config.colors.background
    radius: Config.globalRadius
    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10
        ActionButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            isActive: root.gsrBuffer
            actionName: "Instant Replay"
            icon: "root:assets/instant-replay"
            status: root.gsrBuffer ? "On" : "Off"
            onLeftClick: {
                root.cmdArgument = "gsr toggle"
                cmd.running = true
            }
            onRightClick: {
                root.cmdArgument = "gsr save"
                cmd.running = true
            }
        }
        ActionButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            isActive: root.gsrRecording
            actionName: "Record"
            icon: "root:assets/record"
            status: root.gsrRecording ? "Recording..." : "Off"
            onLeftClick: {
                root.cmdArgument = "gsr record"
                cmd.running = true
            }
        }
        ActionButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            isActive: root.gameModeStatus
            actionName: "GameMode"
            icon: "root:assets/gamepad"
            status: root.gameModeStatus ? "On" : "Off"
            onLeftClick: {
                root.cmdArgument = "gamemode"
                cmd.running = true
            }
        }
    }
}
