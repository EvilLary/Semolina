import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Notifications
import Quickshell
import QtQuick.Layouts
import "../Config"

MouseArea {
    id: root
    height: column.implicitHeight + 12

    readonly property string image: root.modelData?.image || ""
    readonly property string appIcon: Quickshell.iconPath(root.modelData?.appIcon || "", "notifications")
    readonly property real timeout: (root.modelData?.expireTimeout === -1 || root.modelData?.expireTimeout === undefined) ? 5 : root.modelData?.expireTimeout
    readonly property string summary: root.modelData?.summary || ""
    readonly property string body: root.modelData?.body || ""
    readonly property string notificationTitle: root.modelData?.appName || root.modelData?.id || ""
    // INFO filter out the default action that notifications have (like discord), they are always listed in `actions` property
    // probably worth reporting this as an issue to qs
    // Discord reports this -> "actions":[{"objectName":"","identifier":"default","text":"View"}
    readonly property list<NotificationAction> actions: root.modelData?.actions.filter(a => a.identifier !== "default") || []
    readonly property NotificationAction defaultAction: root.modelData?.actions.find(a => a.identifier === "default") || null

    // Component.onCompleted: {
    //     root.image = root.modelData.image;
    //     root.appIcon = Quickshell.iconPath(root.modelData.appIcon, "notifications");
    //     root.timeout = (root.modelData?.expireTimeout === -1) ? 5 : root.modelData?.expireTimeout;
    //     root.summary = root.modelData?.summary;
    //     root.body = root.modelData?.body;
    //     root.notificationTitle = root.modelData?.appName || root.modelData?.id;
    //     root.actions = root.modelData?.actions.filter(a => a.identifier !== "default");
    //     root.defaultAction = root.modelData?.actions.find(a => a.identifier === "default");
    // }
    hoverEnabled: true
    onClicked: {
        if (root.defaultAction) {
            root.defaultAction.invoke();
        } else {
            root.modelData.dismiss();
        }
    }

    // BACKGROUND
    Rectangle {
        id: rect
        anchors.fill: parent
        radius: Stuff.radius
        // color: Colors.base
        color: root.containsMouse ? Colors.altBase : Colors.base
        Behavior on color {
            ColorAnimation {
                duration: 125
            }
        }
        border {
            width: 1
            color: Colors.light
        }
    }

    // CONTENT
    ColumnLayout {
        id: column
        anchors.centerIn: parent
        width: parent.width - 12
        //TOP ROW
        Item {
            id: topRow
            Layout.fillWidth: true
            implicitHeight: 25
            Image {
                id: notificationIcon
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                width: 24
                height: 24
                sourceSize.width: 24
                sourceSize.height: 24
                smooth: false
                cache: false
                source: root.appIcon
                fillMode: Image.PreserveAspectCrop
            }
            Text {
                id: notificationTitle
                text: root.notificationTitle
                anchors {
                    left: notificationIcon.right
                    leftMargin: 4
                    verticalCenter: parent.verticalCenter
                }
                color: Colors.text
                textFormat: Text.PlainText
                renderType: Text.NativeRendering
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
                font {
                    pointSize: 9
                    weight: Font.Medium
                    kerning: false
                    // capitalization: Font.Capitalize
                }
            }
            Rectangle {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 6
                }
                // border {
                //     color: Colors.negative
                //     width: 1
                // }
                height: 24
                width: 24
                radius: 12
                color: closeArea.containsMouse ? Colors.light : Colors.midlight
                Text {
                    anchors.centerIn: parent
                    verticalAlignment: Qt.AlignCenter
                    horizontalAlignment: Qt.AlignCenter
                    text: ""
                    color: Colors.text
                    font {
                        family: "UbuntuSansMono Nerd Font Mono"
                        pointSize: 14
                    }
                }
                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.modelData.dismiss()
                }
            }
        }
        Rectangle {
            id: parentofShitTimer
            Layout.fillWidth: true
            color: Colors.light
            implicitHeight: 1
            Rectangle {
                id: shitTimer
                anchors {
                    left: parent.left
                    // top: parent.top
                    bottom: parent.bottom
                }
                height: 1
                width: parent.width
                color: Colors.accent
                // Component.onCompleted: print(width)
                PropertyAnimation {
                    id: shitAnim
                    target: shitTimer
                    property: "width"
                    to: 0
                    from: parentofShitTimer.width
                    duration: root.timeout * 1000
                    paused: root.containsMouse && this.running
                    onFinished: root.modelData.expire()
                }
                Component.onCompleted: shitAnim.start()
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: implicitHeight
            Loader {
                active: root.image !== ""
                visible: this.active
                Layout.preferredWidth: 75
                Layout.preferredHeight: 75
                sourceComponent: ClippingRectangle {
                    radius: 5
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        smooth: true
                        asynchronous: true
                        mipmap: false
                        cache: false
                        source: root.image
                        fillMode: Image.PreserveAspectCrop
                    }
                }
            }
            ColumnLayout {
                id: textColumn
                Layout.fillWidth: true
                Layout.leftMargin: 6
                Text {
                    visible: this.text !== ""
                    text: root.summary
                    Layout.fillWidth: true
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    textFormat: Text.PlainText
                    renderType: Text.NativeRendering
                    maximumLineCount: 8
                    color: Colors.text
                    font {
                        pointSize: 10
                        weight: Font.DemiBold
                    }
                }
                Text {
                    // text: "Here we are running in the hole,wa de fuk\ndsfsddfshjkjkllkjsdfjklsdffsdfsd\ndsfsfsdkljfsdlkjsdfljkfsddfdsfs\nfddfslkjfdsfsdfsdgjksdfjklfsdgjkfdg\nfgdjkfdjklgfdjklg\nfsdfsdjfkjsdkfsd\nsdfsdfjsdklf"
                    visible: this.text !== ""
                    text: root.body
                    Layout.fillWidth: true
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 8
                    color: Colors.text
                    font {
                        pointSize: 9
                    }
                }
            }
        }
        Rectangle {
            visible: actionRow.visible
            Layout.fillWidth: true
            color: Colors.light
            implicitHeight: 1
        }
        RowLayout {
            id: actionRow
            visible: root.actions.length > 0
            implicitHeight: 35
            Layout.fillWidth: true
            Repeater {
                model: root.actions
                Button {
                    required property NotificationAction modelData
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onClicked: modelData.invoke()
                    text: modelData.text
                    icon.name: modelData.identifier
                    icon.cache: false
                    flat: true
                }
            }
        }
    }
}
