import Quickshell
import QtQuick
// import QtQuick.Controls
import "../Config"

Item {
    id: digitalClock
    height: text.implicitHeight + 4
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    readonly property string localDateTime: Qt.locale("ar_SA").toString(clock.date, "hh\nmmddd dd MMMM\nhh:mm ap    ")

    // MouseArea {
    //     id: mouse
    //     hoverEnabled: true
    //     anchors.fill: parent
    //     ToolTip {
    //         visible: mouse.containsMouse
    //         popupType: Popup.Window
    //         // text: Qt.locale("ar_SA").toString(clock.date, "ddd dd MMMM\nhh:mm ap    ")
    //         text: digitalClock.localDateTime.slice(5)
    //         delay: 450
    //     }
    // }
    Text {
        id: text
        anchors {
            centerIn: parent
        }
        // text: Qt.locale("ar_SA").toString(clock.date, "hh\nmm")
        text: digitalClock.localDateTime.slice(0, 5)
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        color: Colors.text
        textFormat: Text.PlainText
        lineHeight: 0.9
        renderType: Text.NativeRendering
        font {
            kerning: false
            weight: Font.Medium
            preferShaping: false
            pointSize: 14
            features: {
                "frac": 0,
                "kern": 0,
                "dlig": 0,
                "hlig": 0,
                "liga": 0
            }
        }
    }
}
