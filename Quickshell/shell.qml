//@ pragma UseQApplication

import Quickshell
import "bar"
import "Osd"
import "WindowSwitcher"

ShellRoot {
//color accent #7467b3

    Variants {
        model: Quickshell.screens
        Scope {
            id: scope
            required property var modelData

            Bar {
                screen: scope.modelData
            }
            Background {
                screen: scope.modelData
            }
        }
    }
    Osd {}
    Switcher {}
    ReloadPopup {}
}
