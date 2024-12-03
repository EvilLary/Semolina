import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import "root:."
Rectangle {
    id: root
    property real barValue
    required property string osdText
    required property string osdIcon
    required property bool isBarVisible

    anchors.fill: parent
    radius: 5
    border {
        width: 1
        color: Config.colors.border
    }
    color: Config.colors.altBackground

    RowLayout {
        id: row
        // anchors.fill: parent
        anchors.centerIn: parent
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        // Layout.maximumWidth: parent.width * 7/10
        IconImage {
            source: osdIcon
            implicitSize: 26
            // Layout.alignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.leftMargin: 10
            // Layout.fillWidth: true
            // Layout.preferredWidth: 30
            Layout.maximumWidth: 26
        }
        ProgressBar {
            visible: isBarVisible
            id: slider
            from: 0
            to: 1
            value: barValue
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            Layout.preferredWidth: 175
            Layout.maximumWidth: 175
        }
        Text {
            text: osdText
            color: Config.colors.text
            font {
                // family: Config.font
                pointSize: 10
                weight: Font.Medium
            }
            // Layout.fillWidth: true
            // Layout.preferredWidth: 25
            Layout.maximumWidth: 200
            // Layout.preferredWidth: parent.width * 1/5
            Layout.rightMargin: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }

}
