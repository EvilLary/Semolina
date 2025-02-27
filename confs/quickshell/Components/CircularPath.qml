// I'm aware that this technically isn't throbber, but it sounds cool
import QtQuick
import QtQuick.Shapes

Item {

    id: throbber

    required property int startAngle
    required property int endAngle

    property alias value: arc.sweepAngle

    property alias pathColor: throbberPath.strokeColor
    property alias pathBackground: pathBackground.strokeColor
    property real strokeWidth: 4.5

    Shape {
        anchors.centerIn: parent
        preferredRendererType: Shape.CurveRenderer
        fillMode: Shape.PreserveAspectFit
        ShapePath {
            id: pathBackground
            strokeColor: "#1d2626"
            strokeWidth: throbber.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle: ShapePath.SolidLine
            joinStyle: ShapePath.RoundJoin
            PathAngleArc {
                radiusX: (throbber.width / 2) - (pathBackground.strokeWidth / 2 )
                radiusY: (throbber.height / 2) - (pathBackground.strokeWidth / 2)
                centerX: throbber.width / 2
                centerY: throbber.height / 2
                startAngle: throbber.startAngle
                sweepAngle: throbber.endAngle
            }
        }
        ShapePath {
            id: throbberPath
            strokeColor: "white"
            strokeWidth: throbber.strokeWidth
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            strokeStyle: ShapePath.SolidLine
            joinStyle: ShapePath.RoundJoin
            Behavior on strokeColor {
                ColorAnimation {
                    duration: 100
                }
            }
            PathAngleArc {
                id: arc
                radiusX: (throbber.width / 2) - (throbberPath.strokeWidth / 2 )
                radiusY: (throbber.height / 2) - (throbberPath.strokeWidth / 2)
                centerX: throbber.width / 2
                centerY: throbber.height / 2
                startAngle: throbber.startAngle
                Behavior on sweepAngle {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.Linear
                    }
                }
            }
        }
    }
}
