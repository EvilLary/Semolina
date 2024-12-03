import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Layouts

PanelWindow {
    required property ShellScreen screen;
    id: launcherWindow
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "qs:runner"
    exclusionMode: ExclusionMode.Ignore
    width: window.width
    height: window.height
    anchors {
        top: true
        bottom: true
        left: true
    }
    color: "transparent"
    margins {
        top: 5
        bottom: 5
        left: 5
    }

    Rectangle {
        id: window
        color: "#be23263b"
        radius: 2
        border {
            width: 1
            color: "#c1c1c1"
        }
        width: screen.width / 4
        height: screen.height - 10
        ToolBar {
            id: search
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: main.top
            }
        }
        ScrollView {
            id: main
            anchors {
                top: search.bottom
                right: parent.right
                left: parent.left
                bottom: parent.bottom
            }
            padding: 5
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            ColumnLayout {
                // anchors.centerIn: window
                spacing: 15
                Repeater {
                    model: DesktopEntries.applications
                    Button {
                        text: modelData.name
                        visible: !modelData.noDisplay
                        flat: true
                        icon.source: modelData.icon
                        Layout.fillWidth: true
                        onClicked: modelData.execute();
                    }
                }
            }
        }
    }
}
