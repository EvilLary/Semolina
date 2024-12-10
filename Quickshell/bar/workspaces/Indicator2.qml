import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "root:."
import "root:Components"

BarWidgetInner {

    id: root
    required property var bar;
    required property int wsBaseIndex;
    property int wsCount: 8;
    property bool hideWhenEmpty: false;
    implicitHeight: column.implicitHeight + 15;
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen);
    property int currentIndex: 0;
    property int existsCount: 0;
    border.width: 0
    signal workspaceAdded(workspace: HyprlandWorkspace);

    ColumnLayout {

        id: column
        spacing: 0
        anchors {
            fill: parent;
            topMargin: 4
        }
        Layout.fillWidth: true
        Repeater {

            model: ["١","٢","٣","٤","٥","٦","٧","٨"]

            Rectangle {
                id: wsItem
                required property var modelData
                required property int index;
                height: 35
                Layout.fillWidth: true
                color: "transparent"
                Layout.alignment: Qt.AlignHCenter
                property int wsIndex: wsBaseIndex + index;
                property HyprlandWorkspace workspace: null;
                property bool exists: workspace != null;
                property bool active: (monitor?.activeWorkspace ?? false) && monitor.activeWorkspace == workspace;

                onActiveChanged: {
                    if (active) root.currentIndex = wsIndex;
                }

                onExistsChanged: {
                    root.existsCount += exists ? 1 : -1;
                }

                Connections {
                    target: root

                    function onWorkspaceAdded(workspace: HyprlandWorkspace) {
                        if (workspace.id == wsItem.wsIndex) {
                            wsItem.workspace = workspace;
                        }
                    }
                }


                Text {
                    id: wsText
                    text: modelData
                    color: exists ? Config.colors.text : "#64a6a6a6"
                    renderType: Text.NativeRendering
                    font {
                        family: Config.font
                        weight: (exists || active) ? Font.Bold : Font.Thin
                        pixelSize: active ? 30 : 18
                    }
                    anchors.centerIn: parent
                    // horizontalAlignment: Text.AlignHCenter
                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch(`workspace ${wsIndex}`);
                }
            }
        }
    }

    Connections {
        target: Hyprland.workspaces

        function onObjectInsertedPost(workspace) {
            root.workspaceAdded(workspace);
        }
    }
    Component.onCompleted: {
        Hyprland.workspaces.values.forEach(workspace => {
            root.workspaceAdded(workspace)
        });
    }
}
