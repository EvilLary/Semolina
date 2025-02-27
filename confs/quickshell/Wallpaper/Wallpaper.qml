import QtQuick
import Quickshell
import Quickshell.Wayland
import "root:Libs"
import Quickshell.Widgets
//import QtMultimedia

PanelWindow {
    id: background
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    WlrLayershell.namespace: "wallpaper"
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Normal
    color: "black"

    //MediaPlayer {
    //    id: player
    //    loops: MediaPlayer.Infinite
    //    videoOutput: videoView
    //    source: "root:Wallpaper/Beautiful-Outdoors.mp4"
    //    autoPlay: true
    //}
    ClippingRectangle {
        anchors {
            fill: parent
            //topMargin: 0
            bottomMargin: 0
            margins: 8
        }
        radius: Config.globalRadius * 1.5
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
        Image {
            id: backgroundImage
            anchors.fill: parent
            smooth: false
            asynchronous: true
            cache: false
            sourceSize {
                width: 1920
                height: 1080
            }
            fillMode: Image.PreserveAspectCrop
            source: Config.backgroundSource
        }
    }
}
