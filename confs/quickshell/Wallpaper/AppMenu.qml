import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "../Libs"

Menu {
    id: appMenu
    padding: 0
    // margins: 60
    bottomMargin: 58
    // boundingItem: parent
    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1.0
            duration: 150
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0
            duration: 150
        }
    }
    Process {
        id: runner
        command: ["uwsmapp.sh"]
        running: false
    }
    function launch(id: string): void {
        const app = id + '.desktop';
        runner.command = ["uwsmapp.sh", app];
        runner.startDetached();
    }
    // Repeater {
    //     // model: ScriptModel {
    //     //     values: Stuff.appss
    //     // }
    //     model: 4
    //     delegate: Menu {
    //         required property var modelData
    //         text: modelData
    //         // icon.name: "applications-" + modelData.category
    //     }
    //     // Menu {
    //     //     title: "fdf"
    //     // }
    //     // CategoryMenu {
    //     //     required property var modelData
    //     //     title: modelData.category
    //     //     icon.name: "applications-" + modelData.category
    //     //     model: modelData.apps
    //     // }
    //     // Menu {
    //     //     id: categoryMenu
    //     //     required property var modelData
    //     //     bottomMargin: 58
    //     //     title: modelData.category
    //     //     icon.name: "applications-" + modelData.category
    //     //     // Component.onCompleted: {
    //     //     // print(Array.from(model.values()));
    //     //     // }
    //     //     Repeater {
    //     //         // model: ScriptModel {
    //     //         //     values: categoryMenu.modelData.apps.sort((a, b) => {
    //     //         //         return a.name.localeCompare(b.name);
    //     //         //     })
    //     //         // }
    //     //         // model: categoryMenu.modelData.apps.sort((a, b) => {
    //     //         //     return a.name.localeCompare(b.name);
    //     //         // })
    //     //         // MenuItem {
    //     //         //     required property var modelData
    //     //         //     text: modelData.name
    //     //         //     icon.name: modelData.icon
    //     //         //     onClicked: appMenu.launch(modelData.id)
    //     //         // }
    //     //     }
    //     // }
    // }
    CategoryMenu {
        title: "Development"
        icon.name: "applications-development"
        model: Stuff.apps.development
    }
    CategoryMenu {
        title: "Education"
        icon.name: "applications-education"
        model: Stuff.apps.education
    }
    CategoryMenu {
        title: "Games"
        icon.name: "applications-games"
        model: Stuff.apps.games
    }
    CategoryMenu {
        title: "Graphics"
        icon.name: "applications-graphics"
        model: Stuff.apps.graphics
    }
    CategoryMenu {
        title: "Internet"
        icon.name: "applications-internet"
        model: Stuff.apps.internet
    }
    CategoryMenu {
        title: "Multimedia"
        icon.name: "applications-multimedia"
        model: Stuff.apps.multimedia
    }
    CategoryMenu {
        title: "Office"
        icon.name: "applications-office"
        model: Stuff.apps.office
    }
    CategoryMenu {
        title: "System"
        icon.name: "applications-system"
        model: Stuff.apps.system
    }
    CategoryMenu {
        title: "Utilities"
        icon.name: "applications-utilities"
        model: Stuff.apps.utilities
    }
    // Menu {
    //     title: "Utilities"
    //     icon.name: "applications-utilities"
    //     bottomMargin: 58
    //     Repeater {
    //         model: Stuff.apps.utilites
    //         MenuItem {
    //             required property var modelData
    //             text: modelData.name
    //             icon.name: modelData.icon
    //             onClicked: appMenu.launch(modelData.id)
    //         }
    //     }
    // }
    // Loader {
    //     active: Stuff.apps.other.length === 0
    //     sourceComponent: Menu {
    //         title: "Other"
    //         icon.name: "applications-other"
    //         Repeater {
    //             id: others
    //             model: Stuff.apps.other
    //             MenuItem {
    //                 required property var modelData
    //                 text: modelData.name
    //                 icon.name: modelData.icon
    //                 onClicked: appMenu.launch(modelData.id)
    //             }
    //         }
    //     }
    // }
}
