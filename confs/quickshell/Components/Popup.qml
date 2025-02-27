pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland

Scope {
    id: root

    required property QsWindow rootWindow
    required property Item parentItem
    property string contentUrl

    property Item contentItem
    //property bool sideSlide: false
    property int popupWidth: 450
    property int popupHeight: 300
    property int xcoords
    property int ycoords
    property int offsetX: 0
    property int offsetY: 0

    readonly property alias isOpen: loader.active
    signal close
    signal closed

    function open(): void {
        const coords = rootWindow.contentItem.mapFromItem(parentItem, 0, 0);
        root.xcoords = coords.x;
        root.ycoords = coords.y;
        loader.active = true;
    }

    LazyLoader {
        id: loader
        PopupWindow {
            id: popup

            anchor {
                window: root.rootWindow
                rect.x: 0
                rect.y: 0
                onAnchoring: {
                    //yeah..
                    popup.anchor.rect.y = root.ycoords - (popup.height) - 15;
                    popup.anchor.rect.x = (root.xcoords) - (popupWidth / 2) + root.offsetX;
                }
                //gravity: Edges.Top | Edges.Right
                //edges: Edges.Bottom | Edges.Right
            }

            //surfaceFormat {
            //    opaque: true
            //}
            width: root.popupWidth
            height: root.popupHeight
            visible: true
            color: "transparent"
            HyprlandWindow.opacity: 0

            Connections {
                target: root
                enabled: true
                ignoreUnknownSignals: true
                function onClose(): void {
                    popup.hideAnimation();
                }
            }
            HyprlandFocusGrab {
                id: grap
                windows: [popup]
                onCleared: popup.hideAnimation()
            }
            Loader {
                id: popupBody
                anchors.fill: parent
                source: root.contentUrl
                layer.enabled: true
                focus: true
                Keys.onEscapePressed: popup.hideAnimation()
                Keys.forwardTo: popupBody.children
            }
            NumberAnimation {
                id: opacityAnimator
                target: popup
                property: "HyprlandWindow.opacity"
                duration: 150
                easing.type: Easing.Linear
                onFinished: {
                    if (popup.HyprlandWindow.opacity == 0) {
                        root.closed();
                        loader.active = false;
                    }
                }
            }
            function spawnAnimation(): void {
                opacityAnimator.from = 0;
                opacityAnimator.to = 1;
                opacityAnimator.restart();
                grap.active = true;
            }
            function hideAnimation(): void {
                opacityAnimator.from = 1;
                opacityAnimator.to = 0;
                opacityAnimator.restart();
                grap.active = false;
            }
            Component.onCompleted: {
                popup.spawnAnimation();
            }
        }
    }
}
