import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import '../../Libs'
import QtQuick.Controls

Rectangle {
    id: powerButtons

    radius: Config.globalRadius
    color: Config.colors.altBackground

    readonly property list<QtObject> buttons: [ 
        QtObject {
            readonly property string icon: 'image://icon/system-shutdown-symbolic'
            readonly property string tooltip: 'Shutdown the system'
            readonly property Process process: Process {
                command: ['sh','-c','systemctl poweroff']
                manageLifetime: false
            }
            function exec(): void {
                process.running = true
            }
        },
        QtObject {
            readonly property string icon: 'image://icon/system-reboot-symbolic'
            readonly property string tooltip: 'Reboot the system'
            readonly property Process process: Process {
                command: ['sh','-c','systemctl reboot']
                manageLifetime: false
            }
            function exec(): void {
                process.running = true
            }
        },
        QtObject {
            readonly property string icon: 'image://icon/system-suspend-symbolic'
            readonly property string tooltip: 'Suspend the system'
            readonly property Process process: Process {
                command: ['sh','-c','systemctl sleep']
                manageLifetime: false
            }
            function exec(): void {
                process.running = true
            }
        },
        QtObject {
            readonly property string icon: 'image://icon/system-log-out-symbolic'
            readonly property string tooltip: 'Logout from the sessoin'
            readonly property Process process: Process {
                command: ['sh','-c','uwsm stop']
                manageLifetime: false
            }
            function exec(): void {
                process.running = true
            }
        },
        QtObject {
            readonly property string icon: 'image://icon/system-reboot-symbolic'
            readonly property string tooltip: 'Soft-reboot the system'
            readonly property Process process: Process {
                command: ['sh','-c','systemctl soft-reboot']
                manageLifetime: false
            }
            function exec(): void {
                process.running = true
            }
        },
        QtObject {
            readonly property string icon: 'image://icon/system-lock-screen-symbolic'
            readonly property string tooltip: 'Lock the system'
            readonly property Process process: Process {
                command: ['sh','-c','loginctl lock-session']
                manageLifetime: false
            }
            function exec(): void {
                process.running = true
            }
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
                color: mouseArea.containsMouse ? Config.colors.negative : Config.colors.border
                Behavior on color { ColorAnimation { duration: 125; } }
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
                    onAccepted: btn.modelData.exec()
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
