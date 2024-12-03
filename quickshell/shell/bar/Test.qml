import QtQuick
import Quickshell

PopupWindow {
    id: popup
    required property bool targetVisible

    anchor.window: root
    anchor.rect.x: - (popup.width + 5)
    anchor.rect.y: (root.height + popup.height)

    color: "transparent"
    width: 450
    height: 450

    onTargetVisibleChanged: {
        if (targetVisible) {
            visible = true
            popupAnim.to = 0
        } else {
            popupAnim.to = height
        }

        popupAnim.restart()
    }

    Rectangle {
        id: popupItem

        // border.color: "red"
        // border.width: 3
        radius: 4
        scale: targetVisible ? 1 : 0.4
        Behavior on scale {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
        width: popup.width
        height: popup.height
        x: width

        SmoothedAnimation {
            id: popupAnim
            target: popupItem
            property: "x"
            velocity: 1600
            onFinished: {
                if (popupItem.x == popup.height) popup.visible = false
            }
        }
    }
}
