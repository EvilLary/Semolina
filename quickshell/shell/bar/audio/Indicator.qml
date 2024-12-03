import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."
// import "root:."
import "root:./Services"
import org.kde.plasma.networkmanagement as PlasmaNM
BarWidgetInner {
    id: root
    property bool openMixer
    implicitHeight: column.implicitHeight + 30
    PlasmaNM.NetworkStatus {
       id: networkStatus
   }
   PlasmaNM.ConnectionIcon {
       id: connectionIconProvider
       connectivity: networkStatus.connectivity
   }
    ColumnLayout {
        id: column
        spacing: 10
        implicitHeight: childrenRect.height;
        anchors.centerIn: parent

        //SPEAKERS
        Audio {
            Layout.fillWidth: true
            node: PipewireNodes.activeSink
            icon: PipewireNodes.sinkIcon
        }
        //MIC
        Audio {
            Layout.fillWidth: true
            visible: PipewireNodes.activeSource != null
            node: PipewireNodes.activeSource
            icon: PipewireNodes.sourceIcon
        }
        // NETWORK
        Widget {
            Layout.fillWidth: true;
            iconSource: Quickshell.iconPath(connectionIconProvider.connectionIcon)
        }
    }
}
