// pragma Singleton
import QtQuick
import org.kde.plasma.networkmanagement as PlasmaNM

QtObject {
    id: root

    property alias icon: connectionIconProvider.connectionIcon

    property alias wifiStatus: enabledConnections.wirelessEnabled

    property alias connections: enabledConnections
    property alias status: networkStatus

    // property var activeConnection

    //Instantiator {
    //
    //    id: repeat
    //    model: networkModel
    //    asynchronous: false
    //    active: enabledConnections.wirelessEnabled
    //    //asynchronous: true
    //
    //    Connections {
    //        required property var modelData
    //        target: modelData
    //        Component.onCompleted: {
    //            if (wirelessStatus.wifiSSID == modelData.Name) {
    //                root.activeConnection = modelData
    //            }
    //        }
    //        Component.onDestruction: {
    //            root.activeConnection = null
    //        }
    //    }
    //}
    property PlasmaNM.NetworkStatus networkStatus: PlasmaNM.NetworkStatus {
        id: networkStatus
    }
    //PlasmaNM.WirelessStatus {
    //    id: wirelessStatus
    //}
    property PlasmaNM.EnabledConnections enabledConnections: PlasmaNM.EnabledConnections {
        id: enabledConnections
    }
    property PlasmaNM.ConnectionIcon connectionIconProvider: PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
    }
    //PlasmaNM.NetworkModel{
    //    id: networkModel
    //}
    //
    property PlasmaNM.Handler handler: PlasmaNM.Handler {
        id: handler
    }

    function toggleWifi(): void {
        handler.enableWireless(!enabledConnections.wirelessEnabled);
    }
}
