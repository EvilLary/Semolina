pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

Singleton {
    id: root

    signal showOsd(icon: string, value: real, text: string, sliderVisible: bool)

    readonly property PwNode activeSink: Pipewire.ready ? Pipewire.defaultAudioSink : null
    readonly property PwNode activeSource: Pipewire.ready ? root.getActiveSink() : null

    PwObjectTracker {
        objects: [root.activeSink, root.activeSource]
    }

    Connections {
        target: Pipewire
        function onDefaultAudioSinkChanged() {
            if (Pipewire.ready) {
                if (Pipewire.defaultAudioSink !== null) {
                    root.showOsd("audio-card-symbolic", 0, Pipewire.defaultAudioSink.nickname || Pipewire.defaultAudioSink.description, false);
                }
            }
        }
    }
    readonly property real sinkVolume: (activeSink?.ready) ? activeSink?.audio?.volume : 0
    readonly property real sourceVolume: (activeSource?.ready) ? activeSource?.audio?.volume : 0

    readonly property bool sinkMute: (activeSink?.ready) ? activeSink?.audio?.muted : true
    readonly property bool sourceMute: (activeSource?.ready) ? activeSource?.audio?.muted : true

    property string sinkIcon: getIcon(Math.floor(root.sinkVolume * 100), sinkMute, "audio-volume")
    property string sourceIcon: getIcon(Math.floor(root.sourceVolume * 100), sourceMute, "microphone-sensitivity")

    function decSinkVol(): void {
        const newVolume = root.sinkVolume - 0.05;
        root.activeSink.audio.volume = Math.max(newVolume, 0);
        if (Math.floor(root.sinkVolume * 100) == 0) {
            root.showOsd(root.sinkIcon, root.sinkVolume, "Muted", false);
        } else {
            root.showOsd(root.sinkIcon, root.sinkVolume, "", true);
        }
    }
    function decSourceVol(): void {
        const newVolume = root.sourceVolume - 0.05;
        root.activeSource.audio.volume = Math.max(newVolume, 0);
        if (Math.floor(root.sourceVolume * 100) == 0) {
            root.showOsd(root.sourceIcon, root.sourceVolume, "Muted", false);
        } else {
            root.showOsd(root.sourceIcon, root.sourceVolume, "", true);
        }
    }
    function incSinkVol(): void {
        const newVolume = root.sinkVolume + 0.05;
        root.activeSink.audio.volume = Math.min(newVolume, 1);
        root.showOsd(root.sinkIcon, root.sinkVolume, "", true);
    }
    function incSourceVol(): void {
        const newVolume = root.sourceVolume + 0.05;
        root.activeSource.audio.volume = Math.min(newVolume, 1);
        root.showOsd(root.sourceIcon, root.sourceVolume, "", true);
    }
    function toggleMuteSink(): void {
        root.activeSink.audio.muted = !root.activeSink.audio.muted;
        root.showOsd(root.sinkIcon, root.sinkVolume, "Muted", !sinkMute);
    }
    function toggleMuteSource(): void {
        root.activeSource.audio.muted = !root.activeSource.audio.muted;
        root.showOsd(root.sourceIcon, root.sourceVolume, "Muted", !sourceMute);
    }
    function getIcon(volume: string, muted: bool, prefix: string): string {
        let icon = new String();
        switch (true) {
        case (volume <= 0) || muted:
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
            defualt: icon = prefix + "-high-danger-symbolic";
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
        } else {
            return null;
        }
    }

    Timer {
        id: timer
        interval: 75
        repeat: false
        function setTimeout(target) {
            timer.triggered.connect(target);
            timer.triggered.connect(function release() {
                timer.triggered.disconnect(target);
                timer.triggered.disconnect(release);
            });
            timer.start();
        }
    }
    GlobalShortcut {
        name: "toggleMuteSource"
        description: "toggles the default source"
        onPressed: root.toggleMuteSource()
    }
    GlobalShortcut {
        id: dcSourceVol
        name: "decreaseSourceVolume"
        onPressed: dcSourceVol.event()
        function event(): void {
            root.decSourceVol();
            timer.setTimeout(function () {
                if (dcSourceVol.pressed)
                    dcSourceVol.event();
            });
        }
    }
    GlobalShortcut {
        id: inSourceVol
        name: "increaseSourceVolume"
        onPressed: inSourceVol.event()
        function event(): void {
            root.incSourceVol();
            timer.setTimeout(function () {
                if (inSourceVol.pressed)
                    inSourceVol.event();
            });
        }
    }

    GlobalShortcut {
        name: "toggleMuteSink"
        description: "toggles the default sink"
        onPressed: root.toggleMuteSink()
    }
    GlobalShortcut {
        id: dcSinkVol
        name: "decreaseSinkVolume"
        onPressed: dcSinkVol.event()
        function event(): void {
            root.decSinkVol();
            timer.setTimeout(function () {
                if (dcSinkVol.pressed)
                    dcSinkVol.event();
            });
        }
    }
    GlobalShortcut {
        id: inSinkVol
        name: "increaseSinkVolume"
        onPressed: inSinkVol.event()
        function event(): void {
            root.incSinkVol();
            timer.setTimeout(function () {
                if (inSinkVol.pressed)
                    inSinkVol.event();
            });
        }
    }
}
