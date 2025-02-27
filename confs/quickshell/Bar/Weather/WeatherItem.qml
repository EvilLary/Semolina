import QtQuick
import Quickshell
import QtQuick.Layouts
import "root:Libs"

MouseArea {
    id: weather
    implicitWidth: childrenRect.width
    onClicked: Weather.refresh()
    //hoverEnabled: true


    //Popup {
    //    id: weatherInfo
    //    rootWindow: weather.bar
    //    parentItem: weather
    //    contentItem: Item {
    //        Rectangle {
    //            anchors.fill: parent
    //            color: "blue"
    //        }
    //        MouseArea {
    //            id: tooltip
    //            anchors.fill: parent
    //            hoverEnabled: true
    //            onEntered: hideTimer.stop()
    //            onExited: hideTimer.restart()
    //        }
    //        anchors.fill: parent
    //    }
    //    offsetX: -75
    //    offsetY: 184
    //    popupHeight: 100
    //    popupWidth: 100
    //}
    //onEntered: hideTimer.stop(),weatherInfo.open();
    //onExited: {
    //    hideTimer.restart();
    //}
    //Timer {
    //    id: hideTimer
    //    interval: 250
    //    running: false
    //    repeat: false
    //    onTriggered: weatherInfo.close();
    //}
    Image {
        id: icon
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        source: Quickshell.iconPath(Weather.weatherData.weatherIcon,'weather-none-available')
        sourceSize {
            width: 42
            height: 42
        }
        mipmap: true
    }
    ColumnLayout {
        id: column
        Layout.fillHeight: true
        spacing: 0
        anchors {
            left: icon.right
            leftMargin: 5
            verticalCenter: parent.verticalCenter
        }
        //property string timeFormat: "hh:mm AP"
        //property string dateFormat: "hh:mm AP - ddd, MMM dd"
        Text {
            //text: Weather.weatherData.temperature + Weather.weatherData.temperatureUnit
            //text: Qt.formatDate(Clock.time,root.dateFormat)
            //text: Qt.formatDateTime(Clock.time,column.dateFormat)
            text: Clock.timeFormatted
            color: Config.colors.text
            lineHeight: 0
            renderType: Text.NativeRendering
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            Layout.fillWidth: true
            elide: Text.ElideRight
            font {
                pointSize: 11
                hintingPreference: Font.PreferNoHinting
                weight: Font.Bold
            }
        }
        Text {
            //text: `${Weather.weatherData.windSpeed} ${Weather.weatherData.windSpeedUnit} , ${Weather.weatherData.windDirection} ${Weather.weatherData.windDirectionUnit}`
            text: Weather.weatherData.temperature + Weather.weatherData.temperatureUnit + ", " + Weather.weatherData.weatherDescription
            color: Config.colors.text
            lineHeight: 0
            renderType: Text.NativeRendering
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
            font {
                weight: Font.Medium
                hintingPreference: Font.PreferFullHinting
                pointSize: 10
            }
        }
    }
}
