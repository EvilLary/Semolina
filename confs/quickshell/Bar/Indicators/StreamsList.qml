pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../Libs"
import "../../"
import Quickshell.Services.Pipewire

ScrollView {
    id: root

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    //anchors.fill: parent
    PwNodeLinkTracker {
        id: sourceTracker
        node: PipewireNodes.activeSource
    }
    PwNodeLinkTracker {
        id: sinkTracker
        node: PipewireNodes.activeSink
    }
    ColumnLayout {

        anchors.fill: parent
        Layout.fillWidth: true
        spacing: 8
        Repeater {
            model: sinkTracker.linkGroups

            StreamEntry {
                id: streamEntry
                required property var modelData
                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitHeight: 65
                // Application Audio >>> Output Device
                node: modelData.source
            }
        }
        Rectangle {
            id: seperator
            visible: sources.count > 0
            Layout.fillWidth: true
            color: Config.colors.midlight
            implicitHeight: 1
        }
        Repeater {
            id: sources
            model: sourceTracker.linkGroups
            StreamEntry {
                id: sourceEntry
                required property var modelData
                Layout.fillHeight: true
                Layout.fillWidth: true
                implicitHeight: 65
                // Input Device >>> PwNode "Applicaiton using Mic"
                node: modelData.target
            }
        }
    }
}
