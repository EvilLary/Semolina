pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import QtQuick.Controls
import "../"

Rectangle {
    id: rect
    implicitHeight: Math.max(column.childrenRect.height, 100)

    required property var modelData
    required property bool isToast

    color: Config.colors.background
    radius: Config.globalRadius
    border {
        width: 1
        color: Config.colors.border
    }
    signal expired

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        onClicked: {
            rect.modelData.dismiss();
        }

        Item {
            id: column
            implicitHeight: childrenRect.height
            implicitWidth: parent.width
            clip: true

            Rectangle {
                id: header
                implicitHeight: headerRow.implicitHeight + 10
                anchors {
                    right: parent.right
                    left: parent.left
                    top: parent.top
                }
                color: "transparent"
                topLeftRadius: Config.globalRadius
                topRightRadius: Config.globalRadius
                border {
                    width: 1
                    color: Config.colors.border
                }
                RowLayout {
                    id: headerRow
                    anchors {
                        fill: parent
                        margins: 5
                        leftMargin: 8
                    }
                    Image {
                        source: Quickshell.iconPath(rect.modelData.appIcon, 'notifications-symbolic')
                        sourceSize {
                            width: 23
                            height: 23
                        }
                        smooth: false
                        asynchronous: false
                    }
                    Text {
                        id: appName
                        text: rect.modelData.appName
                        Layout.fillWidth: true
                        renderType: Text.NativeRendering
                        horizontalAlignment: Text.AlignLeft
                        color: Config.colors.text
                        font {
                            pointSize: 9
                            weight: Font.DemiBold
                        }
                    }
                    CloseButton {
                        id: timer
                        implicitHeight: 26
                        implicitWidth: 26
                        startTimer: rect.isToast
                        onTimerFinished: {
                            //prevent tracking low urgency notifications
                            if (rect.modelData.urgency == 0 || rect.modelData.transient) {
                                rect.modelData.dismiss();
                            } else {
                                //rect.modelData.expire()
                                //for some reason sending an expire message to the notification removes it from the list of tracked notifications
                                //I don't know if it's intented or not
                                rect.expired();
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: content
                anchors {
                    top: header.bottom
                    right: parent.right
                    left: parent.left
                    topMargin: 10
                    margins: 10
                }
                ClippingRectangle {
                    id: image
                    visible: rect.modelData.image != ""
                    radius: Config.globalRadius
                    color: "transparent"
                    implicitHeight: 100
                    implicitWidth: 100
                    Image {
                        source: rect.modelData.image
                        anchors.fill: parent
                        smooth: false
                        asynchronous: true
                        sourceSize.width: 100
                        sourceSize.height: 100
                        fillMode: Image.PreserveAspectCrop
                    }
                }
                Column {
                    Layout.fillWidth: true
                    Layout.leftMargin: 5
                    Label {
                        text: rect.modelData.summary
                        maximumLineCount: 1
                        width: parent.width
                        elide: Text.ElideRight
                        font {
                            weight: Font.Bold
                            pointSize: 10
                        }
                    }
                    Label {
                        text: rect.modelData.body
                        anchors.rightMargin: 5
                        maximumLineCount: 5
                        width: parent.width
                        textFormat: Text.PlainText
                        elide: Text.ElideRight
                        font {
                            weight: Font.Normal
                            pointSize: 9
                        }
                    }
                }
            }
            Rectangle {
                id: actionRow
                visible: repeater.count > 0
                anchors {
                    top: content.bottom
                    right: parent.right
                    left: parent.left
                    topMargin: 5
                }
                color: "transparent"
                bottomLeftRadius: Config.globalRadius
                bottomRightRadius: Config.globalRadius
                border {
                    width: 1
                    color: Config.colors.border
                }
                height: actions.implicitHeight + 10
                RowLayout {
                    id: actions
                    anchors.fill: parent
                    anchors.margins: 5
                    Repeater {
                        id: repeater
                        model: rect.modelData.actions

                        Button {
                            id: action
                            required property var modelData
                            implicitHeight: 35
                            icon.source: modelData.identifier
                            flat: true
                            display: AbstractButton.TextBesideIcon
                            Layout.fillWidth: true
                            onClicked: modelData.invoke()
                            text: modelData.text
                        }
                    }
                }
            }
        }
    }
}
