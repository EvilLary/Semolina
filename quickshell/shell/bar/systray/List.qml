import QtQuick
import QtQuick.Layouts
import ".."
import Quickshell.Services.SystemTray
import Quickshell
import Quickshell.Widgets
BarWidgetInner {
    id: root
    visible: repeater.count > 0
    // border.width: 0
    implicitHeight: column.implicitHeight + 20
    ColumnLayout {
        id: column
        implicitHeight: childrenRect.height
        Layout.alignment: Qt.AlignBottom
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            id: repeater
            model: SystemTray.items
            property int count: SystemTray.items.values.length
            Rectangle {
                id: toprect
                required property SystemTrayItem modelData
                implicitHeight: trayIcon.height
                implicitWidth: trayIcon.width + 10
                color: "transparent"
                // Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    propagateComposedEvents: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    anchors.fill: parent
                    IconImage {
                        id: trayIcon
                        source: toprect.modelData.icon
                        height: 24
                        width: 24
                        anchors.centerIn: parent
                    }
                    onClicked: mouse => {
                        if (mouse.button == Qt.LeftButton) {
                            toprect.modelData.activate();
                        } else if (mouse.button == Qt.RightButton) {
                            if (!menuOpener.anchor.window) {
                                menuOpener.anchor.window = toprect.QsWindow.window;
                            }
                            if (menuOpener.visible) {
                                menuOpener.close();
                            } else {
                                menuOpener.open();
                            }
                        }
                    }
                }
                QsMenuAnchor {
                    id: menuOpener
                    menu: toprect.modelData.menu
                    anchor {
                        rect.x: 0
                        rect.y: 0
                        onAnchoring: {
                            if (anchor.window) {
                                let coords = anchor.window.contentItem.mapFromItem(toprect, 0, 0);
                                anchor.rect.y = coords.y;
                                anchor.rect.x = coords.x - 25;
                            }
                        }
                        rect.width: trayIcon.width
                        rect.height: trayIcon.height
                        gravity: Edges.Left
                        edges: Edges.Top
                        adjustment: PopupAdjustment.SlideY
                    }
                }
            }
        }
    }
}
