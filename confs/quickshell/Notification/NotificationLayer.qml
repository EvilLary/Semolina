pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../Libs"
import Quickshell.Wayland

Scope {
    id: root

    Connections {
        target: NotificationProvider
        function onNotification(notification) {
            root.toasts.unshift(notification);
        }
    }

    //ListModel {
    //    id: toasts
    //    dynamicRoles: true
    //}
    property list<var> toasts: []
    LazyLoader {
        active: root.toasts.length > 0

        PanelWindow {
            id: notificationLayer

            WlrLayershell.namespace: "notifications"
            WlrLayershell.layer: WlrLayer.Top
            exclusiveZone: 0
            color: "transparent"
            //screen: Quickshell.screens.filter(screen => screen.name == Config.activeMonitor)[0];
            screen: Quickshell.screens[0]
            anchors {
                top: true
                right: true
                bottom: true
            }
            mask: Region {
                //item: list
                height: list.contentHeight
                width: list.width
            }
            margins {
                right: 15
                top: 15
                bottom: 8
            }
            width: 350
            ListView {
                id: list
                model: ScriptModel {
                    values: root.toasts
                }
                anchors.fill: parent
                spacing: 10
                readonly property int duration: 175
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
                            duration: list.duration
                        }
                        NumberAnimation {
                            properties: "x"
                            to: 250
                            duration: list.duration
                        }
                    }
                }
                removeDisplaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: list.duration
                    }
                }
                populate: Transition {
                    ParallelAnimation {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: list.duration
                        }
                        NumberAnimation {
                            properties: "x"
                            from: 250
                            duration: list.duration
                        }
                    }
                }
                move: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: list.duration
                    }
                }
                moveDisplaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: list.duration
                    }
                }
                delegate: NotificationBody {
                    id: rect
                    required property int index
                    isToast: true
                    width: 350
                    onExpired: root.toasts.splice(rect.index, 1)
                    Connections {
                        target: rect.modelData
                        function onClosed() {
                            root.toasts.splice(rect.index, 1);
                        }
                    }
                    // Component.onCompleted: print(this.height)
                }
            }
        }
    }
}
