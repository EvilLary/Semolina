import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

Scope {
    id: root

    LazyLoader {
        id: notifsloader
        PanelWindow {
            id: notifsPopup
            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "qs:notfication"
            anchors {
                top: true
                right: true
            }
            margins {
                top: 5
                right: 5
            }
            color: "transparent"
            width: popup.width
            height: popup.height
            Rectangle {
                id: popup
                color: "black"
                width: 300
                height: 200
                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    onClicked: notifsloader.active = false
                }
            }
        }
    }
}
