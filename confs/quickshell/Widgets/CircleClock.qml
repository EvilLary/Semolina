import QtQuick
import Quickshell
import "../"
import '../Components'

Item {

    SystemClock {
       id: clock
    }
    CircularPath {
        id: hours
        anchors.centerIn: parent
        implicitHeight: 100
        implicitWidth: 100

        pathBackground: Config.colors.altBackground
        endAngle: 360
        startAngle: -90
        strokeWidth: 8
        value: {
            const hours = (clock.hours % 12) || 12;
            return (hours * 30)
        }
    }
    CircularPath {
        id: minutes
        anchors.centerIn: parent
        implicitHeight: 150
        implicitWidth: 150

        pathColor: Config.colors.light
        pathBackground: Config.colors.altBackground
        endAngle: 360
        startAngle: -90
        strokeWidth: 8
        value: (clock.minutes * 6)
    }
    CircularPath {
        id: seconds
        anchors.centerIn: parent
        implicitHeight: 200
        implicitWidth: 200
    
        pathColor: Config.colors.accent
        pathBackground: Config.colors.altBackground
        endAngle: 360
        startAngle: -90
        strokeWidth: 8
        value: (clock.seconds * 6)
    }
}
