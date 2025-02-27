pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Widgets
import "root:Libs"
import Quickshell

ListView {
    id: list
    model: ScriptModel {
        values: Clipboard.images
    }
    cacheBuffer: 0
    spacing: 8
    highlightMoveDuration : 125
    focus: true
    Keys.onTabPressed: list.incrementCurrentIndex()
    Keys.onBacktabPressed: list.decrementCurrentIndex()
    Keys.onReturnPressed: {
        Clipboard.copyItem(list.currentItem.modelData.id)
        IPC.clipboardToggle()
    }
    Keys.forwardTo: [searchBar]
    delegate: ClippingRectangle {
        id: entry
        required property var modelData
        required property int index
        width: list.width
        radius: Config.globalRadius
        height: 150
        color: "transparent"
        border {
            width: entry.ListView.isCurrentItem ? 2 : 0
            color: Config.colors.accent
        }
        MouseArea {
            id: mouseArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                list.currentIndex = entry.index
            }
            onClicked: {
                Clipboard.copyItem(entry.modelData.id)
                IPC.clipboardToggle()
            }
        }
        Image {
            source: Qt.resolvedUrl(entry.modelData.image)
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            smooth: false
            asynchronous: true
            sourceSize {
                width: 100
                height: 100
            }
        }
        Rectangle {
            visible: mouseArea.containsMouse
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                margins: 1
            }
            width: 50
            radius: Config.globalRadius
            color: Qt.alpha("black",0)
            Image {
                source: "image://icon/delete"
                anchors.centerIn: parent
                sourceSize {
                    width: 30
                    height: 30
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Clipboard.deleteItem(entry.modelData.id)
                    Clipboard.images.splice(index,1)
                }
            }
        }
    }
}
