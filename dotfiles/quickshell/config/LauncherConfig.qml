import QtQuick

QtObject {
    property int maxShown: 7
    property int maxWallpapers: 9
    property string specialPrefix: "@"
    property string actionPrefix: ">"
    property int dragThreshold: 50
    property int itemWidth: 600
    property int itemHeight: 57
    property int wallpaperWidth: 280
    property int wallpaperHeight: 200

    property list<var> actions: [
        {
            name: "Calculator",
            icon: "calculate",
            description: "Do simple math equations (powered by Qalc)",
            command: ["autocomplete", "calc"],
            enabled: true
        },
        {
            name: "Wallpaper",
            icon: "image",
            description: "Change the current wallpaper",
            command: ["autocomplete", "wallpaper"],
            enabled: true
        },
        {
            name: "Shutdown",
            icon: "power_settings_new",
            description: "Shutdown the system",
            command: ["systemctl", "poweroff"],
            enabled: true
        },
        {
            name: "Reboot",
            icon: "cached",
            description: "Reboot the system",
            command: ["systemctl", "reboot"],
            enabled: true
        },
        {
            name: "Logout",
            icon: "exit_to_app",
            description: "Log out of the current session",
            command: ["loginctl", "terminate-user", ""],
            enabled: true
        },
        {
            name: "Lock",
            icon: "lock",
            description: "Lock the current session",
            command: ["loginctl", "lock-session"],
            enabled: true
        },
        {
            name: "Sleep",
            icon: "bedtime",
            description: "Suspend then hibernate",
            command: ["systemctl", "suspend-then-hibernate"],
            enabled: true
        }
    ]
}
