import QtQuick
import QtQuick.Controls
import "../../Libs"
import "../../"
import '../../Notification'

Item {

    id: root

    Rectangle {
        id: header
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        radius: Config.globalRadius
        color: Config.colors.accent
        height: 50
        Button {
            id: returnBtn
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            flat: true
            icon.source: "arrow-left"
            height: 40
            width: 40
            icon.width: 25
            icon.height: 25
            onClicked: stackView.pop(null)
        }
        Text {
            anchors {
                left: returnBtn.right
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            text: 'Notifications'
            color: Config.colors.text
            font {
                weight: Font.Bold
                pointSize: 14
            }
        }
    }
    Rectangle {
        anchors {
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            top: header.bottom
            topMargin: 8
        }
        clip: true
        radius: Config.globalRadius
        color: Config.colors.altBackground
        ListView {
            anchors {
                fill: parent
                margins: 8
            }
            spacing: 5
            model: NotificationProvider.tracked
            delegate: NotificationBody {
                isToast: false
                width: 464
            }
        }
    }
    // Component.onCompleted: print(JSON.stringify(NotificationProvider.tracked))
}
