pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: config

    property string backgroundSource: "/home/spicy/Pictures/Wallpapers/Ricodz/lonely_night_by_ricodz_dcydrnm.jpg"
    property int globalRadius: 10
    property QtObject colors: QtObject {
        property color altBackground: "#1f263f"
        property color border: "#303a61"
        property color background: "#15192a"
        property color active: "#8fc1d3"
        property color accent: "#5666ac"
        property color text: "#E6FDFF"
        property color negative: "#CD555E"
        property color positive: "#3EBFB3"
    }
}
// #1E2636
//--prussian-blue: #213348;
//--indigo-dye: #2D4D67;
//--lapis-lazuli: #285A77;
//--light-sea-green: #3EBFB3;
//--electric-blue: #6FE0E8;
//--carolina-blue: #88B6C8;
//--indian-red: #CD555E;
//--azure-web: #E6FDFF;
