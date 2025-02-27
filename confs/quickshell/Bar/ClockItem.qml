import QtQuick
import "root:Libs"
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: column.implicitWidth + 10
    implicitHeight: 40
    property string timeFormat: "hh:mm AP"
    property string dateFormat: "dddd, MMMM dd"
    ColumnLayout {
        id: column
        spacing: 0
        anchors {
            centerIn: parent
        }
        Text {
            text: Qt.formatTime(Clock.time,root.timeFormat)
            color: "white"
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            renderType: Text.NativeRendering
            lineHeight: 0
            font {
                weight: Font.Bold
                hintingPreference: Font.PreferNoHinting
                pointSize: 12
            }
        }
        Text {
            text: Qt.formatDate(Clock.time,root.dateFormat)
            color: "white"
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            renderType: Text.NativeRendering
            lineHeight: 0
            font {
                weight: Font.Medium
                hintingPreference: Font.PreferFullHinting
                pointSize: 10
            }
        }
    }
}
