import QtQuick
import Quickshell
import QtQuick.Controls

Menu {
    id: categoryMenu
    required property var model
    bottomMargin: 58
    // Component.onCompleted: {
    // print(Array.from(model.values()));
    // }
    Repeater {
        model: ScriptModel {
            values: categoryMenu.model
        }
        // model: categoryMenu.model
        MenuItem {
            required property var modelData
            text: modelData.name
            icon.name: modelData.icon
            onClicked: appMenu.launch(modelData.id)
        }
    }
}
