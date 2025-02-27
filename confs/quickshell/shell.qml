//@ pragma UseQApplication
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "Wallpaper"
import "Bar"
import "Osd"
import "Notification"
import "GameOverlay"
import "Launcher"
import "Clipboard"
import "WindowSwitcher"
import "Emojier"
import "Screenshot"

ShellRoot {
    settings.watchFiles: true
    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            required property ShellScreen modelData
            Wallpaper {
                screen: scope.modelData
            }
            //TopBar {
            //    id: top
            //    screen: scope.modelData
            //}
            //SideBar {
            //    id: side
            //}
            BottomBar {
                id: bottom
                screen: scope.modelData
            }
        }
    }
    //Variants {
    //    model: Quickshell.screens
    //    Scope {
    //        required property var modelData
    //    }
    //}

    Osd {}
    ClipboardLayer {}
    NotificationLayer {}
    Switcher {}
    Emojier {}
    Screenshot {}
    Component.onCompleted: [
        Launcher.hola(),
        Overlay.hola()
    ]
}
