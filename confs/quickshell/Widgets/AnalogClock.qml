pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "../"

// import Qt5Compat.GraphicalEffects

Rectangle {
    id: analogClock
    required property int size
    height: this.size
    width: this.size
    radius: this.height / 2
    color: Config.colors.altBase
    border {
        width: 12
        color: Config.colors.border
    }
    // layer {
    //     enabled: true
    //     effect: DropShadow {
    //         radius: 10
    //         spread: 0
    //         samples: 17
    //     }
    // }
    Repeater {
        model: 60
        Item {
            id: tick
            required property int index
            readonly property bool isNumeral: (this.index % 5 == 0)
            y: 0
            x: analogClock.height / 4
            height: analogClock.height / 2
            width: analogClock.height / 2
            rotation: index * 6
            transformOrigin: Item.Bottom
            Rectangle {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 2
                }
                x: 0
                y: 0
                antialiasing: true
                height: tick.isNumeral ? 8 : 4
                width: this.height / 2
                radius: this.width
                color: Config.colors.text
                opacity: tick.isNumeral ? 1 : 0.3
            }
        }
    }

    // Rectangle {
    //     id: seconds
    //     width: 8
    //     height: analogClock.height / 3
    //     radius: this.width / 2
    //     x: analogClock.width / 2 - this.width / 2
    //     y: analogClock.height / 2
    //     // anchors {
    //     //     // bottom: analogClock.verticalCenter
    //     //     // centerIn: parent
    //     //     // top: parent.h
    //     //     // bottom: parent.verticalCenter
    //     // }
    //     // x: analogClock.width / 2 - this.width / 2
    //     // y: (analogClock.height / 2)
    //     // rotation: clock.seconds * 6
    //     transform: Rotation {
    //         origin {
    //             x: 0
    //             y: analogClock.height / 2 - seconds.height
    //         }
    //         // origin.x: analogClock.width / 2 - seconds.width / 2
    //         // origin.y: (analogClock.height / 2)
    //         angle: clock.seconds * 6
    //     }
    //     // transform: Rotation {
    //     //     // origin.x: ticks.width / 2
    //     //     // origin.y: 0
    //     //     // axis {
    //     //     //     x: 0
    //     //     //     y: 0
    //     //     //     z: 1
    //     //     // }
    //     //     // angle: 90 + 360 * ticks.modelData / 60
    //     //     angle: clock.seconds * 6
    //     // }
    //     // scale: analogClock.width/465
    // }
    Repeater {
        model: ["١٢", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩", "١٠", "١١"]
        Item {
            id: numeral
            required property int index
            required property string modelData
            y: 0
            x: analogClock.height / 4
            height: analogClock.height / 2
            width: this.height
            rotation: index * 30
            transformOrigin: Item.Bottom
            Text {
                text: numeral.modelData
                anchors {
                    // centerIn: parent
                    horizontalCenter: parent.horizontalCenter
                    topMargin: 5
                    top: parent.top
                }
                renderType: Text.NativeRendering
                rotation: 360 - numeral.rotation
                color: Config.colors.text
                font {
                    weight: Font.Medium
                    pointSize: analogClock.height / 15
                }
            }
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
    Item {
        id: minutesNeedle
        width: this.height
        anchors {
            top: analogClock.top
            bottom: analogClock.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 5
            height: analogClock.height * 0.37
            color: Config.colors.text
            radius: this.width / 2
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
            }
            antialiasing: true
        }
        rotation: (clock.minutes / 60) * 360
        antialiasing: true
    }
    Item {
        id: hoursNeedle
        width: this.height
        anchors {
            top: analogClock.top
            bottom: analogClock.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 6
            height: analogClock.height * 0.25
            color: Config.colors.text
            radius: this.width / 2
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.verticalCenter
            }
            antialiasing: true
        }
        rotation: clock.hours  * 30 + clock.minutes * 0.5
        antialiasing: true
    }
    Item {
        id: needle
        width: this.height
        anchors {
            top: analogClock.top
            bottom: analogClock.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 4
            height: analogClock.height * 0.5
            color: Config.colors.accent
            radius: this.width / 2
            anchors {
                horizontalCenter: needle.horizontalCenter
            }
            antialiasing: true
            y: analogClock.height * 0.1
            // transform: Rotation {
            //     origin {
            //         // x: 0
            //         // y: 0
            //         x: analogClock.width / 2 - needle.width / 2
            //         y: analogClock.height / 2 -needle.height / 2
            //     }
            //     angle: (clock.seconds / 60) * 360
            // }
        }
        rotation: (clock.seconds / 60) * 360
        // Component.onCompleted: print("x: " + this.x + ", y: " + this.y)
        antialiasing: true
        Behavior on rotation {}
    }
    Rectangle {
        id: center
        anchors.centerIn: parent
        width: 6
        height: this.width
        radius: this.height / 2
        color: Config.colors.base
        // border {
        //     width: 1
        //     // color: Config.colors.accent
        // }
    }
}
