import Quickshell
import QtQuick
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
            width: 46
            height: 46
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
        revealAnimation.to = (revealer.width + row.width + row.anchors.rightMargin)
        row.visible = true
        revealAnimation.restart()
    }
    function hide(): void {
        revealAnimation.to = (revealer.width)
        revealAnimation.restart()
    }
    SmoothedAnimation {
        id: revealAnimation
        target: root
        property: "implicitWidth"
        duration: 250
        easing.type: Easing.Linear
        onFinished: {
            if (root.implicitWidth == revealer.width) {
                row.visible = false
                root.implicitWidth = Qt.binding(function() { return (revealer.width)})
            }
            if (row.visible) {
                root.implicitWidth = Qt.binding(function() { return (revealer.width + row.width + row.anchors.rightMargin) })
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
                iconSource: modelData.icon

                onRightClick: if (modelData.hasMenu) openMenu()
                //Steam reports that it has activations but when clicking on it it complains about "no such method "Activate""
                onLeftClick: if (!modelData.onlyMenu && modelData.id != "steam") modelData.activate()
                onMiddleClick: if (!modelData.onlyMenu) modelData.secondaryActivate()
                function openMenu(): void {
                    const window = QsWindow.window
                    const coords = window.contentItem.mapFromItem(item,15,15)
                    modelData.display(window,coords.x,coords.y)
                }
            }
        }
    }
}
