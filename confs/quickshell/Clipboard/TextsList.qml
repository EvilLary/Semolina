pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import "../Libs"
import "../Components"

ListView {
    id: list
    spacing: 8
    //model: Clipboard.texts.filter(entry => entry != null && entry.content.toLowerCase().includes(searchBar.text))
    model: ScriptModel {
        values: Clipboard.texts
        .filter(entry => entry != null && entry.content.toLowerCase().includes(searchBar.text.toLowerCase()))
        //onValuesChanged: list.currentIndex = 0
    }

    focus: true
    Keys.onTabPressed: list.incrementCurrentIndex()
    Keys.onBacktabPressed: list.decrementCurrentIndex()
    Keys.onReturnPressed: {
        Clipboard.copyItem(list.currentItem.modelData.id)
        IPC.clipboardToggle()
    }
    Keys.forwardTo: searchBar

    cacheBuffer: 0
    currentIndex: 0

    highlight: HighlightDelegate {}
    highlightResizeDuration: 0
    highlightMoveDuration : 0
    layer.enabled: true
    delegate: MouseArea {
        id: entry
        required property var modelData
        required property int index
        width: list.width
        height: 50
        hoverEnabled: true
        onEntered: {
            list.currentIndex = entry.index
        }
        onClicked: {
            Clipboard.copyItem(entry.modelData.id)
            IPC.clipboardToggle()
        }
        Text {
            anchors.fill: parent
            anchors.margins: 8
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignLeft
            color: Config.colors.text

            text: modelData.content
            elide: Text.ElideRight
            textFormat: Text.PlainText
            font {
                weight: Font.Medium
                pointSize: 10
            }
        }
        Rectangle {
            visible: entry.containsMouse
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                margins: 1
            }
            width: height
            radius: Config.globalRadius
            color: Qt.alpha("black",0.2)
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
                    Clipboard.texts.splice(index,1)
                }
            }
        }
    }
}
