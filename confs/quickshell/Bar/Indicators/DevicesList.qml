pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Quickshell
import "../../"

ScrollView {
    id: root

    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    //anchors.fill: parent

    ColumnLayout {

        anchors.fill: parent
        Layout.fillWidth: true
        spacing: 8
        Repeater {
            model: ScriptModel {
                values: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && object.isSink)
            }
            //model: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && object.isSink)
            DeviceEntry {
                id: outputs
                required property PwNode modelData
                readonly property bool isDefault: modelData == Pipewire.defaultAudioSink
                readonly property string icon: {
                    const prop = modelData.properties;
                    const api = prop["device.api"];
                    switch (api) {
                    case "bluez5":
                        return "audio-headphones";
                        break;
                    case "alsa":
                        if (modelData.name.toLowerCase().includes("controller")) {
                            return "input-gamepad";
                        } else if (modelData.name.toLowerCase().includes("hdmi")) {
                            return "monitor";
                        } else {
                            return "audio-card-analog";
                        }
                        break;
                    default:
                        return "audio-card-analog";
                        break;
                    }
                    // const default_icon = function() {
                    //     if (entry.node.isSink) {
                    //         // if (entry.node.name.toLowerCase().includes("controller")) {
                    //         //     return "input-gamepad";
                    //         // }
                    //         return "audio-card-analog";
                    //     } else {
                    //         return "audio-input-microphone"
                    //     }
                    // }
                    // if (prop === undefined || prop === null) {
                    //     return default_icon();
                    // } else {
                    //     const icon = prop["device.icon-name"];
                    //     if (icon) {
                    //         return icon;
                    //     } else {
                    //         return default_icon();
                    //     }
                    // }
                }
                node: modelData
                implicitHeight: 65
                Layout.fillWidth: true
                // icon: "audio-speakers"
                // Component.onCompleted: print(JSON.stringify(modelData, null, '\t'))
                // icon: "audio-card-analog"
                // icon: "audio-card-symbolic"
                //icon: "speaker-symbolic"
                // icon: "audio-card"

            }
        }
        Rectangle {
            id: seperator
            visible: inputs.count > 0
            Layout.fillWidth: true
            color: Config.colors.midlight
            implicitHeight: 1
        }
        Repeater {
            id: inputs
            model: ScriptModel {
                values: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && !object.isSink)
            }
            //model: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && !object.isSink)
            DeviceEntry {
                id: input
                // Component.onCompleted: print(JSON.stringify(modelData, null, '\t'))
                required property PwNode modelData
                readonly property bool isDefault: modelData == Pipewire.defaultAudioSource
                readonly property string icon: "audio-input-microphone"
                node: modelData
                implicitHeight: 65
                Layout.fillWidth: true
                // icon: "audio-input-microphone"
                // Component.onCompleted: print(modelData.ready)
            }
        }
    }
}
