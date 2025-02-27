// I'm aware that this technically isn't throbber, but it sounds cool
import QtQuick
import QtQuick.Shapes
import "root:Libs"

Item {

    id: throbber
    signal timerFinished
    required property bool startTimer
    property alias pathColor: throbberPath.strokeColor

    Shape {
        anchors {
            fill: parent
        }
        containsMode: Shape.FillContains
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            id: throbberPath
            strokeColor: Config.colors.accent
            strokeWidth: 3.5
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle: ShapePath.SolidLine
            joinStyle: ShapePath.RoundJoin
            PathAngleArc {
                id: arc
                radiusX: (throbber.width / 2) - (throbberPath.strokeWidth / 2 )
                radiusY: (throbber.height / 2) - (throbberPath.strokeWidth / 2)
                centerX: throbber.width / 2
                centerY: throbber.height / 2
                startAngle: -90
                sweepAngle: 360
            }
        }
    }
    Image {
        source: 'image://icon/window-close'
        anchors.centerIn: parent
        smooth: false
        asynchronous: true
        width: throbber.height
        height: throbber.width
    }
    PropertyAnimation {
        id: pathAnim
        target: arc
        property: 'sweepAngle'
        to: 0
        duration: 5500
        running: throbber.startTimer
        paused: (mouseArea.containsMouse && throbber.startTimer)
        onFinished: throbber.timerFinished()
    }
}

