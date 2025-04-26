import QtQuick
import "../../Components" as C
import QtQuick.Controls

C.OutRect {
    id: root

    signal closePopup
    C.TabBar {
        id: header
        anchors {
            margins: 8
            top: parent.top
            right: parent.right
            left: parent.left
        }
        model: ["تطبيقات", "صوتيات"]
        height: 46
        activeIndex: 0
        onActiveIndexChanged: {
            if (activeIndex == 0) {
                //stackView.replace('root:Bar/Indicators/StreamsList.qml')
                stackView.pop(null);
            } else if (activeIndex == 1) {
                stackView.push('./DevicesList.qml');
            }
        }
    }
    C.InnRect {
        id: mainView
        anchors {
            top: header.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: 8
        }
        clip: true
        StackView {
            id: stackView
            anchors {
                fill: parent
                margins: 8
            }
            initialItem: './StreamsList.qml'
        }
    }
}
