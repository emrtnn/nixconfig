pragma Singleton

import QtQuick

Singleton {
    property string wallpaperName: "socrates.png"

    property QtObject rounding: QtObject {
        property real scale: 1
        property int small: 12 * scale
        property int normal: 17 * scale
        property int large: 25 * scale
        property int full: 1000 * scale
    }

    // --- Spacing Group ---
    property QtObject spacing: QtObject {
        property real scale: 1
        property int small: 7 * scale
        property int normal: 12 * scale
        property int large: 20 * scale
    }

    // --- Padding Group ---
    property QtObject padding: QtObject {
        property real scale: 1
        property int small: 5 * scale
        property int normal: 10 * scale
        property int large: 15 * scale
    }

    // --- Font Group ---
    property QtObject font: QtObject {
        property QtObject family: QtObject {
            property string mono: "JetbrainsMono Nerd Font"
            property string material: "Material Symbols Rounded"
        }

        property QtObject size: QtObject {
            property int small: 11
            property int normal: 13
            property int large: 18
        }
    }

    // --- Animations ---
    property QtObject anim: QtObject {
        property int duration: 400
        property var curve: [0.2, 0, 0, 1, 1, 1] // Standard cubic bezier
    }

    // --- Colors ---
    property QtObject colors: QtObject {
        property color background: "#282828"
        property color foreground: "#ebdbb2"
        property color text: "#fbf1c7"
        property color subtext: "#d5c4a1"
        property color orange: "#fe8019"
        property color red: "#cc241d"
        property color green: "#98971a"
        property color yellow: "#fabd2f"
    }
}
