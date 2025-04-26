pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../"

Rectangle {
    id: root
    color: Config.colors.altBackground
    radius: Config.globalRadius

    required property var model
    property int activeIndex: 0
    property int textSize: 14

    RowLayout {
        anchors {
            fill: parent
            margins: 5
        }
        Repeater {
            model: root.model

            Rectangle {
                id: rect
                required property int index
                required property var modelData
                Layout.fillWidth: true
                Layout.fillHeight: true
                property bool active: root.activeIndex == index
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: root.activeIndex = rect.index
                    hoverEnabled: true
                }
                radius: Config.globalRadius
                color: (this.active) ? Config.colors.accent : (mouseArea.containsMouse ? Config.colors.altBase : root.color)
                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.Linear
                        duration: 200
                    }
                }
                Text {
                    anchors.fill: parent
                    text: rect.modelData
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    color: (parent.active) ? Config.colors.text : Qt.alpha(Config.colors.text,0.3)
                    renderType: Text.NativeRendering
                    fontSizeMode: Text.Fit
                    font {
                        pixelSize: root.textSize
                        weight: Font.Bold
                    }
                }
            }
        }
    }
}
