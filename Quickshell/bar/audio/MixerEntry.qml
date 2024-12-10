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
        }

        Label {
            text: {
                const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
                const media = node.properties["media.name"];
                return media != undefined ? `${app} - ${media}` : app;
            }
            //color: "white"
            Layout.fillWidth: true
        }
    }

    RowLayout {
        Button {
            icon {
                source: ((node.audio.volume == 0) || node.audio.muted) ? "audio-volume-muted" : "audio-volume-high"
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
            WheelHandler {
                onWheel: event => {
                    event.accepted = true;
                    const step = Math.sign(event.angleDelta.y);
                    if (step >= 1) {
                        slider.value += 0.05
                    }
                    else {
                        slider.value -= 0.05
                    }
                }
            }

            onValueChanged: node.audio.volume = value
        }
        Label {
            text: `${Math.floor(node.audio.volume * 100)}%`
        }
    }
}

