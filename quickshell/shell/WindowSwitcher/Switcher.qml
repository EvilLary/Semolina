import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import "root:."
Scope {

    GlobalShortcut {
        name: "WindowSwitcher"
        onPressed: {
            loader.activeAsync = !loader.active
            // grab.active = true
        }
        // onReleased: loader.active = false
    }


    LazyLoader {
        id: loader

        PanelWindow {
            id: window
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs::switcher"
            exclusionMode: ExclusionMode.Ignore

            //Bugged : (
            // WlrLayershell.keyboardFocus: KeyboardFocus.Exclusive
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
                windows: [ window ]
                // onCleared: loader.active = false
                // onActiveChanged: loader.active = false
            }
            // Keys.onPressed: (event)=> {
            //     loader.active = false
            //     if (event.key == Qt.Key_Escape) {
            //         loader.active = false
            //         grab.active = false
            //     }
            // }
            MouseArea {
                //Click to exit
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    loader.active = false
                    grab.active = false
                }
            }

            Rectangle {
                id: background
                anchors.centerIn: parent
                width: entries.width + 20
                radius: 3
                border {
                    width: 1
                    color: Config.colors.border
                }


                // contentHeight: 300
                height: entries.height + 20
                color: Config.colors.secondaryBackground

                WindowEntries {
                    id: entries
                    windows: ToplevelManager.toplevels
                    activeWindow: ToplevelManager.activeToplevel
                }
            }

        }
    }
}
