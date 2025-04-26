import QtQuick
import "../../Libs"
import "../../Components"

MouseArea {
    id: root

    implicitWidth: 36
    implicitHeight: 36
    required property var bar
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
        switch (mouse.button) {
        case (Qt.LeftButton):
            dashboard.toggle();
            NotificationProvider.isDashboardOpen = true;
            mouse.accepted = true;
            break;
        case (Qt.RightButton):
            NotificationProvider.dndStatus = !NotificationProvider.dndStatus;
            mouse.accepted = true;
            break;
        }
    }
    Popup {
        id: dashboard
        rootWindow: root.bar
        parentItem: mailbox
        contentUrl: "../Bar/MailBox/Dash.qml"
        popupHeight: 600
        popupWidth: 500
        onClosed: {
            NotificationProvider.isDashboardOpen = false;
        }
    }
    Image {
        source: NotificationProvider.icon
        anchors {
            centerIn: parent
        }
        sourceSize {
            width: 36
            height: 36
        }
    }
}
