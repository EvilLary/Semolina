import QtQuick
import "../../Components"
import "../../"
import Quickshell.Services.Pipewire
import QtQuick.Layouts

Rectangle {
    id: entry

    required property PwNode node
    PwObjectTracker {
        objects: [entry.node]
    }

    color: this.isDefault ? Qt.darker(Config.colors.accent, 1.5) : Qt.darker(Config.colors.altBase, 2)
    radius: Config.globalRadius
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            // print(JSON.stringify(entry.node, null, '\t'));
            if (entry.node.ready) {
                if (entry.node.isSink) {
                    Pipewire.preferredDefaultAudioSink = entry.node;
                } else {
                    Pipewire.preferredDefaultAudioSource = entry.node;
                }
            }
        }
    }

    RowLayout {
        id: row
        anchors {
            fill: parent
            margins: 5
            rightMargin: 10
            leftMargin: 10
        }
        Layout.alignment: Qt.AlignVCenter
        spacing: 15
        CircularSlider {
            id: slider
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: row.height
            implicitHeight: this.width

            startValue: -270
            value: entry.node.audio.volume
            throbberColor: entry.node.audio.muted ? Config.colors.negative : Config.colors.text
            iconSize: 30
            iconSource: entry.icon
            onScrollUp: {
                if (!entry.node.ready)
                    return;
                const newVolume = entry.node.audio.volume + 0.05;
                entry.node.audio.volume = Math.min(newVolume, 1);
            }
            onScrollDown: {
                if (!entry.node.ready)
                    return;
                const newVolume = entry.node.audio.volume - 0.05;
                entry.node.audio.volume = Math.max(newVolume, 0);
            }
            onLeftClick: {
                if (!entry.node.ready)
                    return;
                entry.node.audio.muted = !entry.node.audio.muted;
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            spacing: 5
            Text {
                text: entry.node.nickname || entry.node.description
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                renderType: Text.NativeRendering
                color: Config.colors.text
                font {
                    weight: Font.Bold
                    pointSize: 10
                }
            }
            Text {
                text: entry.node.description
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                renderType: Text.NativeRendering
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                color: Config.colors.text
                font {
                    weight: Font.Medium
                    pointSize: 8
                }
            }
        }
    }
}
