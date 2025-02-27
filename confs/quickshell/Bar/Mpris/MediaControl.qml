import QtQuick
import "root:Libs"


MouseArea {
    id: mouseArea
    hoverEnabled: true
    implicitWidth: this.height
    property alias iconSource: icon.source
    property int iconSize: 18
    Rectangle {
        anchors.fill: parent
        radius: this.height
        color: "transparent"
        antialiasing: true
        border {
            width: 2
            color: mouseArea.containsMouse ? Config.colors.accent : "transparent" 
        }
    }
    Image {
        id: icon
        anchors.centerIn: parent
        sourceSize {
            width: mouseArea.iconSize
            height: mouseArea.iconSize
        }
        scale: mouseArea.containsPress ? 0.85 : 1
        Behavior on scale {
            ScaleAnimator { duration: 100}
        }
    }
}
