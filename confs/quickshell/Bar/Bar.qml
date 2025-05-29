import Quickshell
import Quickshell.Wayland
import QtQuick
import "../Config"
import QtQuick.Layouts

Variants {
    model: Quickshell.screens.filter(screen => screen.model === "EK241Y")
    PanelWindow {
        id: bar
        required property ShellScreen modelData
        WlrLayershell.layer: WlrLayer.Bottom
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "qsbar"
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: this.width
        surfaceFormat.opaque: true

        screen: this.modelData
        anchors {
            left: false
            top: true
            bottom: true
            right: true
        }
        implicitWidth: 56
        color: Colors.base

        Rectangle {
            id: shitBorder
            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
            width: 1
            color: Colors.light
        }
        Item {
            id: barContent

            anchors {
                fill: parent
                margins: 6
                topMargin: 8
                bottomMargin: 8
            }
            Tasks {
                id: tasks
                bar: bar
                anchors {
                    top: parent.top
                    right: parent.right
                    left: parent.left
                }
                width: parent.width
            }
            ColumnLayout {
                id: bottom
                anchors {
                    right: parent.right
                    left: parent.left
                    bottom: parent.bottom
                }
                spacing: 8
                height: this.implicitHeight
                Tray {
                    id: tray
                    Layout.preferredHeight: this.height
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    bar: bar
                }
                Seperator {
                    visible: tray.visible
                    Layout.alignment: Qt.AlignCenter
                }
                Indicators {
                    id: indicators
                    Layout.preferredHeight: this.height
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    bar: bar
                }
                Seperator {
                    Layout.alignment: Qt.AlignCenter
                }
                CurrentLayout {
                    Layout.preferredHeight: 20
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                }
                Seperator {
                    Layout.alignment: Qt.AlignCenter
                }
                DigitalClock {
                    id: digitalClock
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter
                    Layout.preferredHeight: this.height
                }
            }
        }
    }

    // HyprlandWindow.visibleMask: Region {
    //     item: barContent
    // }
    component Seperator: Rectangle {
        implicitHeight: 1
        implicitWidth: 14
        color: Colors.light
    }
}
