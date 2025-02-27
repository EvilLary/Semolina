import QtQuick
import QtQuick.Controls
import "../../Libs"

Rectangle {
    anchors.fill: parent
    color: Config.colors.background
    radius: Config.globalRadius

    border {
        color: Qt.alpha(Config.colors.text,0.2)
        width: 1
    }
    clip: false

    StackView {
        id: stackView
        anchors {
            fill: parent
            margins: 10
        }
        initialItem: InitialPage {}
        pushEnter: Transition {
            OpacityAnimator {from: 0; to: 1; duration: 250}
        }
        pushExit: Transition {
            OpacityAnimator {to: 0; duration: 250}
        }
        popEnter: Transition {
            OpacityAnimator {from: 0; to: 1; duration: 250}
        }
        popExit: Transition {
            OpacityAnimator {to: 0; duration: 250}
        }
    }
    // GRIDLAYOUT for buttons
    // Notification, Display & NightLight, Wifi, qahwa mode,
    // clock using circular paths, power buttons beside them in a ColumnLayout
    // two horizontal sliders for Brightness,Sink,Source
}
