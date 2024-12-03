import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import "root:."

GridLayout {
    id: grid
    required property var windows
    required property var activeWindow
    anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
        margins: 20
    }

    columns: 10
    Rectangle {
        visible: repeater.count == 0
        width: 125
        height: 125
        radius: 5
        border {
            width: entryArea.containsMouse ?? 1
            color: Config.colors.border
        }
        color: Config.colors.active
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
        IconImage {
            implicitSize: 90
            anchors.centerIn: parent
            source: "image://icon/preferences-system-windows-effect-coverswitch"
        }
        Text {
            text: "No windows"
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                margins: 5
            }
            color: Config.colors.text
        }
        MouseArea {
            id: entryArea
            anchors.fill: parent
            onClicked: {
                loader.active = false
                grab.active = false
            }
            hoverEnabled: true
        }
    }
    Repeater {
        id: repeater
        model: grid.windows
        // anchors.centerIn: parent
        Rectangle {
            width: 125
            height: 125
            radius: 5
            border {
                width: entryArea.containsMouse ?? 1
                color: Config.colors.border
            }
            color: (modelData == grid.activeWindow || entryArea.containsMouse) ? Config.colors.active : Config.colors.altBackground
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
            IconImage {
                implicitSize: (modelData == grid.activeWindow || entryArea.containsMouse) ? 90 : 80
                anchors.centerIn: parent
                source: {
                    let appIcon = modelData.appId
                    //Exceptions
                    if (appIcon.includes("steam_app_")) appIcon = "wine";

                    return`image://icon/${appIcon}`
                }
                Behavior on implicitSize {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }
            MouseArea {
                id: entryArea
                anchors.fill: parent
                onClicked: {
                    modelData.activate()
                    loader.active = false
                    grab.active = false
                }
                hoverEnabled: true
            }
        }
    }
}
