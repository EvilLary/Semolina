import Quickshell
import QtQuick
import Quickshell.Wayland
import "root:."

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: "qs::bar"

    required property ShellScreen screen;
    default property alias barItems: containment.data;

    width: 50
    margins {
        right: 5
        top: 5
        bottom: 5
    }
    exclusiveZone: width
    anchors {
        top: true
        bottom: true
        right: true
    }
    color: "transparent"

    Rectangle {
        id: rect
        radius: 3
        anchors {
            fill: parent
        }
        color: Config.colors.altBackground
        border {
            color: Config.colors.border
            width: 1
        }
        Item {
            id: containment

            anchors {
                fill: parent
                margins: 5
            }
        }
    }
}
