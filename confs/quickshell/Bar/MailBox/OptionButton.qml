
import QtQuick
import 'root:Libs'
import QtQuick.Layouts

Rectangle {
    id: optionButton

    radius: Config.globalRadius * 1.5
    color: this.status ? Config.colors.accent : Config.colors.border
    Behavior on color { ColorAnimation { duration: 125; } }
    //clip: true

    property alias text: buttonName.text
    property alias statusText: status.text
    property alias icon: buttonIcon.source

    property bool status: true
    property bool hasPage: false

    signal clicked();
    signal openPage();

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: optionButton.clicked();
    }
    Rectangle {
        visible: optionButton.hasPage
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: 40
        radius: parent.radius
        color: Qt.alpha(Config.colors.border,0.3)
        bottomLeftRadius: 0
        topLeftRadius: 0
        Image {
            source: 'image://icon/arrow-right'
            anchors.centerIn: parent
            scale: pageBtn.containsPress ? 0.8 : 1 
            Behavior on scale { ScaleAnimator {duration: 124}}
            sourceSize {
                width: 40
                height: 40
            }
        }
        MouseArea {
            id: pageBtn
            anchors.fill: parent
            onClicked: optionButton.openPage();
        }
    }

    RowLayout {
        anchors {
            margins: 10
            leftMargin: 20
            fill: parent
        }
        spacing: 10
        Image {
            id: buttonIcon
            fillMode: Image.PreserveAspectCrop
            Layout.bottomMargin: 0
            sourceSize {
                width: 36
                height: 36
            }
        }
        Column {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Text {
                id: buttonName
                color: Config.colors.text
                textFormat: Text.PlainText
                elide: Text.ElideRight
                width: parent.width
                font {
                    weight: Font.Bold
                    pointSize: 11
                }
            }
            Text {
                id: status
                color: Qt.alpha(Config.colors.text,0.8)
                textFormat: Text.PlainText
                elide: Text.ElideRight
                width: parent.width
                maximumLineCount: 1
                font {
                    weight: Font.DemiBold
                    pointSize: 8
                }
            }
        }
    }
}
