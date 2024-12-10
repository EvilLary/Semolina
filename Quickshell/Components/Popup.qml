import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:"

PopupWindow {
    id: popup

    required property bool targetVisible
    required property QsWindow rootWindow
    default property alias popupItems: popbody.data
    property int offsetX: 5

    anchor.window: rootWindow
    anchor.rect.x: - (popup.width + offsetX)
    anchor.rect.y: (rootWindow.height - popup.height)

    color: "transparent"
    width: popupBackground.width
    height: popupBackground.height

    onTargetVisibleChanged: {
        if (targetVisible) {
            visible = true
            popupAnim.to = 0
        } else {
            popupAnim.to = popupBackground.width
        }

        popupAnim.restart()
    }
    // HyprlandFocusGrab {
    //     id: grab
    //     active: true
    //     windows: [ popup ]
    //     onCleared: targetVisible = false
    //     // onActiveChanged: loader.active = false
    // }
    Rectangle {
        id: popupBackground
        border {
            color: Config.colors.border
            width: 1
        }
        radius: 4
        width: 500
        height: 450
        x: width
        color: Config.colors.background
        Behavior on scale {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
        // opacity: targetVisible ? 1 : 0.0
        // Behavior on opacity {
        //     NumberAnimation {
        //         duration: 400
        //         easing.type: Easing.InOutQuad
        //     }
        // }
        SmoothedAnimation {
            id: popupAnim
            target: popupBackground
            property: "x"
            velocity: 1800
            onFinished: {
                if (popupBackground.x == popup.width){
                    popup.visible = false
                }
            }
        }
        Item {
            id: popbody
            anchors {
                fill: parent
                margins: 10
            }
        }
    }
}
