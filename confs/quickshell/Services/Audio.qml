pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode activeSink: Pipewire.ready ? Pipewire.defaultAudioSink : null
    readonly property PwNode activeSource: {
        if (!Pipewire.ready) {
            return null;
        }
        const nodeName = Pipewire.defaultAudioSource?.name;
        if (nodeName == null) {
            return null;
        }
        const args = nodeName.split(".");
        if (args[0] === "alsa_input") {
            return Pipewire.defaultAudioSource;
        } else {
            return null;
        }
    }

    PwObjectTracker {
        objects: [root.activeSink, root.activeSource]
    }

    readonly property real sinkVolume: activeSink?.audio?.volume || 0
    readonly property real sourceVolume: activeSource?.audio?.volume || 0

    readonly property bool sinkMute: activeSink?.ready ? activeSink?.audio?.muted : true
    readonly property bool sourceMute: activeSource?.ready ? activeSource?.audio?.muted : true

    readonly property string sinkIcon: getIcon(Math.round(root.sinkVolume * 100), root.sinkMute, "audio-volume")
    readonly property string sourceIcon: getIcon(Math.round(root.sourceVolume * 100), root.sourceMute, "microphone-sensitivity")

    function adjustSinkVol(percentage: real): void {
        const newVolume = root.sinkVolume + percentage;
        if (percentage < 0) {
            root.activeSink.audio.volume = Math.max(newVolume, 0);
        } else {
            root.activeSink.audio.volume = Math.min(newVolume, 1);
        }
        Osd.osdmsg(root.sinkIcon, root.sinkVolume, true);
    }
    function adjustSourceVol(percentage: real): void {
        const newVolume = root.sourceVolume + percentage;
        if (percentage < 0) {
            root.activeSource.audio.volume = Math.max(newVolume, 0);
        } else {
            root.activeSource.audio.volume = Math.min(newVolume, 1);
        }
        Osd.osdmsg(root.sourceIcon, root.sourceVolume, true);
    }
    function toggleMuteSink(): void {
        root.activeSink.audio.muted = !root.activeSink.audio.muted;
        Osd.osdmsg(root.sinkIcon, root.sinkMute ? "Muted" : root.sinkVolume, !root.sinkMute);
    }
    function toggleMuteSource(): void {
        root.activeSource.audio.muted = !root.activeSource.audio.muted;
        Osd.osdmsg(root.sourceIcon, root.sourceMute ? "Muted" : root.sourceVolume, !root.sourceMute);
    }

    function getIcon(volume: string, muted: bool, prefix: string): string {
        switch (true) {
        case (volume <= 0) || muted:
            return prefix + "-muted-symbolic";
        case (volume <= 25):
            return prefix + "-low-symbolic";
        case (volume <= 75):
            return prefix + "-medium-symbolic";
        case (volume > 75):
            return prefix + "-high-symbolic";
        case (volume >= 100):
            return prefix + "-high-warning-symbolic";
            defualt: return prefix + "-high-danger-symbolic";
        }
    }

    Connections {
        target: Pipewire
        enabled: true
        ignoreUnknownSignals: true
        function onDefaultAudioSinkChanged() {
            if (Pipewire.ready) {
                if (Pipewire.defaultAudioSink !== null) {
                    Osd.osdmsg("audio-card-symbolic", Pipewire.defaultAudioSink.nickname || Pipewire.defaultAudioSink.description, false);
                }
            }
        }
        function onDefaultAudioSourceChanged() {
            if (Pipewire.ready) {
                if (Pipewire.defaultAudioSource !== null) {
                    Osd.osdmsg("audio-card-symbolic", Pipewire.defaultAudioSource.nickname || Pipewire.defaultAudioSource.description, false);
                }
            }
        }
    }

    IpcHandler {
        target: "audio"
        function decSinkVol(): void {
            root.adjustSinkVol(-0.05);
        }
        function incSinkVol(): void {
            root.adjustSinkVol(0.05);
        }
        function incSourceVol(): void {
            root.adjustSourceVol(0.05);
        }
        function decSourcekVol(): void {
            root.adjustSourceVol(-0.05);
        }
        function toggleMuteSink(): void {
            root.toggleMuteSink();
        }
        function toggleMuteSource(): void {
            root.toggleMuteSource();
        }
    }
    function init(): void {
    }
}
