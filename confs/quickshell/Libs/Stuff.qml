pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property alias inhibitorStatus: inhibitor.running
    property alias nightLight: nl.running
    property QtObject apps: QtObject {
        property list<var> development: []
        property list<var> education: []
        property list<var> games: []
        property list<var> graphics: []
        property list<var> internet: []
        property list<var> multimedia: []
        property list<var> office: []
        property list<var> system: []
        property list<var> utilities
        property list<var> other: []
    }
    function init_apps() {
        let development = new Set();
        let education = new Set();
        let games = new Set();
        let graphics = new Set();
        let internet = new Set();
        let multimedia = new Set();
        let office = new Set();
        let system = new Set();
        let utilities = new Set();
        let other = new Set();
        for (const app of DesktopEntries.applications.values) {
            let exists = false;
            for (const category of app.categories) {
                switch (category) {
                case "Qt":
                case "KDE":
                case "GNOME":
                case "GTK":
                case "X-Red-Hat-Base":
                case "ConsoleOnly":
                case "X-KDE-Utilities-File":
                case "X-KDE-Utilities-Desktop":
                case "X-SuSE-Core-Office":
                case "X-GNOME-Utilities":
                    break;
                case "Development":
                case "IDE":
                case "TextEditor":
                case "Building":
                case "Documentation":
                case "Debugger":
                    if (!development.has(app.name)) {
                        development.add(app);
                    }
                    exists = true;
                    break;
                case "Education":
                case "Math":
                case "Science":
                    if (!education.has(app.name)) {
                        education.add(app);
                    }
                    exists = true;
                    break;
                case "Game":
                    if (!games.has(app.name)) {
                        games.add(app);
                    }
                    exists = true;
                    break;
                case "Viewer":
                case "Graphics":
                case "2DGraphics":
                case "RasterGraphics":
                case "VectorGraphics":
                    if (!graphics.has(app.name)) {
                        graphics.add(app);
                    }
                    exists = true;
                    break;
                case "Network":
                case "InstantMessaging":
                case "WebBrowser":
                case "Browser":
                case "FileTransfer":
                case "P2P":
                    if (!internet.has(app.name)) {
                        internet.add(app);
                    }
                    exists = true;
                    break;
                case "AudioVideo":
                case "Player":
                case "Recorder":
                case "Audio":
                case "TV":
                case "Video":
                case "Recorder":
                case "AudioVideoEditing":
                    if (!multimedia.has(app.name)) {
                        multimedia.add(app);
                    }
                    exists = true;
                    break;
                case "Office":
                case "Spreadsheet":
                case "WordProcessor":
                case "FlowChart":
                case "Database":
                case "Presentation":
                    if (!office.has(app.name)) {
                        office.add(app);
                    }
                    exists = true;
                    break;
                case "System":
                case "Settings":
                case "DesktopSettings":
                case "Monitor":
                case "FileManager":
                case "FileTools":
                case "TerminalEmulator":
                case "Filesystem":
                    if (!system.has(app.name)) {
                        system.add(app);
                    }
                    exists = true;
                    break;
                case "Utility":
                case "Archiving":
                case "Compression":
                case "Calculator":
                    if (!utilities.has(app.name)) {
                        utilities.add(app);
                    }
                    exists = true;
                    break;
                default:
                    if (!exists) {
                        // print(app.name + ": " + category)
                        other.add(app);
                    }
                    break;
                }
            }
        }
        const to_sorted = function (arr) {
            return [...arr.values()].sort((a, b) => a.name.localeCompare(b.name));
        };
        apps.development = to_sorted(development);
        apps.education = to_sorted(education);
        apps.games = to_sorted(games);
        apps.graphics = to_sorted(graphics);
        apps.internet = to_sorted(internet);
        apps.multimedia = to_sorted(multimedia);
        apps.office = to_sorted(office);
        apps.system = to_sorted(system);
        apps.utilities = to_sorted(utilities);
        apps.other = to_sorted(other);
    }
    Process {
        id: inhibitor
        command: ['systemd-inhibit', '--what', 'idle', 'sleep', 'infinity']
    }
    Process {
        id: nl
        command: ['hyprsunset', '-t', '3500']
    }
    function toggleNL(): void {
        if (nl.running) {
            nl.signal(2);
        } else {
            nl.running = true;
        }
    }
    function toggleInhibit(): void {
        if (inhibitor.running) {
            inhibitor.signal(1);
        } else {
            inhibitor.running = true;
        }
    }
}
