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

    RowLayout { id: row
        anchors.centerIn: parent
        IconImage {
            source: root.osdIcon
            implicitSize: 26
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.leftMargin: 10
            Layout.maximumWidth: 26
        }
        ProgressBar {
            visible: root.isBarVisible
            id: slider
            from: 0
            to: 1
            value: root.barValue
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            // Layout.preferredWidth: 175
            Layout.maximumWidth: 175
            Behavior on value {
                NumberAnimation {
                    duration: 100
                }
            }
        }
        Text {
            id: textt
            text: root.osdText
            color: Config.colors.text
            font {
                // family: Config.font
                pointSize: 10
                weight: Font.Medium
            }
            Layout.rightMargin: 10
        }
    }
}
