import QtQuick
import Quickshell
import QtQuick.Layouts
import "root:Components"
import QtQuick.Controls
import Quickshell.Services.Pipewire
import "root:Services"

Popup {

    required property QsWindow window
    rootWindow: window

    required property bool isVisible
    targetVisible: isVisible

    PwNodeLinkTracker {
        id: linkTracker
        node: PipewireNodes.activeSink
    }
    PwObjectTracker { objects: [ linkTracker.linkGroups ] }


    ScrollView {
        anchors{
            fill: parent
            // margins: 10
        }
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        // ScrollBar.vertical.active: true
        ColumnLayout {
            spacing: 20
            anchors.fill: parent
            MixerEntry {
                node: PipewireNodes.activeSink
                image: "image://icon/audio-card"
            }
            MixerEntry {
                visible: PipewireNodes.activeSource != null
                node: PipewireNodes.activeSource
                image: "image://icon/audio-card"
            }
            Rectangle {
                Layout.fillWidth: true
                color: "#b9b9b9"
                opacity: 0.2
                implicitHeight: 1
            }
            Repeater {
                model: linkTracker.linkGroups

                MixerEntry {
                    required property PwLinkGroup modelData
                    node: modelData.source
                    image: {
                        let icon = "";
                        let props = modelData.source.properties;
                        if (props["application.icon-name"] != undefined) {
                            icon = props["application.icon-name"];
                        } else if (props["application.process.binary"] != undefined) {
                            icon = props["application.process.binary"];
                        }
                        if (icon == "wine64-preloader") icon = "wine";
                        return `image://icon/${icon}`
                    }
                }
            }
        }
    }
}
