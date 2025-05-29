pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// import Quickshell.Hyprland

Singleton {
    id: root
    property QtObject currentLayout: QtObject {
        property string longform: "إنجليزي (أمريكي)"
        property string shortform: "US"
    }
    Process {
        id: cmd
    }
    function runCommand(command: string): void {
        const args = command.split(' ');
        cmd.command = args;
        cmd.startDetached();
    }
    IpcHandler {
        target: "nightlight"
        function toggle(): void {
            nightlight.toggle();
        }
    }
    readonly property QtObject nightlight: QtObject {
        id: nightlight
        property alias status: nl.running
        property int temperature: 3500
        onTemperatureChanged: {
            if (nl.running) {
                root.runCommand(`hyprctl -q hyprsunset temperature ${nightlight.temperature}`);
            }
        }
        function adjust(num: int): void {
            // if (nightlight.temperature >= 6500 || nightlight.temperature <= 1000) return;
            const newTemp = this.temperature + num;
            if (num < 0) {
                if (newTemp <= 1000) {
                    nightlight.temperature = 1000;
                } else {
                    nightlight.temperature = newTemp;
                }
            } else {
                if (newTemp >= 6500) {
                    nightlight.temperature = 6500;
                } else {
                    nightlight.temperature = newTemp;
                }
            }
        }
        readonly property Process proc: Process {
            id: nl
            command: ['hyprsunset', '-t', nightlight.temperature]
        }
        function toggle(): void {
            if (nl.running) {
                nl.signal(2);
            } else {
                nl.running = true;
            }
        }
    }

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
        // print("fdfffddf")
        for (const app of DesktopEntries.applications.values) {
            let exists = false;
            for (const category of app.categories) {
                switch (category) {
                case "Qt":
                case "Application":
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
                    development.add(app);
                    exists = true;
                    break;
                case "Education":
                case "Math":
                case "Science":
                    education.add(app);
                    exists = true;
                    break;
                case "Game":
                    games.add(app);
                    exists = true;
                    break;
                case "Viewer":
                case "Graphics":
                case "2DGraphics":
                case "RasterGraphics":
                case "VectorGraphics":
                    graphics.add(app);
                    exists = true;
                    break;
                case "Network":
                case "InstantMessaging":
                case "WebBrowser":
                case "Browser":
                case "FileTransfer":
                case "P2P":
                    internet.add(app);
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
                    multimedia.add(app);
                    exists = true;
                    break;
                case "Office":
                case "Spreadsheet":
                case "WordProcessor":
                case "FlowChart":
                case "Database":
                case "Presentation":
                    office.add(app);
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
                case "HardwareSettings":
                    system.add(app);
                    exists = true;
                    break;
                case "Utility":
                case "Archiving":
                case "Compression":
                case "Calculator":
                    utilities.add(app);
                    exists = true;
                    break;
                default:
                    // print(category);
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
}
