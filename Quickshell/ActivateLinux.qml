import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland


PanelWindow {
    id: root

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
    mask: Region {}
    WlrLayershell.layer: WlrLayer.Overlay

    ColumnLayout {
        id: content

        Text {
            text: "فعِّل لينكس"
            horizontalAlignment: Text.AlignRight
            Layout.fillWidth: true
            font.weight: Font.Bold
            color: "#50ffffff"
            font.pointSize: 20
        }

        Text {
            text: "اذهب إلى الإعدادات لتفعيل لينكس"
            color: "#50ffffff"
            renderType: Text.NativeRendering
            font.weight: Font.Bold
            font.pointSize: 18
        }
    }
}
