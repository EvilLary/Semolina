import QtQuick
import QtQuick.Layouts
import "../"
import "../Components" as C
import QtQuick.Controls

Rectangle {
    id: content
    color: Config.colors.background
    radius: Config.globalRadius
    // required property Clipboard clipboard
    border {
        color: Qt.alpha(Config.colors.text, 0.2)
        width: 1
    }

    Clipboard {
        id: clipboard
        onClose: {
            loader.active = false;
        }
        Component.onCompleted: this.getClipboardData()
    }
    MouseArea {
        anchors.fill: parent
        onClicked: event => {
            event.accepted = false;
        }
    }
    RowLayout {
        id: header
        height: 48
        spacing: 8
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: 8
        }
        C.TabBar {
            id: tabBar
            model: ["نصوص", "صور"]
            textSize: 16
            Layout.fillHeight: true
            Layout.fillWidth: true
            onActiveIndexChanged: {
                if (activeIndex == 0) {
                    stackView.pop(null);
                } else if (activeIndex == 1) {
                    stackView.push('./ImagesList.qml');
                }
            }
        }
        Rectangle {
            id: wipeBtn
            Layout.fillHeight: true
            implicitWidth: 48
            radius: Config.globalRadius
            color: wipeArea.containsMouse ? Config.colors.negative : Config.colors.altBackground
            Behavior on color {
                ColorAnimation {
                    duration: 125
                }
            }
            MouseArea {
                id: wipeArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: clipboard.wipeCliphist(), loader.active = false
            }
            Image {
                anchors.centerIn: parent
                source: "image://icon/edit-delete-shred-symbolic"
                // asynchronous: true
                smooth: false
                fillMode: Image.PreserveAspectFit
                sourceSize {
                    width: 28
                    height: 28
                }
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
            margins: 8
        }
        TextField {
            id: searchBar
            anchors {
                top: mainView.top
                right: parent.right
                left: parent.left
            }
            leftPadding: clipIcon.width + 8
            height: 50

            placeholderText: "حافظة..."
            color: Config.colors.text
            font {
                weight: Font.Bold
                pointSize: 12
                hintingPreference: Font.PreferNoHinting
            }

            activeFocusOnPress: false
            activeFocusOnTab: false
            Keys.onEscapePressed: loader.active = false
            background: Item {
                Image {
                    id: clipIcon
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 5
                    }
                    smooth: false
                    // asynchronous: true
                    sourceSize {
                        width: 40
                        height: 40
                    }
                    source: 'image://icon/search-icon'
                }
            }
        }
        StackView {
            id: stackView
            anchors {
                top: searchBar.bottom
                bottom: parent.bottom
                right: parent.right
                left: parent.left
                topMargin: 0
                margins: 8
            }
            focus: true
            clip: true
            initialItem: TextsList {}
            //Loader {
            //    id: textsList
            //    active: this.StackLayout.isCurrentItem && Clipboard.ready
            //    //active: this.StackLayout.isCurrentItem
            //    source: "TextsList.qml"
            //    Layout.fillWidth: true
            //    Layout.fillHeight: true
            //    focus: this.StackLayout.isCurrentItem
            //}
            //
            //Loader {
            //    id: imagesList
            //    //active: true
            //    active: this.StackLayout.isCurrentItem && Clipboard.ready
            //    source: "ImagesList.qml"
            //    Layout.fillWidth: true
            //    Layout.fillHeight: true
            //    focus: this.StackLayout.isCurrentItem
            //}
        }
    }
}
