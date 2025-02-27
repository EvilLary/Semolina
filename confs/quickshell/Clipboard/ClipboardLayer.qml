pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import Quickshell.Hyprland
import "../Libs"
Scope {
    id: root

    Connections {
        target: IPC
        ignoreUnknownSignals: true
        function onClipboardToggle(): void {
            if (!loader.active) {
                Clipboard.getClipboardData()
                cursorPosition.running = true
            }
            else {
                loader.active = false
            }
        }
    }
    property int x
    property int y
    Process {
        id: cursorPosition
        command: ["sh","-c","hyprctl cursorpos"]
        stdout: SplitParser {
            onRead: data => {
                const [x,y] = data.split(',')
                root.x = x
                root.y = y
            }
        }
        onExited: {
            loader.active = true
        }
    }
    LazyLoader {
        id: loader

        PanelWindow {
            id: layer
            //WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "shell"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            //exclusionMode: ExclusionMode.Normal

            color: "transparent"

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            //HyprlandFocusGrab {
            //    id: grab;
            //    active: true;
            //    windows: [ layer ];
            //    // onCleared: loader.active = false
            //}
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                onClicked: loader.active = false
            }
            Content {
                id: content
                width: 500
                height: 525
                x: Math.min((root.x + 20),(layer.width - width - 20))
                y: Math.min((root.y + 10),(layer.height - height - 10))
            }
            //Component.onCompleted: {
            //    const component = Qt.createComponent("Content.qml");
            //    if (component.status == Component.Ready) {
            //        component.createObject(layer,{
            //            width: 500,
            //            height: 550,
            //            x: Math.min((root.x + 20),(layer.width - width - 20)),
            //            y: Math.min((root.y + 10),(layer.height - height - 10)),
            //        })
            //}
            //}
        }
    }
}
