import QtQuick
import Quickshell
import Quickshell.Wayland

QtObject {
    id: root
    readonly property list<string> pinnedApps: ["LibreWolf", "footclient","org.kde.discover", "org.kde.dolphin", "steam"]
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    readonly property Connections conn: Connections {
        target: ToplevelManager.toplevels
        Component.onCompleted: {
            for (const app of root.pinnedApps) {
                const entry = DesktopEntries.byId(app);
                root.windows.set(app, {
                    id: app,
                    windows: new Set(),
                    icon: Quickshell.iconPath(entry.icon, 'wayland'),
                    desktopEntry: entry
                });
            }
            for (const toplevel of ToplevelManager.toplevels.values) {
                // TODO Maybe there will be case where a new toplevel is added while
                // this loop is running?
                add_toplevel(toplevel);
            }
        }
        function add_toplevel(toplevel: Toplevel): void {
            const id = toplevel.appId;
            if (root.windows.has(id)) {
                const class_windows = root.windows.get(id);
                class_windows.windows.add(toplevel);
            } else {
                let icon = new String();
                const entry = DesktopEntries.byId(id);
                if (id.endsWith(".exe") || id.startsWith("steam_app_")) {
                    icon = "image://icon/wine";
                } else {
                    if (entry) {
                        icon = Quickshell.iconPath(entry.icon, "wayland");
                    } else {
                        icon = Quickshell.iconPath(id, "wayland");
                    }
                }
                root.windows.set(id, {
                    id: id,
                    windows: new Set([toplevel]),
                    icon: icon,
                    desktopEntry: null
                });
            }
            root.windowsChanged();
            // print("POST-INSERT: " + id);
            // print(JSON.stringify([...root.windows.values()]));
        }
        function onObjectInsertedPost(toplevel, _): void {
            add_toplevel(toplevel);
        }
        function onObjectRemovedPost(toplevel, _): void {
            const id = toplevel.appId;
            const class_windows = root.windows.get(id);
            if (class_windows.windows.size == 0 && !root.pinnedApps.includes(id)) {
                root.windows.delete(id);
            }
            root.windowsChanged();
            // print("POST-REMOVED: " + id);
            // print(id + ": " + [...class_windows.windows.values()]);
            // print(JSON.stringify([...root.windows.values()]));
        }
        function onObjectRemovedPre(toplevel, index): void {
            const id = toplevel.appId;
            const class_windows = root.windows.get(id);
            class_windows.windows.delete(toplevel);
            root.windowsChanged();
            // print("PRE-REMOVED: " + id);
            // print(id + ": " + [...class_windows.windows.values()]);
            // print(JSON.stringify([...root.windows.values()]));
        }
        function onObjectInsertedPre(object, _): void {
            // print("PRE-INSERT: " + object.appId);
        }
    }
    readonly property var windows: new Map()
    readonly property ScriptModel model: ScriptModel {
        id: model
        Component.onCompleted: {
            model.values = Qt.binding(function () {
                return [...root.windows.values()];
            });
        }
    }
}
