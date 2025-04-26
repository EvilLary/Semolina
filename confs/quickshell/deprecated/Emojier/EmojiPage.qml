pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import org.kde.plasma.emoji

GridView {

    id: emojiView

    property alias category: filter.category
    property var emojis

    property string searchText: ""
    property bool showSearch: false
    property bool showClearHistoryButton: false

    readonly property real desiredSize: 50
    readonly property int columnsToHave: Math.ceil(width / desiredSize)
    readonly property int delayInterval: Math.min(300, columnsToHave * 10)

    cellWidth: width / columnsToHave
    cellHeight: desiredSize

    model: CategoryModelFilter {
        id: filter
        sourceModel: SearchModelFilter {
            id: emojiModel
            sourceModel: emojiView.emojis
        }
    }

    Popup {
        id: popup
        anchors.centerIn: parent
        width: 150
        height: 50
        modal: false
        contentItem: Label {
            anchors.centerIn: parent
            text: "Copied to clipboard"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnReleaseOutside
        onOpened: hideTimer.restart()
        Timer {
            id: hideTimer
            interval: 300
            repeat: false
            onTriggered: popup.close()
        }
    }

    function copier(thing: string): void {
        CopyHelper.copyTextToClipboard(thing)
    }
    cacheBuffer: 0
    reuseItems: true
    currentIndex: -1
    delegate: ItemDelegate {
        id: entry
        required property var modelData
        contentItem: Label {
            font.pointSize: 25
            font.family: 'emoji' // Avoid monochrome fonts like DejaVu Sans
            fontSizeMode: entry.modelData.display.length > 5 ? Text.Fit : Text.FixedSize
            minimumPointSize: 10
            text: entry.modelData.display
            textFormat: Text.PlainText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: popup.open(), copier(modelData.display)
    }
}
