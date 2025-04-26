pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import "../../Libs"
import QtQuick.Controls

Loader {
    id: previews
    enabled: taskManager.tracked != -1
    required property int tracked
    signal close

    sourceComponent: MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: hideTimer.restart()
        onEntered: hideTimer.stop()
        Timer {
            id: hideTimer
            repeat: false
            interval: 250
            onTriggered: {
                previews.close();
            }
        }
        Rectangle {
            color: Config.colors.background
            radius: Config.globalRadius
            anchors.fill: parent
            border {
                width: 1
                color: Qt.alpha("white", 0.2)
            }

            Text {
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    //left: parent.left
                    margins: 15
                    topMargin: 5
                }
                text: Toplevels.groupedWindows?.values[tracked]?.id ?? ""
                font {
                    pointSize: 11
                    weight: Font.Bold
                }
                color: Config.colors.text
            }
            ScrollView {
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    //verticalCenter: parent.verticalCenter
                    topMargin: 30
                }
                ScrollBar.horizontal.interactive: true
                ScrollBar.vertical.interactive: false
                //wheelEnabled: true
                //anchors.fill: parent
                //width: parent.width
                //height: parent.height
                RowLayout {
                    anchors.fill: parent
                    //anchors.centerIn: parent
                    spacing: 0
                    Repeater {
                        model: Toplevels.groupedWindows?.values[tracked]?.windows ?? null
                        ItemDelegate {
                            id: window
                            required property var modelData
                            implicitWidth: 160 * 1.95
                            implicitHeight: 90 * 1.90
                            onClicked: modelData.activate(), previews.close()
                            hoverEnabled: true
                            ToolTip.visible: window.hovered
                            ToolTip.text: window.modelData.title
                            ToolTip.delay: 150
                            Image {
                                source: Toplevels.getToplevelIcon(modelData.appId)
                                anchors.centerIn: parent
                                width: 100
                                height: 100
                            }
                            //ScreencopyView {
                            //    anchors.margins: 10
                            //    anchors.fill: parent
                            //    live: true
                            //    //captureSource: window.modelData
                            //    Component.onCompleted: this.captureSource = window.modelData
                            //}
                        }
                    }
                }
            }
            //ListView {
                //    id: list
                //    anchors.fill: parent
                //    layoutDirection: Qt.LeftToRight
                //    model: Toplevels.groupedWindows.values[tracked].windows
                //}
            }
        }
    }
