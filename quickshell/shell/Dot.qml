import Quickshell
import QtQuick
import Quickshell.Wayland
PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "dot"
    required property ShellScreen screen;
    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }
    color: "transparent"
    mask: Region {}
    Rectangle {
        anchors.centerIn: parent
        width: 5
        height: 5
        radius: 5
        color: "red"
    }

}
