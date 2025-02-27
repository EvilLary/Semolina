import QtQuick
import QtQuick.Layouts
import "root:Libs"
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

Rectangle {
    id: mpris
    radius: Config.globalRadius
    width: 500
    height: 200
    color: Config.colors.background
    border {
        width: 1
        color: Qt.alpha(Config.colors.text,0.2)
    }

    Loader {
        active: MprisProvider.trackedPlayer.trackArtUrl != ""
        anchors.fill: parent
        sourceComponent: ClippingRectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: Config.globalRadius
            Image {
                id: trackImg
                anchors.fill: parent
                visible: true
                smooth: false
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                source: MprisProvider.trackedPlayer.trackArtUrl
                retainWhileLoading: true
                sourceSize {
                    width: 100
                    height: 100
                }
                layer.enabled: true
                layer.effect: FastBlur {
                    radius: 42
                    transparentBorder: false
                    layer.enabled: true
                    layer.effect: HueSaturation {
                        lightness: -0.6
                        saturation: 1
                    }
                }
            }
        }
    }
    Rectangle {
        anchors {
            fill: parent
            margins: 10
        }
        //radius: 10
        color: "transparent"
        ColumnLayout {
            id: trackInfo
            spacing: 10
            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
                topMargin: mpris.height / 6
            }
            Text {
                id: trackTitle
                text: MprisProvider.trackedPlayer.trackTitle
                renderType: Text.NativeRendering
                Layout.fillWidth: true
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                elide: Text.ElideRight
                lineHeight: 0
                color: Config.colors.text
                font {
                    weight: Font.Bold
                    pointSize: 13
                }
            }
            Text {
                id: trackArtist
                text: MprisProvider.trackedPlayer.trackArtist
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                elide: Text.ElideRight
                lineHeight: 0
                renderType: Text.NativeRendering
                color: Qt.alpha(Config.colors.text,0.8)
                font {
                    weight: Font.DemiBold
                    pointSize: 9
                }
            }
        }
        RowLayout {
            height: 60
            spacing: 0
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 0
                margins: 10
            }

            MediaControl {
                visible: MprisProvider.trackedPlayer.loopSupported
                Layout.fillHeight: true
                Layout.rightMargin: 50
                iconSource: {
                    switch (MprisProvider.trackedPlayer.loopState) {
                        case (2):
                            return "image://icon/media-playlist-repeat-symbolic"
                        ;;
                        case (1):
                            return "image://icon/media-playlist-repeat-song-symbolic";
                        ;;
                        case (0):
                            return "image://icon/media-playlist-no-repeat-symbolic"
                    }
                }
                onClicked:  {
                    if (MprisProvider.trackedPlayer.loopState == 2) {
                        MprisProvider.trackedPlayer.loopState = 0
                    }
                    else {
                        MprisProvider.trackedPlayer.loopState += 1
                    }
                }
            }
            MediaControl {
                visible: MprisProvider.trackedPlayer.canGoPrevious
                Layout.fillHeight: true
                iconSource: "image://icon/media-skip-backward-symbolic"
                iconSize: 22
                onClicked: MprisProvider.trackedPlayer.previous()
            }
            MediaControl {
                Layout.fillHeight: true
                iconSource: MprisProvider.trackedPlayer.isPlaying ? "image://icon/media-playback-pause-symbolic" : "image://icon/media-playback-start-symbolic"
                iconSize: 36
                onClicked: MprisProvider.trackedPlayer.togglePlaying()
            }
            MediaControl {
                visible: MprisProvider.trackedPlayer.canGoNext
                Layout.fillHeight: true
                iconSource: "image://icon/media-skip-forward-symbolic"
                iconSize: 22
                onClicked: MprisProvider.trackedPlayer.next()
            }
            MediaControl {
                visible: MprisProvider.trackedPlayer.shuffleSupported
                Layout.fillHeight: true
                iconSource: MprisProvider.trackedPlayer.shuffle ? "image://icon/media-playlist-shuffle-symbolic" : "image://icon/media-playlist-no-shuffle-symbolic"
                onClicked: MprisProvider.trackedPlayer.shuffle = !MprisProvider.trackedPlayer.shuffle
                Layout.leftMargin: 50
            }
        }
    }
}
