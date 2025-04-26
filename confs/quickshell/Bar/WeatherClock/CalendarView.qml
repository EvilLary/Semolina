pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
import "../../"
import "../../Components/" as C
import "../../Widgets"

C.OutRect {
    id: calendarView
    signal closePopup
    GridLayout {
        anchors {
            fill: parent
            margins: 8
        }
        columns: 6
        rows: 1
        C.InnRect {
            Layout.column: 0
            Layout.columnSpan: 4
            // Layout.row: 0
            // Layout.rowSpan: 2
            Layout.preferredWidth: 4   // 4 of 5 cols
            // Layout.preferredHeight: 2  // 2 of 5 rows
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                id: row
                anchors {
                    top: parent.top
                    bottom: gridContainer.top
                    right: parent.right
                    left: parent.left
                    margins: 8
                }
                Text {
                    color: Config.colors.text
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font {
                        weight: Font.Medium
                        pointSize: 11
                    }
                    text: {
                        const year = grid.year.toString().replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d]);
                        let month = new String();
                        switch (grid.month) {
                        case Calendar.January:
                            month = "يناير";
                            break;
                        case Calendar.February:
                            month = "فبراير";
                            break;
                        case Calendar.March:
                            month = "مارس";
                            break;
                        case Calendar.April:
                            month = "إبريل";
                            break;
                        case Calendar.May:
                            month = "مايو";
                            break;
                        case Calendar.June:
                            month = "يونيو";
                            break;
                        case Calendar.July:
                            month = "يوليو";
                            break;
                        case Calendar.August:
                            month = "أغسطس";
                            break;
                        case Calendar.September:
                            month = "سبتمبر";
                            break;
                        case Calendar.October:
                            month = "أكتوبر";
                            break;
                        case Calendar.November:
                            month = "نوفمبر";
                            break;
                        case Calendar.December:
                            month = "ديسمبر";
                            break;
                        }
                        return month + " - " + year;
                    }
                }
            }
            C.InnRect {
                id: gridContainer
                color: Config.colors.altBase
                anchors {
                    fill: parent
                    topMargin: 50
                    margins: 8
                }
                layer {
                    enabled: true
                    effect: DropShadow {
                        radius: 5
                        color: Config.colors.shadow
                    }
                }
                GridLayout {
                    anchors {
                        fill: parent
                    }
                    columns: 1
                    DayOfWeekRow {
                        locale: grid.locale

                        Layout.fillWidth: true
                        LayoutMirroring.enabled: true
                        LayoutMirroring.childrenInherit: true
                        delegate: Text {
                            required property var modelData
                            text: modelData.longName
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: Config.colors.text
                            font {
                                weight: Font.Medium
                                pointSize: 12
                            }
                        }
                    }
                    MonthGrid {
                        id: grid
                        locale: Qt.locale("ar_SA")

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        LayoutMirroring.enabled: true
                        LayoutMirroring.childrenInherit: true
                        ParallelAnimation {
                            id: anim
                            NumberAnimation {
                                property: "opacity"
                                target: grid
                                from: 1
                                to: 0
                                duration: 150
                            }
                            NumberAnimation {
                                property: "opacity"
                                target: grid
                                from: 0
                                to: 1
                                duration: 150
                            }
                        }
                        onMonthChanged: anim.start()
                        onYearChanged: anim.start()
                        delegate: ItemDelegate {
                            id: day
                            required property var modelData
                            highlighted: modelData.today
                            Text {
                                text: day.modelData.day.toString().replace(/\d/g, d => '٠١٢٣٤٥٦٧٨٩'[d])
                                color: (day.modelData.month == grid.month) ? Config.colors.text : Qt.alpha(Config.colors.text, 0.5)
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    weight: Font.Bold
                                    pointSize: 12
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onWheel: event => {
                                if (anim.running)
                                    return;
                                //event.accepted = true;
                                const delta = (event.angleDelta.y || event.angleDelta.x);
                                if (delta < 1) {
                                    if (grid.month == 11) {
                                        grid.year += 1;
                                        grid.month = 0;
                                    } else {
                                        grid.month += 1;
                                    }
                                } else if (delta > 1) {
                                    if (grid.month == 0) {
                                        grid.year -= 1;
                                        grid.month = 11;
                                    } else {
                                        grid.month -= 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        C.InnRect {
            Layout.column: 4
            Layout.columnSpan: 3
            // Layout.row: 0
            // Layout.rowSpan: 2
            Layout.preferredWidth: 3   // 4 of 5 cols
            // Layout.preferredHeight: 2  // 2 of 5 rows
            Layout.fillHeight: true
            Layout.fillWidth: true

            AnalogClock {
                id: analogClock
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    topMargin: 5
                }
                size: 250
            }
            C.InnRect {
                color: Config.colors.altBase
                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    left: parent.left
                    margins: 8
                }
                height: 100
                layer {
                    enabled: true
                    effect: DropShadow {
                        radius: 5
                        color: Config.colors.shadow
                    }
                }
            }
        }
    }
}
