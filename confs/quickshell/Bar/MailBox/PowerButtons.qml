pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../"
import QtQuick.Controls

Rectangle {
    id: powerButtons

    radius: Config.globalRadius
    color: Config.colors.altBackground

    Process {
        id: cmd
    }
    readonly property list<var> buttons: [
        {
            icon: 'image://icon/system-shutdown-symbolic',
            tooltip: 'Shutdown the system',
            command: ['systemctl', 'poweroff'],
        },
        {
            icon: 'image://icon/system-reboot-symbolic',
            tooltip: 'Reboot the system',
            command: ['systemctl', 'reboot'],
        },
        {
            icon: 'image://icon/system-suspend-symbolic',
            tooltip: 'Suspend the system',
            command: ['systemctl', 'sleep'],
        },
        {
            icon: 'image://icon/system-log-out-symbolic',
            tooltip: 'Logout from the sessoin',
            command: ['uwsm', 'stop'],
        },
        {
            icon: 'image://icon/system-reboot-symbolic',
            tooltip: 'Soft-reboot the system',
            command: ['systemctl', 'soft-reboot'],
        },
        {
            icon: 'image://icon/system-lock-screen-symbolic',
            tooltip: 'Lock the system',
            command: ['loginctl', 'lock-session'],
        }
    ]

    GridLayout {
        anchors {
            fill: parent
            margins: 8
        }
        columns: 6
        columnSpacing: 6
        rowSpacing: 6
        Repeater {
            model: powerButtons.buttons
            //poweroff,lock,logout,restart,soft-reboot,sleep
            Rectangle {
                id: btn
                required property var modelData
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Config.globalRadius
                color: mouseArea.containsMouse ? Config.colors.negative : Config.colors.altBase
                Behavior on color {
                    ColorAnimation {
                        duration: 125
                    }
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    //onClicked: btn.modelData.exec()
                    onClicked: dialog.open()
                }
                ToolTip {
                    visible: mouseArea.containsMouse
                    text: btn.modelData.tooltip
                    delay: 150
                }
                Dialog {
                    id: dialog
                    width: 170
                    height: 50
                    standardButtons: Dialog.Ok | Dialog.Cancel
                    onAccepted: {
                        cmd.command = btn.modelData.command
                        cmd.startDetached()
                    }
                }
                Image {
                    anchors.centerIn: parent
                    sourceSize {
                        width: 20
                        height: 20
                    }
                    source: btn.modelData.icon
                }
            }
        }
    }
}
