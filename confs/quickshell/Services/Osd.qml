pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Config"

Singleton {
    id: root

    property real sliderValue
    property string iconSource
    property string osdTexts
    property bool barVisibility: true
    //
    property LazyLoader loader: LazyLoader {
        id: loader
        active: false
        WlrLayershell {
            id: osdLayer

            anchors {
                top: true
            }
            margins {
                top: 5
            }
            layer: WlrLayer.Overlay
            keyboardFocus: WlrKeyboardFocus.None
            namespace: "qsosd"
            exclusionMode: ExclusionMode.Normal
            implicitWidth: body.width
            implicitHeight: 50
            mask: Region {}
            // surfaceFormat.opaque: true
            HyprlandWindow.visibleMask: Region {
                item: body
            }
            color: "transparent"

            Rectangle {
                id: body
                height: parent.height
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                property var osdValue: root.osdTexts
                property string icon: root.iconSource
                property bool showingProgress: root.barVisibility
                width: row.width
                antialiasing: true
                radius: 35
                border {
                    width: 1
                    color: Colors.light
                }
                color: Colors.base
                RowLayout {
                    id: row
                    anchors {
                        centerIn: parent
                    }
                    Layout.preferredWidth: Math.max(Math.min(osdLayer.screen.width / 2, implicitWidth), 300)
                    Layout.preferredHeight: body.height
                    // Layout.preferredHeight: Math.max(iconItem.Layout.preferredHeight, implicitHeight)
                    Layout.minimumWidth: Layout.preferredWidth
                    Layout.minimumHeight: Layout.preferredHeight
                    Layout.maximumWidth: Layout.preferredWidth
                    Layout.maximumHeight: Layout.preferredHeight
                    width: Layout.preferredWidth
                    height: Layout.preferredHeight

                    Rectangle {
                        id: iconItem
                        Layout.leftMargin: 8
                        Layout.preferredWidth: 38
                        Layout.preferredHeight: 38
                        Image {
                            // Layout.alignment: Qt.AlignVCenter
                            anchors.centerIn: parent
                            smooth: false
                            cache: false
                            asynchronous: false
                            source: Quickshell.iconPath(body.icon)
                            sourceSize {
                                width: iconItem.width - 12
                                height: iconItem.height - 12
                            }
                        }
                        radius: this.width / 2
                        // color: body.showingProgress ? Config.colors.background : Config.colors.altBase
                        color: Colors.midlight
                    }

                    Rectangle {
                        id: progressBar
                        visible: body.showingProgress
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10
                        Layout.preferredHeight: 5
                        Layout.fillWidth: true
                        radius: 2
                        antialiasing: false
                        color: Colors.altBase
                        Rectangle {
                            height: parent.height
                            implicitWidth: Math.max(parent.width * body.osdValue, 1)
                            radius: progressBar.radius
                            antialiasing: false
                            color: Colors.accent
                            Behavior on implicitWidth {
                                NumberAnimation {
                                    duration: 75
                                }
                            }
                            Rectangle {
                                width: 18
                                height: 18
                                visible: true
                                x: (progressBar.width - 18) * body.osdValue
                                y: progressBar.height / 2 - 9
                                antialiasing: true
                                Behavior on x {
                                    NumberAnimation {
                                        duration: 75
                                    }
                                }
                                radius: this.width / 2
                                color: Colors.midlight
                                border {
                                    width: 1
                                    color: Colors.accent
                                }
                            }
                        }
                    }
                    Text {
                        id: label
                        visible: !body.showingProgress
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: iconItem.width + 8
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        textFormat: Text.PlainText
                        wrapMode: Text.NoWrap
                        elide: Text.ElideRight
                        text: body.osdValue
                        color: Colors.text
                        renderType: Text.NativeRendering
                        font {
                            // pointSize: 11
                            pixelSize: 14
                            weight: Font.DemiBold
                        }
                    }
                    Rectangle {
                        visible: body.showingProgress
                        Layout.rightMargin: 8
                        Layout.preferredHeight: 38
                        Layout.preferredWidth: 38
                        Layout.alignment: Qt.AlignVCenter

                        radius: this.width / 2
                        color: Colors.midlight
                        Text {
                            id: percentLabel
                            anchors.centerIn: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            renderType: Text.NativeRendering
                            textFormat: Text.PlainText
                            wrapMode: Text.NoWrap
                            text: Math.round(body.osdValue * 100).toString().replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d])
                            color: Colors.text
                            font {
                                pointSize: 11
                                weight: Font.DemiBold
                            }
                        }
                    }
                }
            }
        }
    }

    readonly property Connections hyprEvents: Connections {
        target: Hyprland
        enabled: true
        function onRawEvent(event) {
            switch (event.name) {
            case "activelayout":
                {
                    const [device, layout] = event.data.split(',');
                    if (device === "hl-virtual-keyboard") {
                        break;
                    }
                    const layout_ar = function (lang) {
                        switch (lang) {
                        case "Arabic (Eastern Arabic numerals)":
                            return ["عربي (أرقام شرقية)", "ض"];
                        case "Arabic":
                            return ["عربي", "ض"];
                        case "English (US)":
                            return ["إنجليزي (أمريكي)", "US"];
                        case "English (UK)":
                            return ["إنجليزي (انجلترا)", "UK"];
                        default:
                            return [lang, lang];
                        }
                    };
                    const [longform, shortform] = layout_ar(layout);
                    Misc.currentLayout.longform = longform;
                    Misc.currentLayout.shortform = shortform;
                    root.osdmsg("set-language-symbolic", longform, false);
                }
                break;
            case "bell":
            {
                root.osdmsg("preferences-desktop-notification-bell","System Bell", false);
            }
            break;
            // case "submap":
            //     {
            //         if (event.data.length === 0) {
            //             root.osdmsg("accessories-character-map", "Default Submap", false);
            //         } else {
            //             root.osdmsg("accessories-character-map", `${event.data} Submap`, false);
            //         }
            //     }
            //     break;
            // case "screencast": {
            //    // window sharing = 1, screen sharing = 0
            //    // status = 1 is on, 0 is off
            //    let eventData = event.data;
            //    const [status,window] = eventData.split(",")
            //    // ipc.screencast.status = (status == 1)
            //    // ipc.screencast.fullscreen = (window == 0)
            //    break;
            // }
            }
        }
    }
    function osdmsg(icon: string, body: string, bar: bool): void {
        root.iconSource = icon;
        root.osdTexts = body;
        root.barVisibility = bar;
        root.loadOsd();
    }

    property IpcHandler osdIpc: IpcHandler {
        target: "osd"
        function osdmsg(bodyText: string, iconPath: string): void {
            root.iconSource = iconPath;
            root.osdTexts = bodyText;
            root.barVisibility = false;
            root.loadOsd();
        }
    }

    readonly property Timer osdTimer: Timer {
        id: osdTimer
        repeat: false
        interval: 1800
        running: false
        onTriggered: loader.active = false
    }
    function loadOsd() {
        // return;
        loader.active = true;
        osdTimer.restart();
    }
    function init(): void {
    }
}
