pragma Singleton
import QtQuick

QtObject {

    readonly property SystemPalette activeColor: SystemPalette {
        id: activeColors
        colorGroup: SystemPalette.Active
    }
    readonly property SystemPalette inactiveColor: SystemPalette {
        id: inactiveColors
        colorGroup: SystemPalette.Inactive
    }
    readonly property SystemPalette disabledColors: SystemPalette {
        id: disabledColors
        colorGroup: SystemPalette.Disabled
    }

    readonly property color negative: "#CD555E"

    readonly property alias accent: activeColors.accent
    readonly property alias accentInactive: inactiveColors.accent
    readonly property alias accentDisabled: disabledColors.accent

    readonly property alias background: activeColors.window
    readonly property alias backgroundInactive: inactiveColors.window
    readonly property alias backgroundDisabled: disabledColors.window

    readonly property alias base: activeColors.base
    readonly property alias baseInactive: inactiveColors.base
    readonly property alias baseDisabled: disabledColors.base

    readonly property alias altBase: activeColors.alternateBase
    readonly property alias altBaseInactive: inactiveColors.alternateBase
    readonly property alias altBaseDisabled: disabledColors.alternateBase

    readonly property alias button: activeColors.button
    readonly property alias buttonInactive: inactiveColors.button
    readonly property alias buttonDisabled: disabledColors.button

    readonly property alias buttonText: activeColors.buttonText
    readonly property alias buttonTextInactive: inactiveColors.buttonText
    readonly property alias buttonTextDisabled: disabledColors.buttonText

    readonly property alias dark: activeColors.dark
    readonly property alias darkInactive: inactiveColors.dark
    readonly property alias darkDisabled: disabledColors.dark

    readonly property alias highlight: activeColors.highlight
    readonly property alias highlightInactive: inactiveColors.highlight
    readonly property alias highlightDisabled: disabledColors.highlight

    readonly property alias highlightedText: activeColors.highlightedText
    readonly property alias highlightedTextInactive: inactiveColors.highlightedText
    readonly property alias highlightedTextDisabled: disabledColors.highlightedText

    readonly property alias light: activeColors.light
    readonly property alias lightInactive: inactiveColors.light
    readonly property alias lightDisabled: disabledColors.light

    readonly property alias mid: activeColors.mid
    readonly property alias midInactive: inactiveColors.mid
    readonly property alias midDisabled: disabledColors.mid

    readonly property alias midlight: activeColors.midlight
    readonly property alias midlightInactive: inactiveColors.midlight
    readonly property alias midlightDisabled: disabledColors.midlight

    readonly property alias shadow: activeColors.shadow
    readonly property alias shadowInactive: inactiveColors.shadow
    readonly property alias shadowDisabled: disabledColors.shadow

    readonly property alias placeholderText: activeColors.placeholderText
    readonly property alias placeholderTextInactive: inactiveColors.placeholderText
    readonly property alias placeholderTextDisabled: disabledColors.placeholderText

    readonly property alias text: activeColors.text
    readonly property alias textInactive: inactiveColors.text
    readonly property alias textDisabled: disabledColors.text

    readonly property alias windowText: activeColors.windowText
    readonly property alias windowTextInactive: inactiveColors.windowText
    readonly property alias windowTextDisabled: disabledColors.windowText
}
