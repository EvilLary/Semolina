import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:."

BarWidgetInner {
    id: root
    implicitHeight: layout.implicitHeight + 20
    SystemClock {
        id: clock
        enabled: true
        precision: SystemClock.Minutes
    }
    // property string curime: clock.hours.toString().padStart(2, '0') + ":" + clock.minutes.toString().padStart(2, '0')
    // property string curTime: Qt.formatTime((clock.hours.toString().padStart(2, '0') + ":" + clock.minutes.toString().padStart(2, '0')), "hh:mm AP").toUpperCase()
    ColumnLayout {
        id: layout
        spacing: 0
        anchors.centerIn: parent
        anchors {
            right: parent.right
            left: parent.left
        }

        anchors.centerIn: parent
        Text {
            // Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            text: clock.hours.toString().padStart(2, '0')
            font {
                family: Config.font
                pointSize: 14
                weight: Font.ExtraLight
            }
            color: Config.colors.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            // Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            text: clock.minutes.toString().padStart(2, '0')
            font {
                family: Config.font
                pointSize: 14
                weight: Font.ExtraLight
            }
            color: Config.colors.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        // Text {
        //     Layout.alignment: Qt.AlignHCenter
        //     text: curTime.substring(6,8)
        //     font.pointSize: 14
        //     color: "#c1c1c1"
        // }
    }
/*
    MouseArea {
        anchors.fill: parent
        // onClicked: console.log (curime)
    }*/
}
