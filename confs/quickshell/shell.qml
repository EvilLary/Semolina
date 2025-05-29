//@ pragma UseQApplication

import Quickshell
import QtQuick
import "Services"
import "Bar"
// import "Config"
import "Clipboard"
// import "Notifications"

ShellRoot {
    id: root
    Component.onCompleted: {
        Osd.init();
        Audio.init();
        Notifications.init();
        Misc.init_apps();
    }
    Bar {}
    ClipboardLayer {}
}
