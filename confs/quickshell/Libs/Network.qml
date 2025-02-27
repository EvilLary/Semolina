pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import org.kde.plasma.networkmanagement as PlasmaNM

Singleton {
    id: root

    property alias icon: connectionIconProvider.connectionIcon
    
    property alias wifiStatus: enabledConnections.wirelessEnabled

    property alias connections: enabledConnections
    property alias status: networkStatus

    property var activeConnection

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
    PlasmaNM.NetworkStatus {
        id: networkStatus
    }
    //PlasmaNM.WirelessStatus {
    //    id: wirelessStatus
    //}
    PlasmaNM.EnabledConnections {
        id: enabledConnections
    }
    PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
    }
    //PlasmaNM.NetworkModel{
    //    id: networkModel
    //}
    //
    PlasmaNM.Handler {
        id: handler
    }

    function toggleWifi(): void {
        handler.enableWireless(!enabledConnections.wirelessEnabled)
    }
}
