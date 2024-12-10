pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {

    property bool showSwitcher: false
    property string activeMonitor: Hyprland.focusedMonitor.name
    property string hours: clock?.hours.toString().padStart(2, '0')
    property string minutes: clock?.minutes.toString().padStart(2, '0')

    SystemClock {
        id: clock
        enabled: true
        precision: SystemClock.Minutes
    }
    // property color colorss: contentItem.palette.active.window
    property string backgroundImage: "/home/spicy/Pictures/Wallpapers/Einsamer_Raum_by_Orbite_Lambda.jpg"
    property string font: "JetBrainsMono Nerd Font"
    property QtObject colors: QtObject {
        property color windowBorder: "#c1c1c1"
        property color border: "#32c1c1c1"
        property color background: "#be23263b"
        property color altBackground: "#a4202336"
        property color secondaryBackground: "#be2d324c"
        property color active: "#40476c"
        property color selected: "#636fa8"
        property color text: "#ffe6e6e6"
    }

    //Shortcuts
    GlobalShortcut {
        name: "windowswitcher"
        description: "Switch between windows"
        onPressed: {
            showSwitcher = true
            // grab.active = true
            // console.log(JSON.stringify(colorss))
        }
        onReleased: {
            showSwitcher = false
        }
    }
}
