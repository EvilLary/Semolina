pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "root:Libs"
import Qt.labs.sharedimage
import "root:Launcher"

Item {
    id: taskManager
    implicitWidth: row.width
    clip: false
    RowLayout {
        id: row
        anchors.centerIn: parent
        Layout.fillHeight: true
        spacing: 8
        MouseArea {
            id: apper
            Layout.fillHeight: true
            implicitWidth: this.implicitHeight
            implicitHeight: 42
            onClicked: Launcher.toggle()
            hoverEnabled: true
            Image {
                anchors.fill: parent
                source: 'image://icon/app-launcher'
                mipmap: true
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
            model: Toplevels.windows
            
            MouseArea {
                id: toplevel
                Layout.fillHeight: true
                implicitWidth: this.implicitHeight
                implicitHeight: 42
                required property var modelData
                onClicked: modelData.activate()
                hoverEnabled: true

                IconImage {
                    id: toplevelIcon
                    anchors.fill: parent
                    source: Qt.resolvedUrl(Toplevels.getToplevelIcon(toplevel.modelData.appId))
                    implicitSize: 50
                    mipmap: false
                    smooth: true
                    asynchronous: false
                    scale: (toplevel.modelData.activated || toplevel.containsMouse) ? 1.25 : 1
                    backer {
                        sourceSize {
                            //avoid blurring icons when scalling up
                            width: toplevelIcon.implicitSize * toplevelIcon.scale
                            height: toplevelIcon.implicitSize * toplevelIcon.scale
                        }
                    }
                    Behavior on scale {
                        ScaleAnimator {
                            easing.type: Easing.Linear
                            duration: 150
                        }
                    }
                }
            }
        }
    }
}
