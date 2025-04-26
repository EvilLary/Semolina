import QtQuick
import Quickshell
import Quickshell.Wayland
import "../"
// import "../Components" as C
import Quickshell.Widgets
import QtQuick.Effects
// import Qt5Compat.GraphicalEffects

//import QtMultimedia

WlrLayershell {
    id: background
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    namespace: "wallpaper"
    layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    color: "black"

    //MediaPlayer {
    //    id: player
    //    loops: MediaPlayer.Infinite
    //    videoOutput: videoView
    //    source: "root:Wallpaper/Beautiful-Outdoors.mp4"
    //    autoPlay: true
    //}

    // Rectangle {
    //     id: blurred
    //     anchors {
    //         fill: parent
    //     }
    //     color: "transparent"
    // }
    MultiEffect {
        anchors.fill: parent
        source: backgroundImage
        blurEnabled: true
        blur: 0.8
        brightness: -0.1
        saturation: -0.5
        shadowEnabled: false
        shadowColor: Config.colors.shadow
        shadowScale: 1
    }
    // FastBlur {
    //     anchors.fill: blurred
    //     source: backgroundImage
    //     radius: 30
    //     //samples: 10
    //     layer {
    //         enabled: true
    //         effect: HueSaturation {
    //             cached: true
    //             lightness: -0.5
    //             saturation: 1
    //         }
    //     }
    // }
    ClippingRectangle {
        anchors {
            fill: parent
            //topMargin: 0
            bottomMargin: Config.barHeight
            margins: Config.wallpaperGabs
        }
        color: "transparent"
        radius: Config.globalRadius
        // border {
        //     width: 2
        //     color: Qt.alpha(Config.colors.accent,0.5)
        // }
        Image {
            id: backgroundImage
            anchors.fill: parent
            smooth: false
            asynchronous: true
            // cache: false
            // sourceSize {
            //     width: 1920
            //     height: 1080
            // }
            fillMode: Image.PreserveAspectCrop
            source: Config.backgroundSource
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!appMenu.visible) {
                        appMenu.popup();
                    }
                }
            }
            AppMenu {
                id: appMenu
                // width: 225
            }
        }
        // C.AnalogClock {
        //     anchors {
        //         top: parent.top
        //         right: parent.right
        //         margins: 50
        //     }
        //     size: 250
        //     layer {
        //         enabled: false
        //         effect: DropShadow {
        //             radius: 8.0
        //             color: Config.colors.shadow
        //             // spread: 0
        //             // samples: 10
        //         }
        //     }
        // }
        //Video {
        //    source: "root:Wallpaper/Beautiful-Outdoors.mp4"
        //    autoPlay: true
        //    anchors.fill: parent
        //    loops: MediaPlayer.Infinite
        //    fillMode: VideoOutput.PreserveAspectCrop
        //}
        //VideoOutput {
        //    id: videoView
        //    fillMode: VideoOutput.PreserveAspectCrop
        //    anchors.fill: parent
        //}
    }
}
