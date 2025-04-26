import QtQuick
import QtQuick.Layouts
import '../../Libs'
import '../../Components' as C
// import './'

C.InnRect {
    id: quickSettings

    Network {
        id: network
    }
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
            text: 'اشعارات'
            statusText: {
                if(NotificationProvider.toastsCount == 0) {
                    return 'فارغ'
                }
                else {
                    return `${NotificationProvider.toastsCount} اخطار`
                }
            }
            status: !NotificationProvider.dndStatus
            icon: NotificationProvider.dndStatus? 'image://icon/notifications-disabled-symbolic' : 'image://icon/notifications-symbolic'
            onClicked: NotificationProvider.dndStatus = !NotificationProvider.dndStatus
            hasPage: true
            onOpenPage: stackView.push('NotificationPage.qml')
        }
        OptionButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: 'واي-فاي'
            statusText: network.status.activeConnections.replace('Wi-Fi: ','')
            status: network.wifiStatus
            icon: `image://icon/${network.icon}`
            onClicked: network.toggleWifi();
        }
        OptionButton {
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            text: 'ضوء ليلي';
            status: Stuff.nightLight;
            statusText: Stuff.nightLight ? 'مفعل ٣٥٠٠' : 'طافي';
            icon: Stuff.nightLight ? 'image://icon/redshift-status-on' : 'image://icon/redshift-status-off';
            hasPage: true;
            onClicked: Stuff.toggleNL();
        }
        OptionButton {
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            text: 'سهور';
            status: Stuff.inhibitorStatus;
            statusText: Stuff.inhibitorStatus ? 'مفعل' : 'طافي';
            icon: Stuff.inhibitorStatus ? 'image://icon/system-suspend-inhibited' : 'image://icon/system-suspend-uninhibited';
            onClicked: Stuff.toggleInhibit();
        }
    }
    // Component.onCompleted: print(JSON.stringify(NotificationProvider.toastsCount))
}
