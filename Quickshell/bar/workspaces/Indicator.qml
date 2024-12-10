import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "root:."

MouseArea {
    id: root

    required property var bar;
    required property int wsBaseIndex;
    property int wsCount: 8;
    property bool hideWhenEmpty: false;
    implicitHeight: column.implicitHeight;

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen);
    property int currentIndex: 0;
    property int existsCount: 0;


    signal workspaceAdded(workspace: HyprlandWorkspace);

    ColumnLayout {
        id: column
        spacing: 0
        anchors {
            fill: parent;
            // topMargin: 12;
            // margins: 3;
        }

        Repeater {

            model: ["١","٢","٣","٤","٥","٦","٧","٨"]

            MouseArea {
                id: wsItem
                onPressed: Hyprland.dispatch(`workspace ${wsIndex}`);
                required property var modelData
                height: childrenRect.height
                Layout.fillWidth: true
                // Layout.fillHeight: true
                // Layout.bottomMargin: 16
                required property int index;
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

                Rectangle {
                    id: entry
                    height:  35
                    width: parent.width
                    color: "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: exists ? Config.colors.text : "#7da6a6a6"
                        renderType: Text.NativeRendering
                        font {
                            family: Config.font
                            weight: (exists || active) ? Font.Bold : Font.Thin
                            pixelSize: active ? 30 : 18
                        }
                        Behavior on font.pixelSize {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }
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
