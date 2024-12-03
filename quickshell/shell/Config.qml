pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property string font: "JetBrainsMono Nerd Font Mono"
    property QtObject colors: QtObject {
        property color windowBorder: "#c1c1c1"
        property color border: "#96c1c1c1"
        property color background: "#be23263b"
        property color altBackground: "#a4202336"
        property color secondaryBackground: "#be2d324c"
        property color active: "#40476c"
        property color selected: "#636fa8"
        property color text: "#ffe6e6e6"
    }
}
