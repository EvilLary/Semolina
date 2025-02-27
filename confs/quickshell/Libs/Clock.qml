pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root
    //property string time: new Date()
    property string timeFormatted: Qt.formatDateTime(clock.date, "hh:mm AP - ddd, MMM dd")
    property alias seconds: clock.seconds
    property alias minutes: clock.minutes
    property alias hours: clock.hours

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
    //Timer {
    //    running: true
    //    interval: 30000
    //    repeat: true
    //    onTriggered: root.time = Date()
    //}
}
