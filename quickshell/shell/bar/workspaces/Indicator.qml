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

    acceptedButtons: Qt.NoButton

    onWheel: event => {
        event.accepted = true;
        const step = -Math.sign(event.angleDelta.y);
        const targetWs = currentIndex + step;

        if (targetWs >= wsBaseIndex && targetWs < wsBaseIndex + wsCount) {
            Hyprland.dispatch(`workspace ${targetWs}`)
        }
    }

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen);
    property int currentIndex: 0;
    property int existsCount: 0;
    // visible: true

    // destructor takes care of nulling
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

            model: wsCount

            MouseArea {
                id: wsItem
                onPressed: Hyprland.dispatch(`workspace ${wsIndex}`);
                // required property var modelData
                height: childrenRect.height
                // width:
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
                    // anchors.centerIn: parent
                    height:  35
                    // Behavior on height {
                    //     NumberAnimation {
                    //         duration: 200
                    //     }
                    // }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                    width: parent.width
                    // radius: 4
                    // topRightRadius: (wsIndex == 1) ?? 5
                    // topLeftRadius: (wsIndex == 1) ?? 5
                    //
                    // bottomRightRadius: (wsIndex == 8) ?? 5
                    // bottomLeftRadius: (wsIndex == 8) ?? 5
                    // border.color: Config.colors.border
                    // border.width: 1
                    color: active ? Config.colors.selected : exists ? Config.colors.active : Config.colors.background
                    Text {
                        anchors.centerIn: parent
                        text: wsIndex
                        color: Config.colors.text
                        font {
                            family: Config.font
                            weight: active ? Font.Bold : Font.Thin
                            pixelSize: active ? 16 : 12
                        }
                        Behavior on font.weight {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
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
