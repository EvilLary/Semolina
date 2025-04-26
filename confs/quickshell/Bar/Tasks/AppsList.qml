import QtQuick

Text {
    required property list<var> apps
    required property string category
    color: "white"
    text: category
    font {
        pointSize: 15
    }
}
