import QtQuick
import '../../Libs'
import QtQuick.Layouts
import Quickshell

Item {
    id: weatherInfo
    Image {
        id: icon
        source: Quickshell.iconPath(Weather.weatherData.weatherIcon,'weather-none-available')
        fillMode: Image.PreserveAspectFit
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        sourceSize {
            width: 100
            height: 100
        }
    }
    ColumnLayout {
        spacing: 5
        anchors {
            left: icon.right
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        Text {
            text: Weather.weatherData.weatherDescription
            color: 'white'
            Layout.fillWidth: true
            lineHeight: 0
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            font {
                weight: Font.Bold
                pointSize: 12
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 10
            Text {
                text: Weather.weatherData.temperature  + Weather.weatherData.temperatureUnit
                color: 'white'
                lineHeight: 0
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font {
                    weight: Font.Bold
                    pointSize: 11
                }
            }
            Text {
                text: Weather.weatherData.apparentTemp + Weather.weatherData.temperatureUnit
                color: Qt.alpha('white',0.4)
                lineHeight: 0
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font {
                    weight: Font.Bold
                    pointSize: 10
                }
            }
        }
        Text {
            text: '󰖌' + Weather.weatherData.humidity + '%'
            color: 'white'
            Layout.fillWidth: true
            lineHeight: 0
            Layout.alignment: Qt.AlignCenter
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            font {
                weight: Font.Bold
                pointSize: 10
            }
        }
    }
}
