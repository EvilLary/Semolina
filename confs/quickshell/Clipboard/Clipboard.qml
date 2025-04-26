import QtQuick
import Quickshell.Io

QtObject {
    id: root

    signal close()
    property list<var> texts: new Array()
    property list<var> images: new Array()
    property bool ready: false
    property Process cliphist: Process {
        id: cliphist
        command: ["/home/spicy/Documents/git/cliphist/cliphist", "list"]
        stdout: SplitParser {
            onRead: data => {
                const [id,content,imagePath] = data.split(`\t`)
                if (imagePath == undefined) {
                    root.texts.push({"id":id,"content":content})
                } else {
                    root.images.push({"id":id,"content":content,"image":imagePath})
                }
            }
        }
        onExited: root.ready = true
    }
    property Process cmd: Process {
        id: cmd
    }
    property Process grbg: Process {
        id: removeGrbg
        command: ["sh","-c","rm -rf /run/user/1000/cliphist"]
        onExited: cliphist.running = true
    }
    function deleteItem(id: string): void {
        cmd.command = ['sh','-c',`echo ${id} | cliphist delete`]
        cmd.startDetached()
    }
    function copyItem(id: string): void {
        cmd.command = ["sh","-c",`cliphist decode ${id} | wl-copy`]
        cmd.startDetached()
        root.close()
    }
    function getClipboardData(): void {
        root.ready = false
        root.texts = []
        root.images = []
        removeGrbg.running = true
    }
    function wipeCliphist(): void {
        cmd.command = ["sh","-c",'cliphist wipe']
        cmd.startDetached()
    }
}
