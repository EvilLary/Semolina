//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "Wallpaper"
import "Bar"
import "Osd"
import "Notification"
import "Launcher"
import "Clipboard"
import "./Libs"
// import "GameOverlay"
// import "WindowSwitcher"
// import "Emojier"
// import "Screenshot"

ShellRoot {
    settings {
        watchFiles: true
    }
    Variants {
        model: Quickshell.screens

        //INFO
        Scope {
            id: scope
            required property ShellScreen modelData
            Wallpaper {
                screen: scope.modelData
            }
            BottomBar {
                id: bottom
                screen: scope.modelData
            }
        }
    }

    Osd {}
    ClipboardLayer {}
    NotificationLayer {}
    Launcher {}
    //Switcher {}
    //Emojier {}
    // Screenshot {}
    Component.onCompleted: [Stuff.init_apps()]
}
