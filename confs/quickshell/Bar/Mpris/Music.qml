import QtQuick
import QtQuick.Layouts
import "../../Libs"
import Quickshell.Widgets
import "../../Components"

MouseArea {
    id: root

    //visible: MprisProvider.trackedPlayer != null

    property string artUrl: MprisProvider?.trackedPlayer?.trackArtUrl || "image://icon/audio-player"
    property string trackTitle: MprisProvider?.trackedPlayer?.trackTitle || "....."
    property string trackArtist: MprisProvider?.trackedPlayer?.trackArtist || "....."

    implicitWidth: row.implicitWidth
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 5
        Layout.alignment: Qt.AlignVCenter
        //layoutDirection: Qt.RightToLeft
        ClippingRectangle {
            implicitHeight: 42
            implicitWidth: 42
            radius: 5
            color: "transparent"
            Image {
                anchors.fill: parent
                source: root.artUrl
                retainWhileLoading: true
                smooth: true
                asynchronous: true
                cache: false
                sourceSize {
                    width: 40
                    height: 40
                }
                fillMode: Image.PreserveAspectCrop
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 2
            Text {
                Layout.maximumWidth: 220
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                text: root.trackTitle
                elide: Text.ElideRight
                color: Config.colors.text
                lineHeight: 0
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                maximumLineCount: 1
                renderType: Text.NativeRendering
                font {
                    weight: Font.Bold
                    pointSize: 10
                }
            }
            Text {
                //Layout.fillWidth: true
                Layout.maximumWidth: 220
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                text: root.trackArtist
                color: Config.colors.text
                elide: Text.ElideRight
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                lineHeight: 0
                maximumLineCount: 1
                renderType: Text.NativeRendering
                font {
                    weight: Font.DemiBold
                    pointSize: 8
                }
            }
        }
        CircularSlider {
            Layout.rightMargin: 5
            implicitHeight: 42
            implicitWidth: 42
            iconSource: MprisProvider.trackedPlayer.isPlaying ? 'media-play' : 'media-pause'
            startValue: -270
            value: MprisProvider.trackedPlayer.volumeSupported ? MprisProvider.trackedPlayer.volume : 0
            onClicked: {
                if (MprisProvider.trackedPlayer.canPlay) {
                    MprisProvider.trackedPlayer.togglePlaying();
                }
            }
            onScrollUp: {
                if (MprisProvider.trackedPlayer.volumeSupported) {
                    let newValue = Math.min(MprisProvider.trackedPlayer.volume + 0.05, 1)
                    MprisProvider.trackedPlayer.volume = newValue
                }
            }
            onScrollDown: {
                if (MprisProvider.trackedPlayer.volumeSupported) {
                    let newValue = Math.max(MprisProvider.trackedPlayer.volume - 0.05,0)
                    MprisProvider.trackedPlayer.volume = newValue
                }
            }
            Component.onCompleted: print(height)
        }
    }
}
