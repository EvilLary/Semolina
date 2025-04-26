import QtQuick
import "../"
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: root
    property real barValue
    required property string osdText
    property string osdIcon
    required property bool isBarVisible

    anchors.fill: parent
    radius: Config.globalRadius * 1.5
    color: Config.colors.background
    border {
        width: 1
        color: Qt.alpha("white",0.2)
    }

    ClippingRectangle {
        id: wrapper
        visible: root.isBarVisible
        color: 'transparent'
        anchors {
            fill: parent
            margins: 4
        }
        radius: root.radius - this.anchors.margins
        Rectangle {
            height: parent.height
            width: (parent.width) * (root.barValue)
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            Behavior on width {
                PropertyAnimation {
                    duration: 100
                    easing.type: Easing.Linear
                }
            }
            color: Config.colors.accent
            radius: wrapper.radius
        }
    }
    Text {
        id: textt
        visible: !root.isBarVisible
        text: root.osdText
        color: Config.colors.text
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        renderType: Text.NativeRendering
        anchors.centerIn: parent
        lineHeight: 0
        font {
            pointSize: 10
            weight: Font.Bold
            hintingPreference: Font.PreferNoHinting
        }
    }
    Image {
        id: icon
        source: Quickshell.iconPath(root.osdIcon,true)
        smooth: false
        asynchronous: true
        sourceSize {
            width: 28
            height: 28
        }
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            margins: 10
        }
    }
}
