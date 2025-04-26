pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland

Scope {
    id: root

    required property QsWindow rootWindow
    required property Item parentItem

    property alias active: loader.active
    property string contentUrl
    property Component contentItem
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
    function toggle(): void {
        if (loader.active) {
            root.close();
        } else {
            root.open();
        }
    }
    LazyLoader {
        id: loader
        PopupWindow {
            id: popup

            anchor {
                window: root.rootWindow
                rect.x: {
                    const hl_width = root.popupWidth / 2;
                    const pre_calc_x = (root.xcoords) - (root.popupWidth / 2) + root.offsetX;
                    const xmargins = 15;
                    if (root.xcoords < root.rootWindow.width / 2) {
                        if (root.xcoords < hl_width) {
                            return xmargins;
                        } else {
                            return pre_calc_x;
                        }
                    } else {
                        const remaining = root.rootWindow.width - root.xcoords;
                        if (remaining > hl_width) {
                            return pre_calc_x;
                        } else {
                            const rectx = root.rootWindow.width - root.popupWidth - xmargins;
                            return rectx;
                        }
                    }
                }
                rect.y: -((popup.height) + 5)
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
                //source: root.contentUrl
                //sourceComponent: root.contentItem
                layer.enabled: true
                focus: true
                Keys.onEscapePressed: popup.hideAnimation()
                Keys.forwardTo: [popupBody.item]
                Component.onCompleted: {
                    if (root.contentUrl) {
                        popupBody.setSource(root.contentUrl);
                    } else {
                        popupBody.sourceComponent = root.contentItem;
                    }
                }
            }
            Connections {
                target: popupBody.item
                function onClosePopup(): void {
                    popup.hideAnimation()
                }
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
                popupBody.focus = false;
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
