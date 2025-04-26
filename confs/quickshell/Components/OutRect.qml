import QtQuick
import "../"

Rectangle {
    border {
        width: 1
        color: Qt.alpha(Config.colors.light, 0.3)
    }
    color: Config.colors.background
    radius: Config.globalRadius
}
