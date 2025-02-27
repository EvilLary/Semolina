import QtQuick
import Quickshell.Widgets

MouseArea {
    id: mouseArea

    property alias iconSource: icon.source
    implicitWidth:  25
    implicitHeight: 25
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    //signal scrollUp
    //signal scrollDown
    signal rightClick
    signal leftClick
    signal middleClick

    hoverEnabled: false
    //cursorShape: Qt.PointingHandCursor
    IconImage {
        id: icon
        anchors.centerIn: parent
        implicitSize: mouseArea.width
        //scale: mouseArea.containsMouse ? 0.9 : 1
        mipmap: false
        asynchronous: true
        //Behavior on scale {
        //    ScaleAnimator {
        //        easing.type: Easing.InCubic
        //        duration: 175
        //    }
        //}
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
