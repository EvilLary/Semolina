pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Io

Scope {
    id: root

    IpcHandler {
        target: "screenshot"
        function stop(): void {
            loader.active = false
        }
        function start(): void {
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
