import QtQuick
import QtQuick.Layouts
import 'root:Libs'

Rectangle {
    id: quickSettings

    color: Config.colors.altBackground
    radius: Config.globalRadius

    GridLayout {
        anchors {
            fill: parent
            margins: 8
        }
        columns: 2
        columnSpacing: 8
        rowSpacing: 8
        Repeater {
            model: 4

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: Config.globalRadius * 1.5
                color: Config.colors.accent
                RowLayout {
                    anchors {
                        margins: 10
                        fill: parent
                    }
                    Image {
                        source: 'image://icon/notification-inactive-symbolic'
                        fillMode: Image.PreserveAspectCrop
                        Layout.bottomMargin: 5
                        sourceSize {
                            width: 36
                            height: 36
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        text: 'Notifications'
                        color: Config.colors.text
                        font {
                            weight: Font.Bold
                            pointSize: 11
                        }
                    }
                }
            }
        }
    }
}
