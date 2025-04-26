//--prussian-blue: #213348;
//--indigo-dye: #2D4D67;
//--lapis-lazuli: #285A77;
//--light-sea-green: #3EBFB3;
//--electric-blue: #6FE0E8;
//--carolina-blue: #88B6C8;
//--indian-red: #CD555E;
//--azure-web: #E6FDFF;

import QtQuick
import Quickshell
pragma Singleton

Singleton {
    id: config

    readonly property string backgroundSource: "/home/spicy/Pictures/Wallpapers/flowers/flower_tokyo.png"
    readonly property int globalRadius: 10
    readonly property int wallpaperGabs: 10
    readonly property int globalGabs: 8
    readonly property int barHeight: 58
    // readonly property int
    readonly property QtObject
    colors: QtObject {
        readonly property alias altBackground: colors.window
        readonly property alias border: colors.mid
        readonly property alias background: colors.dark
        readonly property alias active: colors.accent
        readonly property alias accent: colors.accent
        readonly property alias text: colors.text
        readonly property alias midlight: colors.midlight
        readonly property alias shadow: colors.shadow
        readonly property alias base: colors.base
        readonly property alias altBase: colors.alternateBase
        readonly property alias button: colors.button
        readonly property alias buttonText: colors.buttonText
        readonly property alias highlight: colors.highlight
        readonly property alias highlightedText: colors.highlightedText
        readonly property alias light: colors.light
        readonly property color negative: "#CD555E"
        readonly property color positive: "#3EBFB3"
    }

    SystemPalette {
        id: colors

        colorGroup: SystemPalette.Active
    }

}
// #1E2636
