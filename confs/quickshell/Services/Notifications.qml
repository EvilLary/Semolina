pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell
import QtQuick
import "../Components"
// import QtQuick.Controls
// import "../Services"

Singleton {
    id: root
    // Connections {
    //     target: NotificationServer
    //     enabled: true
    //     function onNotification(object): void {
    //         print("layer recieved");
    //         root.toasts.push(object);
    //     }
    // }
    property list<var> toasts: []
    property alias list: server.trackedNotifications
    property bool dnd: false
    property bool dashboardOpen: false

    function init(): void {
    }
    NotificationServer {
        id: server
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        persistenceSupported: true
        // extraHints: ["action-icons","urgency","image-path","desktop-entry","inline-reply"]
        onNotification: notification => {
            // must track for notification actions to work
            // not setting this to true, would basicably crash qs if we try 
            // to remove said notification from a list
            notification.tracked = true;
            if (!root.dnd && !root.dashboardOpen) {
                root.toasts.unshift(notification);
                // root.notification(notification);
                // print("notification sent");
            }
        }
    }
    LazyLoader {
        id: loader
        active: root.toasts.length > 0
        // onActiveChanged: print(this.active);
        WlrLayershell {
            keyboardFocus: WlrKeyboardFocus.None
            layer: WlrLayer.Top
            namespace: "qs:notification"
            exclusionMode: ExclusionMode.Normal
            anchors.top: true
            anchors.right: true
            margins.top: 6
            margins.right: 6
            implicitWidth: 350
            implicitHeight: 800
            color: "transparent"
            mask: Region {
                id: mask
                height: listView.contentHeight
                width: 350
            }
            HyprlandWindow.visibleMask: mask
            // surfaceFormat.opaque: true

            ListView {
                id: listView
                cacheBuffer: 0
                anchors.fill: parent
                // model: root.toasts.reverse()
                model: ScriptModel {
                    values: root.toasts
                }
                spacing: 6

                readonly property int duration: 175
                delegate: NotificationPopup {
                    id: popup
                    required property Notification modelData
                    required property int index
                    // height: 150
                    width: 350
                    Connections {
                        target: popup.modelData
                        function onClosed(): void {
                            root.toasts.splice(popup.index, 1)
                        }
                    }
                    // Component.onCompleted: print(JSON.stringify(popup.modelData))
                    // Timer {
                    //     running: true
                    //     interval: 4000
                    //     onTriggered: root.toasts.splice(popup.index, 1)
                    // }
                }
                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: 300
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.01
                    }
                }
                add: Transition {
                    NumberAnimation { properties: "x"; from: 250; duration: 200 }
                }
                remove: Transition {
                    ParallelAnimation {
                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: listView.duration
                        }
                        NumberAnimation {
                            properties: "x"
                            to: 250
                            duration: listView.duration
                        }
                    }
                }
                removeDisplaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: listView.duration
                    }
                }
                populate: Transition {
                    ParallelAnimation {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: listView.duration
                        }
                        NumberAnimation {
                            properties: "x"
                            from: 250
                            duration: listView.duration
                        }
                    }
                }
                move: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: listView.duration
                    }
                }
                moveDisplaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: listView.duration
                    }
                }
            }
        }
    }
}
