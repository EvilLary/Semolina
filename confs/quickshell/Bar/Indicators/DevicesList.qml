pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:Libs"
import Quickshell.Services.Pipewire
import Quickshell
import 'root:Widgets/Mixer'

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
                values: Pipewire.nodes.values
                .filter(object =>
                    object.audio != null && !object.isStream && object.isSink
                )
            }
            //model: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && object.isSink)
            DeviceEntry {
                id: outputs
                required property PwNode modelData
                readonly property bool isDefault: modelData == Pipewire.defaultAudioSink
                node: modelData
                implicitHeight: 65
                Layout.fillWidth: true
                color: this.isDefault ? Qt.alpha(Config.colors.accent,0.8) : Qt.alpha(Config.colors.border,0.5)
                icon: "audio-speakers"
            }
        }
        Rectangle {
            id: seperator
            visible: inputs.count > 0
            Layout.fillWidth: true
            color: Qt.alpha(Config.colors.text,0.1)
            implicitHeight: 1
        }
        Repeater {
            id: inputs
            model: ScriptModel {
                values: Pipewire.nodes.values
                .filter(object =>
                    object.audio != null && !object.isStream && !object.isSink
                )
            }
            //model: Pipewire.nodes.values.filter(object => object.audio != null && !object.isStream && !object.isSink)
            DeviceEntry {
                id: input
                required property PwNode modelData
                readonly property bool isDefault: modelData == Pipewire.defaultAudioSource
                node: modelData
                implicitHeight: 65
                Layout.fillWidth: true
                color: this.isDefault ? Config.colors.accent : Qt.alpha(Config.colors.border,0.5)
                icon: "audio-input-microphone"
            }
        }
    }
}
