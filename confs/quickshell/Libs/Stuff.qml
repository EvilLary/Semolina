pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias inhibitorStatus: inhibitor.running
    property alias nightLight: nl.running

    Process {
        id: inhibitor
        command: ['systemd-inhibit', '--what','idle', 'sleep', 'infinity']
        manageLifetime: true
    }
    Process {
        id: nl
        command: ['hyprsunset','-t', '3500']
        manageLifetime: true
    }
    function toggleNL(): void {
        //nl.running = !nl.running
        if (nl.running) {
            nl.signal(2);
        } else {
            nl.running = true
        }
    }
    function toggleInhibit(): void {

        if (inhibitor.running) {
            inhibitor.signal(1);
        } else {
            inhibitor.running = true
        }
        //persist.inhibitorStatus = !persist.inhibitorStatus
    }
}
