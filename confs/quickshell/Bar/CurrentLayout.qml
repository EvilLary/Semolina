import QtQuick
// import QtQuick.Controls
import "../Services"
import "../Config"

Item {
    id: root
    // hoverEnabled: true
    // ToolTip {
    //     popupType: Popup.Window
    //     text: Misc.currentLayout.longform
    // }
    Text {
        anchors.centerIn: parent
        text: Misc.currentLayout.shortform
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        renderType: Text.NativeRendering
        textFormat: Text.PlainText
        color: Colors.text
        font {
            weight: Font.Medium
            pointSize: 11
            kerning: false
        }
    }
}
