import QtQuick
import "../Libs"
import QtQuick.Layouts
import "../Notification"
Rectangle {
    id: notificationList
    radius: Config.globalRadius
    color: Config.colors.background
    border {
        width: 1
        color: Qt.alpha(Config.colors.text,0.2)
    }
    RowLayout {
        id: header
        anchors {
            margins: 8
            top: parent.top
            right: parent.right
            left: parent.left
        }
        height: 50
        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: Config.colors.accent
            radius: Config.globalRadius
            Text {
                anchors.fill: parent
                anchors.margins: 10
                text: "Notifications"
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                color: Config.colors.text
                font {
                    weight: Font.Bold
                    pointSize: 15
                }
            }
        }
        Rectangle {
            Layout.fillHeight: true
            radius: Config.globalRadius
            implicitWidth: this.height
            color: (toggleDnd.containsMouse) ? Config.colors.accent : Config.colors.altBackground
            MouseArea {
                id: toggleDnd
                anchors.fill: parent
                hoverEnabled: true
                onClicked: NotificationProvider.dndStatus = !NotificationProvider.dndStatus
            }
            Image {
                anchors.centerIn: parent
                smooth: false
                asynchronous: true
                sourceSize {
                    width: 32
                    height: 32
                }
                fillMode: Image.PreserveAspectFit
                source: NotificationProvider.dndStatus ? 'image://icon/notification-disabled' : 'image://icon/preferences-desktop-notification-bell'
            }
        }
    }

    Rectangle {
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 10
        }
        color: Config.colors.altBackground
        radius: Config.globalRadius
        clip: true
        ListView {
            anchors {
                fill: parent
                margins: 8
            }
            spacing: 5
            model: NotificationProvider.tracked
            delegate: NotificationBody {
                isToast: false
                width: notificationList.width - 36
            }

        }
    }
}
