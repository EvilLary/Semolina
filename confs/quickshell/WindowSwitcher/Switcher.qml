pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import "../Libs"

Scope {

    Connections {
        target: IPC
        function onSwitcherShortcut() {
            loader.activeAsync = !loader.active;
        }
    }
    LazyLoader {
        id: loader

        WlrLayershell {
            id: window

            layer: WlrLayer.Overlay
            namespace: "shell"
            exclusionMode: ExclusionMode.Ignore

            //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            color: "transparent"

            HyprlandFocusGrab {
                id: grab
                active: true
                windows: [window]
                // onCleared: loader.active = false
            }
            MouseArea {
                anchors.fill: parent
                onClicked: loader.active = false
            }
            Rectangle {
                id: background
                anchors.centerIn: parent
                width: entries.width + 20
                radius: Config.globalRadius
                focus: true
                Keys.onEscapePressed: loader.active = false
                border {
                    width: 1
                    color: Config.colors.border
                }
                height: entries.height + 20
                color: Config.colors.background
                WindowEntries {
                    id: entries
                    property bool active: loader.active
                }
            }
        }
    }
}
