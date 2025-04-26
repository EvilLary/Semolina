pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import "../../Components" as C
import "../../"
import "../../Libs"

C.OutRect {
    id: kickOff
    signal closePopup
    C.InnRect {
        id: header
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            margins: 8
        }
        height: 45
        TextField {
            id: textField
            anchors.fill: parent
            anchors.margins: 8
            // horizontalAlignment: Text.AlignRight
            placeholderText: " Search..."
            font {
                weight: Font.Medium
                pointSize: 12
            }
            color: Config.colors.text
            onTextChanged: {
                if (textField.text.length === 0 && mainView.currentItem.objectName !== "normalPage") {
                    mainView.pop(null);
                } else if (textField.text.length > 0 && mainView.currentItem.objectName !== "searchPage") {
                    mainView.push(searchPage);
                }
            }
            Component.onCompleted: this.focus = true
        }
    }
    StackView {
        id: mainView
        anchors {
            top: header.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            // margins: 8
        }
        initialItem: normalPage

        // replaceExit: exitTransition
        // replaceEnter: enterTransition
        // popExit: exitTransition
        // popEnter: enterTransition
        // pushExit: exitTransition
        // pushEnter: enterTransition
        // popEnter: Transition {
        //     XAnimator {
        //         from: (mainView.mirrored ? -1 : 1) * -mainView.width
        //         to: 0
        //         duration: 400
        //         easing.type: Easing.OutCubic
        //     }
        // }
        //
        // popExit: Transition {
        //     XAnimator {
        //         from: 0
        //         to: (mainView.mirrored ? -1 : 1) * mainView.width
        //         duration: 400
        //         easing.type: Easing.OutCubic
        //     }
        // }
        Transition {
            id: enterTransition
            OpacityAnimator {
                from: 0.0
                to: 1.0
                duration: 250
            }
        }
        Transition {
            id: exitTransition
            OpacityAnimator {
                from: 1.0
                to: 0.0
                duration: 200
            }
        }
    }
    Component {
        id: searchPage
        Item {
            objectName: "searchPage"
            C.InnRect {
                anchors {
                    fill: parent
                    margins: 8
                }
                ListView {
                    id: searchResults
                    anchors {
                        fill: parent
                        margins: 8
                    }
                    Connections {
                        target: textField
                        function onAccepted() {
                            searchResults.currentItem.launch();
                        }
                    }
                    clip: true
                    model: ScriptModel {
                        values: DesktopEntries.applications.values.filter(entry => textField.text.length === 0 || entry.name.toLowerCase().includes(textField.text.toLowerCase())).sort((a, b) => {
                            const acheck = a.name.toLowerCase().startsWith(textField.text.toLowerCase());
                            const bcheck = b.name.toLowerCase().startsWith(textField.text.toLowerCase());
                            if (acheck && bcheck) {
                                return a.name.localeCompare(b.name);
                            } else if (acheck) {
                                return -1;
                            } else if (bcheck) {
                                return 1;
                            }
                            return a.name.localeCompare(b.name);
                        })
                        onValuesChanged: searchResults.currentIndex = 0
                    }

                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 100
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            property: "opacity"
                            to: 1
                            duration: 100
                        }
                    }

                    move: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            property: "opacity"
                            to: 1
                            duration: 100
                        }
                    }

                    remove: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: 100
                        }
                    }
                    cacheBuffer: 0
                    spacing: 8
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0
                    keyNavigationWraps: true
                    highlight: C.HighlightDelegate {}
                    // add: enterTransition
                    // remove: exitTransition
                    delegate: Rectangle {
                        id: app
                        required property var modelData
                        required property int index
                        width: searchResults.width
                        height: 45
                        radius: Config.globalRadius
                        color: "transparent"
                        function launch() {
                            const cmd = Qt.createQmlObject("import Quickshell.Io; Process {}", kickOff);
                            const desktop = app.modelData.id + '.desktop';
                            cmd.command = ["uwsmapp.sh", desktop];
                            cmd.startDetached();
                            kickOff.closePopup();
                        }
                        MouseArea {
                            id: entryArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: app.launch()
                            onEntered: searchResults.currentIndex = app.index
                        }
                        ColumnLayout {
                            anchors {
                                left: entryIcon.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            spacing: 0
                            Text {
                                id: entryName
                                text: app.modelData.name
                                color: Config.colors.text
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    weight: Font.Bold
                                    pointSize: 11
                                }
                            }
                            Text {
                                id: entryDescription
                                text: app.modelData.genericName || app.modelData.id
                                color: Config.colors.text
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    weight: Font.Medium
                                    pointSize: 9
                                }
                            }
                        }
                        Image {
                            id: entryIcon
                            source: Quickshell.iconPath(app.modelData.icon, "application-x-desktop")
                            sourceSize {
                                width: 32
                                height: 32
                            }
                            // asynchronous: true
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: normalPage

        Item {
            objectName: "normalPage"
            C.InnRect {
                id: categoriesList
                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                    margins: 8
                }
                width: parent.width / 4
                function change_category(category: string): void {
                    switch (category) {
                    case "development":
                        appsList.apps = Stuff.apps.development;
                        break;
                    case "education":
                        appsList.apps = Stuff.apps.education;
                        break;
                    case "games":
                        appsList.apps = Stuff.apps.games;
                        break;
                    case "graphics":
                        appsList.apps = Stuff.apps.graphics;
                        break;
                    case "internet":
                        appsList.apps = Stuff.apps.internet;
                        break;
                    case "multimedia":
                        appsList.apps = Stuff.apps.multimedia;
                        break;
                    case "office":
                        appsList.apps = Stuff.apps.office;
                        break;
                    case "system":
                        appsList.apps = Stuff.apps.system;
                        break;
                    case "utilities":
                        appsList.apps = Stuff.apps.utilities;
                        break;
                    case "other":
                        appsList.apps = Stuff.apps.other;
                        break;
                    }
                    appsList.category = category;
                }
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    Repeater {
                        model: ["development", "education", "games", "graphics", "internet", "multimedia", "office", "system", "utilities", "other"]
                        Rectangle {
                            id: categoryButton
                            required property int index
                            required property string modelData
                            readonly property bool active: (appsList.category === this.modelData)
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: (this.active) ? Config.colors.accent : (mouseArea.containsMouse ? Config.colors.altBase : Config.colors.altBackground)
                            radius: Config.globalRadius
                            RowLayout {
                                anchors {
                                    margins: 8
                                    fill: parent
                                }
                                Image {
                                    id: img
                                    source: "image://icon/applications-" + categoryButton.modelData + ""
                                    sourceSize {
                                        width: 24
                                        height: 24
                                    }
                                }
                                Text {
                                    id: txt
                                    text: categoryButton.modelData
                                    color: Config.colors.text
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.leftMargin: 8
                                    font {
                                        pixelSize: 13
                                        weight: Font.Medium
                                        capitalization: Font.Capitalize
                                    }
                                }
                            }
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                // onClicked: parent.clicked()
                                onClicked: categoriesList.change_category(categoryButton.modelData)
                            }
                        }
                    }
                }
            }
            C.InnRect {
                id: applicationsList
                anchors {
                    top: parent.top
                    left: categoriesList.right
                    bottom: parent.bottom
                    right: parent.right
                    margins: 8
                }
                ListView {
                    id: appsList
                    property string category: "development"
                    property list<var> apps: Stuff.apps.development
                    anchors {
                        fill: parent
                        margins: 8
                    }
                    clip: true
                    model: ScriptModel {
                        values: appsList.apps
                        onValuesChanged: appsList.currentIndex = 0
                    }
                    cacheBuffer: 0
                    spacing: 8
                    highlightMoveDuration: 0
                    highlightResizeDuration: 0
                    keyNavigationWraps: true
                    highlight: C.HighlightDelegate {}

                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 100
                        }
                    }

                    remove: Transition {
                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: 100
                        }
                    }
                    delegate: Rectangle {
                        id: app
                        required property var modelData
                        required property int index
                        width: applicationsList.width - 16
                        height: 45
                        radius: Config.globalRadius
                        color: "transparent"
                        MouseArea {
                            id: entryArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                const cmd = Qt.createQmlObject("import Quickshell.Io; Process {}", applicationsList);
                                const desktop = app.modelData.id + '.desktop';
                                cmd.command = ["uwsmapp.sh", desktop];
                                cmd.startDetached();
                                kickOff.closePopup();
                            }
                            onEntered: appsList.currentIndex = app.index
                        }
                        ColumnLayout {
                            anchors {
                                left: entryIcon.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            spacing: 0
                            Text {
                                id: entryName
                                text: app.modelData.name
                                color: Config.colors.text
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    weight: Font.Bold
                                    pointSize: 11
                                }
                            }
                            Text {
                                id: entryDescription
                                text: app.modelData.genericName || app.modelData.id
                                color: Config.colors.text
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    weight: Font.Medium
                                    pointSize: 9
                                }
                            }
                        }
                        Image {
                            id: entryIcon
                            source: Quickshell.iconPath(app.modelData.icon, "application-x-desktop")
                            sourceSize {
                                width: 32
                                height: 32
                            }
                            // asynchronous: true
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                        }
                    }
                }
            }
        }
    }
}
