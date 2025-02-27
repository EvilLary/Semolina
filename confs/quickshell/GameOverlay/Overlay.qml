pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import "../Libs"
import Quickshell.Io
import Quickshell.Hyprland
import '../Bar/Indicators'
import '../Bar/Mpris'

Singleton {
    id: root

    property bool gsrBuffer
    property bool gsrRecording
    property bool gameModeStatus

    property QtObject gameInfo: QtObject {
        property bool isGame: false
        //property string id
        //property string title
        property string gameLogo
        property string playtime
    }


    property string cmdArgument

    function hola() {}
    GlobalShortcut {
        name: "gameoverlay"
        description: "idk"
        onPressed: {
            if (Toplevels.activeWindow?.appId?.startsWith("steam_app_")) {
                const id = Toplevels.activeWindow.appId.slice(10,)
                if (id != 0) {
                    playtime.running = true
                    //root.gameInfo.id = id
                    //root.gameInfo.title = Toplevels.activeWindow.title
                    root.gameInfo.isGame = true
                    root.gameInfo.gameLogo = `${Quickshell.env("HOME")}/.local/share/Steam/appcache/librarycache/${id}/logo`
                }
            } else {
                root.gameInfo.isGame = false
            }
            NotificationProvider.isDashboardOpen = true
            root.refreshStats()
            loader.activeAsync = true
        }
    }
    Process {
        id: gameModeStatus
        command: ['sh','-c','hyprctl getoption animations:enabled -j | jq .int']
        stdout: SplitParser {
            onRead: data => {
                root.gameModeStatus = !(data == 1)
            }
        }
    }
    Process {
        id: gsrStatus
        command: ['gsr', 'status']
        stdout: SplitParser {
            onRead: data => {
                const status = JSON.parse(data)
                root.gsrBuffer = status.buffer
                root.gsrRecording = status.recording
            }
        }
    }
    Process {
        id: playtime
        command: ['sh','-c','ps -o etime= -p $(hyprctl activewindow -j | jq .pid)']
        stdout: SplitParser {
            onRead: data => {
                const time = data.trim().split(':')
                let hours
                let minutes
                if (time.length == 2) {
                    hours = 0
                    minutes = time[0]
                } else {
                    hours = time[0]
                    minutes = time [1]
                }
                if (hours == 0) {
                    if (minutes == '00') {
                        root.gameInfo.playtime = 'less than a minute'
                    } else {
                        root.gameInfo.playtime = minutes + ' minutes'
                    }
                } else {
                    if (hours == '01') {
                        root.gameInfo.playtime = 'One hour and ' + minutes + ' minutes'
                    }
                    else {
                        root.gameInfo.playtime = hours + ' hours and ' + minutes + ' minutes'
                    }
                }
            }
        }
    }
    Process {
        id: cmd
        command: ['sh','-c',`${root.cmdArgument}`]
        manageLifetime: false
        onExited: (code,status) => {
            root.cmdArgument = ""
            root.refreshStats()
        }
    }
    function refreshStats(): void {
        gsrStatus.running = true
        gameModeStatus.running = true
    }

    LazyLoader {
        id: loader
        onActiveChanged: if(!this.active) NotificationProvider.isDashboardOpen = false

        WlrLayershell {
            id: layer

            layer: WlrLayer.Overlay
            keyboardFocus: WlrKeyboardFocus.OnDemand
            namespace: "shell"

            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            color: Qt.alpha("black",0.3)
            HyprlandFocusGrab {
                id: grab;
                active: true;
                windows: [ layer ];
                // onCleared: loader.active = false
            }
            MouseArea {
                anchors.fill: parent
                onClicked:  {
                    loader.active = false
                }
                propagateComposedEvents: false
            }

            ActionRow {
                id: actions
                anchors {
                    left: parent.left
                    leftMargin: 20
                    bottomMargin: 20
                    bottom: notificationList.top
                }
                height: 164
                width: 500
                focus: true
                Keys.onEscapePressed: loader.active = false
                border {
                    width: 1
                    color: Qt.alpha(Config.colors.text,0.2)
                }
            }
            Loader {
                active: root.gameInfo.isGame
                anchors {
                    left: parent.left
                    leftMargin: 20
                    bottomMargin: 20
                    bottom: actions.top
                }
                sourceComponent: GameInfo {}
            }
            NotificationList {
                id: notificationList
                anchors {
                    left: parent.left
                    bottom: parent.bottom
                    leftMargin: 20
                    bottomMargin: 60
                }
                width: 500
                height: 550
            }
            Mixer {
                id: mixer
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: 60
                    rightMargin: 20
                }
                width: 500
                height: 500
            }
            Loader {
                active: MprisProvider.trackedPlayer != null
                anchors {
                    right: parent.right
                    bottom: mixer.top
                    bottomMargin: 20
                    rightMargin: 20
                }
                sourceComponent: MprisWidget {}
            }
        }
    }
}
