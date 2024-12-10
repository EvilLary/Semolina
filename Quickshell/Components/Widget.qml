import QtQuick
import Quickshell.Widgets

MouseArea {
    id: mouseArea
    required property string iconSource
    implicitWidth:  25
    implicitHeight: 25
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    signal scrollUp
    signal scrollDown
    signal rightClick
    signal leftClick
    signal middleClick

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    IconImage {
        id: icon
        source: mouseArea.iconSource
        anchors.centerIn: parent
        implicitSize: mouseArea.containsMouse ? mouseArea.width + 5 : mouseArea.width
        mipmap: false
        smooth: false
        asynchronous: false
        Behavior on implicitSize {
            NumberAnimation {
                easing.type: Easing.InCubic
                duration: 175
            }
        }
    }
    onClicked: mouse => {
        switch (mouse.button) {
            case (Qt.LeftButton):
                leftClick()
                break;
            case (Qt.RightButton):
                rightClick()
                break;
            case (Qt.MiddleButton):
                middleClick()
                break;
        }
    }
    onWheel: event => {
        event.accepted = true;
        const delta = (event.angleDelta.y || event.angleDelta.x)
        if (delta > 1) {
            scrollUp()
        }
        else if (delta < 1) {
            scrollDown()
        }
    }
}
