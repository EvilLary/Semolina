import QtQuick
import "../Config"
import "../Services"
import "../Components"

Rectangle {
    color: Colors.background
    radius: Stuff.radius
    border {
        width: 1
        color: Colors.light
    }
    CircularSlider {
        // anchors.fill: parent
        // anchors.margins: 4
        size: parent.height - 10
        id: slider
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: 6
        }
        icon: Misc.nightlight.status ? "redshift-status-on-symbolic" : "redshift-status-off-symbolic"
        onScrollDown: Misc.nightlight.adjust(250)
        onScrollUp: Misc.nightlight.adjust(-250)
        value: (6500 - Misc.nightlight.temperature) / 5500
        onLeftClick: Misc.nightlight.toggle()
    }
    Text {
        anchors {
            right: parent.right
            left: slider.right
            verticalCenter: parent.verticalCenter
            margins: 6
        }
        horizontalAlignment: Qt.AlignRight
        verticalAlignment: Qt.AlignVCenter
        text: `ضوء الليلي:  ${Misc.nightlight.status ? Misc.nightlight.temperature.toString().replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]) : "طافي" }`
        color: Colors.text
        textFormat: Text.PlainText
        font {
            pointSize: 12
            kerning: false
        }
    }
}
