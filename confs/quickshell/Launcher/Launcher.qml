pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "../"
import "../Components"
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: root

    GlobalShortcut {
        name: "launcher"
        description: "Application Launcher"
        onPressed: loader.activeAsync = !loader.active
    }
    property string appId
    function toggle() {
        loader.activeAsync = !loader.active;
    }
    function hola() {
    }
    LazyLoader {
        id: loader
        WlrLayershell {
            id: layer
            layer: WlrLayer.Top
            namespace: "shell"
            keyboardFocus: WlrKeyboardFocus.OnDemand
            exclusionMode: ExclusionMode.Ignore

            //HyprlandFocusGrab {
            //    id: grab;
            //    active: true;
            //    windows: [ layer ];
            //    // onCleared: loader.active = false
            //}

            color: "transparent"

            Process {
                id: runner
                command: ["uwsmapp.sh", root.appId]
                running: false
                onExited: loader.active = false
            }
            function launch(appId: string): void {
                root.appId = appId + '.desktop';
                // print(root.appId);
                runner.startDetached();
                //runner.running = true
                loader.active = false;
            }
            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: loader.active = false
            }
            Rectangle {
                id: rect
                anchors.centerIn: parent
                radius: Config.globalRadius
                width: 600
                height: 650
                color: Config.colors.background
                layer.enabled: true
                border {
                    width: 1
                    color: Qt.alpha(Config.colors.text, 0.2)
                }
                TextField {
                    id: searchBar
                    placeholderText: "تطبيقات..."
                    leftPadding: 56
                    height: 58
                    anchors {
                        top: parent.top
                        right: parent.right
                        left: parent.left
                        margins: 8
                    }
                    color: Config.colors.text
                    focus: true
                    Keys.onEscapePressed: loader.active = false
                    Keys.onPressed: event => {
                        switch (event.key) {
                        case (Qt.Key_Backtab):
                            {
                                entries.decrementCurrentIndex();
                                break;
                            }
                            ;
                            ;
                        case (Qt.Key_Tab):
                            {
                                entries.incrementCurrentIndex();
                                break;
                            }
                        }
                    }
                    onAccepted: {
                        //print(entries.currentItem.modelData.id)
                        // print(entry)
                        layer.launch(entries.currentItem.modelData.id);
                        //entries.currentItem.modelData.execute()
                    }
                    renderType: Text.NativeRendering
                    onTextChanged: entries.currentIndex = 0
                    font {
                        weight: Font.Bold
                        pointSize: 14
                        hintingPreference: Font.PreferNoHinting
                    }
                    background: Rectangle {
                        color: Qt.alpha(Config.colors.altBackground, 0.9)
                        border {
                            width: 2
                            color: Qt.alpha(Config.colors.accent, 0.6)
                        }
                        radius: Config.globalRadius
                        Image {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 8
                            }
                            smooth: false
                            // asynchronous: true
                            sourceSize {
                                width: 45
                                height: 45
                            }
                            source: 'image://icon/search-icon'
                        }
                    }
                }

                Rectangle {
                    id: mainView
                    anchors {
                        bottom: parent.bottom
                        top: searchBar.bottom
                        right: parent.right
                        left: parent.left
                        margins: 8
                    }
                    color: Config.colors.altBackground
                    radius: Config.globalRadius
                    clip: true
                    ListView {
                        id: entries
                        anchors {
                            margins: 8
                            fill: parent
                        }
                        cacheBuffer: 0
                        spacing: 8
                        highlightMoveDuration: 0
                        highlightResizeDuration: 0
                        keyNavigationWraps: true
                        model: ScriptModel {
                            values: DesktopEntries.applications.values.filter(entry => {
                                return searchBar.text.length === 0 || entry.name.toLowerCase().includes(searchBar.text.toLowerCase());
                            }).sort((a, b) => {
                                const ab_diff = a.name.localeCompare(b.name);
                                if (searchBar.text.length == 0) {
                                    return ab_diff;
                                }
                                const acheck = a.name.toLowerCase().startsWith(searchBar.text.toLowerCase());
                                const bcheck = b.name.toLowerCase().startsWith(searchBar.text.toLowerCase());
                                if (acheck && bcheck) {
                                    return ab_diff;
                                } else if (acheck) {
                                    return -1;
                                } else if (bcheck) {
                                    return 1;
                                }
                                return ab_diff;
                            })
                            onValuesChanged: entries.currentIndex = 0
                        }
                        add: Transition {
                            NumberAnimation {
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: 100
                            }
                        }

                        displaced: Transition {
                            NumberAnimation {
                                property: "y"
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                            NumberAnimation {
                                property: "opacity"
                                to: 1
                                duration: 100
                            }
                        }

                        move: Transition {
                            NumberAnimation {
                                property: "y"
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                            NumberAnimation {
                                property: "opacity"
                                to: 1
                                duration: 100
                            }
                        }

                        remove: Transition {
                            NumberAnimation {
                                property: "y"
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                            NumberAnimation {
                                property: "opacity"
                                to: 0
                                duration: 100
                            }
                        }
                        highlight: HighlightDelegate {}
                        delegate: Rectangle {
                            id: app
                            required property var modelData
                            required property int index
                            width: 568
                            height: 60
                            radius: Config.globalRadius
                            color: "transparent"
                            MouseArea {
                                id: entryArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    launch(entries.currentItem.modelData.id);
                                }
                                onEntered: entries.currentIndex = app.index
                            }
                            ColumnLayout {
                                anchors {
                                    left: entryIcon.right
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: 10
                                }
                                spacing: 0
                                Text {
                                    id: entryName
                                    text: app.modelData.name
                                    color: Config.colors.text
                                    font {
                                        weight: Font.Bold
                                        pointSize: 13
                                    }
                                }
                                Text {
                                    id: entryDescription
                                    text: app.modelData.genericName || app.modelData.id
                                    color: Config.colors.text
                                    font {
                                        weight: Font.Medium
                                        pointSize: 10
                                    }
                                }
                            }
                            Image {
                                id: entryIcon
                                source: Quickshell.iconPath(app.modelData.icon, "application-x-desktop")
                                sourceSize {
                                    width: 48
                                    height: 48
                                }
                                // asynchronous: true
                                anchors {
                                    left: parent.left
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: 10
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
