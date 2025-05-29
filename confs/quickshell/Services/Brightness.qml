pragma Singleton

import QtQuick
import Quickshell.Io
import Quickshell

// import Services

Singleton {
    id: root
    property int currentBrightness
    property bool firstRun: true
    readonly property string icon: {
        switch (true) {
        //case (root.value <= 25):
        //    return "brightness-off-symbolic"
        case (root.currentBrightness <= 25):
            return "brightness-low-symbolic";
        case (root.currentBrightness <= 50):
            return "brightness-high-symbolic";
        case (root.currentBrightness >= 70):
            return "brightness-high-symbolic";
        default:
            return "brightness-high-symbolic";
        }
    }

    Process {
        id: fetcher
        command: ['sh', '-c', 'ddccontrol dev:/dev/i2c-4 -r 0x10 | tail -n 1']
        running: true
        stdout: SplitParser {
            onRead: data => {
                const values = data.split(' ')[2];
                if (values) {
                    root.currentBrightness = values.split('/')[1] || 0;
                    if (root.firstRun) {
                        root.firstRun = false;
                        return;
                    }
                    Osd.osdmsg(root.icon, root.currentBrightness / 100, true);
                }
            }
        }
    }
    Process {
        id: adjuster
        command: []
        onExited: fetcher.running = true
    }
    function adjust(value: string): void {
        if (adjust.running)
            return;
        adjuster.command = ['ddccontrol', 'dev:/dev/i2c-4', '-r', '0x10', '-W', value];
        adjuster.running = true;
    }
    IpcHandler {
        target: "brightness"
        function adjust(value: string): void {
            root.adjust(value);
        }
    }
    // function decrease(): void {
    //     adjuster.command = ['ddccontrol', 'dev:/dev/i2c-4', '-r', '0x10', '-W', "-5"];
    //     adjuster.running = true
    // }
    // function increase(): void {
    //     adjuster.command = ['ddccontrol', 'dev:/dev/i2c-4', '-r', '0x10', '-W', "+5"];
    //     adjuster.running = true
    // }
}
