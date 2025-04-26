import Quickshell
import QtQuick
import Quickshell.Wayland
// import "../Libs"

PanelWindow {
    id: panel

    default property alias items: barItems.data

    WlrLayershell.namespace: "shell"
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusiveZone: height
    exclusionMode: ExclusionMode.Normal

    color: "transparent"
    //color: Qt.alpha(Config.colors.background, 0.5)

    Item {
        id: barItems
        anchors {
            fill: parent
            rightMargin: 10
            leftMargin: 10
        }
    }
}
