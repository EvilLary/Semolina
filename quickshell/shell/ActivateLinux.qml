import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland


PanelWindow {
    id: root

    // property var modelData
    // screen: modelData

    anchors {
        left: true
        bottom: true
    }

    margins {
        left: 50
        bottom: 50
    }

    width: content.width
    height: content.height

    color: "transparent"

    // Give the window an empty click mask so all clicks pass through it.
    mask: Region {}

    // Use the wlroots specific layer property to ensure it displays over
    // fullscreen windows.
    WlrLayershell.layer: WlrLayer.Overlay

    ColumnLayout {
        id: content

        Text {
            text: "Activate Linux"
            color: "#50ffffff"
            font.pointSize: 18
        }

        Text {
            text: "Go to Settings to activate Linux"
            color: "#50ffffff"
            font.pointSize: 12
        }
    }
}
