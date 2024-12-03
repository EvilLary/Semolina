import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
ColumnLayout {
    required property PwNode node;
    required property string image;
    PwObjectTracker {objects: [node]}
    RowLayout {
        Layout.fillWidth: true

        IconImage {
            visible: source != ""
            asynchronous: true
            source: image
            implicitSize: 24
            // Layout.leftMargin: 4
        }

        Label {
            text: {
                const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
                const media = node.properties["media.name"];
                return media != undefined ? `${app} - ${media}` : app;
            }
            // elide: Text.ElideRight
            // wrapMode: Text.NoWrap
            Layout.fillWidth: true
        }
    }

    RowLayout {
        // Layout.leftMargin: 10
        // Layout.rightMargin: 10
        Button {
            // text: node.audio.muted
            // icon.source: "audio-volume-high-symbolic"
            icon {
                source: ((node.audio.volume == 0) || node.audio.muted) ? "audio-volume-muted" : "audio-volume-high-symbolic"
                width: 20
                height: 20
            }
            hoverEnabled: true
            flat: true
            onClicked: node.audio.muted= !node.audio.muted
        }
        Slider {
            id: slider
            Layout.preferredWidth: 403
            value: node.audio.volume
            // snapMode: Slider.NoSnap
            WheelHandler {
                orientation: Qt.Vertical | Qt.Horizontal
                property int wheelDelta: 0
                acceptedButtons: Qt.NoButton
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: wheel => {
                    const delta = (wheel.angleDelta.y || -wheel.angleDelta.x) * (wheel.inverted ? -1 : 1)
                    wheelDelta += delta;
                    while (wheelDelta >= 120) {
                        wheelDelta -= 120;
                        slider.value += 0.025
                    }
                    while (wheelDelta <= -120) {
                        wheelDelta += 120;
                        slider.value -= 0.025
                    }
                }
            }
            // live: true
            onValueChanged: node.audio.volume = value
        }
        Label {
            // Layout.preferredWidth: 50
            text: `${Math.floor(node.audio.volume * 100)}%`
        }

    }
}

