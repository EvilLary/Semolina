pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import "root:Services"
import QtQuick
import "root:."
Scope {
    id: root

    property real sliderValue;
    property string iconSource;
    property string osdTexts;
    property bool barVisibility: true;

    LazyLoader {
        id: loader

        PanelWindow {
            id: osdLayer

            anchors {
                top: true
            }
            margins {
                top: 5
            }
            screen: Quickshell.screens.filter(screen => screen.name == Config.activeMonitor)[0];
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs::osd"
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

        function onOsdMessage(bodyText,iconPath) {
                iconSource = `image://icon/${iconPath}`
                osdTexts = bodyText
                barVisibility = false
                loadOsd()
        }
    }
    Connections {
        target: PipewireNodes

        function onSourceVolumeChanged() {
            sliderValue = PipewireNodes.sourceVolume
            iconSource = PipewireNodes.sourceIcon
            osdTexts =  Math.trunc(PipewireNodes.sourceVolume * 100)
            barVisibility = true
            loadOsd()
        }
        function onSinkVolumeChanged() {
            sliderValue = PipewireNodes.sinkVolume
            iconSource = PipewireNodes.sinkIcon
            osdTexts = Math.trunc(PipewireNodes.sinkVolume * 100)
            barVisibility = true
            loadOsd()
        }
    }

    Timer {
        id: osdTimer
        repeat: false
        interval: 1800
        running: false
        onTriggered: loader.active = false
    }

    // function test() {
    //     sliderValue = PipewireNodes.sinkVolume
    //     iconSource = PipewireNodes.sinkIcon
    //     if (PipewireNodes.sinkMute) {
    //         osdTexts = "Muted"
    //         barVisibility = false
    //         loadOsd();
    //         return;
    //     }
    //     osdText = Match.trunc(PipewireNodes.sinkVolume)
    // }
    function loadOsd() {
        loader.activeAsync = true
        osdTimer.restart();
    }
}
