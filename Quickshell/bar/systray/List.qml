import QtQuick
import QtQuick.Layouts
import "root:Components"
import Quickshell.Services.SystemTray
import Quickshell

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

            Widget {
                id: sysItem
                required property SystemTrayItem modelData
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                iconSource: modelData.icon
                onRightClick: {
                    if (menuOpener.visible) {
                        menuOpener.close();
                    } else {
                        menuOpener.open();
                    }

                }
                onLeftClick: modelData.activate();
                QsMenuAnchor {
                    id: menuOpener
                    menu: sysItem.modelData.menu
                    anchor {
                        window: QsWindow.window
                        rect.x: 0
                        rect.y: 0
                        onAnchoring: {
                            if (anchor.window) {
                                let coords = anchor.window.contentItem.mapFromItem(sysItem, 0, 0);
                                anchor.rect.y = coords.y - 10;
                                anchor.rect.x = coords.x;
                            }
                        }
                        gravity: Edges.Left
                        edges: Edges.Top
                        adjustment: PopupAdjustment.SlideY
                    }
                }
            }
        }
    }
}
