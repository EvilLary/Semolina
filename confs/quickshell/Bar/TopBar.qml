import QtQuick.Layouts
import QtQuick
import "Weather"
import "Mpris"
import "root:Libs"

BarWindow {
    id: top

    anchors {
        top: true
        right: true
        left: true
    }
    height: 46

    RowLayout {
        id: center
        Layout.fillHeight: true
        anchors {
            centerIn: parent
        }
        ClockItem {
            Layout.fillHeight: true
        }
    }
    RowLayout {
        id: rightItems
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        layoutDirection: Qt.RightToLeft
        WeatherItem {
            id: weather
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
        Loader {
            //active: false
            active: MprisProvider.trackedPlayer != null
            Layout.fillHeight: true
            sourceComponent: Music {}
        }
    }
}
