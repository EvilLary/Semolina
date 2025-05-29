import QtQuick
import QtQuick.Layouts
import "../Config"
import "../Services"
import "../Components" as C

Item {
    id: indicators
    height: column.height + 16
    required property var bar

    C.Popup {
        id: screenSettings
        width: 175
        height: 50
        itemUrl: Qt.resolvedUrl("./NlPopup.qml")
        bar: indicators.bar
        parentItem: indicators
        yMargin: indicators.mapToItem(bright, 0, this.height / 2).y
    }
    C.Popup {
        id: mixer
        width: 500
        height: 450
        itemUrl: Qt.resolvedUrl("./Mixer.qml")
        bar: indicators.bar
        parentItem: indicators
    }

    ColumnLayout {
        id: column
        anchors.centerIn: parent
        width: parent.width
        Layout.alignment: Qt.AlignCenter
        spacing: 10

        C.CircularSlider {
            id: bright
            Layout.alignment: Qt.AlignCenter
            icon: Misc.nightlight.status ? "redshift-status-on-symbolic" : Brightness.icon
            value: Brightness.currentBrightness / 100
            // onScrollUp: Misc.nightlight.temperature += 250
            // onScrollDown: Misc.nightlight.temperature -= 250
            onScrollUp: Brightness.adjust("+5")
            onScrollDown: Brightness.adjust("-5")
            onRightClick: screenSettings.toggle()
            onLeftClick: Misc.nightlight.toggle()
            // showTooltip: true
            // tooltipText: `Monitor Brightness: ${Brightness.currentBrightness}%\nNight Light: ${Misc.nightlight.status ? "On" : "Off"}`
        }
        C.CircularSlider {
            id: sink
            Layout.alignment: Qt.AlignCenter
            icon: Audio.sinkIcon
            value: Audio.sinkVolume
            pathColor: Audio.sinkMute ? Colors.negative : Colors.text
            onScrollUp: Audio.adjustSinkVol(0.05)
            onScrollDown: Audio.adjustSinkVol(-0.05)
            onLeftClick: Audio.toggleMuteSink()
            onRightClick: mixer.toggle()
            // showTooltip: true
            // tooltipText: `Current Output: ${Audio.activeSink?.nickname || Audio.activeSink?.name}`
        }
        C.CircularSlider {
            id: source
            visible: Audio.activeSource !== null
            Layout.alignment: Qt.AlignCenter
            icon: Audio.sourceIcon
            value: Audio.sourceVolume
            onScrollUp: Audio.adjustSourceVol(0.05)
            onScrollDown: Audio.adjustSourceVol(-0.05)
            onLeftClick: Audio.toggleMuteSource()
            onRightClick: mixer.toggle()
            // showTooltip: true
            // tooltipText: `Current Input: ${Audio.activeSource?.nickname || Audio.activeSource?.name}`
        }
    }
}
