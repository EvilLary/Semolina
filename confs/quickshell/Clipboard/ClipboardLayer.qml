pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland

Scope {
    id: root
    property int x
    property int y
    GlobalShortcut {
        name: "clipboard"
        description: "Show clipboard"
        onPressed: {
            if (!loader.active) {
                // clipboard.getClipboardData()
                cursorPosition.running = true
            }
            else {
                loader.active = false
            }
        }
    }
    // Connections {
    //     target: Clipboard
    //     function onClose() {
    //         loader.active = false
    //     }
    // }
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
            exclusionMode: ExclusionMode.Normal

            color: "transparent"

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }

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
                x: Math.min((root.x + 15),(layer.width - width - 15))
                y: Math.min((root.y + 15),(layer.height - height - 8))
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
