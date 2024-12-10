import QtQuick
import QtQuick.Layouts
import "root:."

GridLayout {
    id: grid
    required property var windows
    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
        margins: 20
    }
    // Keys.onEscapePressed: loader.active = false
    columns: 8 

    Repeater {
        id: repeater
        model: grid.windows
        Entry {
            required property var modelData
            onActivate: {
                modelData.activate()
                Config.showSwitcher = false
            }
            iconSource: {
                let appIcon = modelData.appId
                //Exceptions
                if (appIcon.includes("steam_app_") || appIcon == "gamescope" || appIcon.includes(".exe")) appIcon = "wine";
                if (appIcon == "kdesystemsettings" || appIcon == "org.kde.kcolorschemeeditor ") appIcon = "systemsettings"
                return`image://icon/${appIcon}`
            }
        }
    }
    Entry {
        visible: repeater.count == 0
        iconSource: "image://icon/preferences-system-windows-effect-coverswitch"
        onActivate: Config.showSwitcher = false
        color: Config.colors.active
        Text {
            text: "فراغ ..."
            font.pixelSize: 20
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                margins: 5
            }
            color: Config.colors.text
        }
    }
}
