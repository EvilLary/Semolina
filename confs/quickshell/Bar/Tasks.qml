pragma ComponentBehavior: Bound

import QtQuick
import "../Config"
import "../Services"
import "../Components" as C
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
// import Quickshell.Io

Item {
    id: tasks
    required property var bar
    height: column.height
    TaskManager {
        id: taskManager
    }
    // IpcHandler {
    //     target: "launcher"
    //     function toggle(): void {
    //         kickoff.toggle()
    //     }
    // }
    C.Popup {
        id: kickoff
        itemUrl: Qt.resolvedUrl("./Kickoff.qml")
        parentItem: tasks
        width: 500
        height: 600
        bar: tasks.bar
    }
    // component TaskButton: Rectangle {
    // }
    ColumnLayout {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        Layout.preferredHeight: Math.max(implicitHeight, 10)
        Layout.preferredWidth: tasks.width
        Layout.minimumHeight: Layout.preferredHeight
        Layout.minimumWidth: Layout.preferredWidth
        Layout.maximumHeight: Layout.preferredHeight
        Layout.maximumWidth: Layout.preferredWidth
        Layout.fillWidth: true
        // Component.onCompleted: print(this.height)
        // onHeightChanged: print(this.height)
        spacing: 6
        height: Layout.preferredHeight
        width: parent.width
        MouseArea {
            id: menuBtn
            Layout.alignment: Qt.AlignCenter
            implicitWidth: 40
            implicitHeight: 45
            Layout.bottomMargin: 4
            onClicked: kickoff.toggle()
            Text {
                anchors.centerIn: parent
                text: ""
                renderType: Text.NativeRendering
                textFormat: Text.PlainText
                color: Qt.darker(Colors.text, 1.3)
                font {
                    pointSize: menuBtn.containsPress ? 28 : 32
                    Behavior on pointSize {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.Linear
                        }
                    }
                    kerning: false
                    features: {
                        "frac": 0,
                        "kern": 0,
                        "dlig": 0,
                        "hlig": 0,
                        "liga": 0
                    }
                    // preferShaping: false
                }
            }
        }
        Repeater {
            model: taskManager.model
            Rectangle {
                id: task
                Layout.alignment: Qt.AlignCenter
                required property var modelData
                readonly property bool active: modelData.id === taskManager.activeWindow
                readonly property int windowsCount: modelData.windows.size
                implicitWidth: 42
                implicitHeight: 42
                radius: Stuff.radius
                color: this.active ? Colors.light : (this.windowsCount === 0) ? Colors.base : Colors.mid
                // Behavior on color {
                //     ColorAnimation {
                //         duration: 150
                //         easing.type: Easing.Linear
                //     }
                // }
                onWindowsCountChanged: busy.active = false
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton /*| Qt.RightButton*/ | Qt.MiddleButton
                    onClicked: mouse => {
                        switch (mouse.button) {
                        case Qt.LeftButton:
                            if (task.windowsCount === 0) {
                                if (task.modelData.desktopEntry) {
                                    task.modelData.desktopEntry.uwsmExecute();
                                    busy.active = true;
                                }
                            } else {
                                task.modelData.activate();
                            }
                            mouse.accepted = true;
                            break;
                        case Qt.RightButton:
                            mouse.accepted = true;
                            break;
                        case Qt.MiddleButton:
                            task.modelData.close();
                            mouse.accepted = true;
                            break;
                        }
                    }
                }
                Image {
                    id: taskIcon
                    anchors.centerIn: parent
                    width: 32
                    height: 32
                    smooth: true
                    mipmap: false
                    cache: false
                    asynchronous: false
                    source: task.modelData.icon
                    sourceSize {
                        width: 32
                        height: 32
                    }
                    scale: mouseArea.containsPress ? 0.88 : 1
                    Behavior on scale {
                        NumberAnimation {
                            duration: 75
                        }
                    }
                }

                Loader {
                    active: mouseArea.containsMouse
                    visible: this.active
                    anchors.fill: taskIcon
                    asynchronous: false
                    scale: taskIcon.scale
                    sourceComponent: BrightnessContrast {
                        source: taskIcon
                        brightness: 0.25
                        contrast: 0
                    }
                }

                Loader {
                    id: busy
                    active: false
                    visible: this.active
                    asynchronous: false
                    anchors.centerIn: parent
                    width: task.width / 2
                    height: this.width
                    sourceComponent: BusyIndicator {
                        Timer {
                            interval: 5000
                            running: true
                            onTriggered: busy.active = false
                        }
                        running: true
                    }
                }
                Loader {
                    active: task.windowsCount > 1
                    visible: this.active
                    anchors {
                        left: parent.left
                        top: parent.top
                        leftMargin: 2
                        topMargin: 2
                    }
                    sourceComponent: Rectangle {
                        width: 16
                        height: 16
                        radius: 8
                        color: Colors.altBase
                        Text {
                            anchors.centerIn: parent
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                            text: task.windowsCount.toString().replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d])
                            lineHeight: 1
                            color: Colors.text
                            textFormat: Text.PlainText
                            renderType: Text.NativeRendering
                            font {
                                kerning: false
                                weight: Font.DemiBold
                                pointSize: 10
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
        }
    }
}
