import QtQuick
import Quickshell.Hyprland

Rectangle {
    id: entry
    required property int index;
    property int wsIndex: wsBaseIndex + index;
    property HyprlandWorkspace workspace: null;
    property bool exists: workspace != null;
    property bool active: (monitor?.activeWorkspace ?? false) && monitor.activeWorkspace == workspace;

    MouseArea {
        id: mouseAea
        anchors.fill: parent
        onClicked: Hyprland.dispatch(`workspace ${wsIndex}`);
    }
}
