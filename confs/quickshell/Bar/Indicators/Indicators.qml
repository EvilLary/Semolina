import QtQuick
import QtQuick.Layouts
import "../../Libs"
import "../../"
import "../../Components"

Item {
    id: indicators

    required property var bar
    implicitWidth: row.implicitWidth + 20
    readonly property int modulesWidth: 42
    readonly property real iconSize: modulesWidth * 5.5 / 10

    Popup {
        id: mixer
        rootWindow: indicators.bar
        parentItem: indicators
        contentUrl: "root:/Bar/Indicators/Mixer.qml"
        popupHeight: 500
        popupWidth: 500
    }

    Brightness {
        id: brightness
    }
    RowLayout {
        id: row
        anchors.centerIn: parent
        Layout.fillHeight: true

        //CircularSlider {
        //    id: wifi
        //    implicitWidth: 42
        //    implicitHeight: 42
        //
        //    startValue: -270
        //    value: Network?.activeConnection?.Signal / 100
        //    iconSource: Network.icon
        //    throbberColor: Config.colors.text
        //    acceptedButtons: Qt.NoButton
        //}
        CircularSlider {
            id: displayBrightness
            implicitWidth: indicators.modulesWidth
            implicitHeight: indicators.modulesWidth
            iconSize: indicators.iconSize

            startValue: -270
            value: brightness.value / 100
            iconSource: brightness.icon
            throbberColor: Config.colors.text

            onScrollUp: brightness.adjust('+5')
            onScrollDown: brightness.adjust('-5')
        }
        CircularSlider {
            id: sinkControl
            implicitWidth: indicators.modulesWidth
            implicitHeight: indicators.modulesWidth
            iconSize: indicators.iconSize

            startValue: -270
            value: PipewireNodes.sinkVolume
            iconSource: PipewireNodes.sinkIcon
            throbberColor: PipewireNodes.sinkMute ? Config.colors.negative : Config.colors.text

            onLeftClick: PipewireNodes.toggleMuteSink()
            onRightClick: mixer.toggle()

            onScrollUp: PipewireNodes.incSinkVol()
            onScrollDown: PipewireNodes.decSinkVol()
        }
        CircularSlider {
            id: sourceControl
            visible: PipewireNodes.activeSource != null
            implicitWidth: indicators.modulesWidth
            implicitHeight: indicators.modulesWidth
            iconSize: indicators.iconSize

            startValue: -270
            value: PipewireNodes.sourceVolume
            iconSource: PipewireNodes.sourceIcon
            throbberColor: PipewireNodes.sourceMute ? Config.colors.negative : Config.colors.text

            onLeftClick: PipewireNodes.toggleMuteSource()
            onRightClick: mixer.toggle()

            onScrollUp: PipewireNodes.incSourceVol()
            onScrollDown: PipewireNodes.decSourceVol()
        }
    }
}
