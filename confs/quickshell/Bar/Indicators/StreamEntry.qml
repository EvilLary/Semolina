import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../../Libs"
import "../../Components"

Rectangle {
    id: entry

    required property PwNode node

    readonly property string nodeName: {
        const app = entry.node?.properties["application.name"] ?? (entry.node?.description != "" ? entry.node?.description : entry.node?.name);
        const media = entry.node?.properties["media.name"];
        return (media == undefined) ? app : media;
    }
    readonly property string nodeIcon: {
        var icon = "audio-player"; // default one
        let props = entry.node.properties;
        if (props["application.icon-name"] != undefined) {
            icon = props["application.icon-name"];
        } else if (props["application.process.binary"] != undefined) {
            icon = props["application.process.binary"];
        }
        if (icon == "wine64-preloader") icon = "wine";
        return icon
    }
    PwObjectTracker {
        id: tracker
        objects: [entry.node]
    }

    color: Qt.alpha(Config.colors.accent,0.4)
    radius: Config.globalRadius

    RowLayout {
        id: row
        anchors {
            fill: parent
            margins: 5
            rightMargin: 10
            leftMargin: 10
        }
        spacing: 15
        CircularSlider {
            id: slider
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: row.height
            implicitHeight: this.width

            startValue: -270
            value: entry.node?.audio?.volume
            iconSource: entry.nodeIcon
            iconSize: 30
            throbberColor: entry.node.audio.muted ? Config.colors.negative : Config.colors.text

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
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 5
            Text {
                text: entry.nodeName
                elide: Text.ElideRight
                Layout.fillWidth: true
                renderType: Text.NativeRendering
                horizontalAlignment: Qt.AlignLeft
                color: Config.colors.text
                font {
                    weight: Font.Bold
                    pointSize: 10
                }
            }
            Text {
                text: entry.node?.properties["application.name"] || entry.node.description
                renderType: Text.NativeRendering
                color: Config.colors.text
                font {
                    weight: Font.Medium
                    pointSize: 8
                }
            }
        }
    }
}
