import QtQuick
import QtQuick.Controls
import "../../Components" as C

C.OutRect {
    anchors.fill: parent
    signal closePopup
    clip: false

    StackView {
        id: stackView
        anchors {
            fill: parent
            margins: 10
        }
        initialItem: InitialPage {}
        pushEnter: Transition {
            OpacityAnimator {
                from: 0
                to: 1
                duration: 250
            }
        }
        pushExit: Transition {
            OpacityAnimator {
                to: 0
                duration: 250
            }
        }
        popEnter: Transition {
            OpacityAnimator {
                from: 0
                to: 1
                duration: 250
            }
        }
        popExit: Transition {
            OpacityAnimator {
                to: 0
                duration: 250
            }
        }
    }
    // GRIDLAYOUT for buttons
    // Notification, Display & NightLight, Wifi, qahwa mode,
    // clock using circular paths, power buttons beside them in a ColumnLayout
    // two horizontal sliders for Brightness,Sink,Source
}
