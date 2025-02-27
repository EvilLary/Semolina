pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    signal showOsd(icon: string, value: real, text: string, sliderVisible: bool)

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    property PwNode activeSink: Pipewire.defaultAudioSink || null
    property PwNode activeSource: root.getActiveSink();

    property real sinkVolume: activeSink?.audio?.volume || 0
    property real sourceVolume: activeSource?.audio?.volume || 0

    property bool sinkMute: activeSink?.audio?.muted ?? true
    property bool sourceMute: activeSource?.audio?.muted ?? true

    property string sinkIcon: getIcon(Math.floor(root.sinkVolume * 100),sinkMute,"audio-volume")
    property string sourceIcon: getIcon(Math.floor(root.sourceVolume * 100),sourceMute,"microphone-sensitivity")

    function decreaseVolume(target: string): void {
        if (target == "source") {
            const newVolume = root.sourceVolume - 0.05;
            root.activeSource.audio.volume = Math.max(newVolume,0);
            if (Math.floor(root.sourceVolume * 100) == 0) {
                root.showOsd(root.sourceIcon,root.sourceVolume,"Muted",false);
            }
            else {
                root.showOsd(root.sourceIcon,root.sourceVolume,"",true);
            }
        }
        else {
            const newVolume = root.sinkVolume - 0.05;
            root.activeSink.audio.volume = Math.max(newVolume,0);
            if (Math.floor(root.sinkVolume * 100) == 0) {
                root.showOsd(root.sinkIcon,root.sinkVolume,"Muted",false);
            }
            else {
                root.showOsd(root.sinkIcon,root.sinkVolume,"",true);
            }
        }
    }
    function increaseVolume(target): void {
        if (target == "source") {
            const newVolume = root.sourceVolume + 0.05;
            root.activeSource.audio.volume = Math.min(newVolume,1);
            root.showOsd(root.sourceIcon,root.sourceVolume,"",true);
        }
        else {
            const newVolume = root.sinkVolume + 0.05;
            root.activeSink.audio.volume = Math.min(newVolume,1);
            root.showOsd(root.sinkIcon,root.sinkVolume,"",true);
        }
    }
    function toggleMute(target: string): void {
        if (target == "source") {
            root.activeSource.audio.muted = !root.activeSource.audio.muted;
            root.showOsd(root.sourceIcon,root.sourceVolume,"Muted",!sourceMute);
        }
        else {
            root.activeSink.audio.muted = !root.activeSink.audio.muted;
            root.showOsd(root.sinkIcon,root.sinkVolume,"Muted",!sinkMute);
        }
    }
    function getIcon(volume, muted, prefix): string {
        let icon = null;
        switch (true){

            case (volume <= 0) || muted :
                icon = prefix + "-muted-symbolic";
                break;
            case (volume <= 25):
                icon = prefix + "-low-symbolic";
                break;
            case (volume <= 75):
                icon = prefix + "-medium-symbolic";
                break;
            case (volume > 75):
                icon = prefix + "-high-symbolic";
                break;
            case (volume >= 100):
                icon = prefix + "-high-warning-symbolic";
                break;
            defualt:
                icon = prefix + "-high-danger-symbolic";
                break;
        }
        return icon;
    }
    function getActiveSink(): PwNode {
        //Checking if the node is an output, to prevent issues where this node would behave as the defaultAudioSink node,
        const nodeName = Pipewire.defaultAudioSource?.name;
        if (nodeName == null) {
            return null;
        }
        const args = nodeName.split(".");
        if (args[0] == "alsa_input") {
            return Pipewire.defaultAudioSource;
        }
        else {
            return null;
        }
    }
}

