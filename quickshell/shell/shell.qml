//@ pragma UseQApplication
import Quickshell
import "bar"
import "Osd"
import "WindowSwitcher"
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens
        Scope {
            required property var modelData

            Bar {
                screen: modelData
            }
            Background {
                screen: modelData
            }
            ActivateLinux {
                screen: modelData
            }
            Osd {
                // screen: modelData
            }
            Switcher {}
            // Dot {
            //     screen: modelData
            // }
            // // Launcher {
            // //     screen: modelData
            // // }
        }
        //END
    }
    //END
    ReloadPopup {
    }
}
