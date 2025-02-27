import QtQuick
import Quickshell.Widgets
import Quickshell

MouseArea {
    id: mouseArea

    property string iconSource
    property real value

    property alias startValue: throbber.startAngle
    property alias throbberColor: throbber.pathColor
    property alias iconSize: icon.implicitSize

    signal scrollUp
    signal scrollDown
    signal rightClick
    signal leftClick
    // signal middleClick

    acceptedButtons: Qt.LeftButton | Qt.RightButton/* | Qt.MiddleButton*/
    hoverEnabled: false
    //cursorShape: Qt.PointingHandCursor

    CircularPath {
        id: throbber
        implicitWidth: mouseArea.width
        implicitHeight: mouseArea.height
        anchors.centerIn: parent

        value: Math.min(mouseArea.value * this.endAngle, this.endAngle)
        //value: mouseArea.value * this.endAngle
        startAngle: mouseArea.startValue
        endAngle: 280
    }
    IconImage {
        id: icon
        source: Quickshell.iconPath(mouseArea.iconSource,'audio-player')
        anchors.centerIn: parent
        implicitSize: (mouseArea.width / 2)
        mipmap: false
        scale: (mouseArea.containsMouse) ? 0.8 : 1
        Behavior on scale {
            NumberAnimation {
                easing.type: Easing.Linear
                duration: 150
            }
        }
    }

    Text {
        text: Math.trunc(mouseArea.value * 100)
        color: "white"
        font {
            pointSize: 8
            weight: Font.Bold
            hintingPreference: Font.PreferNoHinting
        }
        horizontalAlignment: Qt.AlignRight
        verticalAlignment: Qt.AlignVCenter
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        renderType: Text.NativeRendering
    }
    onClicked: mouse => {
        switch (mouse.button) {
            case (Qt.LeftButton):
                leftClick();
                break;
            case (Qt.RightButton):
                rightClick();
                break;
            // case (Qt.MiddleButton):
            // middleClick()
            // break;
        }
    }
    onWheel: event => {
        //event.accepted = true;
        const delta = (event.angleDelta.y || event.angleDelta.x)
        if (delta > 1) {
            scrollUp()
        }
        else if (delta < 1) {
            scrollDown()
        }
    }
}
