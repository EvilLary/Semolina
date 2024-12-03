import Quickshell
import QtQuick
import Quickshell.Widgets
MouseArea {
    id: root
    required property string iconSource
    implicitWidth:  icon.width // looks more centered :)
    implicitHeight: icon.height
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    IconImage {
        id: icon
        source: root.iconSource
        implicitSize: 25
        anchors.centerIn: parent
    }
}
