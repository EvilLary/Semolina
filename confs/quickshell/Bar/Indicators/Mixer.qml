import QtQuick
import "../../Libs"
import "../../Components" as C
import QtQuick.Controls

Rectangle {
    id: root

    color: Config.colors.background
    radius: Config.globalRadius
    border {
        width: 1
        color: Qt.alpha(Config.colors.text,0.2)
    }
    C.TabBar {
        id: header
        anchors {
            margins: 10
            top: parent.top
            right: parent.right
            left: parent.left
        }
        model: ["Applications","Devices"]
        height: 46
        activeIndex: 0
        onActiveIndexChanged: {
            if (activeIndex == 0) {
                //stackView.replace('root:Bar/Indicators/StreamsList.qml')
                stackView.pop(null)
            } else if (activeIndex == 1) {
                stackView.push('root:Bar/Indicators/DevicesList.qml')
            }
        }
    }
    Rectangle {
        id: mainView
        color: Config.colors.altBackground
        radius: Config.globalRadius
        anchors {
            top: header.bottom
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: 10
        }
        clip: true
        StackView {
            id: stackView
            anchors {
                fill: parent
                margins: 8
            }
            initialItem: 'root:Bar/Indicators/StreamsList.qml'
        }
        //StackLayout {
        //    id: stacks
        //    currentIndex: header.activeIndex
        //    anchors {
        //        fill: parent
        //        margins: 8
        //    }
        //
        //    Loader {
        //        id: streams
        //        //active: true
        //        active: this.StackLayout.isCurrentItem
        //        source: "StreamsList.qml"
        //        Layout.fillWidth: true
        //        Layout.fillHeight: true
        //    }
        //    Loader {
        //        id: devices
        //        //active: true
        //        active: this.StackLayout.isCurrentItem
        //        source: "DevicesList.qml"
        //        Layout.fillWidth: true
        //        Layout.fillHeight: true
        //    }
        //}
    }
}
