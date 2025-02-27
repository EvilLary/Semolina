import QtQuick
import QtQuick.Layouts
import 'root:Libs'
import './'

Rectangle {
    id: quickSettings

    color: Config.colors.altBackground
    radius: Config.globalRadius

    GridLayout {
        anchors {
            fill: parent
            margins: 8
        }
        columns: 2
        columnSpacing: 8
        rowSpacing: 8
        OptionButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: 'Notifications'
            statusText: {
                if(NotificationProvider.toastsCount == 0) {
                    return 'Empty'
                }
                else {
                    return `${NotificationProvider.toastsCount} Notifications`
                }
            }
            status: !NotificationProvider.dndStatus
            icon: NotificationProvider.dndStatus? 'image://icon/notification-disabled-symbolic' : 'image://icon/notification-symbolic'
            onClicked: NotificationProvider.dndStatus = !NotificationProvider.dndStatus
            hasPage: true
            onOpenPage: stackView.push('NotificationPage.qml')
        }
        OptionButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: 'Wi-Fi'
            statusText: Network.status.activeConnections.replace('Wi-Fi: ','')
            status: Network.wifiStatus
            icon: `image://icon/${Network.icon}`
            onClicked: Network.toggleWifi();
        }
        OptionButton {
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            text: 'Night Light';
            status: Stuff.nightLight;
            statusText: Stuff.nightLight ? '3500k Enabled' : 'Disabled';
            icon: Stuff.nightLight ? 'image://icon/redshift-status-on' : 'image://icon/redshift-status-off';
            hasPage: true;
            onClicked: Stuff.toggleNL();
        }
        OptionButton {
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            text: 'Idle Inhibitor';
            status: Stuff.inhibitorStatus;
            statusText: Stuff.inhibitorStatus ? 'Enabled' : 'Disabled';
            icon: Stuff.inhibitorStatus ? 'image://icon/my-caffeine-on-symbolic' : 'image://icon/my-caffeine-off-symbolic';
            onClicked: Stuff.toggleInhibit();
        }
    }
}
