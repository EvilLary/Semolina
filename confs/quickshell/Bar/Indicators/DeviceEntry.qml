import QtQuick
import "root:Libs"
import "root:Components"
import Quickshell.Services.Pipewire
import QtQuick.Layouts

Rectangle {
    id: entry

    required property PwNode node
    property alias icon: slider.iconSource
    PwObjectTracker {objects: [entry.node]}
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
            if (entry.node.isSink) {
                Pipewire.preferredDefaultAudioSink = entry.node
            } else {
                Pipewire.preferredDefaultAudioSource = entry.node
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
            onScrollUp: {
                const newVolume = entry.node.audio.volume + 0.05
                entry.node.audio.volume = Math.min(newVolume,1)
            }
            onScrollDown: {
                const newVolume = entry.node.audio.volume - 0.05
                entry.node.audio.volume = Math.max(newVolume,0)
            }
            onLeftClick: entry.node.audio.muted = !entry.node.audio.muted
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Layout.fillHeight: true
            spacing: 5
            Text {
                text: entry.node.nickname
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
