import QtQuick
import QtQuick.Shapes
// import QtQuick.Controls
import Quickshell
// import QtQuick.VectorImage
import "../Config"

MouseArea {
    id: root

    // Rectangle {
    //     anchors.fill: parent
    //     color: "transparent"
    //     border {
    //         width: 1
    //         color: "white"
    //     }
    // }
    property string icon: ""
    readonly property int startAngle: 80
    readonly property int sweepAngle: 300
    property real value: 0.5
    property real pathWidth: 2
    // property alias tooltipText: tooltip.text
    property alias showTooltip: root.hoverEnabled
    property alias pathColor: throbberPath.strokeColor
    property alias pathBackground: pathBackground.strokeColor
    property alias showText: text.visible

    property int size: 36
    implicitWidth: this.size
    implicitHeight: this.size
    height: this.size
    width: this.size

    hoverEnabled: false
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    // ToolTip {
    //     id: tooltip
    //     visible: root.containsMouse
    //     delay: 600
    //     popupType: Popup.Window
    // }
    signal leftClick
    signal rightClick
    signal middleClick
    signal scrollUp
    signal scrollDown

    Image {
        id: icon
        anchors.centerIn: parent
        width: root.size / 2
        height: this.width
        sourceSize.width: this.width
        sourceSize.height: this.width
        // fillMode: Image.PreserveAspectCrop
        source: Quickshell.iconPath(root.icon, "unknown")
        smooth: true
        mipmap: false
        cache: false
        asynchronous: false
        scale: root.containsPress ? 0.85 : 1
        Behavior on scale {
            NumberAnimation {
                duration: 125
                easing.type: Easing.Linear
            }
        }
    }

    Text {
        id: text
        visible: true
        anchors {
            bottom: parent.bottom
            // horizontalCenter: parent.horizontalCenter
            bottomMargin: -4
            right: parent.right
            rightMargin: 0
        }
        renderType: Text.NativeRendering
        textFormat: Text.PlainText
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: Math.round(root.value * 100).toString().replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d])
        font {
            pixelSize: root.height * 1 / 4 + 1
            weight: Font.DemiBold
            // family: "Vazir Code"
            letterSpacing: 0
        }
        color: Colors.text
    }
    Shape {
        id: shape
        anchors.centerIn: parent
        preferredRendererType: Shape.CurveRenderer
        fillMode: Shape.PreserveAspectFit
        readonly property real center: (root.size) / 2
        readonly property real radius: center - (root.pathWidth / 2)
        ShapePath {
            id: pathBackground
            strokeColor: Colors.light
            strokeWidth: root.pathWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle: ShapePath.SolidLine
            PathAngleArc {
                radiusX: shape.radius
                radiusY: shape.radius
                centerX: shape.center
                centerY: shape.center
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle
            }
        }
        ShapePath {
            id: throbberPath
            strokeColor: Colors.text
            strokeWidth: root.pathWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle: ShapePath.SolidLine
            Behavior on strokeColor {
                ColorAnimation {
                    duration: 100
                }
            }
            PathAngleArc {
                id: arc
                radiusX: shape.radius
                radiusY: shape.radius
                centerX: shape.center
                centerY: shape.center
                startAngle: root.startAngle
                sweepAngle: Math.min(root.sweepAngle * root.value, root.sweepAngle)
                Behavior on sweepAngle {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.Linear
                    }
                }
            }
        }
    }
    onClicked: mouse => {
        switch (mouse.button) {
        case Qt.LeftButton:
            root.leftClick();
            mouse.accepted = true;
            break;
        case Qt.RightButton:
            root.rightClick();
            mouse.accepted = true;
            break;
        case Qt.MiddleButton:
            root.middleClick();
            mouse.accepted = true;
            break;
        }
    }

    onWheel: event => {
        const delta = (event.angleDelta.y || event.angleDelta.x);
        if (delta > 1) {
            root.scrollUp();
            event.accepted = true;
        } else if (delta < 1) {
            root.scrollDown();
            event.accepted = true;
        }
    }
}
