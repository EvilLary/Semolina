pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: ipc

    signal osdMessage(bodyText: string, iconPath: string)

    // property string currentLayout: ""
    //property QtObject screencast: QtObject {
    //    property bool status: false
    //    property bool fullscreen: false
    //}

    //Volume controls
    Connections {
        target: Hyprland
        enabled: true
        function onRawEvent(event) {
            switch (event.name) {
            case "activelayout":
                {
                    // print(event.data);
                    const [device, layout] = event.data.split(',');
                    if (device !== "cooler-master-ck530-v2-gaming-mechanical-keyboard") {
                        return;
                    }
                    ipc.osdMessage(ipc.trans_layout(layout), "set-language-symbolic");
                    // if (event.data.startsWith("hl-virtual-keyboard")) {
                    //     break;
                    // }
                    // print(event.data);
                    // const eventData = event.data;
                    // const lang = eventData.split(",")[1];
                    // print(eventData.split(",")[1]);
                    // const layout = ipc.trans_layout(event.data.split(",")[1]);
                    // ipc.currentLayout = layout;
                    break;
                }
            case "submap":
                {
                    if (event.data.length == 0) {
                        ipc.osdMessage("Default Submap", "accessories-character-map");
                    } else {
                        ipc.osdMessage(`${event.data} Submap`, "accessories-character-map");
                    }
                    break;
                }
            //case "screencast": {
            //    // window sharing = 1, screen sharing = 0
            //    // status = 1 is on, 0 is off
            //    let eventData = event.data;
            //    const [status,window] = eventData.split(",")
            //    ipc.screencast.status = (status == 1)
            //    ipc.screencast.fullscreen = (window == 0)
            //    break;
            //}
            }
        }
    }
    function trans_layout(lang: string): string {
        switch (lang) {
        case "Arabic (Eastern Arabic numerals)":
            return "عربي (أرقام شرقية)";
        case "Arabic":
            return "عربي";
        case "English (US)":
            return "إنجليزي (أمريكي)";
        case "English (UK)":
            return "إنجليزي (انجلترا)";
        default:
            return lang;
        }
    }
}
