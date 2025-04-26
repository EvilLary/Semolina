import QtQuick
import "root:Libs"
Rectangle {

    id: gameInfo
    visible: root.gameInfo.isGame
    radius: 10
    color: Config.colors.background
    width: 500
    height: 200
    border {
        width: 1
        color: Qt.alpha(Config.colors.text,0.2)
    }
    Image {
        id: logo
        source: root.gameInfo.gameLogo
        //smooth: false
        anchors {
            top: parent.top
            margins: 10
            horizontalCenter: parent.horizontalCenter
            bottom: info.top
        }
        width: 400
        height: 130
        asynchronous: true
        fillMode: Image.PreserveAspectFit
    }
    Rectangle {
        id: info
        color: Config.colors.altBackground
        radius: 10
        height: 40
        anchors {
            bottom: parent.bottom
            margins: 10
            right: parent.right
            left: parent.left
        }
        Text {
            text: 'Playtime: ' + root.gameInfo.playtime
            color: Config.colors.text
            anchors.centerIn: parent
            renderType: Text.NativeRendering
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            font {
                weight: Font.Bold
                pointSize: 11
            }
        }
    }
}
