import Quickshell
import Quickshell.Wayland
import "root:Services"
import ".."
import QtQuick
Scope {
    id: root

    property real sliderValue;
    property string iconSource;
    property string osdTexts;
    property bool barVisibility: true;
    LazyLoader {
        id: loader
        activeAsync: false

        PanelWindow {
            id: osdLayer

            anchors {
                top: true
            }
            margins {
                top: 5
            }
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "qs::osd"
            width: 250
            height: 50
            mask: Region {}
            color: "transparent"

            OsdBody {
                id: body
                osdIcon: iconSource
                osdText: osdTexts
                barValue: sliderValue
                isBarVisible: barVisibility
            }
        }
    }

    Connections {
        target: IPC

        function onOsdMessage(bodyText,iconPath) {
                iconSource = Quickshell.iconPath(iconPath)
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
        interval: 2000
        running: false
        onTriggered: loader.active = false
    }

    function loadOsd() {
        loader.activeAsync = true
        osdTimer.restart();
    }

}
