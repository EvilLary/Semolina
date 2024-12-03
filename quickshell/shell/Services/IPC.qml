pragma Singleton
import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Hyprland
Singleton {
    id: root
    signal osdMessage(bodyText: string,iconPath: string)
    SocketServer {
        active: true
        path: "/run/user/1000/quickshell.sock"

        handler: Socket {
            parser: SplitParser {
                onRead: message => {
                    const [type, body] = message.split(":");
                    const args = body.split(",");

                    switch (type) {
                        case "osd":
                            osdMessage(args[0],args[1])
                            break;
                        default:
                            console.log(`socket received unknown message: ${message}`)
                    }
                }
            }

        }
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

    //END
}
