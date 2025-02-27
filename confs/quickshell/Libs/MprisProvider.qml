pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {

    id: root
    property MprisPlayer trackedPlayer
    Instantiator {
        model: Mpris.players.values

        Connections {
            id: connection
            required property var modelData
            target: modelData
            Component.onCompleted: {
                if (root.trackedPlayer == null ) {
                    root.trackedPlayer = modelData
                } else if (modelData.identity == "VLC media player") {
                    root.trackedPlayer = modelData
                }
            }
            Component.onDestruction: {
                if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    for (const player of Mpris.players.values) {
                        if (player.playbackState.isPlaying) {
                            root.trackedPlayer = player;
                            break;
                        }
                    }

                    if (trackedPlayer == null && Mpris.players.values.length != 0) {
                        trackedPlayer = Mpris.players.values[0];
                    }
                }
            }
            //Component.onDestruction: {
            //    root.trackedPlayer = null
            //}
            //function onPlaybackStateChanged() {
            //    root.trackedPlayer = connection.modelData;
            //}
            //function onTrackChanged() {
            //    root.trackedPlayer = connection.modelData
            //}
        }
    }
}
