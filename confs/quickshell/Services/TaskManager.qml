import QtQuick
import Quickshell
import Quickshell.Wayland
import "task.js" as T

QtObject {
    id: root
    readonly property list<string> pinnedApps: ["chromium", "footclient", "org.kde.dolphin", "org.kde.okular"]
    readonly property string activeWindow: ToplevelManager.activeToplevel?.appId || ""
    readonly property var windows: new Map()
    readonly property ScriptModel model: ScriptModel {
        id: model
        Component.onCompleted: {
            model.values = Qt.binding(function () {
                return [...root.windows.values()];
            });
        }
    }

    Component.onCompleted: {
        for (const app of root.pinnedApps) {
            const task = new T.Task(app, null);
            root.windows.set(app, task);
        }
        for (const toplevel of ToplevelManager.toplevels.values) {
            toplevelCon.add_toplevel(toplevel);
        }
    }
    readonly property Connections conn: Connections {
        id: toplevelCon
        target: ToplevelManager.toplevels
        function onObjectInsertedPost(toplevel, _): void {
            add_toplevel(toplevel);
        }
        function onObjectRemovedPre(toplevel, _): void {
            const id = toplevel.appId;
            const task = root.windows.get(id);
            task.deleteToplevel(toplevel);
            if (task.isEmpty() && !root.pinnedApps.includes(id)) {
                root.windows.delete(id);
            }
            root.windowsChanged();
        }
        function add_toplevel(toplevel: Toplevel): void {
            const id = toplevel.appId;
            // print(`adding: ${id}`);
            if (root.windows.has(id)) {
                const task = root.windows.get(id);
                task.addToplevel(toplevel);
            } else {
                const task = new T.Task(id, toplevel);
                root.windows.set(id, task);
            }
            root.windowsChanged();
        }
    }
}
