pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
// import QtQuick.Controls as QQC
import Qt.labs.platform as Labs
// import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../../Libs"
import "../../"
import "../../Components" as C

Item {
    id: taskManager
    implicitWidth: row.width
    required property var bar
    readonly property int iconHeight: 45
    property int tracked
    clip: false

    C.Popup {
        id: kickoffPopup
        rootWindow: taskManager.bar
        parentItem: taskManager
        contentUrl: Qt.resolvedUrl("./KickOff.qml")
        // contentItem: KickOff { }
        popupWidth: 700
        popupHeight: 550
        // This is to ensure we got popup at the center no matter what
        // kinda stupid but whatever
        offsetX: taskManager.width / 2
    }
    Toplevels {
        id: toplevels
    }
    // C.Popup {
    //     id: preview
    //     rootWindow: taskManager.bar
    //     parentItem: taskManager
    //     //contentUrl: "root:/Bar/Tasks/WindowPreview.qml"
    //     contentItem: WindowPreview {
    //         tracked: taskManager.tracked
    //         onClose: preview.close()
    //     }
    //     offsetX: {
    //         let s = taskManager.tracked + 1;
    //         // image size + spacing
    //         return s * 58;
    //     }
    //     popupHeight: 90 * 2 + 25
    //     popupWidth: 160 * 2
    //     onClosed: taskManager.tracked = -1
    // }
    Process {
        id: runner
        command: ["uwsmapp.sh"]
        running: false
        function launch(id: string): void {
            const app = id + '.desktop';
            runner.command = ["uwsmapp.sh", app];
            runner.startDetached();
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        Layout.fillHeight: true
        spacing: 8
        MouseArea {
            id: apper
            Layout.fillHeight: true
            implicitWidth: this.implicitHeight
            implicitHeight: taskManager.iconHeight
            onClicked: kickoffPopup.toggle()
            // onClicked: menuOpener.open()
            hoverEnabled: true

            Image {
                anchors.fill: parent
                source: 'image://icon/applications-all-symbolic'
                mipmap: false
                smooth: true
                asynchronous: false
                fillMode: Image.PreserveAspectFit
                sourceSize {
                    width: 50
                    height: 50
                }
                scale: (apper.containsMouse) ? 1.23 : 1
                Behavior on scale {
                    ScaleAnimator {
                        easing.type: Easing.Linear
                        duration: 150
                    }
                }
            }
        }
        Repeater {
            id: repeater
            model: toplevels.model

            MouseArea {
                id: toplevel
                required property var modelData
                required property int index
                readonly property bool active: (toplevels.activeWindow?.appId || null) === modelData.id
                readonly property int windowsCount: toplevel.modelData.windows.size
                Layout.alignment: Qt.AlignCenter
                Layout.fillHeight: true
                implicitWidth: this.implicitHeight
                implicitHeight: taskManager.iconHeight - 4

                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                onClicked: mouse => {
                    switch (mouse.button) {
                    case (Qt.LeftButton):
                        if (windowsCount <= 0) {
                            runner.launch(modelData.desktopEntry.id);
                        } else {
                            const activateFirst = function () {
                                const windows = [...modelData.windows.values()];
                                windows[0].activate();
                            };
                            if (windowsCount > 1) {
                                const windows = [...modelData.windows.values()];
                                const activeIndex = windows.findIndex(obj => {
                                    return obj.activated;
                                });
                                if (activeIndex == -1) {
                                    activateFirst();
                                } else {
                                    if (activeIndex == (windowsCount - 1)) {
                                        activateFirst();
                                    } else {
                                        windows[1 + activeIndex].activate();
                                    }
                                }
                            } else {
                                // const first = [...modelData.windows.values()][0];
                                // first.close();
                                activateFirst();
                            }
                        }
                        mouse.accepted = true;
                        break;
                    case (Qt.RightButton):
                        toplevel.openMenu = true;
                        menuOpener.open();
                        mouse.accepted = true;
                        break;
                    case (Qt.MiddleButton):
                        if (windowsCount == 0) {
                            mouse.accepted = true;
                            return;
                        };
                        const windows = [...modelData.windows.values()];
                        const activeIndex = windows.findIndex(obj => {
                            return obj.activated;
                        });
                        if (activeIndex == -1) {
                            windows[0].close();
                        } else {
                            windows[activeIndex].close();
                        }
                        // if (modelData.desktopEntry) {
                        //     runner.launch(modelData.desktopEntry.id);
                        // }
                        // mouse.accepted = true;
                        break;
                    }
                }

                property bool openMenu: false
                Labs.Menu {
                    id: menuOpener
                    enabled: false
                    onAboutToHide: this.enabled = false
                    Labs.MenuItem {
                        enabled: (toplevel.modelData.desktopEntry !== null)
                        text: "Launch new Instance"
                        icon.source: toplevel.modelData.icon
                        onTriggered: runner.launch(toplevel.modelData.desktopEntry.id)
                    }

                    Labs.MenuSeparator {
                        text: "Windows"
                    }
                    Instantiator {
                        model: toplevel.modelData.windows
                        // asynchronous: true
                        onObjectAdded: (index, object) => {
                            menuOpener.addItem(object);
                        }
                        onObjectRemoved: (index, object) => {
                            menuOpener.removeItem(object);
                        }
                        delegate: Labs.MenuItem {
                            required property var modelData
                            text: modelData.title.substring(0, 40) + (modelData.title.length > 40 ? '...' : '')
                            icon.source: toplevel.modelData.icon
                            onTriggered: modelData.activate()
                        }
                    }
                    // MenuItemGroup {
                    //     id: actions
                    // }
                    // MenuSeparator {
                    //     text: "Actions"
                    // }
                    // Instantiator {
                    //     id: actionsModel
                    //     active: true
                    //     model: toplevel.modelData.desktopEntry.actions
                    //     // asynchronous: true
                    //     onObjectAdded: (index, object) => {
                    //         menuOpener.addItem(object);
                    //     }
                    //     onObjectRemoved: (index, object) => {
                    //         menuOpener.removeItem(object);
                    //     }
                    //     delegate: MenuItem {
                    //         required property var modelData
                    //         text: modelData.name
                    //         // icon.source: (modelData.icon === "") ? toplevel.modelData.icon : "image://icon/" + modelData.icon
                    //         onTriggered: modelData.execute()
                    //         group: actions
                    //     }
                    // }
                    // onAboutToShow: print(actions.items);
                }
                hoverEnabled: true
                IconImage {
                    id: toplevelIcon
                    anchors.fill: parent
                    source: toplevel.modelData.icon
                    implicitSize: taskManager.iconHeight
                    mipmap: false
                    smooth: false
                    asynchronous: false
                    scale: (toplevel.active || toplevel.containsMouse) ? 1.23 : 1
                    layer {
                        enabled: toplevel.windowsCount <= 0
                        effect: HueSaturation {
                            cached: true
                            lightness: -0.5
                            saturation: -0.4
                        }
                    }
                    backer {
                        sourceSize {
                            width: toplevelIcon.implicitSize * toplevelIcon.scale
                            height: toplevelIcon.implicitSize * toplevelIcon.scale
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            easing.type: Easing.Linear
                            duration: 150
                        }
                    }
                }

                Loader {
                    active: toplevel.windowsCount > 1
                    anchors {
                        top: parent.top
                        topMargin: -5
                        right: parent.right
                        rightMargin: -5
                    }
                    sourceComponent: Rectangle {
                        // visible: toplevel.windowsCount > 1
                        color: Config.colors.accent
                        radius: Config.globalRadius
                        width: 18
                        height: 18
                        Text {
                            anchors.centerIn: parent
                            text: {
                                let num = toplevel.windowsCount.toString();
                                return num.replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]);
                            }
                            color: "white"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font {
                                pointSize: 10
                                weight: Font.Medium
                            }
                        }
                    }
                }
            }
        }
    }
}
