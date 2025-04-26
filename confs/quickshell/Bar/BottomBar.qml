import QtQuick.Layouts
import QtQuick
//import "../Libs"
//import "Mpris"
import "Tasks"
import "Indicators"
import "Systray"
import "MailBox"
import "WeatherClock"
import "../"

BarWindow {
    id: root
    anchors {
        right: true
        left: true
        bottom: true
        top: false
    }
    height: Config.barHeight
    RowLayout {
        id: centerItems
        anchors.centerIn: parent
        height: parent.height

        TaskManager {
            id: taskManager
            Layout.fillHeight: true
            bar: root
            Layout.leftMargin: 5
            // implicitHeight: 45
        }
    }

    RowLayout {
        id: rightItems
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        layoutDirection: Qt.RightToLeft
        Mailbox {
            id: mailbox
            Layout.fillHeight: true
            Layout.leftMargin: 5
            bar: root
        }
        //ClockItem {
        //    Layout.fillHeight: true
        //}
        Indicators {
            id: indicators
            bar: root
            Layout.fillHeight: true
        }
        Systray {
            id: systrayItems
            Layout.fillHeight: true
        }
    }
    RowLayout {
        id: leftItems
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        layoutDirection: Qt.LeftToRight
        spacing: 10
        WeatherClock {
            id: weather
            bar: root
            Layout.fillHeight: true
        }
        // ActiveTask {
        //    id: activetask
        //    Layout.fillHeight: true
        // }
        // Music {
        //    visible: MprisProvider.trackedPlayer != null
        //    Layout.fillHeight: true
        // }
    }
}
