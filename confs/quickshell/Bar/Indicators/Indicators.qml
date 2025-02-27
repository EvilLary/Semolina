import QtQuick
import QtQuick.Layouts
import "../../Libs"
import "../../Components"

Item {
    id: indicators
    
    required property var bar
    implicitWidth: row.implicitWidth + 20

    Popup {
        id: mixer
        rootWindow: indicators.bar
        parentItem: indicators
        contentUrl: "root:/Bar/Indicators/Mixer.qml"
        //WHY THE HELL I CAN'T PUT MIXER IN A FOLDER, IT USED TO WORK
        //contentItem: Loader {
        //    active: mixer.isOpen
        //    anchors.fill: parent
        //    sourceComponent: Mixer {
        //        anchors.fill: parent
        //    }
        //}
        offsetX: -55
        //offsetY: 20
        popupHeight: 500
        popupWidth: 500
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        Layout.fillHeight: true
        
        //Could add a battery indicator here but I don't have a laptop
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
            implicitWidth: 42
            implicitHeight: 42

            startValue: -270
            value: Brightness.value / 100
            iconSource: Brightness.icon
            throbberColor: Config.colors.text

            onScrollUp: Brightness.adjust('+5')
            onScrollDown: Brightness.adjust('-5')
        }
        CircularSlider {
            id: sinkControl
            implicitWidth: 42
            implicitHeight: 42

            startValue: -270
            value: PipewireNodes.sinkVolume
            iconSource: PipewireNodes.sinkIcon
            throbberColor: PipewireNodes.sinkMute ? Config.colors.negative : Config.colors.text

            onLeftClick: PipewireNodes.toggleMute("sink")
            onRightClick: mixer.open()

            onScrollUp: PipewireNodes.increaseVolume("sink")
            onScrollDown: PipewireNodes.decreaseVolume("sink")
        }
        CircularSlider {
            id: sourceControl
            visible: PipewireNodes.activeSource != null
            implicitWidth: 42
            implicitHeight: 42

            startValue: -270
            value: PipewireNodes.sourceVolume
            iconSource: PipewireNodes.sourceIcon
            throbberColor: PipewireNodes.sourceMute ? Config.colors.negative : Config.colors.text

            onLeftClick: PipewireNodes.toggleMute("source")
            onRightClick: mixer.open()

            onScrollUp: PipewireNodes.increaseVolume("source")
            onScrollDown: PipewireNodes.decreaseVolume("source")
        }
    }
}
