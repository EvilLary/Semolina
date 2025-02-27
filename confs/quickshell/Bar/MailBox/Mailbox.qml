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
                dashboard.open()
                NotificationProvider.isDashboardOpen = true
                break;
            case (Qt.RightButton):
                NotificationProvider.dndStatus = !NotificationProvider.dndStatus
                break;
        }
    }
    Popup {
        id: dashboard
        rootWindow: root.bar
        parentItem: mailbox
        contentUrl: "root:Bar/MailBox/Dash.qml"
        //contentItem: Loader {
        //    active: dashboard.isOpen
        //    anchors.fill: parent
        //    sourceComponent: Dash {}
        //}

        popupHeight: 600
        popupWidth: 500
        offsetX: -220
        offsetY: 20
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
