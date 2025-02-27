pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Singleton {
    id: root
    property list<Toplevel> windows: ToplevelManager.toplevels.values
    property Toplevel activeWindow: ToplevelManager.activeToplevel

    property string steamId
    property string gameIcon

    Process {
        id: getGameIcon
        // Ignore this grbg
        command: ['sh','-c',`find '/home/spicy/.local/share/Steam/appcache/librarycache/${root.steamId}/' ! -name 'header*' ! -name 'library*' -name '*.jpg' `]
        stdout: SplitParser {
            id: parser
        }

    }
    function getToplevelIcon(id: string): string {

        if (id.startsWith("steam_app_")) {
            const gameId = id.slice(10,)
            if (gameId == 0) return 'image://icon/wine'
            root.steamId = gameId

            getGameIcon.running = true
            parser.read.connect(path => {
                root.gameIcon = path
            })

            return root.gameIcon
            //return `file:///${Quickshell.env("HOME")}/.local/share/Steam/appcache/librarycache/${gameId}_icon`
        }
        if (id.endsWith(".exe"))  {
            return 'image://icon/wine'
        }
        const entry = DesktopEntries.byId(id)
        if (entry == null) {
            return Quickshell.iconPath(id,'wayland')
        }
        return Quickshell.iconPath(entry.icon,'wayland')

    }
}
