import QtQuick

Item {
    default property Item item;
    property int expandedWidth;
    property int expandedHeight;

    implicitHeight: item.implicitHeight
    implicitWidth: item.implicitWidth

    Component.onCompleted: {
        item.width = Qt.binding(() => this.width)
        item.height = Qt.binding(() => this.height)
    }

    children: [ item ]
}
