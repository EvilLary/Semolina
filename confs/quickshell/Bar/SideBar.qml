import QtQuick.Layouts
import QtQuick
import "root:Libs"
//import "Tasks"
//import "Indicators"
//import "Systray"
//import "MailBox"
//import "Weather"

BarWindow {
    id: root
    anchors {
        right: true
        left: false
        bottom: true
        top: true
    }
    width: 48
    //height: 56
    ColumnLayout {
        id: centerItems
        anchors.centerIn: parent
        height: parent.height
    }

    ColumnLayout {
        id: rightItems
    }
    ColumnLayout {
        id: leftItems
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        layoutDirection: Qt.LeftToRight
    }
}
