pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string args
    property int value: 0

    readonly property string icon: {
        switch(true) {
            case (root.value <= 0):
                return "display-brightness-off-symbolic"
            case (root.value <= 25):
                return "display-brightness-low-symbolic"
            case (root.value <= 50):
                return "display-brightness-medium-symbolic"
            case (root.value >= 70):
                return "display-brightness-high-symbolic"
        }
    }
    Process {
        id: fetchBrightness
        running: true
        command: ['sh','-c','ddccontrol dev:/dev/i2c-5 -r 0x10 | tail -n 1']
        stdout: SplitParser {
            onRead: data => {
                let values = data.split(' ')[2]
                root.value = values.split('/')[1]
            }
        }
    }
    Process {
        id: adjustBrightness
        running: false
        command: ['sh','-c',`ddccontrol dev:/dev/i2c-5 -r 0x10 -W ${root.args}`]
        onExited: fetchBrightness.running = true
    }

    function adjust(adjustment: string): void {
        root.args = adjustment
        adjustBrightness.running = true
    }
}
