.pragma library

.import Quickshell as QC
.import Quickshell.Wayland as QCW

class Task {
    constructor(id, window) {
        const entry = QC.DesktopEntries.byId(id);
        let iconPath = new String();
        if (id.startsWith("steam_app")) {
            iconPath = `image://icon/${id.replace("app", "icon")}?fallback=wine`
        } else if (id.endsWith(".exe")) {
            iconPath = "image://icon/wine";
        } else {
            if (entry) {
                // iconPath = "image://icon/" + entry.icon + "?fallback=wayland";
                iconPath = `image://icon/${entry.icon}?fallback=wayland`;
            } else {
                iconPath = `image://icon/${id}?fallback=wayland`;
            }
        }
        if (window === null) {
            this.windows = new Set();
        } else {
            this.windows = new Set([window])
        }
        this.id = id;
        this.icon = iconPath;
        this.desktopEntry = entry;
    }
}

// Task.prototype.list = function() {
//     return this.windows.values().toArray();
// }
Task.prototype.addToplevel = function(toplevel) {
    this.windows.add(toplevel)
}
Task.prototype.deleteToplevel = function(toplevel) {
    this.windows.delete(toplevel);
}
Task.prototype.isEmpty = function() {
    return this.windows.size === 0;
}
// Task.prototype.windowsCount = function() {
// }
Task.prototype.activate = function() {

    if (this.isEmpty()) {
        return;
    }
    const windows = [...this.windows.values()];
    const windowsCount = this.windows.size;
    if (windowsCount > 1) {
        const activeIndex = windows.findIndex(obj => {
            return obj.activated;
        });
        if (activeIndex == -1) {
            windows[0].activate();
        } else {
            const i = (activeIndex + 1) % windowsCount;
            windows[i].activate();
        }
    } else {
        windows[0].activate();
    }
}
// Task.prototype.isActive = function() {
//     const activeWindow = QCW.ToplevelManager?.activeToplevel?.appId;
//     if (!activeWindow) {
//         return false;
//     }
//     return this.id === activeWindow;
// }
Task.prototype.close = function() {
    if (this.isEmpty()) {
        return;
    }
    const windows = [...this.windows.values()];
    const activeIndex = windows.findIndex(obj => {
        return obj.activated;
    });
    if (activeIndex === -1) {
        windows[0].close();
    } else {
        windows[activeIndex].close();
    }
}
