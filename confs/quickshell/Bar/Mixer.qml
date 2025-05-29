pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import Quickshell
import Quickshell.Services.Pipewire
import "../Config"
import "../Components" as C

Rectangle {
    id: root

    // signal closePopup
    border {
        width: 1
        color: Colors.light
    }
    anchors.fill: parent
    color: Colors.background
    radius: Stuff.radius
    readonly property int entrySize: 64
    C.TabBar {
        id: header
        anchors {
            margins: 8
            top: parent.top
            right: parent.right
            left: parent.left
        }
        model: ["تطبيقات", "صوتيات"]
        height: 36
        implicitHeight: 46
        activeIndex: 0
        onActiveIndexChanged: {
            if (activeIndex == 0) {
                stackView.pop(null);
            } else if (activeIndex == 1) {
                stackView.push(devicesList);
            }
        }
    }
    component MixerEntry: Rectangle {
        id: entry
        required property PwNode node
        required property bool isDevice
        color: {
            if (entry.isDevice) {
                const activeColor = Colors.midlight;
                const inactiveColor = Colors.base;
                if (entry.node.isSink) {
                    // print(JSON.stringify(entry.node.properties, null, '\t'))
                    return (entry.node === Pipewire.defaultAudioSink) ? activeColor : inactiveColor;
                } else {
                    return (entry.node === Pipewire.defaultAudioSource) ? activeColor : inactiveColor;
                }
            } else {
                return Colors.midlight;
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        radius: Stuff.radius

        Loader {
            active: entry.isDevice
            anchors.fill: parent
            sourceComponent: MouseArea {
                onClicked: {
                    if (entry.node.ready) {
                        if (entry.node.isSink) {
                            Pipewire.preferredDefaultAudioSink = entry.node;
                        } else {
                            Pipewire.preferredDefaultAudioSource = entry.node;
                        }
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
            C.CircularSlider {
                id: slider
                Layout.alignment: Qt.AlignVCenter
                size: row.height
                value: entry.node.audio.volume
                pathColor: entry.node.audio.muted ? Colors.negative : Colors.text
                pathWidth: 3
                // iconSize: 30
                icon: {
                    if (entry.isDevice) {
                        return "audio-card";
                    } else {
                        let icon = "audio-player"; // default one
                        const props = entry.node.properties;
                        if (props["application.icon-name"] != undefined) {
                            icon = props["application.icon-name"];
                        } else if (props["application.process.binary"] != undefined) {
                            icon = props["application.process.binary"];
                        }
                        if (icon == "wine64-preloader")
                            icon = "wine";
                        return icon;
                    }
                }
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
                    text: {
                        if (entry.isDevice) {
                            return entry.node.nickname || entry.node.description;
                        } else {
                            const app = entry.node?.properties["application.name"] ?? (entry.node?.description != "" ? entry.node?.description : entry.node?.name);
                            const media = entry.node?.properties["media.name"];
                            return (media == undefined) ? app : media;
                        }
                    }
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    color: Colors.text
                    font {
                        kerning: false
                        weight: Font.Bold
                        pointSize: 10
                    }
                }
                Text {
                    text: {
                        if (entry.isDevice) {
                            return entry.node.description || entry.node.name;
                        } else {
                            return entry.node?.properties["application.name"] || entry.node.description;
                        }
                    }
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    renderType: Text.NativeRendering
                    textFormat: Text.PlainText
                    color: Colors.text
                    font {
                        kerning: false
                        weight: Font.Medium
                        pointSize: 8
                    }
                }
            }
        }
    }

    Component {
        id: streamsList
        ScrollView {
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            PwNodeLinkTracker {
                id: sinkTracker
                node: Pipewire.defaultAudioSink
            }
            PwNodeLinkTracker {
                id: sourceTracker
                node: {
                    const nodeName = Pipewire.defaultAudioSource?.name;
                    if (nodeName == null) {
                        return null;
                    }
                    const args = nodeName.split(".");
                    if (args[0] == "alsa_input") {
                        return Pipewire.defaultAudioSource;
                    } else {
                        return null;
                    }
                }
            }
            ColumnLayout {
                id: column
                anchors.fill: parent
                Layout.fillWidth: true
                spacing: 8
                readonly property list<PwNode> outputStreams: sinkTracker.linkGroups.map(o => o.source)
                readonly property list<PwNode> inputStreams: sourceTracker.linkGroups.map(o => o.target)
                // TODO profile which one is more expensive, binding or mapping the list twice
                PwObjectTracker {
                    objects: column.outputStreams
                }
                PwObjectTracker {
                    objects: column.inputStreams
                }
                Repeater {
                    model: column.outputStreams
                    MixerEntry {
                        required property PwNode modelData
                        node: modelData
                        isDevice: false
                        implicitHeight: root.entrySize
                        Layout.fillWidth: true
                    }
                }
                Rectangle {
                    id: seperator
                    visible: sources.count > 0
                    Layout.fillWidth: true
                    color: Colors.midlight
                    implicitHeight: 1
                }
                Repeater {
                    id: sources
                    model: column.inputStreams
                    MixerEntry {
                        required property PwNode modelData
                        node: modelData
                        isDevice: false
                        implicitHeight: root.entrySize
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
    Component {
        id: devicesList

        ScrollView {

            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            ColumnLayout {
                id: column
                anchors.fill: parent
                Layout.fillWidth: true
                spacing: 8

                // TODO profile which one is more expensive, binding or filtering the list twice
                readonly property list<PwNode> outputDevices: Pipewire.nodes.values.filter(object => object.audio !== null && !object.isStream && object.isSink)
                readonly property list<PwNode> inputDevices: Pipewire.nodes.values.filter(object => object.audio !== null && !object.isStream && !object.isSink)
                PwObjectTracker {
                    objects: column.outputDevices
                }
                PwObjectTracker {
                    objects: column.outputDevices
                }
                Repeater {
                    model: column.outputDevices
                    // model: ScriptModel {
                    //     values: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && object.isSink)
                    // }
                    MixerEntry {
                        required property PwNode modelData
                        node: modelData
                        isDevice: true
                        implicitHeight: root.entrySize
                        Layout.fillWidth: true
                    }
                }
                Rectangle {
                    id: seperator
                    visible: inputs.count > 0
                    Layout.fillWidth: true
                    color: Colors.midlight
                    implicitHeight: 1
                }
                Repeater {
                    id: inputs
                    model: column.inputDevices
                    MixerEntry {
                        required property PwNode modelData
                        node: modelData
                        isDevice: true
                        implicitHeight: root.entrySize
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
    Rectangle {
        id: mainView
        radius: Stuff.radius
        color: Colors.base
        anchors {
            // top: parent.top
            top: header.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: 8
        }
        border {
            width: 1
            color: Colors.light
        }
        clip: true
        StackView {
            id: stackView
            anchors {
                fill: parent
                margins: 6
            }
            initialItem: streamsList
        }
    }
}
