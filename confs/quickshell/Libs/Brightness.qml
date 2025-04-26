// pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int value: 0

    readonly property string icon: {
        switch(true) {
            //case (root.value <= 25):
            //    return "brightness-off-symbolic"
            case (root.value <= 25):
                return "brightness-low-symbolic";
            case (root.value <= 50):
                return "brightness-high-symbolic";
            case (root.value >= 70):
                return "brightness-high-symbolic";
        }
    }
    readonly property Process fetcher: Process {
        id: fetchBrightness
        running: true
        command: ['sh','-c','ddccontrol dev:/dev/i2c-4 -r 0x10 | tail -n 1']
        stdout: SplitParser {
            onRead: data => {
                const values = data.split(' ')[2];
                if (values) {
                    root.value = values.split('/')[1];
                }
            }
        }
    }
    readonly property Process adj: Process {
        id: adjustBrightness
        running: false
        // command: ['sh','-c',`ddccontrol dev:/dev/i2c-4 -r 0x10 -W ${root.args}`]
        onExited: fetchBrightness.running = true
    }

    function adjust(adjustment: string): void {
        adjustBrightness.command = ['ddccontrol', 'dev:/dev/i2c-4', '-r', '0x10', '-W', adjustment];
        adjustBrightness.running = true;
    }
}
