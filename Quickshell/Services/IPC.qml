pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: ipc
    signal osdMessage(bodyText: string,iconPath: string)
    IpcHandler {
        target: "ipc"
        function osdmsg(bodytext: string, iconpath: string): void {osdMessage(bodytext,iconpath)}
    }
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            //console.log("EVENT NAME", event.name);
            //console.log("EVENT DATA", event.data);
            let eventName = event.name;

            switch (eventName) {
                case "activelayout":
                {
                    let layout = event.parse(2)[1];
                    osdMessage(layout,"folder-language-symbolic")
                    break;
                }
            }
        }
    }
}
