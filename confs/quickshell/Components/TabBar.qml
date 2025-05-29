pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../Config"

Item {
    id: root
    // color: Colors.background
    // radius: Stuff.radius

    required property list<string> model
    property int activeIndex: 0
    property int textSize: 14

    RowLayout {
        anchors {
            centerIn: parent
        }
        width: Math.max(parent.width, 10)
        height: Math.max(parent.height, 10)
        Repeater {
            id: repeater
            // model: root.model
            Component.onCompleted: this.model = root.model

            Rectangle {
                id: rect
                required property int index
                required property var modelData
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 1
                Layout.minimumHeight: 1
                readonly property bool active: root.activeIndex == index
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: root.activeIndex = rect.index
                    hoverEnabled: true
                }
                radius: Stuff.radius
                color: (this.active) ? Colors.accent : (mouseArea.containsMouse ? Qt.lighter(Colors.background, 1.5) : Colors.background)
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
                    color: (parent.active) ? Colors.text : Qt.alpha(Colors.text,0.3)
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    fontSizeMode: Text.Fit
                    font {
                        pixelSize: root.textSize
                        weight: Font.Bold
                        kerning: false
                    }
                }
            }
        }
    }
}
