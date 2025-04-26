pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import "../Libs"
import Quickshell.Io
import QtQuick

Scope {
    id: root

    property real sliderValue;
    property string iconSource;
    property string osdTexts;
    property bool barVisibility: true;

    IpcHandler {
        target: "ipc"
        function osdmsg(bodyText: string, iconPath: string): void {
            root.iconSource = iconPath
            root.osdTexts = bodyText
            root.barVisibility = false
            root.loadOsd()
        }
    }
    LazyLoader {
        id: loader
        active: false
        WlrLayershell {
            id: osdLayer

            anchors {
                top: true
            }
            margins {
                top: 15
            }
            layer: WlrLayer.Overlay
            keyboardFocus: WlrKeyboardFocus.None
            namespace: "shell"
            exclusionMode: ExclusionMode.Normal
            width: 250
            height: 50
            mask: Region {}
            color: "transparent"

            OsdBody {
                id: body
                osdIcon: root.iconSource
                osdText: root.osdTexts
                barValue: root.sliderValue
                isBarVisible: root.barVisibility
            }
        }
    }

    Connections {
        target: IPC
        enabled: true
        ignoreUnknownSignals: true
        function onOsdMessage(bodyText,iconPath) {
            root.iconSource = iconPath
            root.osdTexts = bodyText
            root.barVisibility = false
            root.loadOsd()
        }
    }
    Connections {
        enabled: true
        target: PipewireNodes
        ignoreUnknownSignals: true

        function onShowOsd(icon,value,text,sliderVisible) {
            root.barVisibility = sliderVisible
            root.osdTexts = text
            root.sliderValue = value
            root.iconSource = icon
            root.loadOsd()
        }
    }
    Timer {
        id: osdTimer
        repeat: false
        interval: 1800
        running: false
        onTriggered: loader.active = false
    }

    function loadOsd() {
        loader.active = true
        osdTimer.restart();
    }
}
