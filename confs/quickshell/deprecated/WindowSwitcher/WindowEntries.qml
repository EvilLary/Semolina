import QtQuick
import QtQuick.Layouts
import "../Libs"

GridLayout {
    id: grid
    anchors {
        centerIn: parent
        margins: 20
    }

    columnSpacing: 10
    rowSpacing: 25
    columns: 5

    Repeater {
        id: repeater
        model: Toplevels.windows
        Entry {}
    }

    Text {
        visible: repeater.count == 0
        text: "No windows open"
        font.pixelSize: 14
        renderType: Text.NativeRendering
        color: Config.colors.text
    }
}
