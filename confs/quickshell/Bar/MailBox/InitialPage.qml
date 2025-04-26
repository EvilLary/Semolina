import QtQuick
// import "../../Libs"
// import '../../Components'
import "../../Widgets"
import Quickshell.Widgets

Item {
    id: frontPage

    CircleClock {
        anchors {
            top: parent.top
            right: parent.right
            left: parent.horizontalCenter
        }
        height: width
        ClippingRectangle {

            anchors.centerIn: parent
            radius: height / 2
            width: 70
            height: 70
            Image {
                anchors.fill: parent
                source: `/var/lib/AccountsService/icons/spicy`
                //source: `/var/lib/AccountsService/icons/${Quickshell.env('USER')}`
                fillMode: Image.PreserveAspectCrop
                sourceSize {
                    width: 88
                    height: 88
                }
            }
        }
    }

    PowerButtons {
        id: powerButtons
        anchors {
            left: parent.left
            top: parent.top
            right: parent.horizontalCenter
        }
        height: 48
    }

    QuickOptions {
        id: quickSettings
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }
        height: 150
    }
    MprisWidget {
        id: mprisLoader
        anchors {
            right: parent.right
            left: parent.left
            bottom: quickSettings.top
            bottomMargin: 8
        }
        height: 170
    }
    // Loader {
    //     id: mprisLoader
    //     active: MprisProvider.trackedPlayer != null
    //     anchors {
    //         right: parent.right
    //         left: parent.left
    //         bottom: quickSettings.top
    //         bottomMargin: 8
    //     }
    //     height: 170
    //     sourceComponent: MprisWidget {}
    // }
    WeatherInfo {
        anchors {
            top: powerButtons.bottom
            right: powerButtons.right
            left: powerButtons.left
            bottom: mprisLoader.top
            topMargin: 8
            bottomMargin: 8
        }
    }
}
