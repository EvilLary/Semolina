import QtQuick
import "root:."

Rectangle {
    id: entry
    required property string iconSource
    width: 125
    height: 125
    radius: 5
    signal activate
    border {
        width: entryArea.containsMouse ?? 1
        color: Config.colors.border
    }
    color: (entry.modelData.activated || entryArea.containsMouse) ? Config.colors.active : Config.colors.altBackground

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
    Image {
        id: windowIcon
        width: entryArea.containsMouse ? 90 : 80
        height: this.width
        anchors.centerIn: parent
        mipmap : false
        asynchronous: true
        source: entry.iconSource
        Behavior on width {
            NumberAnimation {
                duration: 100
            }
        }
    }
    MouseArea {
        id: entryArea
        anchors.fill: parent
        onClicked: entry.activate()
        hoverEnabled: true
    }
}
