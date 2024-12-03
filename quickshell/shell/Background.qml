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
    mask: Region {}
    Image {
        source: "/home/spicy/Pictures/Wallpapers/Courtside-Sunset.png"
        // source: Qt.resolvedUrl(screen.name == "DP-1" ? "5120x1440.png" : "1920x1080.png")
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        cache: false
        anchors.fill: parent
    }

}
