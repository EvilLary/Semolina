pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import "../Libs"
import "../Components"
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    GlobalShortcut {
        name: "launcher"
        description: "Application Launcher"
        onPressed: loader.activeAsync = !loader.active
    }
    property string appId;
    function toggle() {
        loader.activeAsync = !loader.active
    }
    function hola() {}
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
                command: ["uwsmapp.sh",root.appId];
                manageLifetime: false
                running: false
                onExited: loader.active = false
            }
            function launch(appId: string): void {
                root.appId = appId + '.desktop'
                runner.running = true
                loader.active = false
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
                    color: Qt.alpha(Config.colors.text,0.2)
                }
                TextField {
                    id: searchBar
                    placeholderText: "Applications..."
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
                            case (Qt.Key_Backtab): {
                                entries.decrementCurrentIndex();
                                break;
                            }
                            ;;
                            case (Qt.Key_Tab): {
                                entries.incrementCurrentIndex();
                                break;
                            }
                        }
                    }
                    onAccepted: {
                        //print(entries.currentItem.modelData.id)
                        launch(entries.currentItem.modelData.id);
                        //entries.currentItem.modelData.execute()
                    }
                    renderType: Text.NativeRendering
                    font {
                        weight: Font.Bold
                        pointSize: 14
                        hintingPreference: Font.PreferNoHinting
                    }
                    background: Rectangle {
                        color: Qt.alpha(Config.colors.accent,0.9)
                        radius: Config.globalRadius
                        Image {
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 8
                            }
                            smooth: false
                            asynchronous: true
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
                        //qs crashes or the list produces a weird list without this property set to zero
                        cacheBuffer: 0

                        spacing: 8
                        highlightMoveDuration : 125
                        keyNavigationWraps: true

                        //Shamelessly stolen from outfoxxed
                        model: ScriptModel {
                            values: DesktopEntries.applications.values
                            .map(object => {
                                const stxt = searchBar.text.toLowerCase();
                                const ntxt = object.name.toLowerCase();
                                let si = 0;
                                let ni = 0;

                                let matches = [];
                                let startMatch = -1;

                                for (let si = 0; si != stxt.length; ++si) {
                                    const sc = stxt[si];

                                    while (true) {
                                        // Drop any entries with letters that don't exist in order
                                        if (ni == ntxt.length) return null;

                                        const nc = ntxt[ni++];

                                        if (nc == sc) {
                                            if (startMatch == -1) startMatch = ni;
                                            break;
                                        } else {
                                            if (startMatch != -1) {
                                                matches.push({
                                                    index: startMatch,
                                                    length: ni - startMatch,
                                                });

                                                startMatch = -1;
                                            }
                                        }
                                    }
                                }

                                if (startMatch != -1) {
                                    matches.push({
                                        index: startMatch,
                                        length: ni - startMatch + 1,
                                    });
                                }

                                return {
                                    object: object,
                                    matches: matches,
                                };
                            })
                            .filter(entry => entry !== null)
                            .sort((a, b) => {
                                let ai = 0;
                                let bi = 0;
                                let s = 0;

                                while (ai != a.matches.length && bi != b.matches.length) {
                                    const am = a.matches[ai];
                                    const bm = b.matches[bi];

                                    s = bm.length - am.length;
                                    if (s != 0) return s;

                                    s = am.index - bm.index;
                                    if (s != 0) return s;

                                    ++ai;
                                    ++bi;
                                }

                                s = a.matches.length - b.matches.length;
                                if (s != 0) return s;
                                return a.object.name.length - b.object.name.length;
                            })
                            .map(entry => entry.object);

                            onValuesChanged: entries.currentIndex = 0
                        }

                        add: Transition {
                            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 }
                        }

                        displaced: Transition {
                            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
                            NumberAnimation { property: "opacity"; to: 1; duration: 100 }
                        }

                        move: Transition {
                            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
                            NumberAnimation { property: "opacity"; to: 1; duration: 100 }
                        }

                        remove: Transition {
                            NumberAnimation { property: "y"; duration: 200; easing.type: Easing.OutCubic }
                            NumberAnimation { property: "opacity"; to: 0; duration: 100 }
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
                            Column {
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
                                source: Quickshell.iconPath(app.modelData.icon,true)
                                sourceSize {
                                    width: 48
                                    height: 48
                                }
                                asynchronous: true
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
