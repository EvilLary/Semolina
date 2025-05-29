pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../Config"
import "../Services"

Rectangle {
    id: root
    color: Colors.background
    radius: Stuff.radius
    signal closePopup
    border {
        width: 1
        color: Colors.light
    }
    // readonly property string userName: Quickshell.env("USER")
    Item {
        id: row
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 8
        }
        height: 50

        QQC.TextField {
            id: textField
            visible: this.text !== ""
            anchors {
                fill: parent
            }
            // height: 50
            // width: 40
            topPadding: 10
            width: parent.width - (parent.visibleChildren.length * 50)
            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
            leftPadding: 14
            placeholderText: " Search..."
            focus: true
            placeholderTextColor: Colors.placeholderText
            background: Rectangle {
                anchors.fill: parent
                color: Colors.base
                radius: Stuff.radius
                border {
                    width: 1
                    color: Colors.light
                }
            }
            color: Colors.text
            font {
                pointSize: 13
            }
            Keys.onTabPressed: listView.incrementCurrentIndex()
            Keys.onBacktabPressed: listView.decrementCurrentIndex()
            onAccepted: {
                if (listView.count !== 0) {
                    listView.currentItem.modelData.uwsmExecute()
                    root.closePopup()
                }
            }
        }
        ClippingRectangle {
            id: userIcon
            visible: textField.text === ""
            anchors {
                left: parent.left
                leftMargin: 6
                verticalCenter: parent.verticalCenter
            }
            width: 50
            height: 50
            radius: this.height / 2
            Image {
                // source: `/var/lib/AccountsService/icons/${root.userName}`
                source: "/var/lib/AccountsService/icons/spicy"
                anchors.centerIn: parent
                sourceSize.width: 50
                sourceSize.height: 50
                fillMode: Image.PreserveAspectCrop
                smooth: false
                asynchronous: true
                cache: false
            }
        }
        Text {
            id: userName
            visible: textField.text === ""
            anchors {
                left: userIcon.right
                margins: 6
                verticalCenter: parent.verticalCenter
            }
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
            textFormat: Text.PlainText
            renderType: Text.NativeRendering
            color: Colors.text
            text: "spicy"
            font {
                weight: Font.Medium
                pointSize: 12
            }
        }
        QQC.Button {
            onClicked: powerMenu.open()
            visible: textField.text === ""
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 6
            }
            flat: true
            icon.name: "system-shutdown-symbolic"
            icon.width: 25
            icon.height: 25

            QQC.Menu {
                id: powerMenu
                onClosed: textField.focus = true
                QQC.MenuItem {
                    text: "Shutdown"
                    padding: 0
                    icon.source: "image://icon/system-shutdown-symbolic"
                    onClicked: Misc.runCommand("systemctl poweroff")
                }
                QQC.MenuItem {
                    text: "Restart"
                    padding: 0
                    icon.source: "image://icon/system-reboot-symbolic"
                    onClicked: Misc.runCommand("systemctl reboot")
                }
                QQC.MenuItem {
                    text: "Sleep"
                    padding: 0
                    icon.source: "image://icon/system-suspend-symbolic"
                    onClicked: Misc.runCommand("systemctl suspend")
                }
                QQC.MenuItem {
                    text: "Logout"
                    padding: 0
                    icon.source: "image://icon/system-log-out-symbolic"
                    onClicked: Misc.runCommand("uwsm stop")
                }
                QQC.MenuItem {
                    text: "Lock the system"
                    padding: 0
                    icon.source: "image://icon/system-lock-screen-symbolic"
                    onClicked: Misc.runCommand("loginctl lock-session")
                }
                QQC.MenuItem {
                    text: "Soft Reboot"
                    padding: 0
                    icon.source: "image://icon/system-reboot-symbolic"
                    onClicked: Misc.runCommand("systemctl soft-reboot")
                }
            }
        }
    }

    Rectangle {
        id: content
        anchors {
            right: parent.right
            top: row.bottom
            left: parent.left
            bottom: parent.bottom
            margins: 8
        }
        radius: Stuff.radius
        color: Colors.base
        clip: true
        border {
            width: 1
            color: Colors.light
        }

        Row {
            anchors.fill: parent
            anchors.margins: 8
            move: Transition {
                NumberAnimation {
                    property: "x"
                    duration: 125
                    easing.type: Easing.InOutQuad
                }
            }
            spacing: 6

            ColumnLayout {
                id: column
                visible: textField.text === ""
                height: parent.height
                width: 50
                Repeater {
                    model: ["development", "education", "games", "graphics", "internet", "multimedia", "office", "system", "utilities", "other"]
                    Rectangle {
                        id: category
                        required property string modelData
                        readonly property bool active: modelData === listView.currCategory
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: active ? Colors.accent : (mouse.containsMouse ? Colors.light : Colors.base)
                        Behavior on color {
                            ColorAnimation {
                                duration: 75
                            }
                        }
                        radius: Stuff.radius
                        Image {
                            anchors.centerIn: parent
                            source: Quickshell.iconPath(`applications-${category.modelData}-symbolic`)
                            sourceSize.width: 24
                            sourceSize.height: 24
                            height: 24
                            width: 24
                            smooth: false
                            cache: false
                        }
                        QQC.ToolTip {
                            visible: mouse.containsMouse
                            text: category.modelData
                            // delay:
                        }
                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            onClicked: listView.currCategory = category.modelData
                            // onClicked: column.changeCategory(category.modelData)
                            hoverEnabled: true
                        }
                    }
                }
            }

            Rectangle {
                id: sep
                visible: textField.text.length === 0
                height: parent.height
                color: Colors.light
                width: 1
            }

            ListView {
                id: listView
                height: parent.height
                width: textField.text.length === 0 ? parent.width - sep.width - column.width - 12 : parent.width
                Behavior on width {
                    NumberAnimation {
                        duration: 125
                        easing.type: Easing.InOutQuad
                    }
                }
                property string currCategory: "development"
                model: ScriptModel {
                    id: model
                    values: {
                        if (textField.text.length > 0) {
                            return DesktopEntries.applications.values.filter(entry => entry.name.toLowerCase().includes(textField.text.toLowerCase())).sort((a, b) => {
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
                            });
                        } else {
                            switch (listView.currCategory) {
                            case "development":
                                return Misc.apps.development;
                            case "education":
                                return Misc.apps.education;
                            case "games":
                                return Misc.apps.games;
                            case "graphics":
                                return Misc.apps.graphics;
                            case "internet":
                                return Misc.apps.internet;
                            case "multimedia":
                                return Misc.apps.multimedia;
                            case "office":
                                return Misc.apps.office;
                            case "system":
                                return Misc.apps.system;
                            case "utilities":
                                return Misc.apps.utilities;
                            case "other":
                                return Misc.apps.other;
                            }
                        }
                    }
                    onValuesChanged: listView.currentIndex = 0
                }
                cacheBuffer: 0
                reuseItems: false
                highlight: Rectangle {
                    color: Colors.midlight
                    radius: Stuff.radius
                }
                highlightMoveDuration: 50
                highlightResizeDuration: 0
                keyNavigationWraps: true

                add: Transition {
                    NumberAnimation {
                        property: "opacity"
                        duration: 125
                    }
                }

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 125
                    }
                }
                delegate: AppDelegate {
                    // id: app
                    required property int index
                    height: 55
                    width: listView.width
                    onEntered: listView.currentIndex = this.index
                }
                Loader {
                    active: listView.count === 0
                    anchors.centerIn: parent
                    sourceComponent: Text {
                        text: '\nفارغ'
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        textFormat: Text.PlainText
                        renderType: Text.NativeRendering
                        color: Colors.midlight
                        font {
                            pointSize: 18
                            kerning: false
                            weight: Font.Bold
                        }
                    }
                }
            }
        }
    }
    component AppDelegate: MouseArea {
        id: app
        required property DesktopEntry modelData
        onClicked: modelData.uwsmExecute(), root.closePopup()
        hoverEnabled: true
        Image {
            id: icon
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                margins: 8
            }
            width: 40
            height: 40
            sourceSize.width: 40
            sourceSize.height: 40
            source: Quickshell.iconPath(app.modelData.icon, "unknown")
            cache: false
            smooth: false
            asynchronous: false
        }
        ColumnLayout {
            anchors {
                margins: 8
                left: icon.right
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                textFormat: Text.PlainText
                renderType: Text.NativeRendering
                text: app.modelData.name
                color: Colors.text
                font {
                    pointSize: 10
                    kerning: false
                    preferShaping: false
                    weight: Font.DemiBold
                }
            }
            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                textFormat: Text.PlainText
                renderType: Text.NativeRendering
                text: app.modelData.comment || app.modelData.genericName || app.modelData.id
                color: Colors.text
                font {
                    pointSize: 8
                    kerning: false
                    preferShaping: false
                    features: {
                        "frac": 0,
                        "kern": 0,
                        "dlig": 0,
                        "hlig": 0,
                        "liga": 0
                    }
                }
            }
        }
    }
}
