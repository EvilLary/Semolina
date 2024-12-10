import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:."
import "root:Components"

BarWidgetInner {
    id: root
    implicitHeight: layout.implicitHeight + 5

    SystemClock {
        id: clock
        enabled: true
        precision: SystemClock.Minutes
    }

    ColumnLayout {
        id: layout
        spacing: 0
        // anchors.centerIn: parent
        anchors.fill: parent
        Text {
            id: hourText
            Layout.alignment: Qt.AlignHCenter
            // Layout.fillWidth: true
            text: Config.hours.replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]) + "\n" + Config.minutes.replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d])
            renderType: Text.NativeRendering
            font {
                family: Config.font
                pointSize: 20
                weight: Font.Thin
            }
            lineHeight: 0.7
            color: Config.colors.text
        }
    }
}
