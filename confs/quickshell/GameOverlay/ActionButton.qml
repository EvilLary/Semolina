import QtQuick
import "root:Libs"

Rectangle {
    id: action

    required property bool isActive
    property alias actionName: actionName.text
    property alias icon: actionIcon.source
    property alias status: status.text
    signal leftClick()
    signal rightClick()

    color: action.isActive ? Config.colors.accent : Config.colors.altBackground
    radius: Config.globalRadius
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            switch (mouse.button) {
                case (Qt.LeftButton):
                    action.leftClick()
                break;
                case (Qt.RightButton):
                    action.rightClick()
                break;
            }
        }
    }
    Column {
        id: content
        spacing: 5
        anchors.centerIn: parent

        Text {
            id: actionName
            text: "Instant Replay"
            color: action.isActive ? Config.colors.text : Qt.alpha(Config.colors.text,0.2)
            horizontalAlignment: Qt.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                weight: Font.DemiBold
                pointSize: 11
            }
        }
        Image {
            id: actionIcon
            source: "root:assets/instant-replay"
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize {
                width: 75
                height: 75
            }
            smooth: false
            asynchronous: true
            opacity: action.isActive ? 1 : 0.2
        }
        Text {
            id: status
            color: action.isActive ? Config.colors.text : Qt.alpha(Config.colors.text,0.2)
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                weight: Font.Bold
                pointSize: 9
            }
        }
    }
}
