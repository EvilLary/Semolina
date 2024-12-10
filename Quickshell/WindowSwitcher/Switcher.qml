import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import "root:."

Scope {

    LazyLoader {
        id: loader
        active: Config.showSwitcher

        PanelWindow {
            id: window

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs::switcher"
            exclusionMode: ExclusionMode.Ignore
            //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            // Show only on the focused monitor
            screen: Quickshell.screens.filter(screen => screen.name == Config.activeMonitor)[0];
            color: "transparent"

            HyprlandFocusGrab {
                id: grab
                active: true
                windows: [ window ]
                // onCleared: loader.active = false
                // onActiveChanged: loader.active = false
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
                height: entries.height + 20
                color: Config.colors.secondaryBackground
                // Keys.onEscapePressed: loader.active = false
                WindowEntries {
                    id: entries
                    windows: ToplevelManager.toplevels
                }
            }
        }
    }
}
