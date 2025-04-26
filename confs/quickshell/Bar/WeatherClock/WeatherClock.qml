import QtQuick
import Quickshell
import QtQuick.Layouts
import "../../Libs"
import "../../"
import "../../Components" as C

MouseArea {
    id: weather
    required property var bar
    implicitWidth: childrenRect.width
    onClicked: event => {
        switch (event.button) {
        case (Qt.LeftButton):
            calendar.toggle()
            event.accepted = true
            break;
        case (Qt.RightButton):
            Weather.refresh()
            event.accepted = true
            break;
        }
    }
    acceptedButtons: Qt.RightButton | Qt.LeftButton
    //hoverEnabled: true

    C.Popup {
        id: calendar
        rootWindow: weather.bar
        parentItem: weather
        contentUrl: "root:/Bar/WeatherClock/CalendarView.qml"
        popupHeight: 400
        popupWidth: 750
    }
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
        source: Quickshell.iconPath(Weather.weatherData.weatherIcon, 'weather-none-available')
        sourceSize {
            width: 42
            height: 42
        }
        mipmap: true
    }

    // property string timeFormatted: Qt.locale("ar_SA").toString(clock.date, "ddd, dd MMM | hh:mm AP")
    // property alias seconds: clock.seconds
    // property alias minutes: clock.minutes
    // property alias hours: clock.hours

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
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
        Text {
            // text: Clock.timeFormatted
            text: Qt.locale("ar_SA").toString(clock.date, "ddd, dd MMM | hh:mm AP")
            color: Config.colors.text
            lineHeight: 0
            renderType: Text.NativeRendering
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            Layout.fillWidth: true
            elide: Text.ElideRight
            font {
                pointSize: 12
                //hintingPreference: Font.PreferNoHinting
                weight: Font.Bold
            }
        }
        Text {
            //text: `${Weather.weatherData.windSpeed} ${Weather.weatherData.windSpeedUnit} , ${Weather.weatherData.windDirection} ${Weather.weatherData.windDirectionUnit}`
            text: Weather.weatherData.temperature.replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]) + Weather.weatherData.temperatureUnit + ", " + Weather.weatherData.weatherDescription
            color: Config.colors.text
            lineHeight: 0
            renderType: Text.NativeRendering
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
            font {
                weight: Font.DemiBold
                //hintingPreference: Font.PreferFullHinting
                pointSize: 11
            }
        }
    }
}
