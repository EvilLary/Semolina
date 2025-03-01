import Quickshell
import QtQuick
import Quickshell.Wayland
import "root:Libs"

PanelWindow {
    id: panel

    default property alias items: barItems.data

    WlrLayershell.namespace: "shell"
    WlrLayershell.layer: WlrLayer.Bottom
    height: 48
    //exclusiveZone: height
    //exclusionMode: ExclusionMode.Normal

    color: "black"

    Item {
        id: barItems
        anchors {
            fill: parent
            rightMargin: 10
            leftMargin: 10
        }
    }
}
