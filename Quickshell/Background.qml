import Quickshell
import QtQuick
import Quickshell.Wayland

PanelWindow {
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "background"
    required property ShellScreen screen;
    anchors {
        top: true
        bottom: true
        right: true
        left: true
    }
    color: "transparent"
    mask: Region {}

    Image {
        source: Config.backgroundImage
        fillMode: Image.PreserveAspectCrop
        smooth: false
        // Planned for smoothing animation when transition between different wallpapers
        retainWhileLoading: true
        cache: false
        anchors.fill: parent
    }

    Text {
        anchors.centerIn: parent
        text: Config.hours.replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]) + ":" + Config.minutes.replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d])
        renderType: Text.NativeRendering
        font {
            family: Config.font
            pointSize: 128
        }
        lineHeight: 0.7
        color: Config.colors.text
    }
}
