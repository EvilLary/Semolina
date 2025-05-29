import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Item {
    id: root
    visible: repeater.count > 0
    height: column.height + 8
    required property QsWindow bar
    ColumnLayout {
        id: column
        anchors.centerIn: parent
        Repeater {
            id: repeater
            model: SystemTray.items.values
            MouseArea {
                id: mouseArea
                required property SystemTrayItem modelData
                implicitWidth: 26
                implicitHeight: 26
                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                // hoverEnabled: tooltip.text !== ""
                Image {
                    id: icon
                    anchors.centerIn: parent
                    source: {
                        if (mouseArea.modelData.icon.includes("?path=")) {
                            const [name, path] = mouseArea.modelData.icon.split("?path=");
                            const icon = name.replace("image://icon/", "");
                            return path + "/" + icon;
                        }
                        return mouseArea.modelData.icon;
                    }
                    width: mouseArea.width
                    height: this.width
                    mipmap: false
                    smooth: false
                    asynchronous: true
                    sourceSize {
                        width: icon.width
                        height: icon.height
                    }
                }

                // ToolTip {
                //     id: tooltip
                //     visible: mouseArea.containsMouse
                //     popupType: Popup.Window
                //     text: mouseArea.modelData.tooltipDescription || mouseArea.modelData.tooltipTitle || mouseArea.modelData.title || mouseArea.modelData.id
                // }
                onClicked: mouse => {
                    switch (mouse.button) {
                    case (Qt.LeftButton):
                        // print(JSON.stringify(modelData))
                        if (!modelData.onlyMenu && modelData.id != "steam") {
                            modelData.activate();
                        }
                        break;
                    case (Qt.RightButton):
                        if (modelData.hasMenu) {
                            // console.time("Opening a menu")
                            const window = root.bar;
                            const coords = window.contentItem.mapFromItem(mouseArea, 15, 15);
                            modelData.display(window, coords.x, coords.y);
                            // console.timeEnd("Opening a menu")
                        }
                        break;
                    case (Qt.MiddleButton):
                        if (!modelData.onlyMenu) {
                            modelData.secondaryActivate();
                        }
                        break;
                    }
                }
                //onWheel: event => {
                //    event.accepted = true;
                //    const delta = (event.angleDelta.y || event.angleDelta.x)
                //    if (delta > 1) {
                //        scrollUp()
                //    }
                //    else if (delta < 1) {
                //        scrollDown()
                //    }
                //}
            }
        }
    }
}
