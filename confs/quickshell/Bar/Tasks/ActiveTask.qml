import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import "../../Libs"
import "../../"

Item {
    id: root
    implicitWidth: Math.min(row.implicitWidth + 20, 300)
    property HyprlandWorkspace activeWorkspace: Hyprland.focusedMonitor?.activeWorkspace ?? null

    clip: true
    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 5
        Image {
            id: appIcon
            Layout.alignment: Qt.AlignVCenter
            source: Qt.resolvedUrl(Toplevels.getToplevelIcon(Toplevels.activeWindow?.appId))
            smooth: false
            asynchronous: false
            fillMode: Image.PreserveAspectCrop
            sourceSize {
                height: 44
                width: 44
            }
        }
        ColumnLayout {
            id: column
            Layout.fillHeight: true
            spacing: 0
            Text {
                Layout.fillWidth: true
                text: (Toplevels.activeWindow != null) ? (Toplevels.activeWindow.title || Toplevels.activeWindow.appId) : "Quickshell"
                color: Config.colors.text
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                font {
                    pointSize: 11
                    weight: Font.Bold
                }
                fontSizeMode: Text.VerticalFit
                lineHeight: 0
                renderType: Text.NativeRendering
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }
            Text {
                text: "Workspace " + ( root.activeWorkspace?.id ?? "1" )
                color: Config.colors.text
                renderType: Text.NativeRendering
                lineHeight: 0
                verticalAlignment: Qt.AlignTop
                horizontalAlignment: Qt.AlignLeft
                font {
                    weight: Font.DemiBold
                    pointSize: 9
                }
                textFormat: Text.PlainText
            }
        }
    }
}
