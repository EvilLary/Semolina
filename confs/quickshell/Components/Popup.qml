pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: root
    required property url itemUrl
    required property Item parentItem
    required property QsWindow bar
    required property int height
    required property int width

    // property int xMargin: 0
    property double yMargin: 0

    signal closed
    // signal close
    function toggle(): void {
        if (loader.active) {
            // root.close();
        } else {
            loader.active = true;
        }
    }
    readonly property LazyLoader loader: LazyLoader {
        id: loader
        PopupWindow {
            id: popup
            implicitWidth: root.width + 12
            implicitHeight: root.height
            visible: true
            color: "transparent"
            anchor.window: root.bar
            HyprlandWindow.opacity: 0
            anchor {
                // edges: Edges.Top | Edges.Right
                // gravity: Edges.Bottom | Edges.Left
                rect.x: -(root.width + 12)
                rect.y: {
                    const coords = root.bar.contentItem.mapFromItem(root.parentItem, 0, 0);
                    const ymargins = 6;
                    const height = root.height;
                    const hl_height = height / 2;
                    const barHeight = root.bar.height;
                    const yoffset = root.yMargin;
                    const pre_calc_y = (coords.y) - (height / 2) + yoffset;
                    if (coords.y < barHeight / 2) {
                        if (coords.y < hl_height) {
                            return ymargins;
                        } else {
                            return pre_calc_y;
                        }
                    } else {
                        const remaining = barHeight - coords.x;
                        if (remaining > hl_height) {
                            return pre_calc_y;
                        } else {
                            return barHeight - height - ymargins;
                        }
                    }
                }
            }
            // Connections {
            //     target: root
            //     function onClose(): void {
            //         popup.hideAnimation();
            //     }
            // }
            Connections {
                target: body.item
                ignoreUnknownSignals: true
                function onClosePopup() {
                    popup.hideAnimation()
                }
            }
            HyprlandFocusGrab {
                id: grab
                windows: [popup]
                onCleared: popup.hideAnimation()
            }
            Loader {
                id: body
                // anchors.fill: parent
                focus: true
                width: parent.width - 6
                height: parent.height
                // x: this.width
                Keys.onEscapePressed: popup.hideAnimation()
                source: root.itemUrl
            }
            ParallelAnimation {
                id: startAnim
                NumberAnimation {
                    target: popup
                    property: "HyprlandWindow.opacity"
                    from: 0
                    to: 1
                    duration: 150
                    easing.type: Easing.Linear
                }
                // NumberAnimation {
                //     target: body
                //     property: "x"
                //     from: body.width
                //     to: 0
                //     duration: 150
                //     easing.type: Easing.Linear
                // }
            }

            ParallelAnimation {
                id: hideAnim
                NumberAnimation {
                    target: popup
                    property: "HyprlandWindow.opacity"
                    from: 1
                    to: 0
                    duration: 150
                    easing.type: Easing.Linear
                }
                // NumberAnimation {
                //     target: body
                //     property: "x"
                //     from: 0
                //     to: body.width
                //     duration: 150
                //     easing.type: Easing.Linear
                // }
                onFinished: {
                    root.closed();
                    loader.active = false;
                }
            }
            // NumberAnimation {
            //     id: anim
            //     target: popup
            //     property: "HyprlandWindow.opacity"
            //     duration: 200
            //     easing.type: Easing.InOutQuad
            //     onFinished: {
            //         if (popup.HyprlandWindow.opacity === 0) {
            //             root.closed();
            //             loader.active = false;
            //         }
            //     }
            // }
            function spawnAnimation(): void {
                startAnim.start();
                // anim.to = 1;
                // anim.from = 0;
                // anim.restart();
                grab.active = true;
            }
            function hideAnimation(): void {
                grab.active = false;
                hideAnim.start();
                // anim.to = 0;
                // anim.from = 1;
                // anim.restart();
            }
            Component.onCompleted: this.spawnAnimation()
        }
    }
}
