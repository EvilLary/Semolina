pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Controls
import "../Components" as C
import "../Config"

Scope {
    id: root
    property int x
    property int y
    IpcHandler {
        target: "clipboard"
        function toggle(): void {
            if (!loader.active) {
                cursorPosition.running = true;
            } else {
                loader.active = false;
            }
        }
    }
    Process {
        id: cursorPosition
        command: ["hyprctl", "cursorpos"]
        stdout: SplitParser {
            onRead: data => {
                const [x, y] = data.split(',');
                root.x = x;
                root.y = y;
            }
        }
        onExited: {
            loader.active = true;
        }
    }

    LazyLoader {
        id: loader

        PanelWindow {
            id: layer
            //WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "shell"
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            exclusionMode: ExclusionMode.Ignore

            color: "transparent"
            // surfaceFormat.opaque: true
            HyprlandWindow.visibleMask: Region {
                item: content
            }

            HyprlandFocusGrab {
                id: grab
                windows: [layer]
                active: true
                onCleared: loader.active = false
            }
            implicitWidth: 500
            implicitHeight: 525
            margins {
                top: Math.min((root.y + 5), (layer.screen.height - layer.height - 5))
                left: Math.min((root.x + 5), (layer.screen.width - layer.width - 5))
            }
            anchors {
                top: true
                left: true
            }
            ClipboardModel {
                id: clipboardModel
                onClose: {
                    loader.active = false;
                }
                Component.onCompleted: this.getClipboardData()
            }
            Rectangle {
                id: content
                anchors {
                    fill: parent
                }
                color: Colors.background
                radius: Stuff.radius
                border {
                    color: Qt.alpha(Colors.text, 0.2)
                    width: 1
                }
                RowLayout {
                    id: row
                    height: 40
                    anchors {
                        top: parent.top
                        right: parent.right
                        left: parent.left
                        margins: 8
                    }
                    TextField {
                        id: textField
                        visible: this.text !== ""
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        leftPadding: 14
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
                            kerning: false
                        }
                        focus: true
                        Keys.onEscapePressed: loader.active = false
                        Keys.onBacktabPressed: listView.decrementCurrentIndex()
                        Keys.onTabPressed: listView.incrementCurrentIndex()
                        onAccepted: {
                            if (listView.count !== 0) {
                                clipboardModel.copyItem(listView.currentItem.modelData.id);
                            }
                        }
                    }

                    C.TabBar {
                        id: tabBar
                        visible: textField.text === ""
                        model: ["نصوص", "صور"]
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        visible: textField.text === ""
                        Layout.fillHeight: true
                        implicitWidth: this.height
                        color: deleteArea.containsMouse ? Colors.light : Colors.mid
                        radius: Stuff.radius
                        Text {
                            anchors.centerIn: parent
                            text: "󰆴"
                            verticalAlignment: Qt.AlignVCenter
                            horizontalAlignment: Qt.AlignHCenter
                            color: Colors.negative
                            textFormat: Text.PlainText
                            renderType: Text.NativeRendering
                            font {
                                pointSize: 22
                                weight: Font.Medium
                            }
                        }
                        MouseArea {
                            id: deleteArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: clipboardModel.wipeCliphist()
                        }
                    }
                }

                Rectangle {
                    id: clipContent
                    anchors {
                        right: parent.right
                        top: row.bottom
                        left: parent.left
                        bottom: parent.bottom
                        margins: 8
                    }
                    radius: Stuff.radius
                    color: Colors.base
                    border {
                        width: 1
                        color: Colors.light
                    }

                    Loader {
                        active: !clipboardModel.ready
                        anchors.centerIn: parent
                        sourceComponent: BusyIndicator {
                            running: true
                        }
                    }

                    Loader {
                        active: listView.count === 0 && clipboardModel.ready
                        anchors.centerIn: parent
                        sourceComponent: Text {
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: "\nفارغ"
                            color: Colors.light
                            renderType: Text.NativeRendering
                            textFormat: Text.PlainText
                            font {
                                weight: Font.Bold
                                pointSize: 20
                            }
                        }
                    }
                    ListView {
                        id: listView
                        visible: clipboardModel.ready
                        snapMode: ListView.NoSnap
                        anchors {
                            fill: parent
                            margins: 6
                        }
                        // add: Transition {
                        //     NumberAnimation {
                        //         property: "x"
                        //         from: 0
                        //         duration: 200
                        //         easing.type: Easing.InOutQuad
                        //     }
                        // }
                        // populate: Transition {
                        //     NumberAnimation {
                        //         property: "x"
                        //         from: 0
                        //         duration: 200
                        //         easing.type: Easing.InOutQuad
                        //     }
                        // }
                        highlightMoveDuration: 0
                        highlightResizeDuration: 0
                        maximumFlickVelocity: 10000
                        cacheBuffer: 0
                        // boundsMovement: ListView.StopAtBounds
                        // interactive: true
                        flickableDirection: ListView.VerticalFlick
                        // cacheBuffer: 0
                        model: ScriptModel {
                            values: {
                                const text = textField.text;
                                const currentList = function () {
                                    if (tabBar.activeIndex === 0) {
                                        return clipboardModel.texts;
                                    } else {
                                        return clipboardModel.images;
                                    }
                                };
                                if (textField.text === "") {
                                    return currentList();
                                } else {
                                    return currentList().filter(o => {
                                        return o.content.toLowerCase().includes(text.toLowerCase());
                                    });
                                }
                            }
                            onValuesChanged: listView.currentIndex = 0
                        }
                        clip: true
                        // highlight: Rectangle {
                        //     color: Colors.light
                        //     radius: Stuff.radius
                        // }
                        spacing: 6
                        delegate: Rectangle {
                            id: delegate
                            required property var modelData
                            required property int index
                            readonly property bool isImage: modelData.image !== undefined
                            implicitWidth: listView.width
                            implicitHeight: this.isImage ? 190 : Math.max(textLoader.height, 40)
                            radius: Stuff.radius
                            color: delegate.ListView.isCurrentItem ? Colors.light : Colors.mid
                            border {
                                color: Colors.midlight
                                width: 1
                            }
                            MouseArea {
                                id: mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: listView.currentIndex = delegate.index
                                onClicked: clipboardModel.copyItem(delegate.modelData.id)
                            }
                            // Rectangle {
                            //     visible: mouse.containsMouse
                            //     anchors {
                            //         right: parent.right
                            //         rightMargin: 6
                            //         verticalCenter: parent.verticalCenter
                            //     }
                            //     width: 30
                            //     height: 30
                            //     radius: Stuff.radius
                            //     color: Colors.mid
                            //     Text {
                            //         anchors.centerIn: parent
                            //         horizontalAlignment: Qt.AlignHCenter
                            //         verticalAlignment: Qt.AlignVCenter
                            //         text: ""
                            //         textFormat: Text.PlainText
                            //         renderType: Text.NativeRendering
                            //         color: Colors.text
                            //     }
                            // }
                            Loader {
                                id: imgLoader
                                anchors {
                                    fill: parent
                                    margins: 6
                                }
                                active: delegate.isImage
                                sourceComponent: Image {
                                    source: delegate.modelData.image
                                    smooth: false
                                    asynchronous: true
                                    fillMode: Image.PreserveAspectFit
                                    cache: false
                                    sourceSize.width: 190
                                    sourceSize.height: 190
                                }
                            }
                            Loader {
                                id: textLoader
                                active: !delegate.isImage
                                width: parent.width
                                anchors.centerIn: parent
                                sourceComponent: Text {
                                    id: text
                                    text: delegate.modelData.content
                                    // width: parent.width
                                    padding: 10
                                    horizontalAlignment: Qt.AlignLeft
                                    verticalAlignment: Qt.AlignVCenter
                                    maximumLineCount: 10
                                    color: Colors.text
                                    textFormat: Text.PlainText
                                    renderType: Text.NativeRendering
                                    elide: Text.ElideRight
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    font {
                                        kerning: false
                                        pointSize: 11
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
