pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: ipc

    signal osdMessage(bodyText: string,iconPath: string)
    signal clipboardToggle()
    signal overlayShortcut()
    signal switcherShortcut()
    //signal launcherToggle()
    signal emojierToggle()

    property QtObject screencast: QtObject {
        property bool status: false
        property bool fullscreen: false
    }

    signal stop()
    signal start()
    IpcHandler {
        target: "screenshot"
        function stop(): void {
            ipc.stop()
        }
        function start(): void {
            ipc.start()
        }
    }
    IpcHandler {
        target: "ipc"
        function osdmsg(bodytext: string, iconpath: string): void {
            ipc.osdMessage(bodytext,iconpath)
        }
    }

    GlobalShortcut {
        name: "emojier"
        description: "Show emojier"
        onPressed: ipc.emojierToggle()
    }
    GlobalShortcut {
        name: "clipboard"
        description: "Show clipboard"
        onPressed: ipc.clipboardToggle()
    }
    GlobalShortcut {
        name: "windowswitcher"
        description: "Switch between windows"
        onPressed: ipc.switcherShortcut()
    }
    //GlobalShortcut {
    //    name: "launcher"
    //    description: "Application Launcher"
    //    onPressed: ipc.launcherToggle()
    //}

    //Volume controls
    Timer {
        id: timer
        interval: 75
        repeat: false
        function setTimeout(target) {
            timer.triggered.connect(target);
            timer.triggered.connect(function release () {
                timer.triggered.disconnect(target);
                timer.triggered.disconnect(release);
            });
            timer.start();
        }
    }
    GlobalShortcut {
        name: "toggleMuteSource"
        onPressed: PipewireNodes.toggleMute("source")
    }
    GlobalShortcut {
        id: dcSourceVol
        name: "decreaseSourceVolume"
        onPressed: dcSourceVol.event()
        function event(): void {
            PipewireNodes.decreaseVolume("source")
            timer.setTimeout(function() {
                if (dcSourceVol.pressed) dcSourceVol.event()
            })
        }
    }
    GlobalShortcut {
        id: inSourceVol
        name: "increaseSourceVolume"
        onPressed: inSourceVol.event()
        function event(): void {
            PipewireNodes.increaseVolume("source")
            timer.setTimeout(function() {
                if (inSourceVol.pressed) inSourceVol.event()
            })
        }
    }

    GlobalShortcut {
        name: "toggleMuteSink"
        description: "fdf"
        onPressed: PipewireNodes.toggleMute("sink")
    }
    GlobalShortcut {
        id: dcSinkVol
        name: "decreaseSinkVolume"
        onPressed: dcSinkVol.event()
        function event(): void {
            PipewireNodes.decreaseVolume("sink")
            timer.setTimeout(function() {
                if (dcSinkVol.pressed) dcSinkVol.event()
            })
        }
    }
    GlobalShortcut {
        id: inSinkVol
        name: "increaseSinkVolume"
        onPressed: inSinkVol.event()
        function event(): void {
            PipewireNodes.increaseVolume("sink")
            timer.setTimeout(function() {
                if (inSinkVol.pressed) inSinkVol.event()
            })
        }
    }
    Connections {
        target: Hyprland
        enabled: true
        function onRawEvent(event) {
            let eventName = event.name;
            switch (eventName) {
                case "activelayout": {
                    let eventData = event.data;
                    const layout = eventData.split(",")[1];
                    //osdMessage(layout,"config-language")
                    osdMessage(layout,"")
                    break;
                }
                case "screencast": {
                    // window sharing = 1, screen sharing = 0
                    // status = 1 is on, 0 is off
                    let eventData = event.data;
                    const [status,window] = eventData.split(",")
                    ipc.screencast.status = (status == 1)
                    ipc.screencast.fullscreen = (window == 0)
                    break;
                }
            }
        }
    }
}
