pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }


    property PwNode activeSink: Pipewire.defaultAudioSink

    property PwNode activeSource: {

        //Checking if the node is an output, to prevent issues where this node would behave as the defaultAudioSink node,
        //causing issues like: unwanted loading of OSD, changing mic audio also changes sink audio
        const sourceName = Pipewire.defaultAudioSource.name
        const args = sourceName.split(".");
        const isSource = (args[0] == "alsa_input")

        if (isSource) {
            return Pipewire.defaultAudioSource
        }
        else {
            return null;
        }
    }
    property real sinkVolume: activeSink.audio.volume
    property real sourceVolume: activeSource.audio.volume

    property bool sinkMute: activeSink.audio.muted
    property bool sourceMute: activeSource.audio.muted

    property string sinkIcon: Quickshell.iconPath(getIcon((sinkVolume * 100),sinkMute,"audio-volume"))
    property string sourceIcon: Quickshell.iconPath(getIcon((sourceVolume * 100),sourceMute,"microphone-sensitivity"))


    function getIcon(volume, muted, prefix) {
        let icon = null;
        switch (true){

            case (volume <= 0) || muted :
                icon = prefix + "-muted";
                break;
            case (volume <= 25):
                icon = prefix + "-low";
                break;
            case (volume<= 75):
                icon = prefix + "-medium";
                break;
            case (volume > 75):
                icon = prefix + "-high";
                break;
            case (volume >= 100):
                icon = prefix + "-high-warning"
                break;
            defualt:
            icon = prefix + "-high-danger"
        }
        return icon;
    }
}
