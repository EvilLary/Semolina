pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import "../Libs"

Scope {
    id: root

    Connections {
        target: IPC
        function onStop(): void {
            loader.active = false
        }
        function onStart(): void {
            loader.active = true
        }
    }
    LazyLoader {
        id: loader

        WlrLayershell {
            id: layer

            layer: WlrLayer.Overlay
            //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            namespace: "screenshot"
            exclusionMode: ExclusionMode.Ignore
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: "transparent"
            ScreencopyView {
                captureSource: layer.screen
                anchors.fill: parent
                live: false
            }
        }
    }
}
