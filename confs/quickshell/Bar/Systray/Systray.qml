import Quickshell
import QtQuick
// import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.SystemTray

MouseArea {
    id: root
    clip: true
    visible: repeater.count > 0
    implicitWidth: revealer.width
    implicitHeight: 42
    onClicked: row.visible ? root.hide() : root.reveal()
    Rectangle {
        id: revealer
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        width: 11
        color: "transparent"
        height: parent.height

        Image {
            source: Quickshell.iconPath('arrow-left')
            width: 23
            height: 23
            anchors {
                centerIn: parent
            }
            rotation: row.visible ? 180 : 0
            Behavior on rotation {
                RotationAnimation {
                    duration: 150
                }
            }
        }
    }
    function reveal(): void {
        revealAnimation.to = (revealer.width + row.width + row.anchors.rightMargin);
        row.visible = true;
        revealAnimation.restart();
    }
    function hide(): void {
        revealAnimation.to = (revealer.width);
        revealAnimation.restart();
    }
    SmoothedAnimation {
        id: revealAnimation
        target: root
        property: "implicitWidth"
        duration: 250
        easing.type: Easing.Linear
        onFinished: {
            if (root.implicitWidth == revealer.width) {
                row.visible = false;
                root.implicitWidth = Qt.binding(function () {
                    return (revealer.width);
                });
            }
            if (row.visible) {
                root.implicitWidth = Qt.binding(function () {
                    return (revealer.width + row.width + row.anchors.rightMargin);
                });
            }
        }
    }
    RowLayout {
        id: row
        visible: false
        layoutDirection: Qt.RightToLeft
        anchors {
            rightMargin: 10
            right: revealer.left
            verticalCenter: parent.verticalCenter
        }
        Repeater {
            id: repeater
            model: SystemTray.items.values

            SystrayItem {
                id: item
                required property var modelData
                // Component.onCompleted: print(this.modelData.icon)
                iconSource: {
                    if (modelData.icon.includes("?path=")) {
                        const [name, path] = modelData.icon.split("?path=");
                        const icon = name.replace("image://icon/", "");
                        return Qt.resolvedUrl(path + "/" + icon);
                    }
                    return modelData.icon
                }

                // Popup {
                //     id: popup
                //     // delay: 100
                //     // // text:  item.modelData.tooltipTitle + "\n" + item.modelData.tooltipDescription
                //     // // visible: item.containsMouse || this.
                //     // timeout: 10000
                //
                //     Text {
                //         anchors.centerIn: parent
                //         text: "fdffdfsdfsdfsdfsdfsdf\nsdfsdfsdf\nsdfsdfsdf\ndsf"
                //     }
                //     exit: Transition {
                //         SequentialAnimation {
                //             PauseAnimation {
                //                 duration: 200
                //             }
                //             NumberAnimation {
                //                 property: "opacity"
                //                 from: 1.0
                //                 to: 0.0
                //             }
                //         }
                //     }
                //     popupType: Popup.Window
                //     bottomMargin: 100
                //     // y: -
                //     // bottomPadding: 1000
                // }
                // Timer {
                //     id: timer
                //     interval: 350
                //     repeat: false
                //     onTriggered: {
                //         if (popup.visible) {
                //             popup.close();
                //         } else {
                //             popup.open();
                //         }
                //     }
                // }
                // onEntered: {
                //     // popup.open()
                //     if (popup.visible) {
                //         timer.stop;
                //     } else {
                //         timer.restart();
                //     }
                // }
                // onExited: {
                //     // if ()
                //     // timer.stop();
                //     if (popup.visible) {
                //         timer.restart();
                //     } else {
                //         timer.stop();
                //     }
                // }
                onRightClick: if (modelData.hasMenu)
                    openMenu()
                //Steam reports that it has activations but when clicking on it it complains about "no such method "Activate""
                onLeftClick: if (!modelData.onlyMenu && modelData.id != "steam")
                    modelData.activate()
                onMiddleClick: if (!modelData.onlyMenu)
                    modelData.secondaryActivate()
                function openMenu(): void {
                    const window = QsWindow.window;
                    const coords = window.contentItem.mapFromItem(item, 15, 15);
                    modelData.display(window, coords.x, coords.y);
                }
            }
        }
    }
}
